#!/usr/bin/env bash
# L'arithmétique de dates. Si elle se trompe, tout le programme de révision se
# trompe silencieusement — c'est le seul endroit du dispositif où une erreur ne
# se voit pas à l'œil nu.

. "$(dirname "$0")/aide.sh"

# --- report simple
egal "J+1"                    2026-08-05 "$(at_date_plus 2026-08-04 1)"
egal "J+3"                    2026-08-07 "$(at_date_plus 2026-08-04 3)"
egal "J+90"                   2026-11-02 "$(at_date_plus 2026-08-04 90)"
egal "J+0"                    2026-08-04 "$(at_date_plus 2026-08-04 0)"

# --- franchissements
egal "fin de mois"            2026-09-01 "$(at_date_plus 2026-08-31 1)"
egal "fin d'année"            2027-01-01 "$(at_date_plus 2026-12-31 1)"
egal "février commun"         2026-03-01 "$(at_date_plus 2026-02-28 1)"
egal "février bissextile"     2028-02-29 "$(at_date_plus 2028-02-28 1)"
egal "après le 29 février"    2028-03-01 "$(at_date_plus 2028-02-29 1)"

# --- changement d'heure : l'arithmétique est en UTC, donc il ne se voit pas.
# Un J+3 posé la veille d'un passage à l'heure d'été doit rester un J+3.
egal "heure d'été (Europe)"   2026-03-30 "$(at_date_plus 2026-03-27 3)"
egal "heure d'hiver (Europe)" 2026-10-28 "$(at_date_plus 2026-10-25 3)"
egal "heure d'été (US)"       2026-03-11 "$(at_date_plus 2026-03-08 3)"

# --- écarts
egal "écart nul"              0    "$(at_jours_entre 2026-08-04 2026-08-04)"
egal "écart positif"          3    "$(at_jours_entre 2026-08-04 2026-08-07)"
egal "écart négatif"          -3   "$(at_jours_entre 2026-08-07 2026-08-04)"
egal "écart sur une année"    365  "$(at_jours_entre 2026-01-01 2027-01-01)"
egal "écart sur une bissextile" 366 "$(at_jours_entre 2028-01-01 2029-01-01)"

# --- aller-retour
egal "aller-retour J+30" 30 "$(at_jours_entre 2026-08-04 "$(at_date_plus 2026-08-04 30)")"

# --- l'échelle
egal "barreau 0"  3  "$(at_palier_jours 0)"
egal "barreau 1"  10 "$(at_palier_jours 1)"
egal "barreau 2"  30 "$(at_palier_jours 2)"
egal "barreau 3"  90 "$(at_palier_jours 3)"
echoue "barreau 4 hors échelle" at_palier_jours 4
egal "longueur de l'échelle" 4 "$AT_LADDER_LEN"

# --- validation : ce qui doit être refusé
reussit "date valide"          at_date_valide 2026-08-04
echoue  "tiret manquant"       at_date_valide 20260804
echoue  "mois à un chiffre"    at_date_valide 2026-8-04
echoue  "chaîne vide"          at_date_valide ""
echoue  "texte"                at_date_valide "demain"
echoue  "un tiret cadratin"    at_date_valide "—"
echoue  "13ᵉ mois"             at_date_valide 2026-13-01
echoue  "30 février"           at_date_valide 2026-02-30

bilan
