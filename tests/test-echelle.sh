#!/usr/bin/env bash
# L'échelle d'espacement et les transitions de statut.
#
# Le tuteur émet un verdict ; le script décide de tout le reste. Ces tests
# vérifient que « tout le reste » est bien décidé ici et pas ailleurs.

. "$(dirname "$0")/aide.sh"

D=$(neuf echelle)
J=$(at_today)

moteur "$D" ajouter 1.1 "Un module" --format F1 >/dev/null

egal "à l'ajout : statut"   a-faire "$(module "$D" 1.1 3)"
egal "à l'ajout : barreau"  0       "$(module "$D" 1.1 7)"
egal "à l'ajout : échéance" "—"     "$(module "$D" 1.1 8)"

# --- clôture en acquis : premier barreau, J+3
printf '\n### %s — module 1.1\n' "$J" >> "$D/progression/journal.md"
moteur "$D" cloturer 1.1 acquis >/dev/null
egal "clos acquis : statut"   acquis                    "$(module "$D" 1.1 3)"
egal "clos acquis : barreau"  0                         "$(module "$D" 1.1 7)"
egal "clos acquis : échéance" "$(at_date_plus "$J" 3)"  "$(module "$D" 1.1 8)"
egal "clos acquis : vu le"    "$J"                      "$(module "$D" 1.1 4)"

# --- montée barreau par barreau
moteur "$D" retest 1.1 ok >/dev/null
egal "1er ok : barreau"   1                         "$(module "$D" 1.1 7)"
egal "1er ok : J+10"      "$(at_date_plus "$J" 10)" "$(module "$D" 1.1 8)"

moteur "$D" retest 1.1 ok >/dev/null
egal "2e ok : barreau"    2                         "$(module "$D" 1.1 7)"
egal "2e ok : J+30"       "$(at_date_plus "$J" 30)" "$(module "$D" 1.1 8)"

moteur "$D" retest 1.1 ok >/dev/null
egal "3e ok : barreau"    3                         "$(module "$D" 1.1 7)"
egal "3e ok : J+90"       "$(at_date_plus "$J" 90)" "$(module "$D" 1.1 8)"

# --- le 4ᵉ barreau réussi sort le module de la boucle, et pas avant
moteur "$D" retest 1.1 ok >/dev/null
egal "4e ok : consolidé"  consolide "$(module "$D" 1.1 3)"
egal "4e ok : plus d'échéance" "—"  "$(module "$D" 1.1 8)"

# --- un raté remet le compteur à zéro : toute l'échelle est à refaire
moteur "$D" ajouter 2.1 "Un autre" >/dev/null
printf '\n### %s — module 2.1\n' "$J" >> "$D/progression/journal.md"
moteur "$D" cloturer 2.1 acquis >/dev/null
moteur "$D" retest 2.1 ok >/dev/null
moteur "$D" retest 2.1 ok >/dev/null
egal "avant le raté : barreau" 2 "$(module "$D" 2.1 7)"

moteur "$D" retest 2.1 rate >/dev/null
egal "raté : statut"    fragile "$(module "$D" 2.1 3)"
egal "raté : barreau"   0       "$(module "$D" 2.1 7)"
egal "raté : dû ce jour" "$J"   "$(module "$D" 2.1 8)"

# --- partiel : reste fragile, compteur à zéro
moteur "$D" ajouter 3.1 "Un troisième" >/dev/null
printf '\n### %s — module 3.1\n' "$J" >> "$D/progression/journal.md"
moteur "$D" cloturer 3.1 acquis >/dev/null
moteur "$D" retest 3.1 ok >/dev/null
moteur "$D" retest 3.1 partiel >/dev/null
egal "partiel : statut"  fragile "$(module "$D" 3.1 3)"
egal "partiel : barreau" 0       "$(module "$D" 3.1 7)"

# --- un fragile qui repasse repart au premier barreau, pas là où il s'était arrêté
moteur "$D" retest 3.1 ok >/dev/null
egal "fragile → ok : statut"   acquis                   "$(module "$D" 3.1 3)"
egal "fragile → ok : barreau"  0                        "$(module "$D" 3.1 7)"
egal "fragile → ok : J+3"      "$(at_date_plus "$J" 3)" "$(module "$D" 3.1 8)"

# --- a-revoir : dû à la prochaine séance, sans calcul de date
printf '\n### %s — module 2.1 bis\n' "$J" >> "$D/progression/journal.md"
moteur "$D" cloturer 2.1 a-revoir >/dev/null
egal "a-revoir : statut"   a-revoir "$(module "$D" 2.1 3)"
egal "a-revoir : dû ce jour" "$J"   "$(module "$D" 2.1 8)"

# --- abandonné : hors du parcours, plus jamais d'échéance
printf '\n### %s — module 2.1 ter\n' "$J" >> "$D/progression/journal.md"
moteur "$D" cloturer 2.1 abandonne >/dev/null
egal "abandonné : statut"    abandonne "$(module "$D" 2.1 3)"
egal "abandonné : échéance"  "—"       "$(module "$D" 2.1 8)"

# --- verdicts et statuts inconnus sont refusés, pas interprétés
echoue "verdict inconnu refusé" moteur "$D" retest 3.1 presque
echoue "statut inconnu refusé"  moteur "$D" cloturer 3.1 bien
echoue "a-faire n'est pas une clôture" moteur "$D" cloturer 3.1 a-faire
echoue "module inconnu refusé"  moteur "$D" retest 9.9 ok

# --- recalculer est idempotent : il relit statuts et barreaux, rien d'autre
avant=$(modules "$D")
moteur "$D" recalculer >/dev/null
egal "recalculer ne change rien" "$avant" "$(modules "$D")"

bilan
