------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                  POLYORB.BINDING_DATA.GIOP.IIOP.PRINT                    --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--           Copyright (C) 1-2004 Free Software Foundation, Inc.            --
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

with Common;
with Output;

with PolyORB.Binding_Data.Print;
with PolyORB.Initialization;

with PolyORB.GIOP_P.Tagged_Components.Print;
with PolyORB.Utils.Strings;

package body PolyORB.Binding_Data.GIOP.IIOP.Print is

   ------------------------
   -- Print_IIOP_Profile --
   ------------------------

   procedure Print_IIOP_Profile (Prof : Profile_Access) is
      use Common;
      use Output;

      use PolyORB.Utils;

      use PolyORB.GIOP_P.Tagged_Components.Print;

      IIOP_Prof : IIOP_Profile_Type renames IIOP_Profile_Type (Prof.all);

   begin
      Inc_Indent;

      Put_Line ("IIOP Version",
                Trimmed_Image (Integer (IIOP_Prof.Version_Major))
                & "." & Trimmed_Image (Integer (IIOP_Prof.Version_Minor)));

      Output_Address_Information (IIOP_Prof.Address);

      Output_Object_Information (IIOP_Prof.Object_Id.all);

      Output_Tagged_Components (IIOP_Prof.Components);

      Dec_Indent;
   end Print_IIOP_Profile;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize;

   procedure Initialize is
   begin
      PolyORB.Binding_Data.Print.Register
        (Tag_Internet_IOP, Print_IIOP_Profile'Access);
   end Initialize;

   use PolyORB.Initialization;
   use PolyORB.Initialization.String_Lists;
   use PolyORB.Utils.Strings;

begin
   Register_Module
     (Module_Info'
      (Name      => +"polyorb.binding_data.iiop.print",
       Conflicts => PolyORB.Initialization.String_Lists.Empty,
       Depends   => PolyORB.Initialization.String_Lists.Empty,
       Provides  => PolyORB.Initialization.String_Lists.Empty,
       Implicit  => False,
       Init      => Initialize'Access));
end PolyORB.Binding_Data.GIOP.IIOP.Print;
