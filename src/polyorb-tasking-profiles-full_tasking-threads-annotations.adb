------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--        POLYORB.TASKING.PROFILES.FULL_TASKING.THREADS.ANNOTATIONS         --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--            Copyright (C) 2004 Free Software Foundation, Inc.             --
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

with Ada.Task_Attributes;

with PolyORB.Initialization;
with PolyORB.Utils.Strings;

package body PolyORB.Tasking.Profiles.Full_Tasking.Threads.Annotations is

   use PolyORB.Annotations;

   package Task_Notepad is new Ada.Task_Attributes (Notepad_Access, null);

   Current_TAF : Full_Tasking_TAF_Access;

   --------------------------------
   -- Get_Current_Thread_Notepad --
   --------------------------------

   function Get_Current_Thread_Notepad
     (TAF : access Full_Tasking_TAF)
     return PolyORB.Annotations.Notepad_Access
   is
      pragma Unreferenced (TAF);

      N : Notepad_Access;

   begin
      N := Task_Notepad.Value;

      if N = null then
         N := new Notepad;
         Task_Notepad.Set_Value (N);
      end if;

      return N;
   end Get_Current_Thread_Notepad;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize;

   procedure Initialize is
   begin
      Current_TAF := new Full_Tasking_TAF;
      PolyORB.Tasking.Threads.Annotations.Register
        (PolyORB.Tasking.Threads.Annotations.TAF_Access (Current_TAF));
   end Initialize;

   use PolyORB.Initialization;
   use PolyORB.Initialization.String_Lists;
   use PolyORB.Utils.Strings;

begin
   Register_Module
     (Module_Info'
      (Name      => +"tasking.profiles.full_tasking.annotations",
       Conflicts => Empty,
       Depends   => Empty,
       Provides  => +"tasking.annotations",
       Implicit  => False,
       Init      => Initialize'Access));
end PolyORB.Tasking.Profiles.Full_Tasking.Threads.Annotations;
