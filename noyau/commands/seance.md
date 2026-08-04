---
description: Conduit une séance de travail sur un module — re-test, module, production, journal
argument-hint: "[module] (facultatif — sinon le script décide)"
---

Conduis une séance. Suis la compétence `teach` : lis **maintenant**
`.claude/skills/teach/references/boucle-seance.md` et
`.claude/skills/teach/references/conduite.md` avant de dire un mot à l'apprenant.

Module demandé : $ARGUMENTS *(vide = tu choisis, voir temps 1)*

## Temps 1 — lire l'état (avant de parler)

```sh
.claude/hooks/echeances.sh dues
```

Puis lis, dans cet ordre : `progression/journal.md` (les **trois dernières entrées**
et les patterns consolidés), `progression/checklist.md`, `curriculum.md` pour le
module retenu.

**Une séance s'ouvre en lisant le journal, pas le curriculum.** Le curriculum dit ce
qu'il reste à voir ; le journal dit ce qui ne tient pas. Le second gagne.

Choix du module — table de décision complète dans `boucle-seance.md` :

| S'il y a | Alors |
|---|---|
| un `a-revoir` | c'est lui, rejoué **entier**, en Restitution |
| des `fragile` | 12 min de re-test dessus, puis le module suivant du curriculum |
| rien de dû | module suivant du curriculum, ★ d'abord si le parcours est minimal |

Ouvre la séance dès le module arrêté :

```sh
.claude/hooks/echeances.sh ouvrir <module>
```

## Temps 2 — annoncer

Deux phrases, pas plus : ce qu'on va faire, et **ce que l'apprenant saura faire à la
fin**. Une capacité observable, jamais « on va voir le chapitre 3 ». Si un faux-ami du
module figure au curriculum ou au profil, annonce-le **ici**, avant qu'il ne serve.

## Temps 3 — le re-test, puis le module

**12 minutes de re-test, par des cas, jamais par la définition.** Du module le plus
ancien vers le plus récent — l'ordre est déjà celui de la sortie de `dues`, ne le
réordonne pas. Commence par le cas difficile.

Un verdict par module re-testé, et un seul :

```sh
.claude/hooks/echeances.sh retest <module> <ok|rate|partiel> [--note "…"]
```

`ok` = tranche juste **et** justifie juste. `partiel` = le fond est là, un membre
manque. `rate` = ne tient pas. En cas de doute, ce n'est pas `ok`.

Puis le module du jour, dans le format prévu au curriculum — bascule si un signal de
bascule apparaît (`formats.md`), et note le format réellement conduit. L'écart entre
prévu et réel n'est pas un défaut : c'est la donnée que `/tune` lira.

Tranches de 5 à 8 lignes, une question après chaque tranche, **une seule à la fois**.
Le cas piège du module se pose immédiatement après la tranche qui l'arme, pas à la fin.
`Pourquoi ?` après chaque conclusion, **surtout quand elle est juste** : c'est la seule
façon de distinguer un raisonnement d'une réponse retenue.

## Temps 4 — faire produire

La séance se termine par une production de l'apprenant, **jamais** par ton explication.
S'il ne reste pas le temps, coupe dans l'exposé, pas dans la production.

## Temps 5 — écrire

Dans cet ordre, et l'ordre compte :

1. **`progression/journal.md`** — l'entrée du jour, six à dix lignes factuelles. Lis
   `references/taxonomie.md` avant. L'inférence doit **écarter au moins une explication
   concurrente**, sinon ce n'est pas une inférence. Une étiquette improvisée en langue
   ordinaire vaut mieux qu'un mode forcé.
2. **`progression/glossaire.md`** — les termes apparus, avec la colonne faux-ami.
3. **Une fiche** si un concept vient de tomber pour la **deuxième** fois (`fiches.md`).
4. **La clôture** — et seulement à la fin :

```sh
.claude/hooks/echeances.sh cloturer <module> <acquis|fragile|a-revoir> \
  [--format-reel F3] [--note "ce qui reste bancal, une ligne"]
```

Le script refusera tant que le journal n'aura pas été écrit. C'est voulu : n'essaie pas
de contourner, écris l'entrée.

**Tu n'écris jamais une date toi-même.** Ni ici, ni dans la checklist, ni dans une
phrase adressée à l'apprenant. Toute date sort du script.

## Rappels qui coûtent cher quand on les oublie

- Pas de félicitations. `Correct.` suffit. Une réponse fausse est nommée fausse, avec
  l'endroit exact où ça coince.
- Jamais « c'est clair ? ». On vérifie en faisant produire.
- Aucun vocabulaire du dispositif en séance : ni « F3 », ni « M2 », ni « J+10 ».
