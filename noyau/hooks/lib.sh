#!/usr/bin/env bash
# agent-teach — bibliothèque commune aux hooks et au moteur d'échéances.
#
# Zone : NOYAU. Écrasable à la mise à jour. N'écrit jamais hors de progression/.
#
# Contraintes assumées :
#   - bash 3.2 (macOS livre encore cette version) : pas de tableaux associatifs,
#     pas de ${var,,}, pas de `mapfile`.
#   - aucune dépendance au-delà de coreutils/BSD utils : ni jq, ni python.
#   - dates manipulées en UTC pour que l'arithmétique ne dépende pas d'un
#     changement d'heure. « Aujourd'hui » reste local, c'est la seule exception.

set -u

AT_LADDER="3 10 30 90"   # échelle d'espacement, en jours
AT_LADDER_LEN=4

# ---------------------------------------------------------------- sorties ----

at_err() { printf '%s\n' "$*" >&2; }
at_die() { at_err "agent-teach: $*"; exit 1; }

# ------------------------------------------------------------------ dates ----

if date --version >/dev/null 2>&1; then
  AT_DATE_FLAVOUR=gnu
else
  AT_DATE_FLAVOUR=bsd
fi

at_today() { date +%Y-%m-%d; }

at_date_valide() {
  case "$1" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) : ;;
    *) return 1 ;;
  esac
  at_epoch "$1" >/dev/null 2>&1
}

# at_epoch AAAA-MM-JJ -> secondes depuis l'époque, minuit UTC
at_epoch() {
  if [ "$AT_DATE_FLAVOUR" = gnu ]; then
    date -u -d "$1 00:00:00" +%s 2>/dev/null
  else
    date -j -u -f "%Y-%m-%d %H:%M:%S" "$1 00:00:00" +%s 2>/dev/null
  fi
}

# at_depuis_epoch SECONDES -> AAAA-MM-JJ
at_depuis_epoch() {
  if [ "$AT_DATE_FLAVOUR" = gnu ]; then
    date -u -d "@$1" +%Y-%m-%d 2>/dev/null
  else
    date -u -r "$1" +%Y-%m-%d 2>/dev/null
  fi
}

# at_date_plus AAAA-MM-JJ N -> AAAA-MM-JJ
at_date_plus() {
  local e
  e=$(at_epoch "$1") || return 1
  [ -n "$e" ] || return 1
  at_depuis_epoch $(( e + $2 * 86400 ))
}

# at_jours_entre A B -> nombre de jours de A vers B (négatif si B est avant A)
at_jours_entre() {
  local a b
  a=$(at_epoch "$1") || return 1
  b=$(at_epoch "$2") || return 1
  [ -n "$a" ] && [ -n "$b" ] || return 1
  echo $(( (b - a) / 86400 ))
}

# at_palier_jours N -> nombre de jours du barreau N (0..3) de l'échelle
at_palier_jours() {
  local i=0 j
  for j in $AT_LADDER; do
    if [ "$i" -eq "$1" ]; then echo "$j"; return 0; fi
    i=$(( i + 1 ))
  done
  return 1
}

# --------------------------------------------------------------- racine ------

# Remonte jusqu'au dossier de cours (celui qui contient progression/checklist.md).
at_racine() {
  local d
  if [ -n "${AT_RACINE:-}" ]; then printf '%s\n' "$AT_RACINE"; return 0; fi
  if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -f "$CLAUDE_PROJECT_DIR/progression/checklist.md" ]; then
    printf '%s\n' "$CLAUDE_PROJECT_DIR"; return 0
  fi
  d=$(pwd)
  while [ "$d" != "/" ]; do
    if [ -f "$d/progression/checklist.md" ]; then printf '%s\n' "$d"; return 0; fi
    d=$(dirname "$d")
  done
  return 1
}

# ------------------------------------------------------ tableaux balisés -----

# at_bloc FICHIER NOM -> contenu strictement entre les balises, exclues
at_bloc() {
  awk -v n="$2" '
    $0 == "<!-- at:" n ":debut -->" { dedans = 1; next }
    $0 == "<!-- at:" n ":fin -->"   { dedans = 0; next }
    dedans { print }
  ' "$1"
}

