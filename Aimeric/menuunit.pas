unit menuUnit;

{$mode objfpc}{$H+}

interface

procedure menuGeneral();

implementation

//calcul du lvl du joueur en fonction de son xp
function calculLvl(joueur: personnage): integer;

begin
  if (joueur.xp < 100) then
  result := 1;
  if (joueur.xp => 100) AND (joueur.xp < 300) then
  result := 2;
  if (joueur.xp => 300) AND (joueur.xp < 500) then
  result := 3;
  if (joueur.xp => 500) AND (joueur.xp < 800) then
  result := 4;
  if (joueur.xp => 800) AND (joueur.xp < 1200) then
  result := 5;
  if (joueur.xp => 1200) AND (joueur.xp < 1700) then
  result := 6;
  if (joueur.xp => 1700) AND (joueur.xp < 2300) then
  result := 7;
  if (joueur.xp => 2300) AND (joueur.xp < 3000) then
  result := 8;
  if (joueur.xp => 3000) AND (joueur.xp < 4000) then
  result := 9;
  if (joueur.xp > 4000) then
  result := 10;
end;

//chambre : inventaire de perso et repos
procedure chambre(joueur : perso; dormi : boolean);

var
  choixU : integer; //Choix du joueur dans le menu
  rep : boolean; //Répète le menu tant que le joueur ne décide pas de quitter

begin
  rep := TRUE;

  while rep do
  begin
    choixU := affichageChambre(); //Récupération du choix de l'utilisateur

    if (choixU = 1) then //Le joueur ouvre l'inventaire
    begin
      inventairePerso();
    end
    else
    begin
      if (choixU = 2)//le joueur va dormir
      begin
        litAffichage(dormi);

        if dormi = FALSE then
        begin
          dormi := TRUE;

          vieActu.joueur := vieActu.joueur + (vieMax.joueur div 5); //regen du perso
          if (vieActu.joueur > vieMax.joueur) then //si la regen fait dépasser sa vie max, on le remet à sa vie max
          vieActu.joueur := vieMax.joueur;
        end;
      end // if (choixU = 2)
      else
      begin // Le joueur veut quitter
        rep := FALSE;
      end;
    end; //if (choixU = 1) then
  end; //while rep do

end;

//marchand : achat d'objets
procedure marchand();

begin

end;

//Ville : choix entre les batiments et le combat
procedure ville(joueur : perso; dormi : boolean);

var
  choixU : integer; //Le choix de l'utilisateur (qu'es-ce qu'il veut faire)

begin
  choixU := villeAffichage();

  if choixU = 5 then
  dormi := FALSE;

  case choixU of
  1 : chambre(joueur, dormi);
  2 : marchand(joueur);
  3 : cantine(joueur));
  4 : forge(joueur);
  5 : combat(joueur);
  else menuGeneral();
  end;

end;

//Lancement d'une nouvelle partie
procedure nouvellePartie();

var
  joueur : personnage; //record du joueur
  dormi : boolean; //boolean indiquant si le joueur a fait une chasse depuis sa

begin
  dormi := FALSE;
  regles();
  joueur := creaPerso();
  ville(joueur, dormi);
end;

//Menu principal du jeu
procedure menuGeneral();

var
  choixU : boolean;

begin
  choixU := menuGeneralAffichage; //TRUE pour jouer / FALSE pour quitter

  if choixU then
  nouvellePartie;
end;

end.

