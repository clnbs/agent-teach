---
description: Initialise le cours — huit questions, puis corpus et curriculum, avec deux validations humaines
---

Initialise ce dossier de cours. Deux étapes séparées par des **gates** : tu t'arrêtes,
l'apprenant valide, et tant qu'il n'a pas validé tu n'avances pas.

Lis **maintenant** `.claude/skills/teach/references/intake.md`, puis
`.claude/skills/teach/references/ingestion.md`. Ne commence pas l'entretien avant.

## Avant tout — vérifier que ce n'est pas déjà fait

Si `progression/profil.md` porte déjà un `mode_entree` renseigné, l'intake a eu lieu.
Ne le rejoue pas : dis ce qui existe, et propose soit `/seance`, soit une reprise
ciblée d'une seule étape.

## Étape 1 — l'entretien

Huit questions, **une à la fois**, en langue ordinaire, dans l'ordre de la référence.
Tu attends la réponse avant de poser la suivante. Ce n'est pas un formulaire : rebondis
quand une réponse est floue, mais ne t'installe pas — un quart d'heure au total.

Chaque question porte une **inférence cachée**, listée dans la référence. Tu ne la
discutes jamais pendant l'entretien : on ne demande à personne de choisir sa méthode
pédagogique. La contre-partie est obligatoire — tu écris ensuite chaque déduction **en
clair**, avec la réponse dont elle vient, dans la section « Ce qui a été déduit, et de
quoi » de `progression/profil.md`.

Ce qui ne se demande jamais : son niveau, son style d'apprentissage, s'il est motivé.

Écris `progression/profil.md` : le tableau balisé `<!-- at:profil:… -->` pour les
champs, la prose pour les inférences et les interdits. Chaque ligne est marquée
`déclaré` (une hypothèse) ou `inféré` (avec sa source). Reporte la question 8 dans les
« interdits propres à ce cours » de `CLAUDE.md`.

À la question 7, branche :

- **Mode A — cours fourni** : les supports sont dans `cours/`. Vérifie qu'ils y sont.
- **Mode B — sujet libre** : il n'y a pas de support. Tu vas devoir en constituer un,
  et c'est là que le dispositif peut fabriquer une matière qui n'existe pas.

## Gate 1 — le corpus *(mode B uniquement)*

Constitue le corpus (passe 0 de `ingestion.md`), puis **arrête-toi**. Présente
`progression/sources.md` : ce qui est retenu, ce qui est écarté et pourquoi, les trous
assumés, et un niveau de confiance par source. Demande explicitement : « est-ce que ce
corpus te va ? »

Tu n'entames pas le découpage avant un accord. Un corpus non validé produit un
curriculum plausible et faux, et l'apprenant travaillera des semaines sur une matière
qui ne tombera pas.

## Étape 2 — l'ingestion

Passes 1 à 4 de `ingestion.md`. Ce qui décide de la qualité du résultat :

- **Cinq champs par module**, et un module qui n'en a que quatre est refusé. Celui qui
  manque est toujours le même : le **cas piège**. Il se décrit ici, il ne s'improvise
  pas en séance.
- **Objectif = capacité observable.** « Classer un objet donné et situer la frontière »,
  pas « voir le chapitre 3 ».
- **Traçabilité** : chaque module porte sa source (`fichier:page` en mode A,
  `source:section` + date de consultation en mode B). Un concept sans source ne devient
  **jamais** un module : il va dans « Concepts hors-support », en clair. C'est le
  garde-fou anti-hallucination et il n'est pas négociable.
- **Faux-amis** : croise le vocabulaire du cours avec `domaine_origine`. Sur ces termes
  l'intuition de l'apprenant est confiante et fausse, ce qui est le pire cas.
- **Calendrier inversé** : si `date_cible` est renseignée, appelle
  `.claude/hooks/echeances.sh etat` — il dit si ça rentre. Si ça ne rentre pas, marque
  un parcours minimal (★) et **annonce franchement ce qui saute**. Triage, pas
  réordonnancement : on garde l'ordre pédagogique et on saute, sinon les dépendances
  cassent.

Écris `curriculum.md`. Puis inscris chaque module dans la checklist — **par le script,
pas à la main** :

```sh
.claude/hooks/echeances.sh ajouter <module> "<titre>" --format <F1|F2|F3|F4>
```

## Gate 2 — le curriculum

Arrête-toi. Présente le plan : périmètre, **hors périmètre** (aussi important), nombre
de séances, ce qui saute le cas échéant. Demande la validation.

Un plan validé se suit ; un plan subi s'abandonne en semaine trois. Ces quinze minutes
évitent vingt séances perdues — dis-le si l'apprenant s'impatiente.

## Cas dégradés

`ingestion.md` porte la table complète. Retiens qu'il existe un cas où le dispositif
doit **refuser** plutôt que produire : quand le support est trop mince pour qu'un
curriculum en sorte honnêtement, tu le dis, tu expliques ce qui manque, et tu ne
fabriques pas les modules manquants.
