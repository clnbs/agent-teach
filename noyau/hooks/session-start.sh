#!/usr/bin/env bash
# agent-teach — hook SessionStart.
#
# Zone : NOYAU. Écrasable à la mise à jour.
#
# Rôle : rendre l'état visible à l'ouverture, sans que personne ait à le demander.
# Le dispositif se juge sur la deuxième séance, pas sur la première — et la
# deuxième séance commence par ce que la première a laissé.
#
# Sortie sur stdout, ajoutée au contexte. Toujours exit 0 : un hook de démarrage
# qui échoue ne doit jamais empêcher d'ouvrir une session.

set -u

AT_ICI=$(cd "$(dirname "$0")" && pwd)
. "$AT_ICI/lib.sh"

RACINE=$(at_racine) || exit 0
CHECKLIST="$RACINE/progression/checklist.md"
JOURNAL="$RACINE/progression/journal.md"
PROFIL="$RACINE/progression/profil.md"
SEANCE="$RACINE/.claude/.seance"

echo "## agent-teach — état au $(at_today)"
echo

# --------------------------------------------------------- intake pas fait ----

if [ ! -f "$PROFIL" ] || [ -z "$(at_profil "$RACINE" mode_entree)" ]; then
  echo "**L'intake n'a pas été fait.** Aucun profil, donc aucun modèle d'apprenant :"
  echo "sans lui le dispositif n'est qu'un chatbot qui explique."
  echo
  echo "Lancer \`/intake\` — huit questions, deux validations, un quart d'heure."
  echo "Ne pas conduire de séance avant : un module travaillé hors curriculum ne"
  echo "s'inscrit nulle part et ne sera jamais re-testé."
  exit 0
fi

# ------------------------------------------------------- séance non close -----

if [ -f "$SEANCE/ouverture" ]; then
  module=$(cat "$SEANCE/module" 2>/dev/null)
  date_o=$(cat "$SEANCE/date" 2>/dev/null)
  echo "⚠ **Séance non close** — module \`${module:-?}\`, ouverte le ${date_o:-?}."
  if [ -f "$JOURNAL" ] && [ "$JOURNAL" -nt "$SEANCE/ouverture" ]; then
    echo "Le journal a été écrit. Clore avec :"
    echo '`.claude/hooks/echeances.sh cloturer '"${module:-<module>}"' <acquis|fragile|a-revoir>`'
  else
    echo "Le journal n'a pas été écrit. **Commencer par là** : écrire l'entrée du jour"
    echo "dans \`progression/journal.md\`, puis clore. Une séance non écrite est perdue."
  fi
  echo
fi

# ---------------------------------------------------------------- dus ---------

if [ -f "$CHECKLIST" ]; then
  echo '```'
  "$AT_ICI/echeances.sh" dues 2>/dev/null
  echo '```'
  echo
fi

# ------------------------------------------------------- module suivant -------

if [ -f "$CHECKLIST" ]; then
  suivant=$(at_modules "$CHECKLIST" | awk -F'|' '$3 == "a-faire" { print $1 "|" $2 "|" $5 }' \
            | while IFS= read -r l; do printf '%s\t%s\n' "$(at_cle_module "${l%%|*}")" "$l"; done \
            | LC_ALL=C sort | head -1 | cut -f2-)
  if [ -n "$suivant" ]; then
    printf 'Module suivant si rien ne bloque : **%s** — %s (format prévu %s).\n\n' \
      "$(at_champ "$suivant" 1)" "$(at_champ "$suivant" 2)" "$(at_champ "$suivant" 3)"
  else
    echo "Plus aucun module \`a-faire\`. Le parcours est couvert ; reste la boucle de re-test."
    echo
  fi
fi

# ------------------------------------------------------ patterns du journal ---

if [ -f "$JOURNAL" ]; then
  patterns=$(at_table_section "$JOURNAL" "Patterns consolidés" | head -4)
  if [ -n "$patterns" ]; then
    echo "**Patterns consolidés** — vus au moins deux fois, donc opposables :"
    printf '%s\n' "$patterns"
    echo
    echo "Ils se traitent en séance, pas à la fin : c'est là-dessus que porte le re-test."
    echo
  fi
fi

# ----------------------------------------------------------- garde-fous -------

avert=""
if [ -d "$RACINE/cours" ]; then
  if [ ! -f "$RACINE/.gitignore" ] || ! grep -q '^cours/' "$RACINE/.gitignore" 2>/dev/null; then
    avert="$avert
- \`cours/\` n'est pas dans \`.gitignore\`. Ce sont les supports du professeur, sous
  son droit d'auteur : les pousser sur un dépôt public crée un problème réel.
  Ajouter \`cours/\` au \`.gitignore\` avant tout commit."
  fi
fi
if [ -f "$CHECKLIST" ] && [ -z "$(at_modules "$CHECKLIST")" ]; then
  avert="$avert
- La checklist est vide alors que le profil existe : l'ingestion n'a pas abouti.
  Reprendre \`/intake\` à la passe de découpage."
fi

if [ -n "$avert" ]; then
  echo "**À régler :**$avert"
  echo
fi

echo "\`/seance\` pour ouvrir. La séance commence par 12 minutes de re-test, par des cas."
exit 0
