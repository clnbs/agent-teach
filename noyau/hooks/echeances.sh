#!/usr/bin/env bash
# agent-teach — moteur d'échéances.
#
# Zone : NOYAU. Écrasable à la mise à jour.
#
# C'est ici que vit l'invariant « ce qui peut être calculé ne doit pas être
# deviné ». Le tuteur émet un verdict pédagogique ; ce script décide des dates.
# Aucune date de re-test n'est jamais écrite ailleurs qu'ici.
#
#   dues [--date J]                  ce qui est dû, du plus ancien au plus récent
#   etat [--date J]                  avancement, retard, calendrier inversé
#   ouvrir <module>                  ouvre une séance (marqueur + garde journal)
#   retest <module> <ok|rate|partiel> [--note …]
#   cloturer <module> <statut> [--format-reel F3] [--note …]
#   ajouter <module> <titre> [--format F1] [--statut a-faire]
#   recalculer                       réécrit les dates depuis statuts et barreaux
#   seance-ouverte                   0 si une séance est ouverte, 1 sinon

set -u

AT_ICI=$(cd "$(dirname "$0")" && pwd)
. "$AT_ICI/lib.sh"

RACINE=$(at_racine) || at_die "aucun dossier de cours trouvé (progression/checklist.md absent)."
CHECKLIST="$RACINE/progression/checklist.md"
JOURNAL="$RACINE/progression/journal.md"
SEANCE="$RACINE/.claude/.seance"

AUJOURDHUI=$(at_today)

# ------------------------------------------------------------- utilitaires ---

usage() {
  sed -n '10,17p' "$0" | sed 's/^#   \{0,1\}//'
  exit "${1:-0}"
}

# Réécrit intégralement le tableau des modules depuis un fichier de lignes
# « champ|champ|… », en recalculant la colonne « Prochain re-test ».
ecrire_modules() {
  local lignes="$1" tmp
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-modules.XXXXXX")
  {
    printf '%s\n' "$AT_COLONNES"
    printf '%s\n' "$AT_SEPARATEUR"
    LC_ALL=C sort -t'|' -k10,10 "$lignes" | awk -F'|' '{
      printf "| %s | %s | %s | %s | %s | %s | %s | %s | %s |\n",
             $1, $2, $3, $4, $5, $6, $7, $8, $9
    }'
  } > "$tmp"
  at_remplace_bloc "$CHECKLIST" modules "$tmp"
  rm -f "$tmp"
}

# Charge les modules dans un fichier temporaire, avec une 10ᵉ colonne de tri.
charger_modules() {
  local tmp
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-charge.XXXXXX")
  at_modules "$CHECKLIST" | while IFS= read -r l; do
    printf '%s|%s\n' "$l" "$(at_cle_module "$(at_champ "$l" 1)")"
  done > "$tmp"
  printf '%s\n' "$tmp"
}

# Date du prochain re-test, calculée — jamais saisie.
#   statut, dernière séance, barreau -> date ou « — »
calculer_echeance() {
  local statut="$1" depuis="$2" barreau="$3" jours
  case "$statut" in
    fragile|a-revoir) printf '%s\n' "$AUJOURDHUI" ;;
    acquis)
      if [ "$barreau" -ge "$AT_LADDER_LEN" ]; then printf '%s\n' "—"; return; fi
      jours=$(at_palier_jours "$barreau") || { printf '%s\n' "—"; return; }
      if at_date_valide "$depuis"; then at_date_plus "$depuis" "$jours"; else printf '%s\n' "$AUJOURDHUI"; fi
      ;;
    *) printf '%s\n' "—" ;;
  esac
}

# Un module est-il dû à la date donnée ?
est_du() {
  local statut="$1" echeance="$2" date_ref="$3"
  case "$statut" in
    fragile|a-revoir) return 0 ;;
    acquis)
      at_date_valide "$echeance" || return 1
      [ "$(at_jours_entre "$echeance" "$date_ref")" -ge 0 ] && return 0
      return 1 ;;
    *) return 1 ;;
  esac
}

# Les comparaisons d'identifiant se font en `$1 "" == id ""`, et la concaténation
# n'est pas décorative : awk traite un champ et une variable passées par -v comme
# des nombres quand ils en ont l'air, si bien que « 1.1 » et « 1.10 » sont égaux.
# La concaténation avec la chaîne vide force la comparaison textuelle.
exige_module() {
  awk -F'|' -v id="$1" '$1 "" == id "" { trouve = 1 } END { exit !trouve }' "$2" \
    || at_die "module « $1 » absent de la checklist. \`ajouter\` d'abord."
}

