------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--            CORBA.REPOSITORY_ROOT.INTERFACEATTREXTENSION.IMPL             --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--           Copyright (C) 2006, Free Software Foundation, Inc.             --
--                                                                          --
-- This specification is derived from the CORBA Specification, and adapted  --
-- for use with PolyORB. The copyright notice above, and the license        --
-- provisions that follow apply solely to the contents neither explicitely  --
-- nor implicitely specified by the CORBA Specification defined by the OMG. --
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

with CORBA.Repository_Root.Container.Impl;
with CORBA.Repository_Root.ExtAttributeDef;
with CORBA.Repository_Root.IDLType;
with CORBA.Repository_Root.IRObject.Impl;
with PortableServer;

package CORBA.Repository_Root.InterfaceAttrExtension.Impl is

   type Object is new PortableServer.Servant_Base with private;

   type Object_Ptr is access all Object'Class;

   function describe_ext_interface
     (Self : access Object)
      return InterfaceAttrExtension.ExtFullInterfaceDescription;

   function create_ext_attribute
     (Self           : access Object;
      id             : RepositoryId;
      name           : Identifier;
      version        : VersionSpec;
      IDL_type       : IDLType.Ref;
      mode           : AttributeMode;
      get_exceptions : ExceptionDefSeq;
      set_exceptions : ExceptionDefSeq)
      return ExtAttributeDef.Ref;

   package Internals is

      procedure Init
        (Self        : access Object'Class;
         Real_Object : IRObject.Impl.Object_Ptr);
      --  Recursively initialize object fields

   end Internals;

private

   type Object is new PortableServer.Servant_Base with record
      Real : Container.Impl.Object_Ptr;
   end record;

end CORBA.Repository_Root.InterfaceAttrExtension.Impl;
