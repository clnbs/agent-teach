#!/usr/bin/env bash
# Quels modules sont dus, et dans quel ordre.
#
# L'ordre n'est pas cosmétique : re-tester du plus ancien vers le plus récent est
# la contre-mesure directe du mode M3 (le dernier cas contamine les suivants).

. "$(dirname "$0")/aide.sh"

D=$(neuf dues)
J=2026-08-04

moteur "$D" ajouter 1.1 "Premier"   --format F1 >/dev/null
moteur "$D" ajouter 1.2 "Deuxième"  --format F3 >/dev/null
moteur "$D" ajouter 2.1 "Troisième" --format F2 >/dev/null
moteur "$D" ajouter 10.1 "Dixième"  --format F4 >/dev/null

# --- rien n'est dû tant que rien n'a été travaillé
sortie=$(moteur "$D" dues --date "$J")
contient "aucun dû au départ" "(rien)" "$sortie"
absent   "un a-faire n'est jamais dû" "1.1 " "$sortie"

# --- fixer un état connu, sans passer par les commandes : on teste la lecture
ecrire_etat() {
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-fix.XXXXXX")
  {
    printf '%s\n' "$AT_COLONNES"
    printf '%s\n' "$AT_SEPARATEUR"
    printf '%s\n' "$@"
  } > "$tmp"
  at_remplace_bloc "$D/progression/checklist.md" modules "$tmp"
  rm -f "$tmp"
}

ecrire_etat \
  '| 1.1 | Premier | acquis | 2026-08-01 | F1 | — | 0 | 2026-08-04 | — |' \
  '| 1.2 | Deuxième | acquis | 2026-08-03 | F3 | — | 1 | 2026-08-13 | — |' \
  '| 2.1 | Troisième | fragile | 2026-07-20 | F2 | — | 0 | 2026-08-04 | manque le second membre |' \
  '| 10.1 | Dixième | consolide | 2026-06-01 | F4 | — | 4 | — | — |'

sortie=$(moteur "$D" dues --date "$J")
contient "acquis échu est dû"        "1.1"  "$sortie"
contient "fragile est dû"            "2.1"  "$sortie"
absent   "acquis non échu n'est pas dû" "1.2"  "$sortie"
absent   "consolidé n'est plus jamais dû" "10.1" "$sortie"
contient "la note accompagne le module" "manque le second membre" "$sortie"

# --- l'ordre : le plus ancien d'abord (2.1 vu le 20/07, puis 1.1 vu le 01/08)
premier=$(printf '%s' "$sortie" | awk '/^  [0-9]/ { print $1; exit }')
egal "le plus ancien passe en premier" "2.1" "$premier"

# --- le retard est compté, pas arrondi
sortie=$(moteur "$D" dues --date 2026-08-09)
contient "retard affiché"        "+5j de retard" "$sortie"
contient "1.1 toujours dû"       "1.1" "$sortie"
absent   "1.2 pas encore échu"   "1.2" "$sortie"

# --- le mode de re-test dépend du statut
contient "fragile : cas variés"  "une variable modifiée à la fois" "$sortie"
contient "budget rappelé"        "12 minutes" "$sortie"

# --- une échéance devient due le jour dit, pas la veille
absent   "la veille : pas encore" "1.2" "$(moteur "$D" dues --date 2026-08-12)"
contient "le jour dit : dû"       "1.2" "$(moteur "$D" dues --date 2026-08-13)"

# --- un a-revoir se rejoue entier
ecrire_etat '| 3.1 | Quatrième | a-revoir | 2026-08-02 | F1 | — | 0 | 2026-08-04 | — |'
sortie=$(moteur "$D" dues --date "$J")
contient "a-revoir : module entier" "rejoué ENTIER" "$sortie"

# --- la section « à re-tester » de la checklist suit
moteur "$D" recalculer >/dev/null
dus=$(at_bloc "$D/progression/checklist.md" dus)
contient "le bloc dus est réécrit" "3.1" "$dus"

ecrire_etat '| 3.1 | Quatrième | consolide | 2026-08-02 | F1 | — | 4 | — | — |'
moteur "$D" recalculer >/dev/null
dus=$(at_bloc "$D/progression/checklist.md" dus)
contient "plus rien de dû : le bloc le dit" "Rien de dû" "$dus"

# --- une date invalide est refusée, pas devinée
echoue "date invalide refusée" moteur "$D" dues --date demain
echoue "option inconnue refusée" moteur "$D" dues --hier

bilan
