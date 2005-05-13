-------------------------------------------------
--  This file has been generated automatically
--  by IDLAC (http://libre.adacore.com/polyorb/)
--
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
-------------------------------------------------
pragma Style_Checks (Off);

with PolyORB.Utils.Strings;
with PolyORB.Initialization;
pragma Elaborate_All (PolyORB.Initialization);
with i1.Helper;
with PolyORB.CORBA_P.Domain_Management;
with PolyORB.CORBA_P.IR_Hooks;
with CORBA.Object.Helper;
with CORBA.ORB;
with CORBA.NVList;
with CORBA.ServerRequest;
with i1.Impl;
with CORBA;
pragma Elaborate_All (CORBA);
with PortableServer;
pragma Elaborate_All (PortableServer);
with PolyORB.CORBA_P.Exceptions;

package body i1.Skel is

   --  Skeleton subprograms

   function Servant_Is_A
     (Obj : PortableServer.Servant)
     return Boolean;

   function Servant_Is_A
     (Obj : PortableServer.Servant)
     return Boolean is
   begin
      return Obj.all in i1.Impl.Object'Class;
   end Servant_Is_A;

   procedure Invoke
     (Self : PortableServer.Servant;
      Request : in CORBA.ServerRequest.Object_ptr)
   is
      Operation : constant Standard.String
         := CORBA.To_Standard_String
              (CORBA.ServerRequest.Operation
               (Request.all));
      Arg_List_� : CORBA.NVList.Ref;
   begin
      CORBA.ORB.Create_List (0, Arg_List_�);
      if Operation = "_is_a" then
         declare
            Type_Id : CORBA.String;
            Arg_Name_�_Type_Id : constant CORBA.Identifier
            := CORBA.To_CORBA_String ("Type_Id");
            Argument_�_Type_Id : CORBA.Any := CORBA.To_Any (Type_Id);
            
            Result_� : CORBA.Boolean;
         begin
            CORBA.NVList.Add_Item
            (Arg_List_�,
            Arg_Name_�_Type_Id,
            Argument_�_Type_Id,
            CORBA.ARG_IN);

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any

               Type_Id :=
                 CORBA.From_Any (Argument_�_Type_Id);

               --  Call implementation
               Result_� := i1.Is_A
                 (CORBA.To_Standard_String (Type_Id));
            end;

            -- Set Result

            CORBA.ServerRequest.Set_Result
            (Request,
            CORBA.To_Any (Result_�));
            return;
         end;

      elsif Operation = "_interface" then

         CORBA.ServerRequest.Arguments (Request, Arg_List_�);

         CORBA.ServerRequest.Set_Result
           (Request,
            CORBA.Object.Helper.To_Any
            (CORBA.Object.Ref
             (PolyORB.CORBA_P.IR_Hooks.Get_Interface_Definition
              (CORBA.To_CORBA_String (Repository_Id)))));

         return;

      elsif Operation = "_domain_managers" then

         CORBA.ServerRequest.Arguments (Request, Arg_List_�);

         CORBA.ServerRequest.Set_Result
           (Request,
            PolyORB.CORBA_P.Domain_Management.Get_Domain_Managers
            (Self));

         return;

      elsif Operation = "_get_val1" then

         declare
            Result_�      : CORBA.Float;
         begin

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any


               --  Call implementation
               Result_� := i1.Impl.get_val1
                 (i1.Impl.Object'Class (Self.all)'Access);
            end;

            -- Set result

            CORBA.ServerRequest.Set_Result
              (Request, 
               CORBA.To_Any (Result_�));
            return;
         end;

      elsif Operation = "_set_val1" then

         declare
            To            : CORBA.Float;
            Arg_Name_�_To : constant CORBA.Identifier :=
              CORBA.To_CORBA_String ("To");
            Argument_�_To : CORBA.Any := CORBA.Internals.Get_Empty_Any
              (CORBA.TC_Float);

         begin
            CORBA.NVList.Add_Item
              (Arg_List_�,
               Arg_Name_�_To,
               Argument_�_To,
               CORBA.ARG_IN);

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any

               To :=
                 CORBA.From_Any (Argument_�_To);

               --  Call implementation
               i1.Impl.set_val1
                 (i1.Impl.Object'Class (Self.all)'Access,
                  To);
            end;
            return;
         end;

      elsif Operation = "_get_val2" then

         declare
            Result_�      : CORBA.Float;
         begin

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any


               --  Call implementation
               Result_� := i1.Impl.get_val2
                 (i1.Impl.Object'Class (Self.all)'Access);
            end;

            -- Set result

            CORBA.ServerRequest.Set_Result
              (Request, 
               CORBA.To_Any (Result_�));
            return;
         end;

      elsif Operation = "_set_val2" then

         declare
            To            : CORBA.Float;
            Arg_Name_�_To : constant CORBA.Identifier :=
              CORBA.To_CORBA_String ("To");
            Argument_�_To : CORBA.Any := CORBA.Internals.Get_Empty_Any
              (CORBA.TC_Float);

         begin
            CORBA.NVList.Add_Item
              (Arg_List_�,
               Arg_Name_�_To,
               Argument_�_To,
               CORBA.ARG_IN);

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any

               To :=
                 CORBA.From_Any (Argument_�_To);

               --  Call implementation
               i1.Impl.set_val2
                 (i1.Impl.Object'Class (Self.all)'Access,
                  To);
            end;
            return;
         end;

      elsif Operation = "_get_tab_val" then

         declare
            Result_�      : CORBA.Float;
         begin

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any


               --  Call implementation
               Result_� := i1.Impl.get_tab_val
                 (i1.Impl.Object'Class (Self.all)'Access);
            end;

            -- Set result

            CORBA.ServerRequest.Set_Result
              (Request, 
               CORBA.To_Any (Result_�));
            return;
         end;

      elsif Operation = "_set_tab_val" then

         declare
            To            : CORBA.Float;
            Arg_Name_�_To : constant CORBA.Identifier :=
              CORBA.To_CORBA_String ("To");
            Argument_�_To : CORBA.Any := CORBA.Internals.Get_Empty_Any
              (CORBA.TC_Float);

         begin
            CORBA.NVList.Add_Item
              (Arg_List_�,
               Arg_Name_�_To,
               Argument_�_To,
               CORBA.ARG_IN);

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any

               To :=
                 CORBA.From_Any (Argument_�_To);

               --  Call implementation
               i1.Impl.set_tab_val
                 (i1.Impl.Object'Class (Self.all)'Access,
                  To);
            end;
            return;
         end;

      elsif Operation = "_get_tab" then

         declare
            Result_�      : i1.Tab_Float;
         begin

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any


               --  Call implementation
               Result_� := i1.Impl.get_tab
                 (i1.Impl.Object'Class (Self.all)'Access);
            end;

            -- Set result

            CORBA.ServerRequest.Set_Result
              (Request, 
               i1.Helper.To_Any (Result_�));
            return;
         end;

      elsif Operation = "_set_tab" then

         declare
            To            : i1.Tab_Float;
            Arg_Name_�_To : constant CORBA.Identifier :=
              CORBA.To_CORBA_String ("To");
            Argument_�_To : CORBA.Any := CORBA.Internals.Get_Empty_Any
              (i1.Helper.TC_Tab_Float);

         begin
            CORBA.NVList.Add_Item
              (Arg_List_�,
               Arg_Name_�_To,
               Argument_�_To,
               CORBA.ARG_IN);

            CORBA.ServerRequest.Arguments (Request, Arg_List_�);

            begin
               --  Convert arguments from their Any

               To :=
                 i1.Helper.From_Any (Argument_�_To);

               --  Call implementation
               i1.Impl.set_tab
                 (i1.Impl.Object'Class (Self.all)'Access,
                  To);
            end;
            return;
         end;

      else
         CORBA.Raise_Bad_Operation (CORBA.Default_Sys_Member);
      end if;
   exception
      when E : others =>
         begin
            CORBA.ServerRequest.Set_Exception
              (Request,
               CORBA.Internals.To_CORBA_Any (PolyORB.CORBA_P.Exceptions.System_Exception_To_Any (E)));
            return;
         end;
   end Invoke;
   
   procedure Deferred_Initialization is
   begin
      PortableServer.Internals.Register_Skeleton
        (CORBA.To_CORBA_String (i1.Repository_Id),
         Servant_Is_A'Access,
         Is_A'Access,
         Invoke'Access);
   
   end Deferred_Initialization;

begin
   declare
      use PolyORB.Initialization;
      use PolyORB.Initialization.String_Lists;
      use PolyORB.Utils.Strings;
   begin
      Register_Module
        (Module_Info'
         (Name      => +"i1.Skel",
          Conflicts => Empty,
          Depends   =>
                  Empty
          ,
          Provides  => Empty,
          Implicit  => False,
          Init      => Deferred_Initialization'Access));
   end;

end i1.Skel;
