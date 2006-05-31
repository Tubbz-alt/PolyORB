------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--               T E M P L A T E S _ P A R S E R . I N P U T                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2002-2006, Free Software Foundation, Inc.          --
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

--  This is the implementation to be used with AWS, it is using AWS.Resources
--  to support embedded resources.

with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

with AWS.Resources;

package body Templates_Parser.Input is

   type File_Record is new AWS.Resources.File_Type;

   procedure Check_Open (File : File_Type);
   pragma Inline (Check_Open);
   --  Check if File is opened (File variable is not null).

   procedure Free is new Ada.Unchecked_Deallocation (File_Record, File_Type);

   ----------------
   -- Check_Open --
   ----------------

   procedure Check_Open (File : File_Type) is
   begin
      if File = null then
         raise Ada.Text_IO.Status_Error;
      end if;
   end Check_Open;

   -----------
   -- Close --
   -----------

   procedure Close (File : in out File_Type) is
   begin
      Check_Open (File);
      Close (File.all);
      Free (File);
   end Close;

   -----------------
   -- End_Of_File --
   -----------------

   function End_Of_File (File : File_Type) return Boolean is
   begin
      Check_Open (File);
      return End_Of_File (File.all);
   end End_Of_File;

   --------------
   -- Get_Line --
   --------------

   procedure Get_Line
     (File   : File_Type;
      Buffer :    out String;
      Last   :    out Natural) is
   begin
      Check_Open (File);
      Get_Line (File.all, Buffer, Last);
   end Get_Line;

   -------------------
   -- LF_Terminated --
   -------------------

   function LF_Terminated (File : File_Type) return Boolean is
   begin
      Check_Open (File);
      return LF_Terminated (File.all);
   end LF_Terminated;

   ----------
   -- Open --
   ----------

   procedure Open
     (File : in out File_Type;
      Name : String;
      Form : String    := "") is
   begin
      if File /= null then
         Close (File);
      end if;

      File := new File_Record;
      Open (File.all, Name, Form);
   end Open;

end Templates_Parser.Input;