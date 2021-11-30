unit combatUnit;

{$mode objfpc}{$H+}

interface

type
  monstre = packed record
    id: integer;
    vieBase: integer;
    dragon: boolean;
  end;

function combat(joueur : personnage): personnage;

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

function choixMonstre(nb : integer): monstre;

const
  griffon: monstre = (
    id:1;
    vieBase:100;
    dragon:TRUE;
  );
  dragonDesMontagnes: monstre = (
    id:2;
    vieBase:150;
    dragon:TRUE;
  );
  dragonElectrique : monstre = (
    id:3;
    vieBase:200;
    dragon:TRUE;
  );
  phoenix: monstre = (
    id:4;
    vieBase:250;
    dragon:FALSE;
  );

begin
  case nb of
  1:result := griffon;
  2:result := dragonDesMontagnes;
  3:result := dragonElectrique;
  4:result := phoenix;
  end;

end;

procedure loose(joueur : personnage): personnage;

begin
  joueur.vieActu := (joueur.vieBase div 5);
  result := joueur;
  affichageMort;
end;

procedure win();

begin

end;

//Tour du joueur
function tourJ(vieMd, arme : integer): integer;

var
  dU, reussite, idObjet : integer; //dU = dégats du joueur ; reussite = echec ou critique
  choixA, rep : boolean; //choixA = choix de l'utilisateur lors de son tour entre attaquer et aller dans son inventaire

begin
  rep := TRUE;

  while rep do
  begin
    rep := FALSE;
    choixA := menuCombat; //le joueur attaque ou va dans son inventaire

    if (choixA = TRUE) then //si le joueur décide d'attaquer
    begin
      dU := (random(arme div 2) + (arme div 2)); //calcul des dégats que le joueur inflige au monstre
      reussite := random(100);

      if ((reussite >= 20) AND (reussite <= 90)) then //Coup normal
      begin
        vieMd := vieMd - dU; //le monstre perd des pv
      end
      else if (reussite > 90) then //critique
      begin
        vieMd := vieMd - (dU * 2); //le monstre perd des pv
      end
    end
    else //le joueur ouvre son inventaire
    begin
      idObjet := afficheInventaire();
      if (idObjet = 0) do
      rep := TRUE;
      else
      UtiliserObjet(idObjet);
    end; //if (choixA = TRUE) then
    result := vieMd;
  end; //rep si joueur décide de simplement regarder son inventaire
end;

//Tour du monstre
function tourM(vieMi, vieMd, vieU : integer): integer;

var
  dM, reussite : integer; //dM = dégats du monstre ; reussite = echec ou critique

begin
  dM := random(((vieMi + vieMd) div 2) div 7); //calcul des dégats que le monstre inglige au joueur
  reussite := random(100);

  if ((reussite >= 20) AND (reussite <= 90)) then //Le coup rate
  begin
    vieU := vieU - dM; //le monstre perd des pv
  end
  else if (reussite > 90) then
  begin
    vieU := vieU - (dM * 2); //le monstre perd des pv
  end;

  result := vieU;
end;

//Logique du combat. Retourne le record du joueur
function combat(joueur: personnage): personnage;

var
  vieMi, vieMd : integer; //vieMd = vie du monstre actuel ; vieMi = vie du monstre initial
  monstreActu : monstre;

begin
  randomize;
  vieU := joueur.defGlobal;
  monstreActu := choixMonstre(random(4)); //choix aléatoire du monstre
  vieMi := ((monstreActu.vieBase * joueur.lvl)div 2);
  vieMd := vieMi;
  arme := joueur.atkGlobal;


  afficheCombat(monstreActu);

  if (vieU > vieMd) then //si le joeur a plus de vie que le monstre il commence
  vieMd := tourJ(vieMd, arme);
  attaqueU(vieMd, vieMi, vieU, joueur.defGlobal); //affichage de l'attaque

  while (vieU > 0) AND (vieMd > 0) do // tant qu'aucun des deux n'est mort, le combat continue
  begin
    vieU := tourM(vieMi, vieMd, vieU); //Tour du monstre
    attaqueU(vieMd, vieMi, vieU, joueur.defGlobal); //affichage de l'attaque

    if (vieU > 0) then //si le joueur n'a pas encore perdu
    vieMd := tourJ(vieMd, arme); //Tour du joueur
    attaqueU(vieMd, vieMi, vieU, joueur.defGlobal); //affichage de l'attaque

  end; //while (vieU > 0) AND (vieM > 0) do

  if (vieU > 0) then
  joueur := win
  else
  joueur := loose;

  result := joueur;
end;

end.
