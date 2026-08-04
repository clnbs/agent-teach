---
description: Propose un diff sur les préférences pédagogiques observées — plafonné, jamais appliqué sans accord
---

Recalibre le bloc AUTO de `.claude/skills/teach/SKILL.md` à partir de ce qui a été
**observé**, et de rien d'autre.

## La contrainte, avant la procédure

Ce bloc est le **seul** endroit du noyau qui contienne de l'observation. Il est plafonné
à **dix lignes**, il ne se modifie que par cette commande, et **jamais sans accord
explicite**. Tu proposes un diff ; tu n'écris pas.

Une ligne du bloc AUTO qui n'a pas de contre-partie dans `progression/journal.md` est
une invention : elle se supprime. C'est la règle qui empêche ce bloc de dériver en
profil imaginaire au fil des mois.

## 1 — Lire, sans rien décider

- `progression/journal.md` — **intégralement**, pas les trois dernières entrées. Les
  patterns consolidés, les modes candidats, les entrées.
- `progression/checklist.md` — la colonne **Format prévu** contre la colonne **Format
  réel**. Trois modules prévus en exposé et conduits en cas disent que la pondération
  initiale est fausse, et c'est une donnée plus solide que n'importe quelle déclaration.
- `progression/profil.md` — les lignes `déclaré`. Ce sont des **hypothèses**.

## 2 — Ce qui a le droit de devenir une ligne

Une observation qui remplit les trois conditions :

1. **Au moins deux occurrences**, datées, retrouvables dans le journal.
2. **Formulée en langue ordinaire**, utilisable en séance. « Décroche quand la
   définition arrive avant le cas » — pas « préférence F3 > F1, pondération 0,7 ».
3. **Actionnable** : elle change quelque chose à la conduite de la prochaine séance.

Ce qui n'y entre jamais : du contenu de cours, un jugement sur l'apprenant (« manque de
rigueur »), un chiffre de maîtrise, une observation vue une seule fois.

Format exact, une ligne :

```
- AAAA-MM-JJ (n obs.) — observation, en langue ordinaire.
```

## 3 — Le plafond

Dix lignes. Au-delà, la **plus ancienne** saute — dis laquelle et pourquoi. Ce qui ne
tient pas en dix lignes appartient au journal, pas ici : ce bloc est un aide-mémoire de
conduite, pas un dossier.

## 4 — L'observation écrase la déclaration, à découvert

Si une observation contredit une ligne `déclaré` de `profil.md`, tu le dis **une fois,
en une phrase**, et tu proposes de corriger le profil dans le même diff. Pas de
correction silencieuse : l'apprenant doit pouvoir voir que son modèle a changé, et
pourquoi.

## 5 — Proposer

Affiche le diff : lignes ajoutées, lignes supprimées, avec pour chacune **les
occurrences du journal qui la fondent** (dates et modules). Puis demande.

Sur refus, tu n'écris rien et tu n'insistes pas. Sur accord, réécris le contenu entre
`<!-- at:auto:debut -->` et `<!-- at:auto:fin -->`, et **rien d'autre dans le fichier**.
