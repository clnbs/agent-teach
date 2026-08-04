#!/usr/bin/env bash
# agent-teach — installateur.
#
#   ./install.sh              met agent-teach sur le PATH
#   ./install.sh <dossier>    ça, puis installe un dossier de cours dans <dossier>
#
# N'installe rien de global : un lien symbolique dans ~/.local/bin, et c'est tout.
# Aucun compte, aucun service, aucune télémétrie. Le dépôt reste où il est.

set -eu

DEPOT=$(cd "$(dirname "$0")" && pwd)
BIN="${AT_BIN_DIR:-$HOME/.local/bin}"

command -v bash >/dev/null || { echo "bash introuvable." >&2; exit 1; }

mkdir -p "$BIN"
ln -sf "$DEPOT/bin/agent-teach" "$BIN/agent-teach"
chmod +x "$DEPOT/bin/agent-teach" "$DEPOT/noyau/hooks/"*.sh

echo "agent-teach $(cat "$DEPOT/noyau/VERSION") → $BIN/agent-teach"

case ":$PATH:" in
  *":$BIN:"*) ;;
  *)
    echo
    echo "⚠ $BIN n'est pas dans ton PATH. Ajoute cette ligne à ton ~/.zshrc :"
    echo
    echo "    export PATH=\"$BIN:\$PATH\""
    ;;
esac

if [ $# -ge 1 ]; then
  echo
  mkdir -p "$1"
  "$DEPOT/bin/agent-teach" init "$1"
else
  echo
  echo "Ensuite, dans le dossier où tu veux apprendre :"
  echo
  echo "    agent-teach init ."
  echo
  echo "Puis dépose tes supports dans cours/, ouvre \`claude\`, et lance /intake."
fi
