------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                 P O L Y O R B . S E T U P . S E R V E R                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--            Copyright (C) 2001 Free Software Foundation, Inc.             --
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

--  Set up a simple ORB to act as a server.
--  The user must take care of also setting up a tasking policy.

with PolyORB.Smart_Pointers;  --  WAG:3.15
pragma Elaborate_All (PolyORB.Smart_Pointers);
pragma Warnings (Off, PolyORB.Smart_Pointers);
--  The dependency and pragma above should not be necessary
--  (because of the dependency and pragma on PolyORB.References,
--  which has Smart_Pointers in its closure). They are necessary to
--  work around a bug in GNAT 3.15 (perhaps the same as 9530-011).

package PolyORB.Setup.Server is

   pragma Elaborate_Body;

end PolyORB.Setup.Server;