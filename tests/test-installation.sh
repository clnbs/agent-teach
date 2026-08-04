#!/usr/bin/env bash
# Installation et mise à jour.
#
# La promesse tient en une phrase : une mise à jour du moteur ne coûte jamais une
# ligne d'observation à l'apprenant. Ces tests l'attaquent.

. "$(dirname "$0")/aide.sh"

AT="$AT_DEPOT/bin/agent-teach"
D=$(neuf installation)

# --- ce que init pose
reussit "le skill est là"       test -f "$D/.claude/skills/teach/SKILL.md"
reussit "les références aussi"  test -f "$D/.claude/skills/teach/references/conduite.md"
reussit "les commandes aussi"   test -f "$D/.claude/commands/seance.md"
reussit "les hooks aussi"       test -f "$D/.claude/hooks/echeances.sh"
reussit "les hooks sont exécutables" test -x "$D/.claude/hooks/echeances.sh"
reussit "settings.json câblé"   test -f "$D/.claude/settings.json"
reussit "le manifeste voyage"   test -f "$D/.claude/NOYAU.manifest"
reussit "l'espace apprenant"    test -f "$D/progression/checklist.md"
reussit "le dossier de fiches"  test -d "$D/progression/fiches"
reussit "la zone intermédiaire" test -f "$D/curriculum.md"
reussit "cours/ existe"         test -d "$D/cours"
contient "cours/ est exclu du versionnement" "cours/" "$(cat "$D/.gitignore")"

# --- doctor valide une installation fraîche
reussit "doctor passe" "$AT" doctor "$D"

# --- l'apprenant travaille : profil, curriculum, journal, checklist, bloc AUTO
moteur "$D" ajouter 1.1 "Un module" --format F1 >/dev/null
moteur "$D" retest 1.1 rate --note "ne tient pas" >/dev/null
printf '\n### 2026-08-04 — module 1.1\n\nMon observation à moi.\n' >> "$D/progression/journal.md"
printf '\nMon curriculum à moi.\n' >> "$D/curriculum.md"
printf '\n- Pas de finance.\n'     >> "$D/CLAUDE.md"
printf '\n// ma permission à moi\n' >> "$D/.claude/settings.json"

tmp=$(mktemp "${TMPDIR:-/tmp}/at-auto.XXXXXX")
printf -- '- 2026-08-04 (3 obs.) — décroche quand la définition arrive avant le cas.\n' > "$tmp"
at_remplace_bloc "$D/.claude/skills/teach/SKILL.md" auto "$tmp"
rm -f "$tmp"

empreinte_journal=$(at_empreinte "$D/progression/journal.md")
empreinte_checklist=$(at_empreinte "$D/progression/checklist.md")
empreinte_curriculum=$(at_empreinte "$D/curriculum.md")
empreinte_claude=$(at_empreinte "$D/CLAUDE.md")
empreinte_settings=$(at_empreinte "$D/.claude/settings.json")

# --- init rejoué : idempotent, et sans perte
"$AT" init "$D" >/dev/null 2>&1
egal "init ne touche pas au journal"     "$empreinte_journal"     "$(at_empreinte "$D/progression/journal.md")"
egal "init ne touche pas à la checklist" "$empreinte_checklist"   "$(at_empreinte "$D/progression/checklist.md")"
egal "init ne touche pas au curriculum"  "$empreinte_curriculum"  "$(at_empreinte "$D/curriculum.md")"
egal "init ne touche pas à CLAUDE.md"    "$empreinte_claude"      "$(at_empreinte "$D/CLAUDE.md")"
egal "init ne touche pas à settings"     "$empreinte_settings"    "$(at_empreinte "$D/.claude/settings.json")"
contient "init préserve le bloc AUTO" "décroche quand la définition" \
  "$(at_bloc "$D/.claude/skills/teach/SKILL.md" auto)"
egal "et l'état du module tient" fragile "$(module "$D" 1.1 3)"

