with Ada.Command_line;
use Ada.Command_Line;
with Ada.Text_IO;
use Ada.Text_IO;

package body Objet_Packing is


   function Nouvel_Objet (N, H, L : Integer) return objet is
      begin
      return(Num => N, Haut => H, Large => L, Niveau => -1);
      end;

   function Numero(O : Objet) return Integer is
   begin
      return(O.Num);
   end;

   function Hauteur(O : Objet) return Integer is
   begin
      return(O.Haut);
   end;

   function Largeur(O : Objet) return Integer is
   begin
      return(O.Large);
   end;

   function Niveau(O : Objet) return Integer is
   begin
      return(O.Niveau);
   end;

    procedure Place_Objet(O : in out Objet; N : Integer) is
       begin
          O.Niveau := N;
       end;

end Objet_Packing;

