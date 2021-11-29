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

function choixMonstre();

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
  dragonMagmatique : monstre = (
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
    choixA := TRUE;//menuCombat; //le joueur attaque ou va dans son inventaire

    if (choixA = TRUE) then //si le joueur décide d'attaquer
    begin
      dU := (random(arme div 2) + (arme div 2)); //calcul des dégats que le joueur inflige au monstre
      reussite := random(100);
      //attaqueU(vieMd, dU, reussite); //affichage de l'attaque

      if ((reussite >= 20) AND (reussite <= 90)) then //Coup normal
      begin
        vieMd := vieMd - dU; //le monstre perd des pv
      end
      else if (reussite > 90) then //critique
      begin
        vieMd := vieMd - (dU * 2); //le monstre perd des pv
      end
    end
    else
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
  //attaqueM(dM, reussite); //affichage de l'attaque

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
  monstreActu := choixMonstre(random(4)); //choix aléatoire de la vie du monstre
  vieMi := (monstreActu.vieBase * joueur.lvl);
  arme := joueur.atkGlobal;


  if (vieU > vieMd) then //si le joeur a plus de vie que le monstre il commence
  vieMd := tourJ(vieMd, arme);

  while (vieU > 0) AND (vieMd > 0) do // tant qu'aucun des deux n'est mort, le combat continue
  begin
    vieU := tourM(vieMi, vieMd, vieU); //Tour du monstre

    if (vieU > 0) then //si le joueur n'a pas encore perdu
    vieMd := tourJ(vieMd, arme); //Tour du joueur

  end; //while (vieU > 0) AND (vieM > 0) do

  result := vieU;
end;

end.