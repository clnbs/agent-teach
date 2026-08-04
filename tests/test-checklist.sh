#!/usr/bin/env bash
# La checklist : blocs balisés, tri, et robustesse de ce que le tuteur y écrit.
#
# Ce fichier appartient à l'apprenant. Le moteur n'a le droit d'y toucher qu'entre
# les balises — tout le reste doit survivre, y compris ce que l'apprenant y ajoute.

. "$(dirname "$0")/aide.sh"

D=$(neuf checklist)
C="$D/progression/checklist.md"

# --- ce qui est hors des balises ne bouge pas
printf '\n## Mes notes à moi\n\nCeci ne doit jamais disparaître.\n' >> "$C"
moteur "$D" ajouter 1.1 "Un module" --format F1 >/dev/null
contient "le texte de l'apprenant survit" "Ceci ne doit jamais disparaître." "$(cat "$C")"
contient "la légende survit"              "Comment lire ce tableau"          "$(cat "$C")"
contient "les balises survivent"          "at:modules:fin"                   "$(cat "$C")"

# --- tri naturel : 1.2 avant 10.1, et 2.1 après 1.10
moteur "$D" ajouter 10.1 "Dixième"  >/dev/null
moteur "$D" ajouter 1.10 "Dixième de un" >/dev/null
moteur "$D" ajouter 2.1  "Deuxième" >/dev/null
moteur "$D" ajouter 1.2  "Second"   >/dev/null
ordre=$(modules "$D" | awk -F'|' '{ printf "%s ", $1 }' | sed 's/ $//')
egal "tri naturel, pas lexicographique" "1.1 1.2 1.10 2.1 10.1" "$ordre"

# --- un identifiant à point n'en attrape pas un autre (1.1 n'est pas 1x1)
moteur "$D" retest 1.1 rate >/dev/null
egal "1.1 touché"     fragile "$(module "$D" 1.1 3)"
egal "1.10 intact"    a-faire "$(module "$D" 1.10 3)"
egal "1.2 intact"     a-faire "$(module "$D" 1.2 3)"

# --- un doublon est refusé
echoue "doublon refusé" moteur "$D" ajouter 1.1 "Encore"
egal "le titre d'origine tient" "Un module" "$(module "$D" 1.1 2)"

# --- ce que le tuteur écrit ne peut pas casser le tableau
moteur "$D" ajouter 4.1 "Titre | avec un tuyau" >/dev/null
egal "le pipe est neutralisé" "Titre / avec un tuyau" "$(module "$D" 4.1 2)"
egal "le tableau garde 5 lignes" 6 "$(modules "$D" | wc -l | tr -d ' ')"

moteur "$D" retest 4.1 rate --note "deux lignes
sur une cellule" >/dev/null
egal "le saut de ligne est neutralisé" "deux lignes sur une cellule" "$(module "$D" 4.1 9)"

# --- lecture du profil : seules les valeurs renseignées comptent
egal "champ vide = vide" "" "$(at_profil "$D" date_cible)"
python3 - "$D" <<'PY' 2>/dev/null || sed -i.bak 's/^| date_cible | — |/| date_cible | 2026-12-01 |/' "$D/progression/profil.md"
import sys
p = sys.argv[1] + "/progression/profil.md"
s = open(p).read().replace("| date_cible | — |", "| date_cible | 2026-12-01 |")
open(p, "w").write(s)
PY
egal "champ renseigné" "2026-12-01" "$(at_profil "$D" date_cible)"
egal "champ inconnu"   ""           "$(at_profil "$D" couleur_preferee)"

# --- le calendrier inversé dit ce qui rentre, et ce qui saute
sortie=$(moteur "$D" etat --date "$(at_today)")
contient "état : total"          "modules" "$sortie"
contient "état : date cible"     "date cible" "$sortie"

# Beaucoup de modules pour trois séances par semaine : ça ne rentre pas.
i=20
while [ "$i" -lt 90 ]; do moteur "$D" ajouter "$i.1" "Module $i" >/dev/null; i=$(( i + 1 )); done
sortie=$(moteur "$D" etat)
contient "trop de modules : c'est dit" "Ça ne rentre pas" "$sortie"
contient "et le remède est nommé"      "parcours minimal" "$sortie"
contient "triage, pas réordonnancement" "Triage, pas réordonnancement" "$sortie"

# --- une balise absente est une erreur franche, pas une écriture au hasard
cp "$C" "$C.sauve"
grep -v 'at:modules:fin' "$C.sauve" > "$C"
echoue "balise manquante : le moteur refuse" moteur "$D" recalculer
mv "$C.sauve" "$C"
reussit "balise rétablie : le moteur repart" moteur "$D" recalculer

bilan
