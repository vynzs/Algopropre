package Objet_Packing is

   type Objet is private;

   type Tableau_Objets is array(Integer range <>) of Objet;

   function Nouvel_Objet (N, H, L : Integer) return Objet;
   --Crée un objet (numero, hauteur, largeur, niveau) le niveau est initialisé a -1.

   function Numero(O : Objet) return Integer;

   function Hauteur(O : Objet) return Integer;

   function Largeur(O : Objet) return Integer;

   function Niveau(O : objet) return Integer;

   procedure Place_Objet(O : in out Objet; N : integer);
   --place l' objet O dans le n-ieme niveau

private

    type Objet is record
      Num : Integer;
      Haut : Integer;
      Large : Integer;
      Niveau :Integer;
    end record;

   end Objet_Packing;
