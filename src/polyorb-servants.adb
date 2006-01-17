------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                     P O L Y O R B . S E R V A N T S                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2002-2004 Free Software Foundation, Inc.           --
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

with PolyORB.Servants.Iface;

package body PolyORB.Servants is

   ----------------
   -- Notepad_Of --
   ----------------

   function Notepad_Of
     (S : Servant_Access)
     return PolyORB.Annotations.Notepad_Access is
   begin
      return S.Notepad'Access;
   end Notepad_Of;

   ------------------
   -- Set_Executor --
   ------------------

   procedure Set_Executor
     (S    : access Servant;
      Exec :        Executor_Access)
   is
   begin
      S.Exec := Exec;
   end Set_Executor;

   --------------------
   -- Handle_Message --
   --------------------

   function Handle_Message
     (S   : access Servant;
      Msg :        Components.Message'Class)
      return Components.Message'Class
   is
      use PolyORB.Servants.Iface;

   begin
      if Msg in Execute_Request then
         return Handle_Request_Execution
           (S.Exec,
            Msg,
            PolyORB.Components.Component_Access (S));

      else
         raise Program_Error;
      end if;
   end Handle_Message;

end PolyORB.Servants;