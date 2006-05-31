------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                           A W S . O S _ L I B                            --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2000-2006, Free Software Foundation, Inc.          --
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

--  Use the OS support routines in GNAT.OS_Lib instead of the POSIX library
--  and get the current UTC/GMT time from the C library.

--  @@@ uses ada.calendar

with GNAT.OS_Lib;

package body AWS.OS_Lib is

   function OS_Time_To_Calendar_Time (UTC : GNAT.OS_Lib.OS_Time)
     return Ada.Calendar.Time;
   --  Returns a Calendar.Time from an OS_Time variable.

   ------------------
   -- Is_Directory --
   ------------------

   function Is_Directory (Filename : String) return Boolean
     renames GNAT.OS_Lib.Is_Directory;

   ---------------------
   -- Is_Regular_File --
   ---------------------

   function Is_Regular_File (Filename : String) return Boolean
     renames GNAT.OS_Lib.Is_Regular_File;

   ---------------
   -- File_Size --
   ---------------

   function File_Size (Filename : String)
     return Ada.Streams.Stream_Element_Offset
   is
      use GNAT.OS_Lib;

      Name    : String := Filename & ASCII.NUL;
      FD      : File_Descriptor;
      Length  : Ada.Streams.Stream_Element_Offset := 0;
   begin
      FD := Open_Read (Name'Address, Binary);
      if FD /= Invalid_FD then
         Length := Ada.Streams.Stream_Element_Offset (File_Length (FD));
         Close (FD);
         return Length;
      end if;
      raise No_Such_File;
   end File_Size;

   --------------------
   -- File_Timestamp --
   --------------------

   function File_Timestamp (Filename : String) return Ada.Calendar.Time is
   begin
      return OS_Time_To_Calendar_Time (GNAT.OS_Lib.File_Time_Stamp (Filename));
   exception
      when others =>
         raise No_Such_File;
   end File_Timestamp;

   ---------------
   -- GMT_Clock --
   ---------------

   function GMT_Clock return Ada.Calendar.Time is
      type OS_Time_A is access all GNAT.OS_Lib.OS_Time;

      function C_Time (Time : OS_Time_A) return GNAT.OS_Lib.OS_Time;
      pragma Import (C, C_Time, "time");

   begin
      return OS_Time_To_Calendar_Time (C_Time (null));
   end GMT_Clock;

   ------------------------------
   -- OS_Time_To_Calendar_Time --
   ------------------------------

   function OS_Time_To_Calendar_Time (UTC : GNAT.OS_Lib.OS_Time)
      return Ada.Calendar.Time
   is
      Year   : Integer;
      Month  : Integer;
      Day    : Integer;
      Hour   : Integer;
      Minute : Integer;
      Second : Integer;
   begin
      GNAT.OS_Lib.GM_Split (UTC, Year, Month, Day, Hour, Minute, Second);
      return Ada.Calendar.Time_Of (Year, Month, Day,
                                   Duration (Hour   * 3600 +
                                             Minute * 60 +
                                             Second));
   end OS_Time_To_Calendar_Time;

end AWS.OS_Lib;