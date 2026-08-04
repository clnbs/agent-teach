#!/usr/bin/env bash
# agent-teach — aides de test.
#
# Pas de framework : bash 3.2 et rien d'autre, comme le reste du dispositif.
# Un test qui aurait besoin d'une dépendance testerait autre chose que ce qu'on
# livre.

set -u

AT_TESTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
AT_DEPOT=$(cd "$AT_TESTS/.." && pwd)
AT_TMP="$AT_TESTS/tmp"

. "$AT_DEPOT/noyau/hooks/lib.sh"

at_n=0
at_ko=0
at_fichier=$(basename "${0:-?}")

_ok()  { at_n=$(( at_n + 1 )); }
_ko()  { at_n=$(( at_n + 1 )); at_ko=$(( at_ko + 1 )); printf '  ✗ %s\n' "$1"; shift; [ $# -gt 0 ] && printf '    %s\n' "$@"; }

# egal LABEL ATTENDU OBTENU
egal() {
  if [ "$2" = "$3" ]; then _ok; else _ko "$1" "attendu : $2" "obtenu  : $3"; fi
}

# different LABEL PAS_CA OBTENU
different() {
  if [ "$2" != "$3" ]; then _ok; else _ko "$1" "ne devait pas valoir : $2"; fi
}

# contient LABEL AIGUILLE TEXTE
contient() {
  case "$3" in
    *"$2"*) _ok ;;
    *) _ko "$1" "devait contenir : $2" "texte : $(printf '%s' "$3" | head -3)" ;;
  esac
}

# absent LABEL AIGUILLE TEXTE
absent() {
  case "$3" in
    *"$2"*) _ko "$1" "ne devait pas contenir : $2" ;;
    *) _ok ;;
  esac
}

# reussit LABEL COMMANDE…
reussit() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then _ok; else _ko "$label" "échec : $*"; fi
}

# echoue LABEL COMMANDE…
echoue() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then _ko "$label" "aurait dû échouer : $*"; else _ok; fi
}

# code LABEL ATTENDU COMMANDE…
code() {
  local label="$1" attendu="$2" obtenu; shift 2
  "$@" >/dev/null 2>&1; obtenu=$?
  egal "$label (code de sortie)" "$attendu" "$obtenu"
}

# neuf NOM -> chemin d'un dossier de cours fraîchement installé
neuf() {
  local d="$AT_TMP/$1"
  rm -rf "$d"
  mkdir -p "$d"
  "$AT_DEPOT/bin/agent-teach" init "$d" >/dev/null 2>&1 || at_die "init a échoué pour $1"
  printf '%s\n' "$d"
}

# moteur RACINE ARGS… -> sortie du moteur d'échéances de ce dossier
moteur() {
  local r="$1"; shift
  AT_RACINE="$r" "$r/.claude/hooks/echeances.sh" "$@"
}

# modules RACINE -> lignes de données de la checklist
modules() { at_modules "$1/progression/checklist.md"; }

# module RACINE ID CHAMP -> valeur d'un champ d'un module
module() {
  at_champ "$(modules "$1" | awk -F'|' -v id="$2" '$1 "" == id "" { print; exit }')" "$3"
}

bilan() {
  if [ "$at_ko" -eq 0 ]; then
    printf '  %-28s %2d assertions, tout passe\n' "$at_fichier" "$at_n"
    exit 0
  fi
  printf '  %-28s %2d assertions, %d ÉCHEC(S)\n' "$at_fichier" "$at_n" "$at_ko"
  exit 1
}
