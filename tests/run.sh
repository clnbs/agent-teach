#!/usr/bin/env bash
# agent-teach — lanceur de tests.
#
#   tests/run.sh              tout
#   tests/run.sh dates garde  seulement tests/test-dates.sh et tests/test-garde-*.sh

set -u

ICI=$(cd "$(dirname "$0")" && pwd)
DEPOT=$(cd "$ICI/.." && pwd)

rm -rf "$ICI/tmp"
mkdir -p "$ICI/tmp"

fichiers=""
if [ $# -eq 0 ]; then
  fichiers=$(ls "$ICI"/test-*.sh 2>/dev/null)
else
  for motif in "$@"; do
    fichiers="$fichiers $(ls "$ICI"/test-*"$motif"*.sh 2>/dev/null)"
  done
fi

[ -n "$(printf '%s' "$fichiers" | tr -d ' ')" ] || { echo "aucun test à lancer." >&2; exit 1; }

echo "agent-teach — tests  (bash $BASH_VERSION)"
echo

echecs=0
total=0
for f in $fichiers; do
  total=$(( total + 1 ))
  bash "$f" || echecs=$(( echecs + 1 ))
done

echo
if [ "$echecs" -eq 0 ]; then
  printf '%s fichiers de test, tout passe.\n' "$total"
  printf '%s\n' "$(date +%Y-%m-%dT%H:%M:%S) ok" > "$ICI/.last-run"
  exit 0
fi
printf '%s fichiers de test, %s en échec.\n' "$total" "$echecs"
printf 'Les dossiers de travail sont conservés dans tests/tmp/ pour inspection.\n'
printf '%s\n' "$(date +%Y-%m-%dT%H:%M:%S) echec" > "$ICI/.last-run"
exit 1
