#!/usr/bin/env bash
# La garde du journal.
#
# Le journal est le point unique de défaillance du dispositif : sans lui, pas de
# patterns, donc pas de fiches, donc plus rien qui distingue agent-teach d'un
# chatbot qui explique bien. Ces tests vérifient que la garde tient, et surtout
# qu'elle ne tient QUE dans le cas prévu — une garde qui se déclenche à tort
# interromprait la séance elle-même.

. "$(dirname "$0")/aide.sh"

D=$(neuf garde)
S="$D/.claude/.seance"
GATE="$D/.claude/hooks/journal-gate.sh"

garde() { AT_RACINE="$D" bash "$GATE"; }

moteur "$D" ajouter 1.1 "Un module" --format F1 >/dev/null

# --- hors séance, la garde dort
code "hors séance : la garde laisse passer" 0 garde
echoue "aucune séance ouverte" moteur "$D" seance-ouverte

# --- séance ouverte, journal non écrit : la garde dort ENCORE.
# C'est le point délicat : un hook Stop se déclenche à la fin de chaque tour.
moteur "$D" ouvrir 1.1 >/dev/null
reussit "séance ouverte détectée" moteur "$D" seance-ouverte
code "séance en cours : la garde ne coupe pas la parole" 0 garde
contient "l'état le dit" "journal NON écrit" "$(moteur "$D" seance-ouverte)"

# --- la clôture, elle, refuse
code "clôture refusée sans journal" 1 moteur "$D" cloturer 1.1 acquis
sortie=$(AT_RACINE="$D" "$D/.claude/hooks/echeances.sh" cloturer 1.1 acquis 2>&1)
contient "le refus est expliqué"  "CLÔTURE REFUSÉE" "$sortie"
contient "le refus dit quoi faire" "l'inférence" "$sortie"
reussit "le drapeau est posé" test -f "$S/cloture-refusee"
egal "et le module n'a pas bougé" a-faire "$(module "$D" 1.1 3)"

# --- une clôture refusée réveille la garde
code "après refus : la garde bloque" 2 garde
sortie=$(garde 2>&1)
contient "la garde dit le module"   "1.1" "$sortie"
contient "la garde dit quoi écrire" "écarte" "$sortie"

# --- mais jamais deux fois de suite : l'anti-boucle prime sur tout
relance() { printf '{"session_id":"x","stop_hook_active":true}' | AT_RACINE="$D" bash "$GATE"; }
code "anti-boucle : la garde s'efface" 0 relance

# --- écrire le journal désarme la garde, sans rien demander
printf '\n### %s — module 1.1 — format réel : F3\n\nLe cas posé : …\n' "$(at_today)" \
  >> "$D/progression/journal.md"
code "journal écrit : la garde passe" 0 garde
echoue "le drapeau est retiré" test -f "$S/cloture-refusee"
contient "l'état le dit" "journal écrit" "$(moteur "$D" seance-ouverte)"

# --- et la clôture passe
reussit "clôture acceptée" moteur "$D" cloturer 1.1 acquis --format-reel F3
egal "le module est clos" acquis "$(module "$D" 1.1 3)"
egal "le format réel est enregistré" F3 "$(module "$D" 1.1 6)"
echoue "la séance est refermée" test -f "$S/ouverture"
echoue "plus de séance ouverte" moteur "$D" seance-ouverte

# --- l'écart entre format prévu et format réel est une donnée, pas un défaut
printf '\n### %s — module 1.1 bis\n' "$(at_today)" >> "$D/progression/journal.md"
sortie=$(moteur "$D" cloturer 1.1 acquis --format-reel F4)
contient "l'écart est signalé" "Écart de format" "$sortie"
contient "et rattaché à /tune" "/tune" "$sortie"

# --- marqueur orphelin : la garde nettoie au lieu de bloquer
mkdir -p "$S"; : > "$S/cloture-refusee"
code "drapeau orphelin : on laisse passer" 0 garde
echoue "et il est nettoyé" test -f "$S/cloture-refusee"

# --- ouvrir remet le compteur à zéro
moteur "$D" ouvrir 1.1 >/dev/null
echoue "ouvrir efface un ancien refus" test -f "$S/cloture-refusee"
echoue "module inconnu : pas d'ouverture" moteur "$D" ouvrir 9.9

bilan
