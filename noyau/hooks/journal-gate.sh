#!/usr/bin/env bash
# agent-teach — hook Stop : la garde du journal.
#
# Zone : NOYAU. Écrasable à la mise à jour.
#
# Le journal est le point unique de défaillance du dispositif : sans lui, pas de
# patterns, donc pas de fiches, donc plus rien qui distingue agent-teach d'un
# chatbot qui explique bien. Cette garde existe pour ça, et pour rien d'autre.
#
# Elle est volontairement étroite. Un hook Stop se déclenche à la fin de CHAQUE
# tour d'assistant : bloquer dès qu'une séance est ouverte interromprait la séance
# elle-même toutes les trois phrases. La garde ne se réveille donc que si une
# clôture a été REFUSÉE — c'est-à-dire seulement après que quelqu'un a
# explicitement essayé de clore sans avoir écrit.
#
#   code 0  → on laisse passer
#   code 2  → stderr est renvoyé au modèle, qui reprend la main
#
# Toute condition inattendue laisse passer : une garde qui casse doit s'effacer,
# pas retenir l'apprenant en otage.

set -u

AT_ICI=$(cd "$(dirname "$0")" && pwd)
. "$AT_ICI/lib.sh"

# --- Anti-boucle : si la garde a déjà relancé le modèle, on ne recommence pas.
charge=""
if [ ! -t 0 ]; then charge=$(cat 2>/dev/null); fi
case "$charge" in
  *'"stop_hook_active"'*true*) exit 0 ;;
esac

RACINE=$(at_racine) || exit 0
SEANCE="$RACINE/.claude/.seance"

# Aucune clôture refusée en attente : rien à garder.
[ -f "$SEANCE/cloture-refusee" ] || exit 0

# Séance déjà close, ou marqueur orphelin : on nettoie et on laisse passer.
if [ ! -f "$SEANCE/ouverture" ]; then
  rm -f "$SEANCE/cloture-refusee"
  exit 0
fi

# Le journal a été écrit entre-temps : la garde s'efface d'elle-même.
if at_journal_ecrit "$RACINE"; then
  rm -f "$SEANCE/cloture-refusee"
  exit 0
fi

module=$(cat "$SEANCE/module" 2>/dev/null)
[ -n "$module" ] || module="<module>"

cat >&2 <<FIN
La séance sur le module $module ne peut pas se terminer : progression/journal.md
n'a pas été écrit depuis son ouverture, et la clôture a déjà été refusée une fois.

Écris l'entrée du jour maintenant, avant toute autre chose. Six à dix lignes,
factuelles, datées, dans progression/journal.md :

  - **Le cas posé** et la réponse effectivement donnée par l'apprenant — ses mots,
    pas une reformulation propre.
  - **L'inférence** : ce que cette réponse dit de sa façon de se tromper. Elle doit
    écarter explicitement au moins une explication concurrente, sinon ce n'est pas
    une inférence, c'est une impression.
  - **Le mode** (M1…M10) si un mode connu correspond, ou une étiquette improvisée
    en langue ordinaire — une étiquette qui ne colle à aucun mode existant est un
    signal positif, pas un échec de classement.
  - **La consigne** exécutable pour la prochaine séance.

Une observation vue deux fois devient un pattern opposable ; vue une fois, elle
n'est rien. C'est cette entrée qui décidera de la prochaine.

Puis :  .claude/hooks/echeances.sh cloturer $module <acquis|fragile|a-revoir>
FIN
exit 2
