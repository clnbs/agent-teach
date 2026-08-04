# De la matière au curriculum — les cinq passes

**Zone : NOYAU.** Procédure exécutable de l'étape 2 de `/intake`.

**C'est le morceau dur.** Tout le reste du dispositif est une adaptation de quelque
chose qui tourne déjà.

Un dossier de cours contient un **plan de professeur**, qui est un ordre d'exposition
— pas un ordre d'apprentissage. Les deux coïncident rarement. Et il ne contient jamais
le cas piège. Le saut à franchir : **d'une table des matières à un graphe de
dépendances assorti de critères de validation.** Un système qui découpe les chapitres
en modules a produit un sommaire, pas un curriculum, et il ne sert à rien.

La passe 0 n'existe qu'en mode B. **À partir de la passe 1, les deux modes sont
indiscernables** : le pipeline travaille sur un `cours/` figé et ignore comment il a
été rempli. C'est la condition pour que le mode B soit un mode de plus, et non un
second produit à maintenir.

---

## Passe 0 — Constitution du corpus *(mode B uniquement)*

C'est l'endroit où le dispositif peut faire le plus de dégâts : **en mode A le support
du professeur fait autorité par construction ; ici, le dispositif décide seul de ce qui
fait autorité, face à quelqu'un qui ne peut pas le juger.**

### 0.1 Cadrage

Deux ou trois questions de resserrage, puis un **périmètre chiffré** annoncé :
« une vingtaine de modules, environ quinze séances ; voilà ce qui est dedans, voilà ce
qui est dehors. » L'apprenant valide avant toute recherche.

