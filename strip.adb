--paquetages classiques
with Ada.Command_line;
use Ada.Command_Line;
with Ada.Text_IO;
use Ada.Text_IO;

--paquetages "maison"
with Objet_Packing;
use Objet_Packing;
with Parseur;
with Packing;
with Svg;

procedure Strip is
	Nombre_Objets : Natural;
	Largeur_Ruban : Natural;
	Hauteur_Ruban : Natural;
begin

	if Argument_Count /= 2 then
		Put_Line(Standard_Error, "utilisation : strip benchmark.txt packing.svg");
		return;
	end if;

	Parseur.Lecture_En_Tete(Argument(1), Nombre_Objets, Largeur_Ruban);

	declare
		Objets : Tableau_Objets(1..Nombre_Objets);
	begin
		Parseur.Lecture(Argument(1), Objets);
		Packing.Next_Fit_Decreasing_Height(Objets, Largeur_Ruban, Hauteur_Ruban);
		Svg.Sauvegarde(Argument(2), Objets, Largeur_Ruban, Hauteur_Ruban);
	end;

exception
	when Parseur.Erreur_Lecture_Benchmark
		=> Put_Line(Standard_Error, "le fichier d'entree est illisible");
end;
