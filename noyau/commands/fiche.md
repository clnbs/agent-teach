---
description: Produit ou met à jour une fiche de révision depuis le journal
argument-hint: "<terme> — ou rien pour lister ce qui mérite une fiche"
---

Terme demandé : $ARGUMENTS

Lis `.claude/skills/teach/references/fiches.md` avant d'écrire quoi que ce soit.

## Sans argument — l'inventaire

Croise `progression/journal.md` et `progression/fiches/`. Liste les concepts tombés
**au moins deux fois** qui n'ont pas encore de fiche, et les fiches dont le concept est
retombé depuis leur dernière mise à jour. Rien d'autre. Puis attends.

## Avec un terme — la règle qui décide de tout

> **Une fiche n'est pas dérivée du cours. Elle est dérivée du journal.**

Concrètement : ouvre `progression/journal.md` et cherche les occurrences du terme.

- **Aucune occurrence** → tu ne produis pas de fiche. Dis-le franchement : une fiche
  sans erreur réelle est un résumé, et un résumé ne se relit pas. Propose plutôt une
  entrée de glossaire, ou de poser un cas maintenant pour voir si le concept tient.
- **Une seule occurrence** → règle des deux occurrences : pas encore. Le journal suffit.
  Sur-réagir au bruit remplit `progression/fiches/` de bruit, et un paquet de 400 fiches
  ne se relit pas plus qu'un polycopié.
- **Deux occurrences ou plus** → tu produis la fiche.

## Écrire la fiche

`progression/fiches/<terme>.md`, six blocs dans l'ordre de la référence : Définition,
Mécanisme, **Où je suis tombé**, Faux-ami, Le cas qui discrimine, Rattachement.

Le bloc **« Où je suis tombé » est la fiche** ; les cinq autres existent pour le rendre
exploitable. Il porte les cas **réels**, **datés**, avec la réponse effectivement donnée
et pourquoi elle était fausse. Reprends-les du journal tels quels — ne les lisse pas,
ne les généralise pas, ne les reformule pas en énoncé de cours. Ce qui rend cette fiche
incopiable, c'est précisément qu'elle contient l'erreur de cet apprenant-là, à cette
date-là.

« Le cas qui discrimine » est **un cas**, pas une définition : re-tester par la
définition ne révèle rien. Si la fiche existe déjà et que le concept vient d'être raté
sur ce cas, **remplace-le** — un cas qui n'a pas discriminé ne sert à rien.

Jamais dans une fiche : un résumé du chapitre, tout le vocabulaire du module (c'est le
glossaire), un pourcentage de maîtrise, ni une bonne réponse mise en avant. Si l'œil
tombe d'abord sur la solution, la fiche ne teste plus rien.

## Mise à jour d'une fiche existante

N'écrase pas. Ajoute une ligne datée dans « Où je suis tombé », et remplace le cas
discriminant s'il a échoué à discriminer. Le reste ne bouge que si le journal montre que
le mécanisme avait été mal compris.

## Suppression

Une fiche dont le concept est `consolide` et qui n'a rien reçu depuis trois échéances a
servi : propose de la supprimer. La garder dilue le paquet. La décision appartient à
l'apprenant.