Sujet trop large (« l'intelligence artificielle ») : **ne pas commencer.** Proposer
trois découpes possibles avec leur volume, faire choisir.

### 0.2 Recherche et sélection

Par ordre de préférence, et l'ordre est la règle :

1. cours et syllabus universitaires publics ;
2. manuels de référence ;
3. sources primaires — textes normatifs, spécifications, articles fondateurs.

**Écartés par défaut** : contenus optimisés pour le référencement, vulgarisation sans
auteur identifiable, vidéos sans transcription, contenus manifestement générés.

### 0.3 Fiche de source obligatoire

Une entrée par source dans `progression/sources.md` : URL, auteur ou institution, date
de publication, date de consultation, type, et une phrase sur ce qu'elle couvre et
pourquoi elle est retenue.

> **Une source sans auteur identifiable ni date n'est pas retenue.** Pas « retenue avec
> réserve ». Pas retenue.

### 0.4 Copie locale

Le texte retenu est copié dans `cours/`, pas seulement le lien. Sans copie locale, le
sondage de traçabilité du rituel de fin de bloc devient un acte de foi dès qu'une page
bouge ou disparaît. **Une URL n'est pas une source, c'est un pointeur vers une source.**

`sources.md` ne contient **que des références**, jamais du texte copié : c'est ce qui
garde ce fichier partageable alors que `cours/` ne l'est pas.

### 0.5 Gate corpus

Détail dans `intake.md`. Ce qui se présente en premier : **le degré de confiance du
corpus**, y compris et surtout quand il est faible.

---

## Passe 1 — Inventaire *(aucune interprétation)*

Lister ce qu'il y a. Rien d'autre : à ce stade on ne lit pas pour comprendre, on lit
pour constater.

Sortie : un tableau brut soumis à l'apprenant.

| Fichier | Type | Volume | Lisible ? | Rôle | Doublon de |
|---|---|---|---|---|---|

- **Lisibilité** : un scan sans couche texte est un **mur**, pas une difficulté. On le
  signale et on s'arrête dessus. Ne jamais deviner le contenu d'une page illisible.
- **Rôle** : cours / notes / annales / exercices / hors-sujet.
- **Les trous** sont la sortie principale de cette passe, pas un détail.

Puis deux questions, systématiquement :

- « Il n'y a rien sur *[thème annoncé au sommaire mais absent des fichiers]*. Tu l'as
  ailleurs, ou on le traite comme hors-support ? »
- « Le fichier *[annales]* est un sujet d'examen, pas du cours. Je m'en sers pour le
  triage, pas pour l'enseignement. D'accord ? »

---

## Passe 2 — Graphe de concepts

Extraire les concepts et, pour chacun, **ce qu'il faut avoir compris avant**. Sortie :
un **DAG**, pas une liste.

### Deux règles de qualité

**Traçabilité obligatoire.** Chaque concept porte sa source :
- mode A → `fichier:page`
- mode B → `source:section` + date de consultation

Un concept sans source est marqué **`hors-support`** et signalé. C'est le garde-fou
anti-hallucination, et il n'est pas négociable : un module inventé fait travailler
l'apprenant sur une matière qui ne tombera pas.

**L'ordre du prof est une donnée, pas une consigne.** S'il diverge du graphe de
dépendances, on suit le graphe **et on le dit** à l'apprenant, avec la raison. Le
désaccord se signale, il ne se cache pas.

### Les faux-amis

En parallèle du graphe, produire la **table des faux-amis candidats** : termes du cours
qui existent dans le domaine d'origine de l'apprenant (`profil.md`) avec un sens
différent. Chaque entrée dit **en quoi** ça diffère — jamais un symbole seul.

Ces termes sont marqués dans le curriculum et **traités frontalement en séance** : on
annonce la collision avant de définir (M9). Symétriquement, quand une analogie avec le
domaine d'origine tient, on l'utilise **et on dit où elle casse**. C'est là que se
logent les erreurs les plus coûteuses, parce qu'elles ne se présentent pas comme des
erreurs.

---

## Passe 3 — Découpage en modules

Chaque module produit **cinq champs**. Un module qui n'en a que quatre est refusé — et
celui qui manque est toujours le même, le cinquième.

| Champ | Contrainte |
|---|---|
| **Objectif** | Formulé en **capacité observable** (« savoir distinguer X de Y en situation »), jamais en couverture (« voir le chapitre 3 »). |
| **Prérequis** | Modules amont dans le graphe. Explicites, pas « les bases ». |
| **Termes** | **8 à 12.** Au-delà, le module est trop gros et se découpe. |
| **Format** | Un des quatre (`formats.md`), choisi sur le **type de contenu**. |
| **Validation + cas piège** | **Le champ qui fait la différence.** Comment on saura que c'est acquis, et le cas limite volontairement ambigu qui le testera. |

**Calibrage cible** : un module = un mécanisme + 8–12 termes ≈ 30–45 min. En volume de
support dense, l'ordre de grandeur est de **15 à 40 pages de slides** ou **8 à 15 pages
de polycopié**. C'est une estimation à recalibrer sur données réelles, pas une mesure.

### Le cas piège — ce qui le distingue d'un exercice

Un cas piège n'est pas un cas difficile. C'est un cas **sur la frontière**, dont la
réponse dépend d'un seul élément que l'apprenant est susceptible de ne pas tester.
Il révèle **où passe la frontière dans sa tête**, pas s'il a révisé.

Test de qualité : *si un apprenant qui a compris et un apprenant qui a mémorisé
répondent pareil, ce n'est pas un cas piège.*

### Exemple de module bien formé *(structure, domaine neutralisé)*

> **0.3 — Les objets du domaine**
> **Objectif** — classer un objet donné et situer la frontière entre les deux
> catégories que le cours oppose.
> **Prérequis** — 0.1, 0.2.
> **Termes** — les 8 à 12 termes du module.
> **Format** — F3 (cas d'abord) : c'est une classification.
> **Validation** — face à cinq descriptions d'objets, l'apprenant les classe
> correctement **et justifie la classification du dernier** — celui qui est
> volontairement ambigu.
> **Source** — `poly-ch1.pdf:12-18`.
> **Faux-amis** — *terme X* (sens différent dans le domaine d'origine : …).

---

## Passe 4 — Calendrier inversé et triage

Depuis la date cible du `profil.md`, à rebours :

```
modules × 45 min + (1 séance de révision par bloc) + re-tests
      ─────────────────────────────────────────────────────  vs  soirées disponibles
```

`.claude/hooks/echeances.sh etat` fait ce calcul une fois le curriculum écrit. **Ne le
fais pas à la main.**

Si ça ne rentre pas — **cas majoritaire** — le système **ne compresse pas les modules**.
Il marque un **parcours minimal (★)** et le dit franchement :

> « 34 modules, 6 semaines, 3 soirées par semaine : il en passe 18. Voilà les 18, voilà
>   ce qui saute, voilà le risque pris. »

**Triage, pas réordonnancement** : on garde l'ordre pédagogique et on **saute**, sinon
les dépendances cassent. Le triage se fait sur les annales et le barème quand ils
existent, sur la **centralité dans le graphe** sinon.

**Sans date cible** — cas fréquent en mode B — cette passe ne s'applique pas : pas de
compte à rebours, donc pas de triage. Le parcours est intégral, et c'est le **critère
de réussite** déclaré à l'étape 1 qui définit la fin. L'espacement des re-tests, lui,
continue de fonctionner sans changement : il est relatif à chaque module, pas à une
échéance.

---

## Les cas dégradés — à traiter explicitement, jamais à contourner

| Cas | Réponse du dispositif |
|---|---|
| Matière trop mince (30 slides pour un semestre) | Le dire. Proposer 4 modules et une recherche de sources complémentaires. **Ne pas gonfler artificiellement.** |
| Matière énorme (800 pages) | Calendrier inversé, triage ★ agressif, et annoncer le **taux de couverture**. |
| Notes manuscrites illisibles, scans sans couche texte | **Blocage franc à l'inventaire.** Ne jamais deviner le contenu d'une page illisible. |
| Cours dans une langue différente de celle de l'apprenant | Le jargon reste dans la langue du support — c'est celui de l'examen. **Jamais de traduction maison d'un terme technique.** |
| Matière purement factuelle (dates, listes, nomenclatures) | Le dire : sur du pur factuel, un logiciel de répétition espacée classique fait mieux et coûte moins cher. **Reconnaître son inutilité est un critère de qualité.** |
| Deux cours dans un même dossier | **Refuser.** Un dossier = un cours = un curriculum. |
| **Mode B** — sujet trop large | Ne pas commencer. Trois découpes chiffrées, faire choisir. |
| **Mode B** — sujet trop récent ou confidentiel pour avoir des sources solides | **Le dire et s'arrêter.** Sur un sujet dont il n'existe que des billets contradictoires, le dispositif fabriquerait un curriculum d'apparence sérieuse sur du sable. |
| **Mode B** — seul corpus disponible payant ou fermé | Le dire. Proposer la liste des références à se procurer, et basculer en mode A si l'apprenant les obtient. |

---

## Le risque propre à l'ingestion

L'ingestion est l'endroit où le système peut fabriquer du contenu **plausible et faux**
sans que l'apprenant — qui, par définition, ne connaît pas encore la matière — puisse
le détecter.

La traçabilité est la seule protection sérieuse, et **elle doit être vérifiable par
sondage** : le rituel de fin de bloc tire trois affirmations du curriculum et les
confronte à leur source dans `cours/`.

**En mode B, le risque change de nature et monte d'un cran.** En mode A, une
affirmation fausse est détectable : elle n'est pas dans le poly. En mode B, le
dispositif a choisi lui-même le poly — une affirmation peut être **parfaitement
traçable vers une source qui a tort**. La traçabilité protège de l'invention, pas de la
mauvaise source. C'est pourquoi le gate corpus porte sur la **provenance** — qui écrit,
quand, avec quelle autorité — et pas seulement sur la couverture.

Aggravant, à garder en tête : **la mise en forme est identique dans les deux modes.**
Un curriculum bâti sur trois billets de blog a exactement l'apparence d'un curriculum
bâti sur un manuel de référence. C'est au dispositif d'annoncer la différence, parce
que rien dans le fichier ne la montrera.
