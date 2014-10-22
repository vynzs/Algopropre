with objet_packing; use objet_packing;

package Parseur is
   
   Erreur_Lecture_Benchmark : exception;

   procedure Lecture_En_Tete(Nom_Entree :in String; Nombre_Objets, Largeur_Ruban : out Integer);
   procedure Lecture(Nom_Entree : in String; Objets : in out Tableau_Objets) ;
   -- Requiert : Nombre_Objets Objets, définis une unique fois, ayant tous des numéros différents.
   -- Garanti : Tableau contenant tout les objets en sortie.
   
end Parseur;