# Ligne complète d'un module, ou vide.
ligne_module() {
  awk -F'|' -v id="$1" '$1 "" == id "" { print; exit }' "$2"
}

# Réécrit aussi la section « à re-tester au prochain démarrage ».
rafraichir_dus() {
  local date_ref="$1" charge tmp n=0
  charge=$(charger_modules)
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-dus.XXXXXX")
  LC_ALL=C sort -t'|' -k4,4 -k10,10 "$charge" | while IFS='|' read -r id titre statut derniere fprevu freel barreau echeance note cle; do
    if est_du "$statut" "$echeance" "$date_ref"; then
      printf -- '- **%s** — %s · `%s`' "$id" "$titre" "$statut"
      [ -n "$note" ] && [ "$note" != "—" ] && printf ' · %s' "$note"
      printf '\n'
    fi
  done > "$tmp"
  n=$(wc -l < "$tmp" | tr -d ' ')
  if [ "$n" -eq 0 ]; then
    printf '_Rien de dû. Le module suivant du curriculum peut être pris._\n' > "$tmp"
  fi
  at_remplace_bloc "$CHECKLIST" dus "$tmp"
  rm -f "$tmp" "$charge"
  return 0
}

# ------------------------------------------------------------ sous-commandes -

cmd_dues() {
  local date_ref="$AUJOURDHUI" charge n=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --date) date_ref="$2"; shift 2 ;;
      *) at_die "option inconnue : $1" ;;
    esac
  done
  at_date_valide "$date_ref" || at_die "date invalide : $date_ref"

  charge=$(charger_modules)
  echo "Re-tests dus au $date_ref — du plus ancien au plus récent (contre-mesure M3)"
  echo
  # Tri : date de dernière séance croissante, puis identifiant naturel.
  LC_ALL=C sort -t'|' -k4,4 -k10,10 "$charge" | while IFS='|' read -r id titre statut derniere fprevu freel barreau echeance note cle; do
    if est_du "$statut" "$echeance" "$date_ref"; then
      case "$statut" in
        a-revoir) mode="module rejoué ENTIER en F4" ;;
        fragile)  mode="cas variés, une variable modifiée à la fois" ;;
        *)        mode="2–3 cas, barreau $barreau" ;;
      esac
      retard=""
      if at_date_valide "$echeance"; then
        j=$(at_jours_entre "$echeance" "$date_ref")
        [ "$j" -gt 0 ] && retard=" · +${j}j de retard"
      fi
      printf '  %-8s %-9s vu le %-10s → %s%s\n' "$id" "[$statut]" "${derniere:---}" "$mode" "$retard"
      [ -n "$note" ] && [ "$note" != "—" ] && printf '           %s\n' "$note"
    fi
  done
  n=$(LC_ALL=C sort -t'|' -k4,4 "$charge" | while IFS='|' read -r id titre statut derniere fprevu freel barreau echeance note cle; do
        est_du "$statut" "$echeance" "$date_ref" && echo x; done | wc -l | tr -d ' ')
  if [ "$n" -eq 0 ]; then
    echo "  (rien) — prendre le module suivant du curriculum."
  else
    echo
    echo "  Budget : 12 minutes, par des cas, jamais par la définition."
    echo "  Commencer par le cas difficile."
  fi
  rm -f "$charge"
}

