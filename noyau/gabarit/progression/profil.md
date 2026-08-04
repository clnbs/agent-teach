# Profil — qui apprend

**Zone : ESPACE APPRENANT.** Jamais écrasé par une mise à jour du moteur.
Rempli par l'étape 1 de `/intake`, à partir de huit questions en langue ordinaire.

Deux conventions, et elles décident de la façon dont ce fichier est utilisé :

- **`déclaré`** — tu l'as dit. C'est une **hypothèse**.
- **`inféré`** — le dispositif l'a déduit d'une de tes réponses, et il dit laquelle.

> **Dès qu'il y a de l'observation, l'observation gagne.** Le journal et le bloc AUTO
> écrasent la déclaration, sans le demander et sans le cacher. Si ce que tu as déclaré
> et ce que tu fais divergent, le dispositif te le dit une fois, en une phrase, puis il
> applique ce qu'il observe.

Ce fichier est à toi. S'il dit quelque chose de faux, corrige-le à la main.

---

## Champs

<!-- at:profil:debut -->
| Champ | Valeur | Source |
|---|---|---|
| domaine_origine | — | déclaré |
| formation | — | déclaré |
| date_cible | — | déclaré |
| nature_echeance | — | déclaré |
| critere_reussite | — | déclaré |
| seances_par_semaine | 3 | déclaré |
| duree_seance_min | 45 | inféré |
| moment_habituel | — | déclaré |
| delai_avant_indice | 2 tentatives | inféré |
| ponderation_initiale | — | inféré |
| registre | simple | inféré |
| mode_entree | — | déclaré |
| langue_support | — | déclaré |
<!-- at:profil:fin -->

`date_cible` vide = régime sans calendrier inversé : pas de compte à rebours, donc pas
de triage, et le parcours est intégral. C'est alors `critere_reussite` qui définit la
fin — et il doit être formulé en capacité observable et datable.

`nature_echeance` : `examen` · `prise-de-poste` · `entretien` · `curiosite`
`mode_entree` : `A` (cours fourni) · `B` (sujet libre)
`ponderation_initiale` : `questions` · `cherche-seul` · `expose-dabord`
`registre` : `simple` · `standard` · `dense` — comment le tuteur écrit, déduit de la
façon dont tu écris. `simple` par défaut. Ça change les phrases du tuteur, jamais son
exigence ni ses verdicts.

---

## Ce qui a été déduit, et de quoi

_Rempli à l'intake. Une ligne par inférence, avec la réponse dont elle vient._

L'inférence est invisible pendant l'entretien — c'est le prix d'une décision assumée :
on ne demande jamais à quelqu'un de choisir sa méthode. La contre-mesure est ici :
**elle est écrite en clair après.** Si une déduction te paraît fausse, elle se corrige.

---

## Faux-amis

_Rempli à l'ingestion, à partir de `domaine_origine`._

Termes du cours qui existent dans ton domaine d'origine avec un sens différent. Ton
domaine d'origine est à la fois ton meilleur levier et ton piège principal : sur ces
termes, l'intuition est **confiante et fausse**, ce qui est le pire cas possible.

| Terme du cours | Sens dans le domaine d'origine | En quoi ça diffère |
|---|---|---|

---

## Contraintes et interdits

_Ce qui te ferait décrocher, ce que tu maîtrises déjà._
