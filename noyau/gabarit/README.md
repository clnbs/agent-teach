# Mon cours

Dossier de cours instrumenté par [agent-teach](https://github.com/) — un dispositif qui
**se souvient de la façon dont tu te plantes**.

> ⚠️ **`cours/` est dans `.gitignore`, et il faut l'y laisser.** Il contient les supports
> de ton professeur, qui sont sous son droit d'auteur. Pousser ce dossier sur un dépôt
> public te crée un problème juridique réel.

---

## Démarrer

```sh
/intake      # une seule fois : huit questions, puis le corpus et le curriculum
/seance      # ensuite, à chaque fois
```

`/intake` s'arrête sur deux **gates** : tu valides le corpus (mode sujet libre
seulement), puis le curriculum. Un plan validé se suit ; un plan subi s'abandonne en
semaine trois. Compte quinze minutes, elles évitent vingt séances perdues.

## Le rituel

| Quand | Commande | Ce qui se passe |
|---|---|---|
| Chaque séance | `/seance` | 12 min de re-test par des cas, puis un module, puis tu produis |
| Fin de bloc | `/revision` | Restitution, relecture du journal, sondage de traçabilité |
| Après coup | `/fiche <terme>` | Une fiche depuis ton journal — pas depuis le cours |
| Quand ça sonne faux | `/tune` | Diff sur les préférences pédagogiques observées |
| Nouvelle version du moteur | `/maj` | Met à jour le noyau, ne touche jamais à `progression/` |

## Ce qui s'écrit, et où

```
progression/
├── profil.md      qui apprend — ce qui est déclaré cède devant ce qui est observé
├── checklist.md   l'état par module + les dates, calculées jamais devinées
├── journal.md     comment tu te plantes — le cœur
├── glossaire.md   les termes au fil de l'eau, avec les faux-amis
└── fiches/        une fiche par concept qui est tombé au moins une fois
```

**Tout est en markdown, lisible à l'œil nu, et t'appartient.** Rien n'est transmis nulle
part. Si le journal dit quelque chose de faux sur toi, corrige-le : c'est ton fichier.

## Deux choses qui ressemblent à des bugs et n'en sont pas

- **Tu n'as aucune fiche.** Une fiche vient du journal, pas du cours : un concept qui
  n'est jamais tombé n'en produit pas. Peu de fiches = peu de difficultés réelles.
- **Le tuteur ne te félicite jamais.** C'est le contrat. Si tout est félicité, une bonne
  réponse ne se distingue plus d'une réponse passable, et tu perds ta seule mesure.

## Versionner

`git init` puis un commit après chaque séance : `diff`, historique et retour arrière
gratuits sur ton propre modèle d'apprenant. C'est ce qui rend le rituel « l'apprenant
lit, garde ou jette » applicable sans risque.

`cours/` reste exclu. `progression/` se versionne — c'est à toi de voir si tu pousses
ce dépôt quelque part, et la réponse par défaut devrait être non.
