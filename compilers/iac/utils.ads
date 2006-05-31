with Types;     use Types;

package Utils is

   procedure Capitalize (S : in out String);

   function Quoted (S : String; D : Character := '"') return String; --  "
   function Quoted (S : String; D : Character := '"') return Name_Id; --  "
   function Quoted (N : Name_Id; D : Character := '"') return String; --  "
   function Quoted (N : Name_Id; D : Character := '"') return Name_Id; --  "
   --  Embrace string S or name N with character D

   function To_Lower (N : Name_Id) return Name_Id;

end Utils;