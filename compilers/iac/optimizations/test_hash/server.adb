------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                               S E R V E R                                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--            Copyright (C) 2002 Free Software Foundation, Inc.             --
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
--                PolyORB is maintained by ACT Europe.                      --
--                    (email: sales@act-europe.fr)                          --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;

with PolyORB.CORBA_P.Server_Tools; use PolyORB.CORBA_P.Server_Tools;
with Polyorb.Types; use Polyorb.Types;

with PolyORB.Setup.No_Tasking_Server;
pragma Warnings (Off, PolyORB.Setup.No_Tasking_Server);

with IOR_Utils;

with CORBA;
with CORBA.Object;
with CORBA.ORB;

with test_hash.Impl;
with Statistics;

procedure Server is
   use PolyORB.CORBA_P.Server_Tools;

   Ref             : CORBA.Object.Ref;
begin

   Ada.Text_IO.Put_Line (Ada.Text_IO.Standard_Error, "Server starting.");
   CORBA.ORB.Initialize ("ORB");
   if Argument_Count < 1 then
      Ada.Text_IO.Put_Line
        ("usage : server howmany");
      return;
   end if;
   Statistics.Nbr_Ietr :=
     Polyorb.Types.Unsigned_Long'Value (Argument (1));

   Initiate_Servant (new test_hash.Impl.Object, Ref);
   --  Note that Ref is a smart pointer to a Reference_Info, *not*
   --  to a CORBA.Impl.Object.

   --  Print IOR so that we can give it to a client

   --  Ada.Text_IO.Put_Line
     --  (Ada.Text_IO.Standard_Error,
      --  "'" & CORBA.To_Standard_String (CORBA.Object.Object_To_String (Ref)) &
      --  "'");
   IOR_Utils.Put_Ref ("ref.ref", Ref);

   --  Launch the server
   Initiate_Server;
end Server;

