# Contribuer

Deux zones, deux régimes, et l'asymétrie est voulue : **le noyau se protège, les
curricula s'accueillent.**

| | |
|---|---|
| **Un curriculum** | Ouvert largement. Un domaine, un fichier, un responsable. C'est du markdown — la barrière d'entrée la plus basse qui existe, et elle vise exactement les gens qui connaissent leur discipline sans savoir programmer. |
| **Le noyau** | Cap étroit, mainteneur unique. L'échec typique de ce genre de projet est l'accrétion de fonctionnalités demandées par des gens qui veulent un LMS. La liste des non-objectifs du [`README`](README.md#ce-que-ce-nest-pas) est l'outil de refus, et elle est publique pour ça. |

---

## Contribuer un curriculum

### La barre de qualité

Elle est explicite et elle est tenue, sinon le dépôt se remplit de sommaires déguisés.

**Un module est refusé s'il n'a pas :**

- un **objectif** formulé en capacité observable — pas « voir le chapitre 3 »
- ses **prérequis** explicites
- **8 à 12 termes**, pas 40 — au-delà, le module est trop gros et se découpe
- un **format** choisi parmi les quatre ([`formats.md`](noyau/skills/teach/references/formats.md)),
  et justifié s'il s'écarte du défaut
- **un critère de validation et au moins un cas piège**

**Le dernier point est celui qui sera systématiquement bâclé, et c'est le seul qui
distingue un curriculum d'une table des matières.**

Un cas piège n'est pas un exercice difficile. C'est le cas où la compréhension
approximative donne une réponse *cohérente et fausse* — celui qui sépare la règle sue
de la règle comprise. Il se décrit dans le module, pas s'improvise en séance : improvisé,
il devient une devinette, et une devinette ne mesure rien.

> Le [`6/4 de passage`](exemples/curriculum-harmonie-tonale.md), en harmonie :
> l'apprenant qui a compris le renversement comme une permutation le chiffre
> correctement et se trompe entièrement sur son emploi. Voilà la forme.

Le [gabarit](noyau/gabarit/curriculum.md) porte un modèle de module à domaine
neutralisé, et [`exemples/`](exemples/) en montre deux complets — un en mode A (cours
fourni, date cible, parcours minimal), un en mode B (sujet libre).

### Ce qui n'est pas accepté

- **Des curricula générés en masse sans relecture d'un connaisseur du domaine.** Le
  volume n'est pas la contribution ; le jugement l'est. Un module dont personne ne peut
  dire s'il est juste est un module qu'on ne peut pas maintenir.
- **Des traductions automatiques de curricula existants.** Le jargon dans la mauvaise
  langue est pire que pas de curriculum : il apprend des faux-amis à la place des
  bons termes.
- **Des curricula de domaines régulés** — formation obligatoire, conformité,
  certification professionnelle. Ouvert une fois, c'est ouvert pour toujours, et un
  contenu régulé faux engage autre chose que la note de quelqu'un.

### Ce qui ne doit jamais arriver dans une PR

- **Aucun extrait de `cours/`.** Ce sont les supports d'un professeur, sous *son* droit
  d'auteur. Un curriculum cite ses sources (`poly-ch1.pdf:12-18`, ou une référence en
  ligne datée) — il ne les recopie pas.
- **Aucun `progression/` réel, même anonymisé de bonne foi.** Un journal d'apprentissage
  décrit la façon dont une personne précise échoue ; c'est intime, et le dispositif n'a
  volontairement aucun moyen technique d'en collecter. Si un exemple de journal est
  utile, il se **fabrique** : [`exemples/journal-anonymise.md`](exemples/journal-anonymise.md)
  est un composite, et le dit en tête.

### Le mode B demande une chose de plus

En sujet libre, chaque module porte sa **source réelle et sa date de consultation**. Un
curriculum de mode B sans sources vérifiables n'est pas relisible : personne ne peut
distinguer ce qui vient d'un traité de ce que le modèle a inventé.

