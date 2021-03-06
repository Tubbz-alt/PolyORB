------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--              P O L Y O R B . U T I L S . B A C K T R A C E               --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2011-2012, Free Software Foundation, Inc.          --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.                                               --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
--                  PolyORB is maintained by AdaCore                        --
--                     (email: sales@adacore.com)                           --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Strings.Unbounded;
with System.Address_Image;
with GNAT.Traceback;

package body PolyORB.Utils.Backtrace is

   use Ada.Strings.Unbounded;
   use GNAT.Traceback;

   ---------------
   -- Backtrace --
   ---------------

   function Backtrace return String is
      Tra : Tracebacks_Array (1 .. 64);
      Len : Natural;
      Res : Unbounded_String;
   begin
      Call_Chain (Tra, Len);
      for J in Tra'First .. Len loop
         if Length (Res) > 0 then
            Append (Res, ' ');
         end if;
         Append (Res, System.Address_Image (Tra (J)));
      end loop;
      return To_String (Res);
   end Backtrace;

end PolyORB.Utils.Backtrace;
