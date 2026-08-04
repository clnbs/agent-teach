# L'initialisation, en deux étapes

**Zone : NOYAU.** Procédure exécutable de `/intake`. Aucune donnée d'apprenant ici.

Deux étapes, dans cet ordre, et **l'ordre n'est pas négociable** : on établit qui
apprend avant de décider quoi. Un même chapitre ne se découpe pas de la même façon
pour quelqu'un qui a un partiel dans trois semaines et pour quelqu'un qui apprend par
curiosité. Décider du curriculum avant de connaître l'apprenant produit un sommaire
générique — exactement ce qu'on cherche à ne pas faire.

```
ÉTAPE 1 — QUI APPREND               8 questions → progression/profil.md
                │
ÉTAPE 2 — QUOI, ET À PARTIR DE QUOI
      A « j'ai un cours »   │   B « j'ai un sujet » → passe 0 → GATE CORPUS
                └───────────┴───────────┘
                      passes 1 à 4 (ingestion.md)
                            ▼
                      GATE CURRICULUM
```

---

## Étape 1 — Qui apprend

### La règle qui gouverne toute l'étape

> **L'apprenant décrit sa situation. Il ne choisit jamais sa méthode.**

Deux raisons, la seconde est la vraie :

1. Il ne connaît pas les réglages. Personne n'a d'avis éclairé sur « quelle pondération
   entre exposé et restitution » avant d'avoir vécu six séances.
2. **Il choisirait mal, et toujours dans le même sens.** Interrogé, un apprenant demande
   l'exposé : c'est confortable, ça donne le sentiment d'avancer, et c'est le format
   dont on a mesuré qu'il ne tient pas (M7).

Conséquence : les questions portent sur des **faits** et des **situations**. Tout ce qui
est pédagogique en est déduit, **et l'inférence ne s'affiche jamais pendant l'entretien**.

### Comment conduire l'entretien

- **Une question à la fois.** On attend la réponse, on relance si elle est creuse, on
  passe. Huit questions, dix minutes.
- **Aucune ne nomme un concept du dispositif.** Ni « format », ni « mode d'échec »,
  ni « re-test », ni « module ».
- **Relancer une fois, jamais deux.** Une réponse vague relancée deux fois donne une
  réponse inventée pour avoir la paix, qui est pire que la réponse vague.
- **Ne pas commenter les réponses.** Pas de « très intéressant », pas de « ça va nous
  aider ». On enchaîne.
- Si l'apprenant demande à quoi sert une question : répondre en une phrase, vraie et
  vague — « à calibrer le rythme » — et enchaîner. L'inférence détaillée ne se discute pas.

### Les huit questions et ce qu'on en tire

La colonne de droite ne s'affiche **jamais** à l'apprenant.

| # | Question posée | Ce qui en est inféré |
|---|---|---|
| 1 | « Tu fais quoi dans la vie, et tu as étudié quoi ? » | domaine d'origine → **table des faux-amis** ; niveau de jargon toléré ; analogies disponibles et leurs limites |
| 2 | « Pourquoi ce sujet, et pour quand ? » | nature de l'échéance (examen / prise de poste / entretien / curiosité) ; existence d'une date → calendrier inversé ou régime sans calendrier |
| 3 | « À quoi tu verras que c'est acquis ? » | critère de réussite → format de validation des modules (QCM, cas, dissertation, conversation) |
| 4 | « Combien de soirées par semaine, et à quelle heure ? » | budget réel → calibrage de la checklist, longueur des séances |
| 5 | « Raconte-moi la dernière fois que tu as appris un truc difficile. Ça s'est passé comment ? » | endurance, tolérance à une correction sèche, modes d'échec à surveiller en priorité |
| 6 | « Quand tu bloques, tu préfères qu'on te donne la réponse ou qu'on te mette sur la piste ? » | agressivité socratique, délai avant indice |
| 7 | « Tu préfères qu'on avance par questions, que tu cherches par toi-même, ou que je t'expose d'abord ? » | pondération **initiale** des quatre formats — un signal de départ, rien de plus |
| 8 | « Qu'est-ce qui te ferait décrocher ? » | interdits explicites (« zéro code », « pas de formules »), contraintes, ce qui est déjà connu |

La question 7 est la seule qui approche un choix de méthode, et elle est posée **en
langue ordinaire**. La correspondance vers les quatre formats est interne
(`formats.md`) et ne se discute pas avec l'apprenant.

**Question 3 en mode B : elle est obligatoire.** Sans échéance, le critère de réussite
*est* l'échéance. Il doit être formulé en capacité observable et datable — « tenir une
conversation de vingt minutes sur le sujet », « écrire un texte qui tient devant
quelqu'un du domaine ». Un apprenant en mode B qui ne sait pas dire à quoi il verra
que c'est fini est un apprenant dont il faut **cadrer le sujet davantage**, pas moins.

### Ce qu'on ne demande jamais

| Jamais demandé | Pourquoi |
|---|---|
| Le format des séances, le rythme de re-test, les modes d'échec à surveiller | Ce sont des **sorties** du dispositif. En faire des entrées fige sur une déclaration ce qui devait venir d'une mesure. |
| « Quel est ton style d'apprentissage ? » (visuel, auditif, kinesthésique) | La théorie n'est pas étayée. La reprendre donnerait au dispositif l'air sérieux et le rendrait faux. |
| Une auto-évaluation de niveau sur une échelle | Non corrélée au niveau réel, dans les deux sens. La première séance la mesure mieux. |
| Quoi que ce soit qui ne changera aucune décision | Une question dont la réponse ne modifie ni le curriculum, ni le calendrier, ni la conduite est une question à supprimer. |

