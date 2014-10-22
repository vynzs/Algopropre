with Objet_Packing;
use Objet_Packing;

Package Packing is

   Objet_Trop_Grand : exception;
   --Levee dans next_fit_decreasing_height si un objet est plus large qu le ruban

   procedure Next_Fit_Decreasing_Height(Objets : in out Tableau_Objets; Largeur_Ruban : in Integer; Hauteur_Ruban : out Integer);
   --Requiert : objets : tableau d'objets de largeur inférieure à celle du ruban, largeur_ruban : largeu du ruban utilise
   --garantie : objets tableau trie par hauteur decroissante d'objet place dans des niveaux croissant, hauteur_ruban : hauteur du ruban necessaire

end Packing;
