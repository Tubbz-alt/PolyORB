------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--               D Y N A M I C A N Y . D Y N V A L U E B O X                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--            Copyright (C) 2005 Free Software Foundation, Inc.             --
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
--                  PolyORB is maintained by AdaCore                        --
--                     (email: sales@adacore.com)                           --
--                                                                          --
------------------------------------------------------------------------------

with CORBA.Object;

with DynamicAny.DynValueBox.Impl;

package body DynamicAny.DynValueBox is

   ---------------------
   -- Get_Boxed_Value --
   ---------------------

   function Get_Boxed_Value (Self : in Local_Ref) return CORBA.Any is
      Self_Ref : constant CORBA.Object.Ref := CORBA.Object.Ref (Self);

   begin
      if CORBA.Object.Is_Nil (Self_Ref) then
         CORBA.Raise_Inv_Objref (CORBA.Default_Sys_Member);
      end if;

      return Impl.Get_Boxed_Value (Impl.Object_Ptr (Entity_Of (Self)));
   end Get_Boxed_Value;

   --------------------------------
   -- Get_Boxed_Value_As_Dyn_Any --
   --------------------------------

   function Get_Boxed_Value_As_Dyn_Any
     (Self : in Local_Ref)
      return DynAny.Local_Ref
   is
      Self_Ref : constant CORBA.Object.Ref := CORBA.Object.Ref (Self);

   begin
      if CORBA.Object.Is_Nil (Self_Ref) then
         CORBA.Raise_Inv_Objref (CORBA.Default_Sys_Member);
      end if;

      return
        Impl.Get_Boxed_Value_As_Dyn_Any (Impl.Object_Ptr (Entity_Of (Self)));
   end Get_Boxed_Value_As_Dyn_Any;

   ---------------------
   -- Set_Boxed_Value --
   ---------------------

   procedure Set_Boxed_Value
     (Self  : in Local_Ref;
      Boxed : in CORBA.Any)
   is
      Self_Ref : constant CORBA.Object.Ref := CORBA.Object.Ref (Self);

   begin
      if CORBA.Object.Is_Nil (Self_Ref) then
         CORBA.Raise_Inv_Objref (CORBA.Default_Sys_Member);
      end if;

      Impl.Set_Boxed_Value (Impl.Object_Ptr (Entity_Of (Self)), Boxed);
   end Set_Boxed_Value;

   --------------------------------
   -- Set_Boxed_Value_As_Dyn_Any --
   --------------------------------

   procedure Set_Boxed_Value_As_Dyn_Any
     (Self  : in Local_Ref;
      Boxed : in DynAny.Local_Ref)
   is
      Self_Ref : constant CORBA.Object.Ref := CORBA.Object.Ref (Self);

   begin
      if CORBA.Object.Is_Nil (Self_Ref) then
         CORBA.Raise_Inv_Objref (CORBA.Default_Sys_Member);
      end if;

      Impl.Set_Boxed_Value_As_Dyn_Any
        (Impl.Object_Ptr (Entity_Of (Self)), Boxed);
   end Set_Boxed_Value_As_Dyn_Any;

end DynamicAny.DynValueBox;