with Ada.Text_Io, Ada.Integer_Text_Io;
use Ada.Text_Io, Ada.Integer_Text_Io;
with Objet_Packing;
use Objet_Packing;

package body Parseur is
   Input :  File_Type; 
   Index, Largeur, Hauteur : Integer;

   procedure Lecture_En_Tete(Nom_Entree :in String; Nombre_Objets, Largeur_Ruban : out Integer) is

   begin
      Open (File => Input,
            Mode => In_File,
            Name => Nom_Entree);

      Get(Input, Nombre_Objets);
      Get(Input, Largeur_Ruban);
      Close (Input);
   exception
      when End_Error =>
         Close (Input);
         raise Erreur_Lecture_Benchmark;
   end Lecture_En_Tete;

   procedure Lecture(Nom_Entree : in String; Objets : in out Tableau_Objets) is
      Index, Hauteur, Largeur : Integer;
      O : Objet;

   begin
      Open (File => Input,
            Mode => In_File,
            Name => Nom_Entree);
      Skip_Line(Input); -- On passe les carac globales pour arriver au 1er objet
      Skip_Line(Input);

      for I in Objets'Range loop
         Get(Input,Index);
         Get(Input,Largeur);
         Get(Input,Hauteur);
         O := Nouvel_Objet(Index, Hauteur, Largeur);
	 Objets(I) := O; -- Distingue Identifiant objet et position dans tableau.
      end loop;
      
      if not End_Of_File(Input) then
	 Put_Line ("Attention : Objets annoncés < Objets définis ");
      end if;
      
      Close(Input);

   exception
      when End_Error =>
         Close (Input);
	 Put_Line ("Erreur : Objets annoncés > Objets définis");
         raise Erreur_Lecture_Benchmark;

   end Lecture;

end Parseur;









