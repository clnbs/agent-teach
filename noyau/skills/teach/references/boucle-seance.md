# La boucle de séance, en cinq temps

**Zone : NOYAU.** Écrasable à la mise à jour. Aucune donnée d'apprenant.

Une séance = un module = 30 à 45 minutes. Cinq temps, dans cet ordre, et l'ordre est
la moitié du dispositif : **une séance s'ouvre en lisant le journal, pas le
curriculum.** La mémoire pilote la boucle, jamais l'inverse.

```
1. LIRE L'ÉTAT      hors temps apprenant   ce qui a coincé, ce qui est dû
2. ANNONCER         ≤ 1 min                le plan de la séance, y compris ce qu'on saute
3. DÉROULER         ~12 min + ~20 min      re-test d'ouverture, puis le module
4. FAIRE PRODUIRE   ~5 min                 l'apprenant explique ou tranche, seul
5. ÉCRIRE           hors temps apprenant   journal, checklist, glossaire, fiches
```

---

## Temps 1 — Lire l'état

**Avant la première phrase adressée à l'apprenant.** Le hook `session-start.sh` a déjà
affiché l'essentiel ; on le lit, on ne le redemande pas.

À lire, dans cet ordre — l'ordre compte, il va du plus périssable au plus stable :

1. **`progression/journal.md`** — les trois dernières entrées **et** la section
   « Patterns consolidés » en entier. C'est ce qui décide de la conduite du jour.
2. **Les re-tests dus**, calculés par `.claude/hooks/echeances.sh dues`. Jamais
   recalculés à la main, jamais estimés (D4).
3. **`progression/checklist.md`** — statut du module prévu et de ses prérequis.
4. **`progression/profil.md`** — seulement si la séance est parmi les cinq premières,
   ou si un faux-ami est attendu sur ce module.
5. **Le module du jour dans `curriculum.md`** — en dernier. Il ne se lit qu'une fois
   qu'on sait dans quel état est l'apprenant.

**Décision de fin de temps 1**, prise avant d'ouvrir la bouche :

| Constat | Décision |
|---|---|
| Un prérequis du module est `fragile` ou `à revoir` | **On ne fait pas le module.** On traite le prérequis (I6). |
| Trois modules ou plus sont dus | Le re-test prend 20 min, le module du jour est allégé ou reporté. |
| Le journal signale une 2ᵉ occurrence non traitée | Elle passe **avant** le module du jour. |
| Rien de dû, rien de fragile | Module prévu, re-test de 12 min quand même. |

---

## Temps 2 — Annoncer

Une phrase, deux au plus. Ce qu'on fait, dans quel ordre, et **ce qu'on ne fait pas**.

> « On commence par re-tester deux choses des séances précédentes, puis on prend le
>   module sur X. Je saute le point Y prévu : ton prérequis dessus n'est pas là, on
>   le reprend jeudi. »

Trois règles :

- **Ce qu'on saute se dit**, avec la raison. Un renoncement silencieux est un
  renoncement qui ne s'enregistre pas.
- **Aucun mot du dispositif.** Pas de « format F3 », pas de « re-test J+10 », pas de
  « mode M2 ». Langue ordinaire, toujours (conduite §4).
- **Pas de préambule motivationnel.** Ni « on va bien s'amuser », ni « c'est un chapitre
  difficile mais tu vas y arriver ».

---

## Temps 3 — Dérouler

### 3a. Le re-test d'ouverture — 12 minutes, budgétées comme telles

Non négociable, et la première chose qu'on sacrifie quand on est en retard — c'est
exactement l'erreur à ne pas commettre. Trois mesures concordantes : **12 minutes, pas
5.**

Cinq règles, toutes issues de mesures :

1. **Par des cas (F3), jamais par la définition.** Une distinction correctement récitée
   s'effondre au premier cas posé juste après. Re-tester par la définition ne révèle
   rien — c'est mesuré, pas supposé.
2. **Une seule variable change entre deux cas.**
3. **Commencer par le cas difficile.**
4. **Ordre inversé de l'apprentissage** : du module le plus ancien vers le plus récent.
   `echeances.sh dues` fournit déjà ce tri ; le suivre.
5. Après chaque réponse, **`Pourquoi ?`** — y compris quand elle est juste.

**Verdict de re-test**, à la fin des 12 minutes, pour chaque module re-testé — c'est le
seul verdict que le tuteur émet, et il est à trois valeurs :

| Verdict | Ce qu'on a vu | Effet, appliqué par le script |
|---|---|---|
| `ok` | Tranche juste **et** justifie juste | monte d'un cran dans l'échelle d'espacement |
| `rate` | Tranche faux, ou juste avec un mécanisme faux (M1) | retombe en `fragile`, compteur à zéro |
| `partiel` | Le fond est là, le mot ou un membre manque (M4, M6) | reste `fragile`, compteur à zéro, note au journal |

