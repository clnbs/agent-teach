# Checklist — l'état du parcours

**Zone : ESPACE APPRENANT.** Jamais écrasée par une mise à jour du moteur.

Ce fichier est ton état d'avancement. Tu peux le lire, le corriger et le versionner.
**Les deux tableaux ci-dessous sont réécrits par `.claude/hooks/echeances.sh`** :
garde les balises `<!-- at:… -->`, sinon le script ne sait plus où écrire.

**Aucune date n'est saisie à la main, ici ou ailleurs.** Le tuteur émet un statut, le
script calcule la date. C'est l'invariant : ce qui peut être calculé ne se devine pas.

---

## À re-tester au prochain démarrage

<!-- at:dus:debut -->
_Rien de dû. Le module suivant du curriculum peut être pris._
<!-- at:dus:fin -->

---

## Modules

<!-- at:modules:debut -->
| Module | Titre | Statut | Dernière séance | Format prévu | Format réel | Barreau | Prochain re-test | Ce qui reste bancal |
|---|---|---|---|---|---|---|---|---|
<!-- at:modules:fin -->

---

## Comment lire ce tableau

| Statut | Ce que ça veut dire | Prochaine échéance |
|---|---|---|
| `a-faire` | Pas encore travaillé | — |
| `acquis` | Tranche juste **et** justifie juste | J+3, puis J+10, J+30, J+90 |
| `fragile` | Le fond est là, un membre manque | **prochaine séance**, systématiquement |
| `a-revoir` | Ne tient pas | prochaine séance, module rejoué **entier** en Restitution |
| `consolide` | A tenu les quatre barreaux | plus jamais — sorti de la boucle |
| `abandonne` | Écarté du parcours au triage (★) | — |

**Barreau** : position dans l'échelle d'espacement (0 → J+3, 1 → J+10, 2 → J+30,
3 → J+90). Un re-test raté remet le barreau à zéro : toute l'échelle est à refaire.

**Format prévu / format réel** : le format annoncé par le curriculum et celui
réellement employé. L'écart n'est pas un défaut, c'est une donnée — trois modules
prévus en exposé et conduits en cas disent que la pondération est fausse, et c'est ce
que `/tune` lit.

**Ce qui reste bancal** : une ligne, pas un paragraphe. Ce qui mérite plus d'une ligne
appartient au journal.