# at_remplace_bloc FICHIER NOM FICHIER_CONTENU
# Remplace le contenu entre balises. Échoue si les balises manquent.
at_remplace_bloc() {
  local f="$1" n="$2" src="$3" tmp
  grep -q "<!-- at:$n:debut -->" "$f" || at_die "balise at:$n:debut absente de $f"
  grep -q "<!-- at:$n:fin -->"   "$f" || at_die "balise at:$n:fin absente de $f"
  tmp="$f.at-tmp.$$"
  awk -v n="$n" -v src="$src" '
    $0 == "<!-- at:" n ":debut -->" {
      print
      while ((getline ligne < src) > 0) print ligne
      close(src)
      dedans = 1
      next
    }
    $0 == "<!-- at:" n ":fin -->" { dedans = 0 }
    !dedans { print }
  ' "$f" > "$tmp" || { rm -f "$tmp"; at_die "échec de réécriture de $f"; }
  mv "$tmp" "$f"
}

# ------------------------------------------------------------- checklist -----
#
# Colonnes, dans cet ordre :
#   1 Module | 2 Titre | 3 Statut | 4 Dernière séance | 5 Format prévu
#   6 Format réel | 7 Barreau | 8 Prochain re-test | 9 Note
#
# Statuts : a-faire · acquis · fragile · a-revoir · consolide · abandonne

AT_COLONNES='| Module | Titre | Statut | Dernière séance | Format prévu | Format réel | Barreau | Prochain re-test | Ce qui reste bancal |'
AT_SEPARATEUR='|---|---|---|---|---|---|---|---|---|'

at_statut_valide() {
  case "$1" in
    a-faire|acquis|fragile|a-revoir|consolide|abandonne) return 0 ;;
    *) return 1 ;;
  esac
}

# Nettoie une valeur destinée à une cellule : pas de pipe, pas de saut de ligne.
at_cellule() {
  printf '%s' "$1" | tr '\n' ' ' | tr '|' '/' | sed 's/^ *//; s/ *$//'
}

# at_modules FICHIER -> lignes de données, champs séparés par « | », sans
# bordures ni espaces. En-tête et séparateur écartés.
at_modules() {
  at_bloc "$1" modules | awk '
    /^\|/ {
      ligne = $0
      sub(/^\| */, "", ligne)
      sub(/ *\|$/, "", ligne)
      gsub(/ *\| */, "|", ligne)
      if (ligne ~ /^-+$/ || ligne ~ /^-+\|/) next
      if (ligne ~ /^Module\|/) next
      if (ligne == "") next
      print ligne
    }'
}

# at_table_section FICHIER TITRE -> lignes de données du premier tableau qui suit
# le titre « ## TITRE », bordures comprises, en-tête et séparateur écartés.
#
# Sert à LIRE les fichiers de l'espace apprenant. Eux ne portent aucune balise, et
# c'est délibéré : une balise annonce « ce bloc est réécrit par le script », ce qui
# serait faux ici. On lit, on n'écrit pas.
at_table_section() {
  awk -v titre="$2" '
    $0 == "## " titre { section = 1; next }
    /^## /            { section = 0 }
    section && /^\|/ {
      if ($0 !~ /[^|: -]/) next          # ligne de séparation
      if (!entete) { entete = 1; next }  # ligne d en-tête
      print
    }
  ' "$1"
}

# at_champ "a|b|c" N -> champ N (1-indexé)
at_champ() {
  printf '%s\n' "$1" | awk -F'|' -v n="$2" '{ print $n }'
}

# Clé de tri naturelle d'un identifiant de module : 10.3 -> 0010.0003
at_cle_module() {
  printf '%s\n' "$1" | awk '{
    n = split($0, p, ".")
    out = ""
    for (i = 1; i <= n; i++) {
      if (p[i] ~ /^[0-9]+$/) out = out sprintf("%04d.", p[i])
      else out = out p[i] "."
    }
    print out
  }'
}

# Bloc (préfixe avant le premier point) d'un identifiant de module
at_bloc_module() {
  printf '%s\n' "$1" | awk -F. '{ print $1 }'
}

# ------------------------------------------------------------- profil --------

# at_profil RACINE CHAMP -> valeur, ou vide
at_profil() {
  local f="$1/progression/profil.md"
  [ -f "$f" ] || return 0
  at_bloc "$f" profil | awk -F'|' -v c="$2" '
    {
      cle = $2; val = $3
      gsub(/^ +| +$/, "", cle); gsub(/^ +| +$/, "", val)
      if (cle == c && val != "-" && val != "—") { print val; exit }
    }'
}
