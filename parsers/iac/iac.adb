with GNAT.OS_Lib;    use GNAT.OS_Lib;

with Analyzer;  use Analyzer;
with Backend;   use Backend;
with Errors;    use Errors;
with Flags;     use Flags;
with Lexer;     use Lexer;
with Namet;     use Namet;
with Parser;    use Parser;
with Scopes;    use Scopes;
with Types;     use Types;
with Usage;

with Backend.Config;
with Frontend.Debug;

procedure IAC is
   Preprocessed_File : File_Descriptor;

begin

   --  Initialization step

   Namet.Initialize;
   Errors.Initialize;
   Backend.Config.Initialize;
   Scan_Flags;
   Scopes.Initialize;

   if Main_Source = No_Name then
      Usage;
   end if;

   Get_Name_String (Main_Source);
   if not Is_Regular_File (Name_Buffer (1 .. Name_Len)) then
      Add_Str_To_Name_Buffer (".idl");
      if Is_Regular_File (Name_Buffer (1 .. Name_Len)) then
         Main_Source := Name_Find;
      else
         Error_Name (1) := Main_Source;
         DE ("%not found");
      end if;
   end if;

   declare
      First, Last : Natural;
   begin
      Get_Name_String (Main_Source);

      --  Remove any prefix

      First := 1;
      for J in reverse 1 .. Name_Len loop
         if Name_Buffer (J) = '/'
           or else Name_Buffer (J) = '\'
         then
            First := J + 1;
            exit;
         end if;
      end loop;

      --  Remove any suffix.
      --
      --  Implementation note: we do not want any '.' character left
      --  in the specification unit name since this would require to
      --  define the parent unit as well.

      Last := Name_Len;
      for J in First .. Name_Len loop
         if Name_Buffer (J) = '.' then
            Last := J - 1;
            exit;
         end if;
      end loop;

      Set_Str_To_Name_Buffer (Name_Buffer (First .. Last));
      IDL_Spec_Name := Name_Find;
   end;

   --  The "cppargs" section is processed in Lexer.Preprocess.
   --  Preprocessor step

   Lexer.Preprocess (Main_Source, Preprocessed_File);

   if Preprocess_Only then
      Lexer.Output (Preprocessed_File);
      return;
   end if;

   --  Lexer step

   Lexer.Process (Preprocessed_File, Main_Source);

   --  Parser step

   Parser.Process (IDL_Spec);

   Analyze (IDL_Spec);

   if Print_Full_Tree then
      Frontend.Debug.W_Full_Tree;
   end if;

   if N_Errors > 0 then
      Error_Int (1) := N_Errors;
      Error_Int (2) := N_Warnings;
      if N_Warnings > 0 then
         DE ("$ error(s) and $ warning(s)");
      else
         DE ("$ error(s)");
      end if;
      return;

   elsif N_Warnings > 0 then
      Error_Int (1) := N_Warnings;
      DE ("$ warning(s)");
   end if;

   Generate (IDL_Spec);

exception when Fatal_Error =>
   null;
end IAC;
