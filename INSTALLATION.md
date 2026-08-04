# Installation

## Prérequis

| | |
|---|---|
| **Claude Code** | Le dispositif est un skill, des commandes et des hooks — il tourne dedans. |
| **bash** | Version 3.2 suffit : c'est celle que macOS livre encore, et tout a été écrit pour elle. |
| **Rien d'autre** | Pas de `jq`, pas de Python, pas de Node, pas de gestionnaire de paquets. Les scripts n'emploient que `awk`, `sed`, `sort` et `date`. |

Testé sur macOS (bash 3.2, date BSD) et Linux (bash 5, date GNU). L'arithmétique de
dates détecte la variante et se fait en UTC, pour qu'un changement d'heure ne décale
jamais une échéance.

## Installer

```sh
git clone <ce-dépôt> ~/agent-teach
~/agent-teach/install.sh
```

`install.sh` pose un lien symbolique dans `~/.local/bin` et s'arrête là. Rien de global,
aucun service, aucun démon. Si `~/.local/bin` n'est pas dans ton `PATH`, il te le dit et
te donne la ligne à ajouter.

Pour l'installer ailleurs : `AT_BIN_DIR=/usr/local/bin ~/agent-teach/install.sh`.

## Créer un dossier de cours

```sh
mkdir ~/cours/harmonie && cd ~/cours/harmonie
agent-teach init .
```

Ce que ça pose :

```
.claude/
├── skills/teach/      le tuteur et ses références
├── commands/          /intake /seance /revision /fiche /tune /maj
├── hooks/             le moteur d'échéances et les deux gardes
├── settings.json      câblage des hooks
└── NOYAU.manifest     la liste de ce qu'une mise à jour peut écraser
progression/           ← à toi, jamais écrasé
cours/                 ← tes supports, exclus du versionnement
curriculum.md          ← généré à l'intake, puis à toi
CLAUDE.md              ← idem
.gitignore
```

Puis, dans l'ordre :

1. **Dépose tes supports dans `cours/`** — PDF, slides, notes, annales. Si tu n'as pas de
   support, saute cette étape : l'intake proposera le mode « sujet libre » et
   constituera un corpus qu'il te fera valider.
2. **`claude`**, puis **`/intake`**.

Compte un quart d'heure. L'intake s'arrête sur deux validations : le corpus (mode sujet
libre seulement), puis le curriculum. Ce n'est pas une formalité — un plan validé se
suit, un plan subi s'abandonne en semaine trois.

Ensuite, `/seance` à chaque fois.

## Versionner ton dossier de cours

Recommandé : `git diff`, historique et retour arrière gratuits sur ton propre modèle
d'apprenant.

```sh
git init && git add . && git commit -m "installation"
```

Deux règles, et la première n'est pas négociable :

- **`cours/` reste exclu.** Le `.gitignore` posé par `init` s'en charge. Ce sont les
  supports de ton professeur, sous *son* droit d'auteur : un `git push` sur un dépôt
  public te crée un problème juridique réel.
- **`progression/` se versionne**, et c'est voulu. Mais il contient des observations
  intimes sur ta façon d'échouer : réfléchis avant de pousser ce dépôt où que ce soit.

## Mettre à jour

```sh
cd ~/agent-teach && git pull
agent-teach maj ~/cours/harmonie              # montre le diff, n'écrit rien
agent-teach maj ~/cours/harmonie --appliquer  # applique
```

Ce qui est écrasé est exactement ce que liste `.claude/NOYAU.manifest`, et rien d'autre.
`progression/`, `curriculum.md`, `CLAUDE.md` et `settings.json` n'y figurent pas : ils
sont protégés par leur absence, pas par une précaution du code.

Une seule fusion existe : le bloc de préférences observées de `SKILL.md` est prélevé
avant l'écrasement et réinjecté après. C'est de l'observation, la perdre coûterait des
semaines.

`agent-teach init .` rejoué fait la même chose, en réparant en plus ce qui manque.

## Quand quelque chose ne va pas

```sh
agent-teach doctor ~/cours/harmonie
```

Il vérifie le noyau fichier par fichier, les balises des tableaux réécrits par le moteur,
l'arithmétique de dates, et si `cours/` est bien exclu du versionnement. Il code 1 s'il
trouve quelque chose.

| Symptôme | Cause probable | Remède |
|---|---|---|
| « aucun dossier de cours trouvé » | La commande est lancée hors du dossier | `cd` dedans, ou `AT_RACINE=/chemin/du/cours` |
| « balise at:modules:fin absente » | Une balise `<!-- at:… -->` a été supprimée de `checklist.md` | La remettre — le moteur ne sait plus où écrire. `git checkout progression/checklist.md` si tu versionnes. |
| Les dates ne bougent plus | Les hooks ne sont pas exécutables | `chmod +x .claude/hooks/*.sh`, ou `agent-teach init .` |
| Le hook de démarrage ne dit rien | L'intake n'a pas été fait, ou `progression/checklist.md` est absent | `/intake` |
| Une clôture est refusée | C'est prévu : le journal n'a pas été écrit | Écrire l'entrée du jour, puis relancer |

Les commandes du moteur s'appellent aussi directement, ce qui est le moyen le plus court
de voir ce qui se passe :

```sh
.claude/hooks/echeances.sh etat
.claude/hooks/echeances.sh dues
.claude/hooks/echeances.sh dues --date 2026-09-01   # se projeter
.claude/hooks/echeances.sh recalculer               # réécrit les dates depuis les statuts
```

## Désinstaller

```sh
rm ~/.local/bin/agent-teach
rm -rf ~/agent-teach
```

Tes dossiers de cours restent, et restent lisibles : ce sont des fichiers markdown. Le
noyau dans `.claude/` ne sert plus, `progression/` continue de se lire tout seul. C'était
le but.

## Lancer les tests

```sh
tests/run.sh              # tout
tests/run.sh dates garde  # une sélection
```

Aucune dépendance là non plus : bash et coreutils, comme le reste. Un test qui aurait
besoin d'autre chose testerait autre chose que ce qu'on livre.