> **Ce qui peut être observé ne se demande pas.** C'est ce qui borne le questionnaire à
> huit questions. Un formulaire de trente champs produit un profil abandonné, et un
> profil abandonné vaut zéro.

### Écrire `profil.md`

Le fichier a deux parties : un bloc de champs machine, puis de la prose.

- **Toute ligne issue du questionnaire est marquée `déclaré`.** C'est une hypothèse.
- Une ligne inférée est marquée `inféré`, et **on écrit de quelle réponse elle vient**.
  L'inférence ne se montre pas pendant l'entretien ; elle est en clair dans le fichier
  après. C'est la contre-mesure au principal défaut de cette décision : l'inférence est
  invisible, donc invérifiable — sauf si elle est écrite.
- Dès qu'il y a de l'observation, **l'observation gagne** : le journal et le bloc AUTO
  écrasent la déclaration, sans le demander et sans le cacher. Le dispositif le dit une
  fois, en une phrase, à la troisième séance, puis il l'applique.

À la fin de l'étape 1 : **faire lire `profil.md` à l'apprenant.** Il corrige ce qui est
faux. C'est un fichier markdown dont il est propriétaire.

---

## Étape 2 — Le sujet et les sources

### L'embranchement

Une seule question, et c'est une question de **fait** :

> **« Tu as des documents à travailler, ou tu pars d'un sujet ? »**

| | **A — cours fourni** | **B — sujet libre** |
|---|---|---|
| Les sources | déposées par l'apprenant dans `cours/` | **cherchées et sélectionnées par le dispositif** |
| Le périmètre | fixé par le support | à cadrer explicitement, sinon il est infini |
| Passe supplémentaire | — | passe 0 + gate corpus |
| Dépendance | markdown + bash | **+ recherche web** |

**Si la recherche web n'est pas disponible**, le mode B se dégrade proprement : on le
dit, et on demande des documents. On ne bricole pas un corpus de mémoire — un corpus
récité par un modèle est un corpus sans provenance, donc sans valeur.

### Branche A — l'apprenant a ses documents

`cours/` est une zone de dépôt. On passe directement à la passe 1 de `ingestion.md`.

Le seul travail spécifique de cette branche : **faire dire à l'apprenant ce que le PDF
ne dit pas.** Trois questions, qui valent plus que le sommaire :

- « Sur quoi le prof insiste-t-il ? »
- « Qu'est-ce qui est tombé l'an dernier ? Tu as les annales ? »
- « Qu'est-ce que tu maîtrises déjà là-dedans ? »

### Branche B — l'apprenant a un sujet

Passe 0 de `ingestion.md`. Trois points structurants :

1. **Cadrer avant de chercher.** « La cryptographie » n'est pas un sujet, c'est un
   champ. Deux ou trois questions de resserrage, puis une proposition de périmètre
   **chiffrée** : « une vingtaine de modules, environ quinze séances ; voilà ce qui est
   dedans, voilà ce qui est dehors ». L'apprenant valide.
2. **Le gate corpus vient avant le gate curriculum.** Jeter un corpus coûte dix minutes ;
   jeter un curriculum construit dessus coûte beaucoup plus.
3. **Le corpus est figé après validation.** Une source ajoutée ensuite propose un diff,
   elle ne relance pas la génération.

---

## Les deux gates

Un gate n'est pas une confirmation. C'est un moment où **l'apprenant peut jeter le
travail**, et il doit avoir en main de quoi le faire.

### Gate corpus *(mode B seulement)*

On présente, dans cet ordre :

1. **le degré de confiance du corpus**, annoncé franchement — y compris quand il est
   faible ;
2. la liste des sources : auteur ou institution, date, type, ce qu'elle couvre, pourquoi
   elle est retenue ;
3. la couverture annoncée, et **les trous** ;
4. ce qui a été **écarté** et pourquoi.

Puis : « tu valides, tu corriges, ou tu jettes ? » Aucun module n'est écrit avant la
réponse.

### Gate curriculum *(les deux modes)*

On présente **d'abord ce qui saute et pourquoi** — c'est la partie qui provoque une
réaction, et un gate sans réaction est un gate raté. Puis le plan, le nombre de
modules, le calendrier, les faux-amis détectés.

Trois raisons d'exister, dans l'ordre :

1. Un curriculum faux coûte vingt séances. Le gate en coûte quinze minutes.
2. L'apprenant sait des choses que le PDF ne dit pas.
3. Un plan validé se suit ; un plan subi s'abandonne en semaine trois.

**Après validation, le curriculum appartient à l'apprenant.** C'est un fichier markdown
qu'il édite à la main, et qui n'est **jamais régénéré silencieusement**.

---

## Ce que l'initialisation ne fait pas

- **Elle ne lance pas la première séance.** Deux gates la séparent du travail réel.
- **Elle ne produit aucune observation.** `journal.md` sort de l'intake **vide**, et
  c'est normal : le modèle d'apprenant se construit en séance, jamais par déclaration.
  C'est toute la thèse du projet.
- **Elle ne se rejoue pas silencieusement.** Un `/intake` sur un dossier déjà initialisé
  propose un **diff** sur `profil.md` et `curriculum.md`. Rien de `progression/` n'est
  réécrit, jamais.
