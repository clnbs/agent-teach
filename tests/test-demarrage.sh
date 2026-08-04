#!/usr/bin/env bash
# Le hook de démarrage.
#
# Le dispositif se juge sur la deuxième séance, pas sur la première — et la
# deuxième séance commence par ce que la première a laissé. C'est ce hook qui le
# remet sous les yeux, sans que personne ait à le demander.

. "$(dirname "$0")/aide.sh"

D=$(neuf demarrage)
demarrer() { AT_RACINE="$D" bash "$D/.claude/hooks/session-start.sh"; }

renseigner() {
  python3 - "$D" "$1" "$2" <<'PY' 2>/dev/null && return 0
import sys
p, cle, val = sys.argv[1] + "/progression/profil.md", sys.argv[2], sys.argv[3]
s = open(p).read().replace("| %s | — |" % cle, "| %s | %s |" % (cle, val))
open(p, "w").write(s)
PY
  sed -i.bak "s/^| $1 | — |/| $1 | $2 |/" "$D/progression/profil.md"
}

# --- avant l'intake : une seule chose à dire, et une seule à faire
sortie=$(demarrer)
contient "l'intake manquant est annoncé" "L'intake n'a pas été fait" "$sortie"
contient "et la commande est donnée"     "/intake" "$sortie"
absent   "rien d'autre n'est affiché"    "Module suivant" "$sortie"
code "le hook réussit malgré tout" 0 demarrer

# --- après l'intake
renseigner mode_entree A
moteur "$D" ajouter 1.1 "Premier"  --format F1 >/dev/null
moteur "$D" ajouter 1.2 "Deuxième" --format F3 >/dev/null

sortie=$(demarrer)
absent   "l'intake n'est plus réclamé" "L'intake n'a pas été fait" "$sortie"
contient "le module suivant est nommé" "1.1" "$sortie"
contient "avec son format prévu"       "F1"  "$sortie"
contient "et le rituel est rappelé"    "12 minutes de re-test" "$sortie"

# --- une checklist vide malgré un profil : l'ingestion a échoué, on le dit
E=$(neuf demarrage-vide)
AT_RACINE="$E" python3 - "$E" <<'PY' 2>/dev/null || true
import sys
p = sys.argv[1] + "/progression/profil.md"
s = open(p).read().replace("| mode_entree | — |", "| mode_entree | B |")
open(p, "w").write(s)
PY
contient "ingestion non aboutie" "checklist est vide" "$(AT_RACINE="$E" bash "$E/.claude/hooks/session-start.sh")"

# --- séance non close : c'est la première chose affichée
moteur "$D" ouvrir 1.1 >/dev/null
sortie=$(demarrer)
contient "la séance ouverte est signalée" "Séance non close" "$sortie"
contient "avec son module"                "1.1" "$sortie"
contient "et l'ordre de priorité"         "Commencer par là" "$sortie"

printf '\n### %s — module 1.1\n\nMon observation.\n' "$(at_today)" >> "$D/progression/journal.md"
sortie=$(demarrer)
contient "journal écrit : on propose de clore" "cloturer 1.1" "$sortie"
absent   "et on ne réclame plus le journal"    "Commencer par là" "$sortie"

moteur "$D" cloturer 1.1 acquis >/dev/null

# --- les dus remontent
moteur "$D" retest 1.2 rate >/dev/null 2>&1 || true
printf '\n### %s — module 1.2\n' "$(at_today)" >> "$D/progression/journal.md"
moteur "$D" cloturer 1.2 fragile --note "manque le second membre" >/dev/null
sortie=$(demarrer)
contient "le fragile est dû"   "1.2" "$sortie"
contient "avec ce qui coince"  "manque le second membre" "$sortie"

# --- les patterns consolidés remontent, parce que c'est sur eux que ça porte
python3 - "$D" <<'PY' 2>/dev/null || true
import sys
p = sys.argv[1] + "/progression/journal.md"
s = open(p).read().replace(
  "| Pattern | Mode | Occurrences | Contre-mesure appliquée |\n|---|---|---|---|\n",
  "| Pattern | Mode | Occurrences | Contre-mesure appliquée |\n|---|---|---|---|\n"
  "| Confond frontière et exception | M2 | 2026-07-28, 2026-08-04 | cas jumeaux |\n")
open(p, "w").write(s)
PY
sortie=$(demarrer)
contient "le pattern remonte"    "Confond frontière et exception" "$sortie"
absent   "sans l'en-tête du tableau" "| Pattern | Mode |" "$sortie"

# --- le garde-fou droit d'auteur
mkdir -p "$D/cours"
python3 - "$D" <<'PY' 2>/dev/null || true
import sys
p = sys.argv[1] + "/.gitignore"
open(p, "w").write(open(p).read().replace("\ncours/\n", "\n"))
PY
sortie=$(demarrer)
contient "cours/ non exclu : c'est dit" "n'est pas dans" "$sortie"
contient "et la raison est donnée"      "droit d'auteur" "$sortie"

# --- hors d'un dossier de cours, le hook se tait au lieu d'échouer
code "hors dossier de cours : silence" 0 env AT_RACINE= CLAUDE_PROJECT_DIR=/ \
  bash "$D/.claude/hooks/session-start.sh"

bilan