Le tuteur émet le verdict. **Il ne calcule jamais la date suivante** (D4) : il appelle
`echeances.sh retest <module> <verdict>`.

### 3b. Le module — 20 à 25 minutes

Format choisi selon `formats.md`, sur le **type de contenu** et non sur la préférence
déclarée.

Déroulé invariant, quel que soit le format :

1. **Les faux-amis d'abord.** Si un terme du module est dans la table des faux-amis du
   curriculum, la collision s'annonce **avant** de définir : « ce mot existe dans ton
   domaine d'origine, il n'a pas le même sens ici, voilà en quoi » (M9).
2. **Définir avant d'employer** (I5).
3. **Le cas piège du module est posé immédiatement après la tranche qui l'arme** —
   pas en fin de module (M7).
4. **Un `Pourquoi ?` après chaque conclusion**, juste ou fausse (M1).
5. Les termes nouveaux vont au glossaire **au fil de l'eau**, pas en fin de séance.

**Renoncer proprement.** Si le module ne passe pas — prérequis absent découvert en
route, apprenant fatigué, temps consommé par le re-test — on l'arrête. On le dit, on
écrit `à revoir` ou `—` dans la checklist, et on écrit **pourquoi** au journal. Un
module conduit à moitié et marqué acquis empoisonne les vingt séances suivantes.

---

## Temps 4 — Faire produire

Cinq minutes, et c'est le temps qui décide si la séance a servi.

**L'apprenant produit seul.** Le tuteur ne complète pas, ne souffle pas, ne remplit pas
les silences. Une seule des trois formes :

- **restitution** (F4) : « explique ce mécanisme à quelqu'un du domaine qui ne connaît
  pas ce point » ;
- **cas de sortie** (F3) : un cas neuf, sur la frontière, jamais vu pendant le module ;
- **prédiction** : « si on change ce paramètre, qu'est-ce qui se passe, et pourquoi ? ».

Ce qui se mesure ici :
- ce qui est **omis** — la donnée principale, et celle qu'on ne voit qu'en se taisant ;
- les mots employés sans être définis ;
- l'ordre dans lequel l'apprenant reconstruit le mécanisme, qui n'est presque jamais
  celui du cours.

**Interdit de terminer sur une explication du tuteur.** Une séance qui se clôt sur la
parole du tuteur n'a rien mesuré, et il n'y aura rien à écrire au temps 5.

---

## Temps 5 — Écrire

Hors temps apprenant, et **non négociable** : une séance non écrite est une séance
perdue, parce que la version du tuteur qui ouvrira dans trois jours n'aura aucun
souvenir de celle-ci.

Dans cet ordre :

1. **`journal.md`** — l'entrée du jour. Six à dix lignes factuelles. Le cas posé, la
   réponse, l'inférence qui écarte une explication concurrente, la consigne pour la
   prochaine séance. Codes de la taxonomie en attribut, jamais à la place de
   l'observation.
2. **Deuxième occurrence ?** Si une confusion du jour est déjà au journal, elle monte
   en « Patterns consolidés », le concept passe `fragile`, et une **fiche** est produite.
3. **`checklist.md`** — via `echeances.sh cloturer <module> <statut> --format-reel <F>`.
   Le statut est pédagogique, la date est calculée. Jamais l'inverse.
4. **`glossaire.md`** — les termes du jour, s'ils n'y sont pas déjà. Colonne faux-ami
   renseignée seulement quand le terme existe dans le domaine d'origine avec un autre
   sens, et alors **en disant en quoi ça diffère** — jamais un symbole seul.
5. **`fiches/`** — une fiche par concept **tombé**. Un concept qui n'est jamais tombé
   ne produit pas de fiche (D3).

`echeances.sh cloturer` **refuse** de clore si `journal.md` n'a pas été modifié depuis
l'ouverture de la séance. Ce n'est pas une politesse : le journal est le point unique
de défaillance du dispositif, et un journal bâclé produit des fiches vides.

---

## Le rituel de fin de bloc

À la fin de chaque bloc du curriculum, une séance entière — pas un module. Voir
`/revision`. Quatre temps :

1. **Restitution du bloc entier** (F4), le tuteur en collègue qui ne comprend pas.
2. **Relecture intégrale du journal** — tout, pas les trois dernières entrées — et
   proposition d'un **diff** sur le bloc AUTO du `SKILL.md`.
3. **Sondage de traçabilité** : trois affirmations du curriculum tirées au hasard,
   confrontées à leur source dans `cours/`. Garde-fou anti-hallucination de
   l'ingestion. Une affirmation dont la source ne se retrouve pas est marquée
   `hors-support` dans le curriculum, séance tenante.
4. **L'apprenant lit, garde ou jette.** Git fait le retour arrière.

Entre deux rituels, **rien ne se modifie tout seul** — sauf `progression/` et le bloc
AUTO, qui est plafonné et sous balises.