cmd_etat() {
  local date_ref="$AUJOURDHUI" charge
  while [ $# -gt 0 ]; do
    case "$1" in
      --date) date_ref="$2"; shift 2 ;;
      *) at_die "option inconnue : $1" ;;
    esac
  done
  charge=$(charger_modules)

  local total=0 fait=0 afaire=0 acq=0 frg=0 rev=0 cons=0 aband=0
  while IFS='|' read -r id titre statut reste; do
    total=$(( total + 1 ))
    case "$statut" in
      a-faire)   afaire=$(( afaire + 1 )) ;;
      acquis)    acq=$(( acq + 1 ));  fait=$(( fait + 1 )) ;;
      fragile)   frg=$(( frg + 1 ));  fait=$(( fait + 1 )) ;;
      a-revoir)  rev=$(( rev + 1 ));  fait=$(( fait + 1 )) ;;
      consolide) cons=$(( cons + 1 )); fait=$(( fait + 1 )) ;;
      abandonne) aband=$(( aband + 1 )) ;;
    esac
  done < "$charge"

  local blocs
  blocs=$(awk -F'|' '{ split($1, p, "."); print p[1] }' "$charge" | LC_ALL=C sort -u | wc -l | tr -d ' ')

  echo "État du parcours au $date_ref"
  echo
  printf '  modules            %s au total, %s traités, %s à faire\n' "$total" "$fait" "$afaire"
  printf '  statuts            acquis %s · fragile %s · à revoir %s · consolidé %s' "$acq" "$frg" "$rev" "$cons"
  [ "$aband" -gt 0 ] && printf ' · abandonné %s' "$aband"
  printf '\n'
  printf '  blocs              %s (soit %s séances de révision de fin de bloc)\n' "$blocs" "$blocs"

  local cible seances_sem duree
  cible=$(at_profil "$RACINE" date_cible)
  seances_sem=$(at_profil "$RACINE" seances_par_semaine)
  duree=$(at_profil "$RACINE" duree_seance_min)
  [ -n "$seances_sem" ] || seances_sem=3
  [ -n "$duree" ] || duree=45

  echo
  if [ -z "$cible" ] || ! at_date_valide "$cible"; then
    echo "  Pas de date cible dans profil.md — régime sans calendrier inversé."
    echo "  Pas de compte à rebours, donc pas de triage : le parcours est intégral."
    echo "  C'est le critère de réussite déclaré à l'intake qui définit la fin :"
    local critere; critere=$(at_profil "$RACINE" critere_reussite)
    printf '    « %s »\n' "${critere:-non renseigné — à cadrer, voir R10}"
    rm -f "$charge"; return 0
  fi

  # Calendrier inversé : ce qui rentre, ce qui saute.
  local jours seances_dispo besoin
  jours=$(at_jours_entre "$date_ref" "$cible")
  if [ "$jours" -lt 0 ]; then
    printf '  Date cible          %s — DÉPASSÉE de %s jours.\n' "$cible" "$(( -jours ))"
    rm -f "$charge"; return 0
  fi
  seances_dispo=$(( jours * seances_sem / 7 ))
  besoin=$(( afaire + blocs ))

  printf '  date cible         %s — dans %s jours\n' "$cible" "$jours"
  printf '  budget déclaré     %s séances/semaine de %s min\n' "$seances_sem" "$duree"
  printf '  séances possibles  %s\n' "$seances_dispo"
  printf '  séances nécessaires %s (%s modules restants + %s révisions de bloc)\n' "$besoin" "$afaire" "$blocs"
  echo
  if [ "$besoin" -le "$seances_dispo" ]; then
    printf '  ✓ Ça rentre, avec %s séances de marge.\n' "$(( seances_dispo - besoin ))"
  else
    local saute=$(( besoin - seances_dispo ))
    printf '  ✗ Ça ne rentre pas : %s séances de trop.\n' "$saute"
    echo
    echo "  Les modules ne se compressent pas. On marque un parcours minimal (★) et"
    echo "  on annonce franchement ce qui saute : $saute modules, choisis sur les"
    echo "  annales et le barème s'ils existent, sur la centralité dans le graphe sinon."
    echo "  Triage, pas réordonnancement : on garde l'ordre pédagogique et on saute,"
    echo "  sinon les dépendances cassent."
  fi
  rm -f "$charge"
}

cmd_ajouter() {
  [ $# -ge 2 ] || at_die "usage : ajouter <module> <titre> [--format F1] [--statut a-faire]"
  local id titre format="—" statut="a-faire" charge
  id=$(at_cellule "$1"); titre=$(at_cellule "$2"); shift 2
  while [ $# -gt 0 ]; do
    case "$1" in
      --format) format=$(at_cellule "$2"); shift 2 ;;
      --statut) statut="$2"; shift 2 ;;
      *) at_die "option inconnue : $1" ;;
    esac
  done
  at_statut_valide "$statut" || at_die "statut inconnu : $statut"
  charge=$(charger_modules)
  if [ -n "$(ligne_module "$id" "$charge")" ]; then rm -f "$charge"; at_die "le module $id existe déjà."; fi
  printf '%s|%s|%s|—|%s|—|0|—|—|%s\n' "$id" "$titre" "$statut" "$format" "$(at_cle_module "$id")" >> "$charge"
  ecrire_modules "$charge"
  rm -f "$charge"
  rafraichir_dus "$AUJOURDHUI"
  echo "Module $id ajouté."
}

