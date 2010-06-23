------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                POLYORB.DNS.TRANSPORT_MECHANISMS.MDNS                     --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2005-2010, Free Software Foundation, Inc.          --
--                                                                          --
-- PolyORB is free software; you  can  redistribute  it and/or modify it    --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. PolyORB is distributed  in the hope that it will be  useful,    --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with PolyORB; see file COPYING. If    --
-- not, write to the Free Software Foundation, 51 Franklin Street, Fifth    --
-- Floor, Boston, MA 02111-1301, USA.                                       --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--                  PolyORB is maintained by AdaCore                        --
--                     (email: sales@adacore.com)                           --
--                                                                          --
------------------------------------------------------------------------------

with PolyORB.Binding_Data.DNS.MDNS;
with PolyORB.Binding_Objects;
with PolyORB.ORB;
with PolyORB.Parameters;
with PolyORB.Protocols.DNS.MDNS;
with PolyORB.Sockets;
with PolyORB.Transport.Datagram.Sockets_In;
with PolyORB.Filters;

package body PolyORB.DNS.Transport_Mechanisms.MDNS is

   use PolyORB.Components;
   use PolyORB.Errors;
   use PolyORB.Parameters;
   use PolyORB.Sockets;
   use PolyORB.Transport.Datagram.Sockets_In;
   use PolyORB.Utils.Sockets;

   ----------------
   -- Address_Of --
   ----------------

   function Address_Of
     (M : MDNS_Transport_Mechanism) return Utils.Sockets.Socket_Name
   is
   begin
      return M.Address.all;
   end Address_Of;

   --------------------
   -- Bind_Mechanism --
   --------------------

   --  Factories

   Pro : aliased PolyORB.Protocols.DNS.MDNS.MDNS_Protocol;
   MDNS_Factories : constant PolyORB.Filters.Factory_Array
     := (0 => Pro'Access);

   procedure Bind_Mechanism
     (Mechanism : MDNS_Transport_Mechanism;
      Profile   : access PolyORB.Binding_Data.Profile_Type'Class;
      The_ORB   : Components.Component_Access;
      QoS       : PolyORB.QoS.QoS_Parameters;
      BO_Ref    : out Smart_Pointers.Ref;
      Error     : out Errors.Error_Container)
   is
      pragma Unreferenced (QoS);

      use PolyORB.Binding_Data;
      use PolyORB.Binding_Objects;

      Sock        : Socket_Type;
      Addr        : Sock_Addr_Type;
      TTL         : constant Natural :=
                      Natural (Get_Conf ("dns", "polyorb.dns.ttl",
                                         Default_TTL));

      TE          : Transport.Transport_Endpoint_Access;

   begin
      if Profile.all
        not in PolyORB.Binding_Data.DNS.MDNS.MDNS_Profile_Type then
         Throw (Error, Comm_Failure_E,
                System_Exception_Members'
                (Minor => 0, Completed => Completed_Maybe));
         return;
      end if;

      Create_Socket (Socket => Sock,
                     Family => Family_Inet,
                     Mode   => Socket_Datagram);

      Set_Socket_Option
        (Sock,
         Socket_Level, (Reuse_Address, True));

      Set_Socket_Option
        (Sock,
         IP_Protocol_For_IP_Level, (Multicast_TTL, TTL));

      TE := new Socket_In_Endpoint;
      Addr.Addr := Inet_Addr (Mechanism.Address.all.Host_Name);
      Addr.Port := Mechanism.Address.all.Port;
      PolyORB.Transport.Datagram.Sockets_In.Create
        (Socket_In_Endpoint (TE.all), Sock, Addr);
      Binding_Objects.Setup_Binding_Object
        (The_ORB,
         TE,
         MDNS_Factories,
         BO_Ref,
         Profile_Access (Profile));

      ORB.Register_Binding_Object
        (ORB.ORB_Access (The_ORB),
         BO_Ref,
         ORB.Client);

   exception
      when Sockets.Socket_Error =>
         Throw (Error, Comm_Failure_E, System_Exception_Members'
                (Minor => 0, Completed => Completed_Maybe));
   end Bind_Mechanism;

   --------------------
   -- Create_Factory --
   --------------------

   procedure Create_Factory
     (MF  : out MDNS_Transport_Mechanism_Factory;
      TAP :     Transport.Transport_Access_Point_Access)
   is
   begin
      MF.Address :=
        new Socket_Name'(Address_Of (Socket_In_Access_Point (TAP.all)));
   end Create_Factory;

   --------------------------------
   -- Create_Transport_Mechanism --
   --------------------------------

   function Create_Transport_Mechanism
     (MF : MDNS_Transport_Mechanism_Factory)
      return Transport_Mechanism_Access
   is
      Result  : constant Transport_Mechanism_Access
        := new MDNS_Transport_Mechanism;
      TResult : MDNS_Transport_Mechanism
        renames MDNS_Transport_Mechanism (Result.all);

   begin
      TResult.Address := new Socket_Name'(MF.Address.all);
      return Result;
   end Create_Transport_Mechanism;

   function Create_Transport_Mechanism
     (Address : Utils.Sockets.Socket_Name)
      return Transport_Mechanism_Access
   is
      Result  : constant Transport_Mechanism_Access
        := new MDNS_Transport_Mechanism;
      TResult : MDNS_Transport_Mechanism
        renames MDNS_Transport_Mechanism (Result.all);

   begin
      TResult.Address := new Socket_Name'(Address);
      return Result;
   end Create_Transport_Mechanism;

   ------------------------
   -- Is_Local_Mechanism --
   ------------------------

   function Is_Local_Mechanism
     (MF : access MDNS_Transport_Mechanism_Factory;
      M  : access Transport_Mechanism'Class)
      return Boolean is
   begin
      return M.all in MDNS_Transport_Mechanism
               and then
             MDNS_Transport_Mechanism (M.all).Address.all = MF.Address.all;
   end Is_Local_Mechanism;

   ----------------------
   -- Release_Contents --
   ----------------------

   procedure Release_Contents (M : access MDNS_Transport_Mechanism) is
   begin
      Free (M.Address);
   end Release_Contents;

   ---------------
   -- Duplicate --
   ---------------

   function Duplicate
     (TMA : MDNS_Transport_Mechanism)
     return MDNS_Transport_Mechanism
   is
   begin
      return MDNS_Transport_Mechanism'
               (Address => new Socket_Name'(TMA.Address.all));
   end Duplicate;

   ------------------
   -- Is_Colocated --
   ------------------

   function Is_Colocated
     (Left  : MDNS_Transport_Mechanism;
      Right : Transport_Mechanism'Class) return Boolean
   is
   begin
      return Right in MDNS_Transport_Mechanism
        and then Left.Address = MDNS_Transport_Mechanism (Right).Address;
   end Is_Colocated;

end PolyORB.DNS.Transport_Mechanisms.MDNS;
