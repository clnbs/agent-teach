# agent-teach

Tu déposes tes supports de cours dans un dossier. agent-teach en tire un dispositif de
révision qui retient **la façon dont tu te plantes** : tes erreurs à toi, datées, plutôt
qu'un résumé du cours.

```sh
git clone <ce-dépôt> ~/agent-teach && ~/agent-teach/install.sh
mkdir mon-cours && cd mon-cours && agent-teach init .
# déposer tes supports dans cours/, puis :
claude
/intake
```

Markdown et bash, rien d'autre à installer. Pas de serveur, pas de compte, pas de
télémétrie. Ce qui est écrit sur toi reste chez toi, et se lit en clair.

---

## Ce que ça fait

Un assistant qui explique bien te fait progresser pendant la séance. Mais il ne sait pas
que tu as confondu ces deux notions trois fois. La séance suivante, il repart de zéro.

agent-teach ajoute la couche qui manque : un modèle d'apprenant gardé en fichiers.

1. **Un intake en deux étapes.** Huit questions simples, puis un curriculum que tu
   valides. La méthode se déduit de tes réponses ; tu n'as jamais à choisir ta pédagogie.
2. **Des séances.** Douze minutes de re-test sur des cas, puis un module, puis tu
   produis. Jamais l'inverse.
3. **Une écriture.** À la fin de chaque séance : le cas posé, ta réponse, ce qu'on en
   déduit. La séance suivante démarre là-dessus.
4. **Un calendrier calculé.** Les dates de re-test sortent d'un script, jamais du modèle.
   Un modèle oublie, dérive vers ce qu'il vient de traiter, et ne s'en aperçoit pas.

Au bout de quelques semaines : un état d'avancement, un journal de tes modes d'échec, un
glossaire, et des fiches bâties sur **l'erreur exacte que tu as commise, avec sa date**.
Un résumé de cours, n'importe quel assistant en produit un ; ça, non.

Un aperçu vaut mieux qu'une description :
[`exemples/journal-anonymise.md`](exemples/journal-anonymise.md).

## Ce que ce n'est pas

- ❌ Un chatbot qui résume ton cours
- ❌ Un générateur de flashcards
- ❌ Un LMS, avec serveur et tableau de bord
- ❌ Un correcteur d'examen
- ❌ Un outil qui te félicite
- ❌ Un tableau de réglages pédagogiques

## Deux choses qui ressemblent à des bugs

- **Tu n'as aucune fiche.** Une fiche vient du journal, pas du cours : un concept qui n'a
  jamais posé problème n'en produit pas.
- **Le tuteur ne te félicite jamais.** C'est voulu. Si tout est félicité, une bonne
  réponse ne se distingue plus d'une réponse passable.

## Comment c'est fait

| Zone | Contenu | Qui la possède |
|---|---|---|
| **Noyau** | `noyau/` — skill, références, hooks, commandes | Le projet. Écrasé à chaque mise à jour. |
| **Intermédiaire** | `curriculum.md`, `CLAUDE.md` | Généré à l'intake, **puis à toi**. |
| **Espace apprenant** | `progression/` | **Toi.** Jamais écrasé, jamais transmis. |

[`noyau/NOYAU.manifest`](noyau/NOYAU.manifest) liste tout ce qu'une mise à jour a le
droit d'écraser. `progression/` n'y figure pas : c'est ce qui rend la séparation réelle,
et pas seulement annoncée. Une exception, le bloc de préférences observées de
`SKILL.md`, prélevé avant la mise à jour et réinjecté après.

Trois invariants :

1. La mémoire est un fichier, pas un contexte.
2. Ce qui se calcule ne se devine pas — les échéances sortent de `echeances.sh`.
3. L'erreur est le moment d'apprentissage. Une séance sans erreur n'a rien mesuré.

## Tes données

Elles ne partent nulle part : il n'y a pas de serveur à qui les envoyer.

`progression/` contient des observations intimes sur ta façon d'échouer. Versionne-le
pour avoir `diff` et retour arrière, mais réfléchis à deux fois avant de pousser ce dépôt
où que ce soit.

**`cours/` est exclu du versionnement, et il faut l'y laisser.** Ce sont les supports de
ton professeur, sous *son* droit d'auteur. `agent-teach doctor` te le rappelle.

## Installation, contribution, licences

- [`INSTALLATION.md`](INSTALLATION.md) — prérequis, installation, mise à jour, panne
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — la barre de qualité d'un curriculum
- [`LICENSES.md`](LICENSES.md) — noyau Apache 2.0, curricula CC BY-SA 4.0
- [`exemples/`](exemples/) — deux curricula et un journal anonymisé