cmd_ouvrir() {
  [ $# -ge 1 ] || at_die "usage : ouvrir <module>"
  local charge
  charge=$(charger_modules)
  exige_module "$1" "$charge"
  rm -f "$charge"
  mkdir -p "$SEANCE"
  printf '%s\n' "$1" > "$SEANCE/module"
  printf '%s\n' "$AUJOURDHUI" > "$SEANCE/date"
  rm -f "$SEANCE/cloture-refusee"
  # Le marqueur ouvre la séance ; l'empreinte fige l'état du journal au moment
  # de l'ouverture. La clôture comparera, et c'est ce qui rend la garde exacte.
  : > "$SEANCE/ouverture"
  at_empreinte "$JOURNAL" > "$SEANCE/journal-empreinte"
  echo "Séance ouverte sur le module $1 au $AUJOURDHUI."
  echo "Elle ne pourra pas être close tant que progression/journal.md n'aura pas été écrit."
}

journal_ecrit() { at_journal_ecrit "$RACINE"; }

cmd_retest() {
  [ $# -ge 2 ] || at_die "usage : retest <module> <ok|rate|partiel> [--note …]"
  local id="$1" verdict="$2" note="" charge tmp
  shift 2
  while [ $# -gt 0 ]; do
    case "$1" in
      --note) note=$(at_cellule "$2"); shift 2 ;;
      *) at_die "option inconnue : $1" ;;
    esac
  done
  case "$verdict" in ok|rate|partiel) : ;; *) at_die "verdict inconnu : $verdict (ok|rate|partiel)" ;; esac

  charge=$(charger_modules)
  exige_module "$id" "$charge"
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-retest.XXXXXX")

  while IFS='|' read -r m_id titre statut derniere fprevu freel barreau echeance m_note cle; do
    if [ "$m_id" = "$id" ]; then
      case "$verdict" in
        ok)
          if [ "$statut" != "acquis" ]; then
            # Un fragile qui passe un re-test repart au premier barreau.
            statut=acquis; barreau=0
          else
            barreau=$(( barreau + 1 ))
          fi
          [ "$barreau" -ge "$AT_LADDER_LEN" ] && { statut=consolide; barreau=$AT_LADDER_LEN; }
          ;;
        rate)    statut=fragile; barreau=0 ;;
        partiel) statut=fragile; barreau=0 ;;
      esac
      derniere="$AUJOURDHUI"
      [ -n "$note" ] && m_note="$note"
      echeance=$(calculer_echeance "$statut" "$derniere" "$barreau")
    fi
    printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n' \
      "$m_id" "$titre" "$statut" "$derniere" "$fprevu" "$freel" "$barreau" "$echeance" "$m_note" "$cle"
  done < "$charge" > "$tmp"

  ecrire_modules "$tmp"
  rm -f "$charge" "$tmp"
  rafraichir_dus "$AUJOURDHUI"

  local ligne
  ligne=$(at_modules "$CHECKLIST" | awk -F'|' -v id="$id" '$1 "" == id "" { print; exit }')
  printf 'Re-test %s sur %s → statut %s, barreau %s, prochain le %s.\n' \
    "$verdict" "$id" "$(at_champ "$ligne" 3)" "$(at_champ "$ligne" 7)" "$(at_champ "$ligne" 8)"
  case "$verdict" in
    rate)    echo "Compteur remis à zéro : toute l'échelle est à refaire." ;;
    partiel) echo "Reste fragile. Écris au journal QUEL membre manquait (M4 ou M6)." ;;
  esac
}

