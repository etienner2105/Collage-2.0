# Collage-2.0 · Tournez l'affichage

Application de gestion des panneaux d'affichage libre : collages, nombre d'affiches, constats (conforme, à contrôler, décollé, recouvert par un parti), historique signé par personne, tableau de bord et tournée avec lien Google Maps. Deux campagnes : Nouvelle Energie et #RemueMéninges.

Le site est un fichier unique (`index.html`). Les données et les comptes passent par Supabase (gratuit).

## Mise en route

1. **Créer le projet.** Sur supabase.com, crée un compte gratuit puis un projet (choisis une région en Europe).
2. **Interdire les inscriptions.** Authentication > Sign In / Providers > Email : désactive « Allow new users to sign up » (et « Confirm email » si tu veux créer les comptes sans courriel de validation).
3. **Créer les trois comptes.** Authentication > Users > Add user > Create new user : adresse e-mail et mot de passe de chacun, avec « Auto Confirm User » coché. L'adresse e-mail sert d'identifiant.
4. **Créer la base.** SQL Editor > New query : colle le contenu de `supabase/schema.sql`, remplace les trois lignes `insert into membres` en bas par les vraies adresses et les prénoms, puis Run.
5. **Relier le site.** Project Settings > API : copie « Project URL » et la clé « anon public » dans `config.js`.
6. **Publier.** Settings > Pages du dépôt GitHub : branche `main`, dossier racine. Le site est en ligne à l'adresse affichée.

## Sécurité

- Seuls les trois membres listés dans la table `membres` lisent ou écrivent. Un quatrième ajout est refusé par la base.
- L'historique ne peut ni être modifié ni effacé, et chaque ligne porte l'identifiant de son auteur.
- La clé `anon` visible dans `config.js` est publique par conception. Ne mets jamais la clé `service_role` dans ce dépôt.
