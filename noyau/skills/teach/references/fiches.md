# Fiches et programme de révision

**Zone : NOYAU.** Écrasable à la mise à jour. Aucune donnée d'apprenant.

---

## Partie A — Les fiches

### 1. Le principe

> **Une fiche n'est pas dérivée du cours. Elle est dérivée du journal.**

Une fiche générée depuis le PDF est un résumé : n'importe quel assistant en produit un
en dix secondes, et personne ne le relit. Une fiche générée depuis le journal contient
**l'erreur exacte que cet apprenant-là a commise, à quelle date, sur quel cas** — et ça
n'existe nulle part ailleurs. C'est le seul artefact du dispositif qui soit incopiable.

**Règle de génération, qui est un corollaire :**

> **Un concept qui n'est jamais tombé ne produit pas de fiche.**

Pas de fiche préventive, pas de fiche « sur les notions probablement difficiles ».
Difficile pour qui ? La difficulté prédite est une conjecture ; la difficulté observée
est une donnée. Le volume de fiches est proportionnel aux **difficultés réelles**, pas
au volume du cours : un dossier de 30 fiches se relit, un dossier de 400 ne se relit pas.

### 2. Quand une fiche est créée

| Déclencheur | Effet |
|---|---|
| **2ᵉ occurrence** d'une confusion (règle des deux occurrences) | Fiche **créée**, et elle cite les deux occurrences |
| Occurrence suivante du même concept | Fiche **mise à jour** : une ligne de plus dans « Où je suis tombé » |
| Re-test raté sur un concept déjà fiché | Ligne de plus, et le cas discriminant est **remplacé** — s'il n'a pas discriminé, il ne sert à rien |
| 1ʳᵉ occurrence isolée | **Rien.** Le journal suffit. Sur-réagir au bruit remplit `fiches/` de bruit. |

Une fiche se **supprime** quand son concept est sorti de la boucle d'espacement
(`consolide`) et qu'aucune occurrence n'est apparue depuis trois échéances. Elle a
servi ; la garder dilue le paquet.

### 3. Anatomie — six blocs, dans cet ordre

```markdown
# <terme, dans la langue du support>

**Définition** — une à deux phrases. Pas de paraphrase du cours.

**Mécanisme** — pourquoi ça marche comme ça. C'est le bloc qui compte :
le mode d'échec M1 (conclusion juste, mécanisme faux) se soigne ici.

**Où je suis tombé** — le cas réel, daté, avec ma réponse fausse et
pourquoi elle était fausse.
  · 2026-08-04 (module 0.4) — cas limite posé juste après la tranche, sur
    la frontière entre <terme> et <terme voisin> → j'ai dit oui. Faux :
    les deux notions ne portent pas sur le même acteur.

**Faux-ami** — renseigné seulement si le terme existe dans mon domaine
d'origine avec un autre sens, et alors en disant *en quoi* ça diffère.

**Le cas qui discrimine** — le cas limite à se re-poser. Pas la définition :
un cas. Re-tester par la définition ne révèle rien (mesuré).

**Rattachement** — module d'origine, prérequis, concepts voisins qui ont
déjà provoqué une confusion.
```

Le bloc **« Où je suis tombé »** est la fiche. Les autres blocs existent pour le
rendre exploitable. Une fiche dont ce bloc est vide ou vague n'aurait pas dû être créée.

### 4. Ce qu'on ne met jamais dans une fiche

| Absent | Pourquoi |
|---|---|
| Un résumé du chapitre | Ce n'est pas une fiche, c'est le cours en plus petit. |
| La liste de tout le vocabulaire du module | Le glossaire existe pour ça, et il est alimenté au fil de l'eau. |
| Un pourcentage de maîtrise | Un chiffre inventé sur une échelle auto-définie n'est pas une mesure. |
| Une bonne réponse mise en avant | La fiche doit se lire **par le cas**, pas par la solution. Si l'œil tombe d'abord sur la réponse, la fiche ne teste plus rien. |

### 5. Le paquet, en fin de parcours