cmd_cloturer() {
  [ $# -ge 2 ] || at_die "usage : cloturer <module> <acquis|fragile|a-revoir|abandonne> [--format-reel F3] [--note …]"
  local id="$1" statut="$2" freel="" note="" charge tmp
  shift 2
  while [ $# -gt 0 ]; do
    case "$1" in
      --format-reel) freel=$(at_cellule "$2"); shift 2 ;;
      --note)        note=$(at_cellule "$2");  shift 2 ;;
      *) at_die "option inconnue : $1" ;;
    esac
  done
  at_statut_valide "$statut" || at_die "statut inconnu : $statut"
  [ "$statut" = "a-faire" ] && at_die "a-faire n'est pas un statut de clôture."

  if ! journal_ecrit; then
    mkdir -p "$SEANCE"
    : > "$SEANCE/cloture-refusee"
    at_err "CLÔTURE REFUSÉE — progression/journal.md n'a pas été écrit depuis l'ouverture de la séance."
    at_err ""
    at_err "Ce n'est pas une formalité : le journal est le point unique de défaillance du"
    at_err "dispositif. Une séance non écrite est une séance perdue, et un journal bâclé"
    at_err "produit des fiches vides."
    at_err ""
    at_err "Écris l'entrée du jour — six à dix lignes factuelles :"
    at_err "  · le cas posé et la réponse donnée ;"
    at_err "  · l'inférence, qui doit écarter au moins une explication concurrente ;"
    at_err "  · la consigne exécutable pour la prochaine séance."
    at_err "Puis relance cette commande."
    exit 1
  fi

  charge=$(charger_modules)
  exige_module "$id" "$charge"
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-clot.XXXXXX")

  while IFS='|' read -r m_id titre m_statut derniere fprevu m_freel barreau echeance m_note cle; do
    if [ "$m_id" = "$id" ]; then
      # Un module qui n'était pas encore acquis repart au premier barreau.
      case "$statut" in
        acquis)            [ "$m_statut" = "acquis" ] || barreau=0 ;;
        fragile|a-revoir)  barreau=0 ;;
      esac
      m_statut="$statut"
      derniere="$AUJOURDHUI"
      [ -n "$freel" ] && m_freel="$freel"
      [ -n "$note" ] && m_note="$note"
      echeance=$(calculer_echeance "$m_statut" "$derniere" "$barreau")
    fi
    printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n' \
      "$m_id" "$titre" "$m_statut" "$derniere" "$fprevu" "$m_freel" "$barreau" "$echeance" "$m_note" "$cle"
  done < "$charge" > "$tmp"

  ecrire_modules "$tmp"
  rm -f "$charge" "$tmp"
  rafraichir_dus "$AUJOURDHUI"
  rm -f "$SEANCE/ouverture" "$SEANCE/module" "$SEANCE/date" \
        "$SEANCE/cloture-refusee" "$SEANCE/journal-empreinte"

  local ligne
  ligne=$(at_modules "$CHECKLIST" | awk -F'|' -v id="$id" '$1 "" == id "" { print; exit }')
  printf 'Module %s clos en %s. Prochain re-test : %s.\n' "$id" "$statut" "$(at_champ "$ligne" 8)"

  local fprev freal
  fprev=$(at_champ "$ligne" 5); freal=$(at_champ "$ligne" 6)
  if [ -n "$freal" ] && [ "$freal" != "—" ] && [ "$fprev" != "—" ] && [ "$freal" != "$fprev" ]; then
    printf 'Écart de format : prévu %s, conduit en %s. C'"'"'est une donnée — /tune la lira.\n' "$fprev" "$freal"
  fi
}

cmd_recalculer() {
  local charge tmp
  charge=$(charger_modules)
  tmp=$(mktemp "${TMPDIR:-/tmp}/at-recalc.XXXXXX")
  while IFS='|' read -r id titre statut derniere fprevu freel barreau echeance note cle; do
    case "$barreau" in ''|*[!0-9]*) barreau=0 ;; esac
    echeance=$(calculer_echeance "$statut" "$derniere" "$barreau")
    printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n' \
      "$id" "$titre" "$statut" "$derniere" "$fprevu" "$freel" "$barreau" "$echeance" "$note" "$cle"
  done < "$charge" > "$tmp"
  ecrire_modules "$tmp"
  rm -f "$charge" "$tmp"
  rafraichir_dus "$AUJOURDHUI"
  echo "Dates recalculées depuis les statuts et les barreaux."
}

cmd_seance_ouverte() {
  if [ -f "$SEANCE/ouverture" ]; then
    printf 'séance ouverte sur %s depuis le %s\n' \
      "$(cat "$SEANCE/module" 2>/dev/null)" "$(cat "$SEANCE/date" 2>/dev/null)"
    journal_ecrit && echo "journal écrit — la clôture passera." || echo "journal NON écrit — la clôture sera refusée."
    exit 0
  fi
  echo "aucune séance ouverte"
  exit 1
}

# ------------------------------------------------------------------ aiguillage

[ $# -ge 1 ] || usage 0
CMD="$1"; shift
case "$CMD" in
  dues|dus)        cmd_dues "$@" ;;
  etat|état)       cmd_etat "$@" ;;
  ajouter)         cmd_ajouter "$@" ;;
  ouvrir)          cmd_ouvrir "$@" ;;
  retest)          cmd_retest "$@" ;;
  cloturer)        cmd_cloturer "$@" ;;
  recalculer)      cmd_recalculer "$@" ;;
  seance-ouverte)  cmd_seance_ouverte ;;
  -h|--help|aide)  usage 0 ;;
  *) at_err "sous-commande inconnue : $CMD"; usage 1 ;;
esac
