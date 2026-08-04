# Licences — qui couvre quoi

Trois régimes, parce que ce dépôt contient trois choses de nature différente :
du logiciel, du contenu pédagogique, et de la documentation. Un quatrième objet —
les données d'apprentissage — n'est pas couvert du tout, et c'est volontaire.

| Composant | Chemin | Licence |
|---|---|---|
| **Noyau** — skill, références, hooks, commandes, CLI, gabarits, tests | `noyau/`, `bin/`, `tests/`, `install.sh` | **Apache 2.0** ([`LICENSE`](LICENSE)) |
| **Curricula vitrine et communautaires** | `exemples/curriculum-*.md` | **CC BY-SA 4.0** |
| **Documentation** | `README.md`, `CONTRIBUTING.md`, `INSTALLATION.md` | **CC BY 4.0** |
| **Données d'apprentissage d'un apprenant** | le `progression/` et le `cours/` de chaque dossier de cours | **appartient à l'apprenant** — voir ci-dessous |

- CC BY-SA 4.0 : <https://creativecommons.org/licenses/by-sa/4.0/legalcode.fr>
- CC BY 4.0 : <https://creativecommons.org/licenses/by/4.0/legalcode.fr>

## Pourquoi cette découpe

**Le noyau est permissif** parce qu'il n'y a rien à protéger : quelques milliers de
mots de markdown et de bash, que quiconque observe trois séances reconstruit. Apache
plutôt que MIT pour la concession de brevet explicite et l'exigence d'attribution en
cas de fork.

**Les curricula sont en copyleft** parce que c'est là qu'est le travail coûteux. Un
curriculum amélioré doit revenir à la communauté ; c'est le bon endroit pour du
*share-alike*, et le noyau ne l'est pas.

Règle générale : **on ouvre ce qui n'est pas protégeable, on garde ce qui coûte cher à
produire.** Et l'interdit correspondant : ne jamais ouvrir un curriculum de domaine
régulé pour faire nombre. Ouvert une fois, il est ouvert pour toujours.

## Les données d'apprentissage n'ont pas de licence, elles ont un propriétaire

Le dossier `progression/` d'un apprenant contient un journal d'observations sur la
façon dont cette personne échoue. Ce n'est pas du contenu sous licence, c'est un
dossier personnel.

- Il est produit sur la machine de l'apprenant, et il y reste.
- Il n'est **jamais** collecté, transmis, ni nécessaire au fonctionnement du dispositif.
- Aucune télémétrie n'existe dans ce dépôt, y compris anonyme. C'est un non-objectif
  explicite, pas un oubli.

## Avertissement sur `cours/`

`cours/` contient les supports de l'apprenant : polycopiés, slides, annales. Ces
documents sont fréquemment **sous droit d'auteur d'un tiers** — un professeur, une
université, un éditeur. En mode « sujet libre », le dispositif y ajoute lui-même des
copies locales de sources trouvées en ligne.

Le dispositif les lit localement et ne les redistribue jamais. Le `.gitignore` posé
par `agent-teach init` exclut `cours/` par défaut, **et il ne faut pas le retirer**.
Publier un dépôt contenant le polycopié de son professeur est un problème juridique
réel pour l'apprenant.
