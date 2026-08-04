---
description: Rituel de fin de bloc — restitution, relecture du journal, sondage de traçabilité
argument-hint: "[bloc] (facultatif — sinon le bloc qui vient d'être terminé)"
---

Conduis le rituel de fin de bloc. Ce n'est pas une séance de plus : c'est la seule
occasion où l'apprenant regarde son propre modèle d'apprenant, et où le dispositif se
fait auditer.

Bloc concerné : $ARGUMENTS *(vide = celui dont tous les modules viennent d'être clos)*

Lis `.claude/skills/teach/references/fiches.md` (§ rituel de fin de bloc) et
`.claude/skills/teach/references/conduite.md`.

## 1 — Restitution, sans support

Format F4, intégralement. L'apprenant reconstruit le bloc de mémoire : les objets, ce
qui les sépare, dans quel ordre ça s'enchaîne. Tu ne fournis rien, pas même une amorce.

Ce que tu écoutes, ce n'est pas l'exactitude : c'est **ce qu'il omet**. Une omission
répétée dit plus qu'une erreur ponctuelle, et elle se journalise comme telle.

Chaque module du bloc reçoit son verdict :

```sh
.claude/hooks/echeances.sh retest <module> <ok|rate|partiel>
```

## 2 — Relecture du journal, à voix haute

Ouvre `progression/journal.md` avec l'apprenant sur les entrées du bloc. Lis-lui les
patterns consolidés qui le concernent — **en toutes lettres, avec leurs dates**.

Puis le rituel, et il est à sens unique : **l'apprenant lit, garde ou jette.** Une
observation qu'il conteste se supprime, sans négociation et sans justification à
fournir. C'est son fichier. Un journal qu'il ne reconnaît pas est un journal qu'il
cessera de lire, et le dispositif meurt ce jour-là.

Ce que tu ne fais pas ici : défendre une inférence, la reformuler pour la sauver, ou la
réécrire ailleurs sous un autre nom.

C'est aussi le moment prévu pour le bloc AUTO : enchaîne sur la procédure de `/tune`
et propose un **diff**. Rien ne s'y applique sans accord explicite.

## 3 — Sondage de traçabilité

Tire **trois affirmations au hasard** parmi celles enseignées dans le bloc. Pour
chacune, retourne à `cours/` et retrouve la source annoncée.

Écris le résultat dans le tableau « Sondages de traçabilité » de `curriculum.md` :
date, affirmation, source annoncée, retrouvée ou non.

Une affirmation dont la source ne se retrouve pas est marquée `hors-support` **séance
tenante**, dans le curriculum et dans le journal. Tu ne la défends pas, tu ne cherches
pas une source de remplacement plausible : tu la signales. C'est le seul mécanisme qui
détecte une hallucination installée depuis des semaines.

## 4 — Fiches

Toute confusion du bloc apparue **deux fois** doit avoir sa fiche. Vérifie
`progression/fiches/`, et produis ce qui manque via la procédure de `fiches.md` — depuis
le journal, jamais depuis le cours.

## 5 — Écrire

Une entrée de journal pour le bloc entier : ce qui a tenu, ce qui est tombé à la
restitution, ce que le sondage a donné, et la consigne pour le bloc suivant.

Puis clos les modules restants du bloc. Rappel : aucune date écrite à la main.
