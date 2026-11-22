# Collage-2.0 · Tournez l'affichage

Application de gestion des panneaux d'affichage libre : collages, nombre d'affiches, constats (conforme, à contrôler, décollé, recouvert par un parti), historique signé par prénom, tableau de bord et tournée avec lien Google Maps. Deux campagnes : Nouvelle Energie et #RemueMéninges.

Toute modification est enregistrée en ligne et apparaît en direct sur tous les appareils de l'équipe. L'accès est protégé par un code d'équipe commun, sans comptes individuels. Sans réseau, les modifications sont gardées sur l'appareil et partent dès le retour de la connexion.

## Mise en route (une seule fois)

1. **Projet.** Sur supabase.com, crée un compte gratuit puis un projet (région en Europe).
2. **Inscriptions.** Authentication > Sign In / Providers : dans Email, désactive « Allow new users to sign up » et « Confirm email ». Laisse « Allow anonymous sign-ins » désactivé.
3. **Compte de l'équipe.** Authentication > Users > Add user > Create new user. Saisis exactement l'adresse `equipe@exemple.fr` (fictive, elle ne reçoit rien ; si tu en choisis une autre, change-la aussi dans `config.js` et dans `supabase/schema.sql`) et, comme mot de passe, le **code d'équipe** que vous choisissez (8 caractères ou plus). Coche « Auto Confirm User ».
4. **Base.** SQL Editor > New query : colle le contenu de `supabase/schema.sql`, puis Run.
5. **Relier le site.** Project Settings > API : recopie « Project URL » et la clé « anon public » dans `config.js`, avec l'adresse e-mail du compte équipe dans `TEAM_EMAIL`.
6. **Publier.** Settings > Pages du dépôt : branche `main`, dossier `/`.

Chaque personne ouvre le site, saisit le code d'équipe une fois sur son appareil, puis indique son prénom. Le prénom signe ses saisies dans l'historique.

## Installer comme une application

- iPhone (Safari) : Partager, puis « Sur l'écran d'accueil ».
- Android (Chrome) : menu, puis « Installer l'application ».
- Ordinateur (Chrome ou Edge) : icône d'installation dans la barre d'adresse.

## Sécurité

- Sans le code d'équipe, personne ne lit ni n'écrit les données.
- L'historique ne peut ni être modifié ni effacé.
- La clé `anon` de `config.js` est publique par conception. Ne mets jamais la clé `service_role` dans ce dépôt.
- Pour changer le code : Authentication > Users, modifie le mot de passe du compte équipe. Les appareils déjà connectés le restent jusqu'à leur déconnexion.
