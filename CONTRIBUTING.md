# Contribuer

Deux zones, deux régimes : **le noyau se protège, les curricula s'accueillent.**

| | |
|---|---|
| **Un curriculum** | Ouvert largement. Un domaine, un fichier, un responsable. C'est du markdown, pas du code : ça vise les gens qui connaissent leur discipline sans savoir programmer. |
| **Le noyau** | Cap étroit, mainteneur unique. Le risque, ici, est l'accumulation de fonctionnalités demandées par des gens qui veulent un LMS. La liste des non-objectifs du [`README`](README.md#ce-que-ce-nest-pas) sert à dire non. |

---

## Contribuer un curriculum

### La barre de qualité

Sans elle, le dépôt se remplit de sommaires déguisés.

**Un module est refusé s'il n'a pas :**

- un **objectif** formulé en capacité observable — pas « voir le chapitre 3 »
- ses **prérequis** explicites
- **8 à 12 termes**, pas 40 ; au-delà, le module se découpe
- un **format** choisi parmi les quatre ([`formats.md`](noyau/skills/teach/references/formats.md)),
  justifié s'il s'écarte du défaut
- **un critère de validation et au moins un cas piège**

**Le dernier point est celui qui sera systématiquement bâclé, et c'est le seul qui
distingue un curriculum d'une table des matières.**

Un cas piège n'est pas un exercice difficile. C'est le cas où la compréhension
approximative donne une réponse *cohérente et fausse*. Il se décrit dans le module ; il
ne s'improvise pas en séance, sinon il devient une devinette.

> Exemple, en harmonie : le **6/4 de passage**. L'apprenant qui a compris le
> renversement comme une permutation le chiffre correctement et se trompe entièrement
> sur son emploi ([curriculum complet](exemples/curriculum-harmonie-tonale.md)).

Le [gabarit](noyau/gabarit/curriculum.md) contient un modèle de module à domaine
neutralisé. [`exemples/`](exemples/) en montre deux complets, un par mode d'entrée.

### Ce qui n'est pas accepté

- **Des curricula générés en masse sans relecture d'un connaisseur du domaine.** Un
  module dont personne ne peut dire s'il est juste ne peut pas être maintenu.
- **Des traductions automatiques de curricula existants.** Le jargon dans la mauvaise
  langue est pire que pas de curriculum : il enseigne des faux-amis.
- **Des curricula de domaines régulés** — formation obligatoire, conformité,
  certification. Ouvert une fois, c'est ouvert pour toujours.

### Ce qui ne doit jamais arriver dans une PR

- **Aucun extrait de `cours/`.** Ce sont les supports d'un professeur, sous *son* droit
  d'auteur. Un curriculum cite ses sources (`poly-ch1.pdf:12-18`, ou une référence en
  ligne datée), il ne les recopie pas.
- **Aucun `progression/` réel, même anonymisé de bonne foi.** Un journal décrit la façon
  dont une personne précise échoue. Si un exemple est utile, il se fabrique :
  [`exemples/journal-anonymise.md`](exemples/journal-anonymise.md) est un composite, et
  le dit en tête.

### Le mode B demande une chose de plus

En sujet libre, chaque module porte sa **source et sa date de consultation**. Sans elles,
personne ne peut distinguer ce qui vient d'un traité de ce que le modèle a inventé.

---

## Contribuer au noyau

### Les contraintes

| Contrainte | Raison |
|---|---|
| **bash 3.2** | C'est ce que macOS livre. Pas de `declare -A`, pas de `${var,,}`, pas de `mapfile`. |
| **Aucune dépendance** | Pas de `jq`, pas de Python, pas de Node. Chaque dépendance ajoutée coûte le « ça tourne partout, tout de suite ». |
| **Dates portables** | GNU et BSD `date` ont des interfaces incompatibles. L'arithmétique passe par `at_date_plus` / `at_epoch` de [`lib.sh`](noyau/hooks/lib.sh), en UTC : un changement d'heure ne doit pas décaler une échéance. |
| **Le modèle ne calcule pas de dates** | Il émet un verdict pédagogique, `echeances.sh` tient le calendrier. Une PR qui fait choisir une échéance au modèle est refusée sur ce seul motif. |

### Avant d'ouvrir une PR

```sh
tests/run.sh
agent-teach doctor /un/dossier/de/cours
```

Une correction de bug arrive avec le test qui échouait avant elle. La suite n'a pas plus
de dépendances que le reste.

Si le changement touche un fichier du noyau, vérifie qu'il est listé dans
[`NOYAU.manifest`](noyau/NOYAU.manifest) : un fichier absent n'est jamais posé chez
l'apprenant, un fichier ajouté à tort y écrase son travail.

### Commits

[Conventional Commits](https://www.conventionalcommits.org/), **en anglais**, portée
courte : `feat(hooks):`, `fix(cli):`, `docs(exemples):`, `test:`. Le contenu du projet
est en français, l'historique git en anglais.

Petits commits. Un commit qui touche le moteur d'échéances et la documentation en même
temps se relit deux fois moins bien.

### Ajouter un mode d'échec

La taxonomie ([`taxonomie.md`](noyau/skills/teach/references/taxonomie.md)) décrit dix
modes observés, pas dix modes imaginés. Sa section 4 pose quatre conditions pour en
ajouter un : trois occurrences datées au journal, irréductibilité à tout mode existant,
signature formulable sans nommer le domaine, contre-mesure différente de celles au
catalogue.

Les deux dernières sont les plus filtrantes. Un mode qui se soigne comme M2 *est* M2, et
un catalogue qui se recoupe devient inutilisable en séance, où il faut trancher vite.

---

## Licences

En contribuant, tu acceptes que ta contribution soit publiée sous la licence de sa
zone : **Apache 2.0** pour le noyau, **CC BY-SA 4.0** pour les curricula, **CC BY 4.0**
pour la documentation. Détail dans [`LICENSES.md`](LICENSES.md).

Le *share-alike* sur les curricula est le point important : c'est là qu'est le travail
coûteux, et un curriculum amélioré doit revenir à la communauté.

---

## Signaler un problème

Ce qui aide, dans l'ordre :

1. La sortie de `agent-teach doctor` sur le dossier concerné.
2. `bash --version` et `date --version` (ou l'erreur renvoyée, sur BSD).
3. Ce qui était attendu, et ce qui s'est produit.

**Pas de capture de `progression/`.** Si le problème est dans le contenu d'un fichier,
remplace le domaine : la structure suffit à diagnostiquer.

Pour une demande de fonctionnalité, la première question sera : *est-ce que ça figure
dans la liste des non-objectifs ?*
