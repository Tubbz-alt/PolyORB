------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                  POLYORB.REPRESENTATIONS.CDR.GIOP_1_2                    --
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

with PolyORB.Initialization;
with PolyORB.Utils.Strings;

package body PolyORB.Representations.CDR.GIOP_1_2 is

   function Create return CDR_Representation_Access;

   procedure Deferred_Initialization;

   ------------
   -- Create --
   ------------

   function Create return CDR_Representation_Access is
   begin
      return new GIOP_1_2_CDR_Representation;
   end Create;

   -----------------------------
   -- Deferred_Initialization --
   -----------------------------

   procedure Deferred_Initialization is
   begin
      Register_Factory (1, 2, Create'Access);
   end Deferred_Initialization;

   --------------------
   -- Set_Converters --
   --------------------

   procedure Set_Converters
     (R : in out GIOP_1_2_CDR_Representation;
      C : PolyORB.GIOP_P.Code_Sets.Converters.Converter_Access;
      W : PolyORB.GIOP_P.Code_Sets.Converters.Wide_Converter_Access)
   is
   begin
      PolyORB.GIOP_P.Code_Sets.Converters.Set_GIOP_1_2_Mode (W.all);
      GIOP_1_1.Set_Converters (GIOP_1_1.GIOP_1_1_CDR_Representation (R), C, W);
   end Set_Converters;

begin
   declare
      use PolyORB.Initialization;
      use PolyORB.Initialization.String_Lists;
      use PolyORB.Utils.Strings;
   begin
      Register_Module
        (Module_Info'
         (Name      => +"representations.cdr.giop_1_2",
          Conflicts => Empty,
          Depends   => Empty,
          Provides  => Empty,
          Implicit  => False,
          Init      => Deferred_Initialization'Access,
          Shutdown  => null));
   end;
end PolyORB.Representations.CDR.GIOP_1_2;
