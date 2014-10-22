with Ada.Text_Io, Ada.Integer_Text_Io;
use Ada.Text_Io, Ada.Integer_Text_Io;
with Objet_Packing;
use Objet_Packing;

package body Svg is -- Tracé de Haut gauche vers Bas droite.
   
   type Point is  record
      X : Natural;
      Y : Natural;
   end record;
   
   type Couleur is record
      R : Integer range 0..255;
      G : Integer range 0..255;
      B : Integer range 0..255;
   end record;
   
   Output : File_Type; -- Flux sortant
   Coord_Act : Point; -- Position actuelle dans le svg.
   Hauteur_Niveau: Integer :=0 ; -- Hauteur du niveau en train d'être dessiné.
   
   -- Couleurs prédéfinies.
   Noir : Couleur := (0,0,0);
   Gris : Couleur := (110,110,110);
   Orange : Couleur := (255,127,0);
   Rouge : Couleur := (150,0,0);
   Bleu : Couleur := (0,0,255);
   BlueClair : Couleur := (99,184,255);
   Vert : Couleur := (0,201,87);
     
       

   Set_Couleurs : array ( Integer range 0..1 , Integer range 0..2 ) of Couleur := ( 0 => ( 0 => Rouge, 1 => Orange, 2 => Gris ), 1 => ( 0 => Bleu, 1 => BleuClair, 2 => Vert));
   Set_Act : Integer range Set_Couleurs'Range(1) := Set_Couleurs'First(1);
   Couleur_Act : Integer range Set_Couleurs'Range(2) := Set_Couleurs'First(2);
   -- Couleurs qui seront utilisées pour le dessin : 
   -- Dans Set_Couleurs(X,Y), X correspond au jeu de couleurs actuellement utilisé (change à chaque niveau),
   -- et Y à l'indice de la couleur utilisée (change à chaque objet) 

   procedure Trace_Ligne  (A,B : in Point; Col : in Couleur) is
   begin
      Put(Output, " <line x1=""" & Integer'Image(A.X) & """ y1 =""" & Integer'Image (A.Y) & """ " ); -- Point de départ
      Put(Output, " x2=""" & Integer'Image(B.X) & """ y2 =""" & Integer'Image (B.Y) & """ " ); -- Point d'arrivée
      Put(Output, " style=""stroke:rgb(" & Integer'Image (Col.R) & "," & Integer'Image (Col.G) & "," & Integer'Image(Col.B) & ");stroke-width:2"" />"); -- Couleur et épaisseur;
      Put_Line (Output, ""); -- Retour à la ligne
   end Trace_Ligne;

   procedure Trace_Ruban (Largeur,Hauteur : in Integer ) is
   begin
      Trace_Ligne ((0,0),(Largeur,0),Noir);
      Trace_Ligne ((0,0),(0,Hauteur),Noir);
      Trace_Ligne ((Largeur,0),(Largeur,Hauteur),Noir);
   end Trace_Ruban;

   procedure Trace_Rectangle (Obj : in Objet; ColE : in Couleur ) is 
   begin

      Put(Output, "  <rect x=""" & Integer'Image(Coord_Act.X) & """ y=""" & Integer'Image(Coord_Act.Y) & """ " ); -- Départ rectangle (Haut,Gauche)
      Put(Output, "width=""" & Integer'Image(Largeur(Obj)) & """ " ); -- Largeur
      Put(Output, "height=""" & Integer'Image(Hauteur(Obj)) & """ " ); -- Hauteur
      Put(Output, " style=""fill:rgb(" & Integer'Image (ColE.R) & "," & Integer'Image (ColE.G) & "," & Integer'Image(ColE.B) & ");" );
      Put(Output, " stroke:black;stroke-width:0;opacity:0.5"" />")

      Coord_Act.X := Coord_Act.X + Largeur(Obj) ; -- On se déplace pour le prochain rectangle
   end Trace_Rectangle;

   procedure Init(Sortie : in String; Objets : in Tableau_Objets; Largeur,Haut : in Integer) is
   begin
      Coord_Act := (others => 0);
      Create (File => Output, Mode => Out_File, Name => Sortie);
      Put(Output, " <svg height=""" & Integer'Image(Haut + 100) & """ width=""" & Integer'Image(Largeur + 100) & """> "); -- En tête pour le moment
      Hauteur_Niveau := Hauteur( Objets(Objets'First) );
   end Init;



   procedure Sauvegarde (Sortie : in String; Objets : in Tableau_Objets; Largeur, Haut : in Integer) is
      Mauvais_Rangement : exception;
   begin

      Init(Sortie, Objets,Largeur,Haut);
      Trace_Ruban (Largeur, Haut);
      for I in Objets'Range loop
         Trace_Rectangle (Objets(I),Set_Couleurs(X,Y));
         Couleur_Act:= (Couleur_Act+1) mod (Set_Couleurs'Last(1)+1); -- Couleur prochain objet

         if I<Objets'Last and then Niveau(Objet_De_Tableau(Objets, I)) /= Niveau(Objet_De_Tableau(Objets,I+1)) then -- On s'apprêtre à changer de Niveau
            Coord_Act.X := 0;
            Coord_Act.Y := Coord_Act.Y + Hauteur_Niveau;
            Hauteur_Niveau := Hauteur(Objet_De_Tableau(Objets, I+1));  -- Hauteur du niveau = Hauteur du 1er objet du Niveau suivant
            Set_Act:= (Set_Act+1) mod (Set_Couleurs'Last(2)+1); -- Change de set de couleur.
         end if;

      end loop;
      Put_Line(Output, "</svg>");
      Close (Output);

   exception
      when Mauvais_Rangement =>
        Put_Line(Output, "</svg>");
         Close (Output);
         raise Mauvais_Rangement;

   end Sauvegarde;


end Svg;
