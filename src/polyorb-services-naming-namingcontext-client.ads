------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--              POLYORB.SERVICES.NAMING.NAMINGCONTEXT.CLIENT                --
--                                                                          --
--                                 S p e c                                  --
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

with PolyORB.References;

package PolyORB.Services.Naming.NamingContext.Client is

   procedure Bind
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name;
      Obj  : PolyORB.References.Ref);

   Bind_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/bind:1.0";

   procedure Rebind
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name;
      Obj  : PolyORB.References.Ref);

   Rebind_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/rebind:1.0";

   procedure Bind_Context
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name;
      Nc   : NamingContext.Ref);

   Bind_Context_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/bind_context:1.0";

   procedure Rebind_Context
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name;
      Nc   : NamingContext.Ref);

   Rebind_Context_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/rebind_context:1.0";

   function Resolve
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name)
     return PolyORB.References.Ref;

   Resolve_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/resolve:1.0";

   procedure Unbind
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name);

   Unbind_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/unbind:1.0";

   function New_Context
     (Self : PolyORB.Services.Naming.NamingContext.Ref)
     return NamingContext.Ref;

   New_Context_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/new_context:1.0";

   function Bind_New_Context
     (Self : PolyORB.Services.Naming.NamingContext.Ref;
      N    : Name)
     return NamingContext.Ref;

   Bind_New_Context_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/bind_new_context:1.0";

   procedure Destroy
     (Self : PolyORB.Services.Naming.NamingContext.Ref);

   Destroy_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/destroy:1.0";

--     procedure List
--       (Self     : PolyORB.Services.Naming.NamingContext.Ref;
--        How_Many : PolyORB.Types.Unsigned_Long;
--        Bl       :    out BindingList;
--        Bi       :    out BindingIterator_Forward.Ref);

   List_Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext/list:1.0";

   Repository_Id : constant Standard.String
     := "IDL:omg.org/CosNaming/NamingContext:1.0";

end PolyORB.Services.Naming.NamingContext.Client;