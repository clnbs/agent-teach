---
description: Met à jour le noyau depuis une copie d'agent-teach et montre le diff
argument-hint: "[chemin vers le dépôt agent-teach] (défaut : ~/agent-teach)"
---

Mets à jour le noyau de ce dossier de cours. Source : $ARGUMENTS *(vide = `~/agent-teach`)*

## Ce que cette commande garantit

`.claude/NOYAU.manifest` liste **exhaustivement** ce qu'une mise à jour a le droit
d'écraser. Ce qui n'y figure pas ne sera pas touché — c'est structurel, pas une
politesse. Par construction, sont donc hors d'atteinte :

- tout `progression/` — profil, checklist, journal, glossaire, fiches, sources ;
- `curriculum.md` et `CLAUDE.md`, qui sont générés une fois puis **appartiennent à
  l'apprenant** ;
- `.claude/settings.json`, où l'apprenant a pu ajouter ses propres permissions.

Une seule fusion existe dans tout le dispositif, et elle est mécanique : le bloc
`<!-- at:auto:… -->` de `SKILL.md`.

## Procédure

1. **Vérifier la source.** Si le chemin n'existe pas ou ne contient pas
   `noyau/NOYAU.manifest`, arrête-toi et dis-le. Ne devine pas un autre chemin.

2. **Comparer les versions.** `.claude/VERSION` contre `noyau/VERSION`. Si elles sont
   identiques, dis-le et propose de continuer quand même (une copie de travail peut
   avoir changé sans changer de version) — mais ne force rien.

3. **Prélever le bloc AUTO** de `.claude/skills/teach/SKILL.md`, s'il existe, et le
   garder de côté. C'est de l'observation : la perdre coûterait des semaines.

4. **Montrer le diff, avant d'écrire.** Pour chaque ligne du manifeste, `diff` entre le
   fichier installé et le fichier source. Présente le résultat en trois listes : ce qui
   change, ce qui est nouveau, ce qui disparaît du manifeste. Signale à part tout
   fichier installé **modifié à la main** par rapport à la version précédente : il sera
   écrasé, et l'apprenant doit le savoir avant, pas après.

5. **Demander.** Pas d'écriture sans accord explicite.

6. **Copier**, ligne à ligne du manifeste, puis **réinjecter le bloc AUTO** entre ses
   balises dans le nouveau `SKILL.md`. Remets `.claude/VERSION` à jour.

7. **Le reste, en diff seulement.** Pour `settings.json`, et pour tout écart de
   structure dans `curriculum.md` ou `CLAUDE.md`, montre ce que la nouvelle version
   ferait et laisse l'apprenant décider ligne à ligne. Tu ne les écris pas.

8. **Vérifier.** `.claude/hooks/echeances.sh etat` doit répondre. S'il échoue, dis
   exactement quelle commande a échoué et avec quel message — ne rafistole pas.

## Si l'apprenant a versionné son dossier

Dis-le-lui : `git diff` après la mise à jour montre exactement ce qui a bougé, et
`git checkout` annule tout. C'est le filet de sécurité prévu, et il coûte une commande.
