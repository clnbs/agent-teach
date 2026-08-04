# agent-teach

Un dossier de cours entre. Un dispositif d'apprentissage qui **se souvient de la façon
dont tu te plantes** en sort.

```sh
git clone <ce-dépôt> ~/agent-teach && ~/agent-teach/install.sh
mkdir mon-cours && cd mon-cours && agent-teach init .
# déposer tes supports dans cours/, puis :
claude
/intake
```

Markdown et bash. Pas de serveur, pas de compte, pas de télémétrie, aucune dépendance
au-delà de ce que ta machine a déjà. Tout ce qui est écrit sur toi reste chez toi et se
lit à l'œil nu.

---

## Ce que ça fait

Un assistant qui explique bien te fait progresser pendant la séance. Il ne sait pas que
tu as confondu ces deux notions trois fois, ni que tu abandonnes systématiquement la
seconde moitié d'un critère à deux conditions. **La séance d'après, il recommence à
zéro.**

agent-teach ajoute la couche qui manque : un modèle d'apprenant persistant, en fichiers.

1. **Un intake en deux étapes.** Huit questions en langue ordinaire, puis le corpus et le
   curriculum. Tu valides les deux — un plan validé se suit, un plan subi s'abandonne en
   semaine trois. C'est le dispositif qui déduit sa méthode de tes réponses ; on ne te
   demande jamais de choisir ta pédagogie, et chaque déduction est écrite en clair
   ensuite.
2. **Des séances.** Douze minutes de re-test par des cas, puis un module, puis **tu
   produis**. Jamais l'inverse.
3. **Une écriture.** À la fin de chaque séance, ce qui a coincé **chez toi** : le cas
   posé, ta réponse, et ce qu'on en déduit — en écartant au moins une explication
   concurrente. La séance suivante commence par là.
4. **Un calendrier calculé.** Les dates de re-test sortent d'un script, jamais du modèle.
   Un modèle ne doit pas décider de son propre calendrier de révision : il oublie, il
   dérive vers ce qu'il vient de traiter, et il ne s'en aperçoit pas.

Au bout de quelques semaines : un état d'avancement, un journal de tes modes d'échec
récurrents, un glossaire, et des fiches qui contiennent **l'erreur exacte que tu as
commise, avec sa date**. C'est le seul artefact du dispositif qui soit incopiable — un
résumé de cours, n'importe quel assistant en produit un en dix secondes.

Un aperçu, plutôt qu'une description : [`exemples/journal-anonymise.md`](exemples/journal-anonymise.md).

## Ce que ce n'est pas

- ❌ Un chatbot qui résume ton cours
- ❌ Un générateur de flashcards
- ❌ Un LMS, avec serveur, comptes et tableau de bord
- ❌ Un correcteur d'examen ou un système de notation
- ❌ Un outil qui te félicite
- ❌ Un tableau de réglages pédagogiques à configurer soi-même

Cette liste est un outil de refus, et elle est publique pour ça.

## Deux choses qui ressemblent à des bugs

- **Tu n'as aucune fiche.** Une fiche vient du journal, pas du cours : un concept qui
  n'est jamais tombé n'en produit pas. Peu de fiches = peu de difficultés réelles.
- **Le tuteur ne te félicite jamais.** C'est le contrat. Si tout est félicité, une bonne
  réponse ne se distingue plus d'une réponse passable, et tu perds ta seule mesure.

## Comment c'est fait

| Zone | Contenu | Qui la possède |
|---|---|---|
| **Noyau** | `noyau/` — le skill, ses références, les hooks, les commandes | Le projet. Écrasé à chaque mise à jour, et c'est sa définition. |
| **Intermédiaire** | `curriculum.md`, `CLAUDE.md` | Généré une fois à l'intake, **puis à toi**. Jamais régénéré sans ton accord. |
| **Espace apprenant** | `progression/` | **Toi, entièrement.** Jamais écrasé, jamais transmis. |

Ce qui rend cette séparation vraie et pas seulement annoncée :
[`noyau/NOYAU.manifest`](noyau/NOYAU.manifest) liste **exhaustivement** ce qu'une mise à
jour a le droit d'écraser. `progression/` n'y figure pas. Une seule exception existe, le
bloc de préférences observées dans `SKILL.md`, qui est prélevé puis réinjecté.

Trois invariants tiennent le reste :

1. **La mémoire est un fichier, pas un contexte.**
2. **Ce qui peut être calculé ne doit pas être deviné** — les échéances sortent de
   `echeances.sh`, jamais du modèle.
3. **L'erreur est le moment d'apprentissage, pas l'exposé.** Une séance sans erreur n'a
   rien mesuré.

## Tes données

Elles ne partent nulle part. Il n'y a pas de serveur à qui les envoyer, et c'est un choix
d'architecture, pas une politique qu'on pourrait changer d'avis.

`progression/` contient des observations intimes sur ta façon d'échouer. Versionne-le si
tu veux `diff` et retour arrière — mais réfléchis avant de pousser ce dépôt où que ce
soit, et la réponse par défaut devrait être non.

**`cours/` est exclu du versionnement par défaut, et il faut l'y laisser.** Ce sont les
supports de ton professeur, sous *son* droit d'auteur. Un `git push` sur un dépôt public
te crée un problème juridique réel ; `agent-teach doctor` te le rappelle.

## Installation, contribution, licences

- [`INSTALLATION.md`](INSTALLATION.md) — prérequis, installation, mise à jour, panne
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — la barre de qualité d'un curriculum
- [`LICENSES.md`](LICENSES.md) — noyau Apache 2.0, curricula CC BY-SA 4.0, ton
  `progression/` à toi
- [`exemples/`](exemples/) — deux curricula vitrine et un journal anonymisé

## Origine, et ce qui reste à démontrer

Extraction générique d'un dispositif réel : un programme de 39 séances sur un domaine
professionnel technique, construit et éprouvé sur **un** apprenant. Les modes d'échec du
catalogue sont des observations, pas des hypothèses de design.

L'hypothèse centrale — **ces modes d'échec sont largement indépendants du domaine et de
l'apprenant** — n'est pas démontrée. Elle est en cours de réfutation, et si elle tombe,
la sortie honnête est de publier le pilote comme un exemple documenté plutôt que de
promettre une généricité qui n'existe pas.