---

## Contribuer au noyau

### Les contraintes, et pourquoi elles ne se négocient pas

| Contrainte | Raison |
|---|---|
| **bash 3.2** | C'est ce que macOS livre. Pas d'`declare -A`, pas de `${var,,}`, pas de `mapfile`. |
| **Aucune dépendance** | Pas de `jq`, pas de Python, pas de Node. « Ça tourne partout, tout de suite » est un avantage réel, pas de la frugalité — et chaque dépendance ajoutée le dépense. |
| **Dates portables** | GNU et BSD `date` ont des interfaces incompatibles. L'arithmétique passe par `at_date_plus` / `at_epoch` de [`lib.sh`](noyau/hooks/lib.sh), en UTC, pour qu'un changement d'heure ne décale jamais une échéance. |
| **Le modèle ne calcule pas de dates** | Il émet un verdict pédagogique ; `echeances.sh` possède le calendrier. Une PR qui fait choisir une échéance au modèle sera refusée sur ce seul motif. |

### Avant d'ouvrir une PR

```sh
tests/run.sh
agent-teach doctor /un/dossier/de/cours
```

Une correction de bug arrive avec le test qui échouait avant elle. La suite n'a pas plus
de dépendances que le reste : un test qui aurait besoin d'autre chose testerait autre
chose que ce qu'on livre.

Si le changement touche un fichier du noyau, vérifie qu'il est bien listé dans
[`NOYAU.manifest`](noyau/NOYAU.manifest) — un fichier absent de cette liste n'est jamais
posé chez l'apprenant, et un fichier ajouté à tort y écrase son travail.

### Commits

[Conventional Commits](https://www.conventionalcommits.org/), **en anglais**, portée
courte : `feat(hooks):`, `fix(cli):`, `docs(exemples):`, `test:`. Le contenu du projet
est en français, l'historique git est en anglais — c'est délibéré, l'un s'adresse à un
apprenant francophone, l'autre à quiconque lit du code.

Petits commits. Un commit qui touche le moteur d'échéances et la documentation en même
temps se relit deux fois moins bien.

### Ajouter un mode d'échec

La taxonomie ([`taxonomie.md`](noyau/skills/teach/references/taxonomie.md)) décrit dix
modes observés, pas dix modes imaginés. Un onzième s'ajoute selon les quatre conditions
de sa section 4 : trois occurrences datées au journal, irréductibilité à tout mode
existant, signature formulable sans nommer le domaine, et une contre-mesure différente
de celles déjà au catalogue. La deuxième et la quatrième sont les vraies : un mode qui
se soigne comme M2 *est* M2, et un catalogue qui se recoupe est inutilisable en séance,
où il faut trancher en trois secondes.

---

## Licences

En contribuant, tu acceptes que ta contribution soit publiée sous la licence de sa
zone : **Apache 2.0** pour le noyau, **CC BY-SA 4.0** pour les curricula, **CC BY 4.0**
pour la documentation. Le détail est dans [`LICENSES.md`](LICENSES.md).

Le *share-alike* sur les curricula est le point important : c'est là qu'est le travail
coûteux, et un curriculum amélioré doit revenir à la communauté.

---

## Signaler un problème

Ce qui aide, dans l'ordre :

1. La sortie de `agent-teach doctor` sur le dossier concerné.
2. `bash --version` et `date --version` (ou l'erreur qu'il renvoie, sur BSD).
3. Ce qui était attendu, et ce qui s'est produit.

**Pas de capture de `progression/`.** Si le problème est dans le contenu d'un fichier,
remplace le domaine — la structure suffit à diagnostiquer, et c'est ton dossier.

Pour une demande de fonctionnalité, la première question posée sera : *est-ce que ça
figure dans la liste des non-objectifs ?* Si oui, la réponse est non, et elle est non
depuis avant que la demande existe.
