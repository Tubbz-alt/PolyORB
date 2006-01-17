------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                        R T C O R B A . M U T E X                         --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2004-2006, Free Software Foundation, Inc.          --
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

with PolyORB.Tasking.Mutexes;
with PolyORB.RTCORBA_P.Mutex;

package body RTCORBA.Mutex is

   ----------
   -- Lock --
   ----------

   procedure Lock (Self : Local_Ref) is
   begin
      PolyORB.Tasking.Mutexes.Enter
        (PolyORB.RTCORBA_P.Mutex.Mutex_Entity (Entity_Of (Self).all).Mutex);
   end Lock;

   ------------
   -- Unlock --
   ------------

   procedure Unlock (Self : Local_Ref) is
   begin
      PolyORB.Tasking.Mutexes.Leave
        (PolyORB.RTCORBA_P.Mutex.Mutex_Entity (Entity_Of (Self).all).Mutex);
   end Unlock;

end RTCORBA.Mutex;