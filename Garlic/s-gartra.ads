------------------------------------------------------------------------------
--                                                                          --
--                            GLADE COMPONENTS                              --
--                                                                          --
--                  S Y S T E M . G A R L I C . T R A C E                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision$                             --
--                                                                          --
--         Copyright (C) 1996,1997 Free Software Foundation, Inc.           --
--                                                                          --
-- GARLIC is free software;  you can redistribute it and/or modify it under --
-- terms of the  GNU General Public License  as published by the Free Soft- --
-- ware Foundation;  either version 2,  or (at your option)  any later ver- --
-- sion.  GARLIC is distributed  in the hope that  it will be  useful,  but --
-- WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHANTABI- --
-- LITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public  --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License  distributed with GARLIC;  see file COPYING.  If  --
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
--               GLADE  is maintained by ACT Europe.                        --
--               (email: glade-report@act-europe.fr)                        --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Streams;
with System.RPC;
with System.Garlic.Heart;

package System.Garlic.Trace is

   procedure Record_Trace
     (Partition : in System.RPC.Partition_ID;
      Data      : in Ada.Streams.Stream_Element_Array);
   --  Trace the message Data (and the time that has passed since the
   --  previous recording) and record it in the partition's trace file.

   procedure Deliver_Next_Trace (Last : out Boolean);
   --  Read the next trace from the partition's trace file, sleep for the
   --  recorded amount of time and deliver the message to Heart.Has_Arrived.

   procedure Initialize;
   --  Initialize trace/replay stuff.

   procedure Save_Partition_ID (Partition : in System.RPC.Partition_ID);
   --  Save our partition ID to a file named ''Command_Name & ".pid"''
   --  N.B. This is ugly -- too many files -- it'd be nice save the
   --  partition ID in the trace file instead.

   function Load_Partition_ID return System.RPC.Partition_ID;
   --  Load and return partition ID from the above mentioned file.

   function Get_Current_Execution_Mode return Heart.Execution_Mode_Type;
   --  So we won't have to rescan the argument list every time we need
   --  the execution mode.

end System.Garlic.Trace;
