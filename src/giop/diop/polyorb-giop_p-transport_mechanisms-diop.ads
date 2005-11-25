------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                POLYORB.GIOP_P.TRANSPORT_MECHANISMS.DIOP                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--            Copyright (C) 2005 Free Software Foundation, Inc.             --
--                                                                          --
-- PolyORB is free software; you  can  redistribute  it and/or modify it    --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. PolyORB is distributed  in the hope that it will be  useful,    --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with PolyORB; see file COPYING. If    --
-- not, write to the Free Software Foundation, 59 Temple Place - Suite 330, --
-- Boston, MA 02111-1307, USA.                                              --
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

with PolyORB.Sockets;

package PolyORB.GIOP_P.Transport_Mechanisms.DIOP is

   type DIOP_Transport_Mechanism is new Transport_Mechanism with private;

   procedure Bind_Mechanism
     (Mechanism : DIOP_Transport_Mechanism;
      Profile   : access PolyORB.Binding_Data.Profile_Type'Class;
      The_ORB   : Components.Component_Access;
      BO_Ref    : out Smart_Pointers.Ref;
      Error     : out Errors.Error_Container);

   procedure Release_Contents (M : access DIOP_Transport_Mechanism);

   --  DIOP Transport Mechanism specific subprograms

   function Address_Of (M : DIOP_Transport_Mechanism)
     return Sockets.Sock_Addr_Type;
   --  Return address of transport mechanism's transport access point.

   type DIOP_Transport_Mechanism_Factory is
     new Transport_Mechanism_Factory with private;

   procedure Create_Factory
     (MF  : out DIOP_Transport_Mechanism_Factory;
      TAP :     Transport.Transport_Access_Point_Access);

   function Is_Local_Mechanism
     (MF : access DIOP_Transport_Mechanism_Factory;
      M  : access Transport_Mechanism'Class)
      return Boolean;

   function Create_Tagged_Components
     (MF : DIOP_Transport_Mechanism_Factory)
      return Tagged_Components.Tagged_Component_List;

   --  DIOP Transport Mechanism Factory specific subprograms

   function Create_Transport_Mechanism
     (MF : DIOP_Transport_Mechanism_Factory)
      return Transport_Mechanism_Access;
   --  Create transport mechanism

   function Create_Transport_Mechanism
     (Address : Sockets.Sock_Addr_Type)
      return Transport_Mechanism_Access;
   --  Create transport mechanism for specified transport access point address

   function Duplicate
     (TMA : DIOP_Transport_Mechanism)
     return DIOP_Transport_Mechanism;

private

   type DIOP_Transport_Mechanism is new Transport_Mechanism with record
      Address : Sockets.Sock_Addr_Type;
   end record;

   type DIOP_Transport_Mechanism_Factory is
     new Transport_Mechanism_Factory with
   record
      Address : Sockets.Sock_Addr_Type;
   end record;

end PolyORB.GIOP_P.Transport_Mechanisms.DIOP;