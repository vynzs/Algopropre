with Objet_Packing;
use Objet_Packing;
with Ada.Text_Io;
use Ada.Text_Io;

package body Packing is

   procedure Echange (T : in out Tableau_Objets; I,J : in Integer) is
      Tmp : Objet;
   begin
      Tmp:=T(I);
      T(I):=T(J);
      T(J):=Tmp;
   end Echange;

   procedure TriR_Aux (T : in out Tableau_Objets; TF, TL : Integer) is -- [TF,TL] : Intervalle sur lequel on doit travailler
      Ind : Integer := (TF+TL)/2; -- Indice du pivot (on prend l'éléement du milieu)
      D,F : Integer := Ind; -- [D,F] : Intervalle d'éléments égaux au pivot.
      Tmp,P : Objet; -- P : Pivot.
      I : Integer := TF; -- Dans [TF,I-1] : Elements grantis > au pivot.
      J : Integer := Ind+1; -- Dans [F+1,J-1] : Elements garantis < au pivot.
      -- On a toujours TF<=I<=D<=F<=J<=TL+1
   begin
      if TL-TF >= 1 then
         P := T(Ind);
         while I < D loop -- Boucle sur les élements à gauche de [D,F].
            if Hauteur(T(I)) = Hauteur(P) then -- Element égal au pivot.
               Echange(T,I,D-1);
               D:=D-1;
            elsif Hauteur(T(I)) > Hauteur(P) then -- Doit placer l'élement à gauche du pivot (déjà le cas)
               I:=I+1;
            else -- Doit placer l'élement à droite.
               if J < TL + 1 then -- Si on peut, on les met après F.
                  Echange(T,I,J);
                  J:=J+1;
               else -- Si J vaut TL+1 : Toutes les cases après F sont déjà utilisées, on déplace donc [D,F] vers la gauche pour faire de la place.
                  Tmp := T(F);
                  T(F) := T(I);
                  T(I) := T(D-1);
                  T(D-1) := Tmp;
                  F := F-1;
                  D := D-1;
               end if;
            end if;
         end loop;

         while J < TL +1 loop -- Même boucle que précedement mais pour les éléments à droite de [D,F]
            if Hauteur (T(J)) = Hauteur(P) then
               Echange(T,J,F+1);
               J:=J+1;
               F:=F+1;
            elsif Hauteur (T(J)) > Hauteur (P) then -- Ici, obligé de déplacer [D,F] vers la droite pour mettre un élément à gauche de [D,F]
               Tmp:=T(D);
               T(D):=T(J);
               T(J):=T(F+1);
               T(F+1):=Tmp;
               D:=D+1;
               F:=F+1;
               J:=J+1;
            else
               J:=J+1;
            end if;
         end loop;
         TriR_Aux(T,TF,D-1);
         TriR_Aux(T,F+1,TL);
      end if;
   exception
      when Constraint_Error => -- Affiche variables en cas d'erreur.
         New_Line;
         Put(Integer'Image(Ind));
         Put(Integer'Image(TF));
         Put(Integer'Image(TL));
         Put(Integer'Image(T'First));
         raise Constraint_Error;
   end TriR_Aux;

   procedure TriR(T : in out Tableau_Objets) is -- Tri Rapide, ordre décroissant hauteur.
   begin
      TriR_Aux(T,T'First,T'Last);
   end TriR;
   
   procedure Next_Fit_Decreasing_Height(Objets : in out Tableau_Objets; Largeur_Ruban : in Integer; Hauteur_Ruban : out Integer) is
      T_O : Tableau_Objets := Objets;
      Hr : Integer ;
      Niveau_Courant : Integer := 1;
      Largeur_Restante_Courante : Integer := Largeur_Ruban;
      begin
         TriR(T_O);
	 Hr := Hauteur(Objet_De_Tableau(T_O, T_O'First)); -- Init hauteur totale a hauteur du 1er niveau
	 
         for I in Objets'Range loop 
            if Largeur(Objet_De_Tableau(T_O, I)) > Largeur_Ruban then
               raise Objet_Trop_Grand;
            end if;
	    
            if Largeur_Restante_Courante >= Largeur(Objet_De_Tableau(T_O, I)) then -- Si on peut, met objet dans niveau actuel.
               Place_Objet( T_O(I), Niveau_Courant);
               Largeur_Restante_Courante :=Largeur_Restante_Courante - Largeur(T_O(I));
            else -- Sinon passe au niveau suivant.
               Largeur_Restante_Courante:= Largeur_Ruban - Largeur(T_O(I));
               Niveau_Courant := Niveau_Courant + 1;
	       Place_Objet( T_O(I), Niveau_Courant);
	       Hr := Hr + Hauteur(T_O(I));
            end if;

         end loop;

         Hauteur_Ruban := Hr;
         Objets := T_O;

      exception
         when Objet_Trop_Grand =>
	    Put_Line("Un Objet Est Plus Large Que Le Ruban");
	    raise Objet_Trop_Grand; -- Pour ne pas continuer exécution.
      end;

end Packing;