# --- maj : diff par défaut, rien n'est écrit
sortie=$("$AT" maj "$D")
contient "maj sans changement le dit" "rien à faire" "$sortie"

# on simule une nouvelle version du noyau
sauve=$(mktemp "${TMPDIR:-/tmp}/at-conduite.XXXXXX")
cp "$AT_DEPOT/noyau/skills/teach/references/conduite.md" "$sauve"
printf '\n<!-- I9 — nouveauté de la version suivante -->\n' \
  >> "$AT_DEPOT/noyau/skills/teach/references/conduite.md"

sortie=$("$AT" maj "$D")
contient "maj annonce le fichier"   "conduite.md" "$sortie"
contient "maj montre le diff"       "I9" "$sortie"
contient "maj n'écrit pas sans ordre" "Diff seulement" "$sortie"
absent   "le fichier n'a pas bougé" "I9" "$(cat "$D/.claude/skills/teach/references/conduite.md")"

# --- maj --appliquer : écrase le noyau, et rien d'autre
"$AT" maj "$D" --appliquer >/dev/null
contient "le noyau est à jour" "I9" "$(cat "$D/.claude/skills/teach/references/conduite.md")"
egal "maj ne touche pas au journal"     "$empreinte_journal"    "$(at_empreinte "$D/progression/journal.md")"
egal "maj ne touche pas à la checklist" "$empreinte_checklist"  "$(at_empreinte "$D/progression/checklist.md")"
egal "maj ne touche pas au curriculum"  "$empreinte_curriculum" "$(at_empreinte "$D/curriculum.md")"
egal "maj ne touche pas à CLAUDE.md"    "$empreinte_claude"     "$(at_empreinte "$D/CLAUDE.md")"
egal "maj ne touche pas à settings"     "$empreinte_settings"   "$(at_empreinte "$D/.claude/settings.json")"
contient "maj préserve le bloc AUTO" "décroche quand la définition" \
  "$(at_bloc "$D/.claude/skills/teach/SKILL.md" auto)"

cp "$sauve" "$AT_DEPOT/noyau/skills/teach/references/conduite.md"
rm -f "$sauve"
"$AT" maj "$D" --appliquer >/dev/null   # on redescend le noyau du dépôt

# --- le bloc AUTO seul ne compte pas comme une différence de version
tmp=$(mktemp "${TMPDIR:-/tmp}/at-auto.XXXXXX")
printf -- '- 2026-08-05 (2 obs.) — une deuxième observation.\n' > "$tmp"
at_remplace_bloc "$D/.claude/skills/teach/SKILL.md" auto "$tmp"
rm -f "$tmp"
contient "l'observation n'est pas un écart de noyau" "rien à faire" "$("$AT" maj "$D")"

# --- doctor voit ce qui manque et ne se tait pas
rm -f "$D/.claude/hooks/session-start.sh"
code "doctor échoue sur un noyau incomplet" 1 "$AT" doctor "$D"
contient "et dit lequel" "session-start.sh" "$("$AT" doctor "$D" 2>&1)"
"$AT" init "$D" >/dev/null 2>&1
reussit "init répare" "$AT" doctor "$D"

# --- doctor voit une balise arrachée
python3 - "$D" <<'PY' 2>/dev/null || sed -i.bak '/at:modules:fin/d' "$D/progression/checklist.md"
import sys
p = sys.argv[1] + "/progression/checklist.md"
s = open(p).read().replace("<!-- at:modules:fin -->", "")
open(p, "w").write(s)
PY
contient "doctor voit la balise arrachée" "at:modules" "$("$AT" doctor "$D" 2>&1)"

# --- init sur un dossier sans .gitignore complète au lieu de tout réécrire
E="$AT_TMP/sans-gitignore"
mkdir -p "$E"
printf '*.log\n' > "$E/.gitignore"
"$AT" init "$E" >/dev/null 2>&1
contient "l'ancien contenu reste" "*.log"  "$(cat "$E/.gitignore")"
contient "et cours/ est ajouté"   "cours/" "$(cat "$E/.gitignore")"

bilan