À la veille de l'échéance, `fiches/` est la **carte des points faibles réels** de cet
apprenant, utilisable seule. C'est la sortie la plus visible du dispositif.

Conséquence contre-intuitive à annoncer d'avance : **un apprenant qui ne se plante
jamais n'obtient aucune fiche.** C'est cohérent — il n'en a pas besoin — mais ça
ressemble à un bug si on ne l'a pas dit.

---

## Partie B — Le programme de révision

### 6. Ce qui est calculé, ce qui est décidé

| Calculé par le script, déterministe | Décidé par le tuteur en séance |
|---|---|
| Quels modules sont dus aujourd'hui | Comment les re-tester |
| Depuis combien de temps un module n'a pas été revu | Quel cas construire |
| Quels modules sont `fragile` | Quel format employer |
| Le retard sur le calendrier cible | Quand renoncer au module du jour |

> **Un modèle ne doit jamais décider de son propre calendrier de révision.** Il oublie,
> il dérive vers ce qu'il vient de traiter, et il ne s'en aperçoit pas. Les dates sont
> dans la checklist, et un script les compare à aujourd'hui. C'est tout.

### 7. L'algorithme d'espacement

Volontairement simple. Quatre statuts, et une échelle à quatre barreaux.

| Statut | Prochaine échéance | Mode de re-test |
|---|---|---|
| `acquis` | **J+3, puis J+10, puis J+30, puis J+90** | 2–3 cas, en ouverture de séance |
| `fragile` | **prochaine séance, systématiquement** | Cas variés, une variable modifiée à la fois |
| `a-revoir` | prochaine séance | Le module est rejoué **entier**, en Restitution (F4) — pas en Exposé |
| `consolide` | plus jamais | Sorti de la boucle |

**Transitions**, appliquées par `echeances.sh` et par lui seul :

- verdict `ok` sur un `acquis` → monte d'un barreau. Après le 4ᵉ barreau réussi
  (J+90), le module passe `consolide` et **sort de la boucle**.
- verdict `rate` → retombe en `fragile`, **compteur remis à zéro**. Toute l'échelle est
  à refaire.
- verdict `partiel` → reste `fragile`, compteur à zéro, et une note au journal qui dit
  **quel membre** manquait.
- un module `fragile` ou `a-revoir` est **dû à chaque séance**, sans calcul de date.

### 8. Les cinq règles de re-test — toutes issues de mesures

1. **Re-tester par des cas, jamais par la définition.** Une distinction enseignée et
   correctement récitée s'effondre au premier cas posé juste après.
2. **Une seule variable change entre deux cas.** Quatre cas construits sur un même objet
   en ne modifiant qu'un paramètre localisent l'échec exactement. Quatre cas différents
   ne localisent rien.
3. **Commencer par le cas difficile.** Partir du cas facile installe une réponse qui
   contamine les suivants (M3).
4. **Re-tester en ordre inversé de l'apprentissage.** Contre-mesure directe de M3, et
   c'est le tri que `echeances.sh dues` renvoie déjà.
5. **Budgéter 12 minutes de re-test, pas 5.** Trois mesures concordantes. Un budget
   sous-estimé conduit à écourter le re-test, c'est-à-dire à sacrifier la seule partie
   de la séance dont on sait qu'elle fonctionne.

### 9. Le rituel de fin de bloc

Une séance entière, à la fin de chaque bloc du curriculum. Commande : `/revision`.

1. **Restitution** — l'apprenant explique le bloc, le tuteur joue le collègue qui ne
   comprend pas et pose les questions gênantes exactement là où il a survolé.
2. **Relecture intégrale du journal** — tout, pas les trois dernières entrées — et
   proposition d'un **diff** sur le bloc AUTO.
3. **Sondage de traçabilité** — trois affirmations du curriculum tirées au hasard,
   confrontées à leur source dans `cours/`. Une affirmation dont la source ne se
   retrouve pas est marquée `hors-support` séance tenante.
4. **L'apprenant lit, garde ou jette.** Git fait le retour arrière.

Rien ne se modifie tout seul entre deux rituels, à l'exception de `progression/` et du
bloc AUTO — plafonné, sous balises.
