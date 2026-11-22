-- Tournez l'affichage : base de données partagée par l'équipe.
-- À coller en entier dans Supabase > SQL Editor > Run.

create table if not exists panneaux      (id text primary key, data jsonb not null);
create table if not exists interventions (id text primary key, data jsonb not null, created_at timestamptz not null default now());
create table if not exists reglages      (id text primary key, data jsonb not null);

alter table panneaux      enable row level security;
alter table interventions enable row level security;
alter table reglages      enable row level security;

-- Un seul utilisateur existe (le compte « équipe », dont le mot de passe est le code d'équipe).
-- Seul cet utilisateur connecté accède aux données.
drop policy if exists "equipe panneaux" on panneaux;
create policy "equipe panneaux" on panneaux for all to authenticated using (true) with check (true);

drop policy if exists "equipe reglages" on reglages;
create policy "equipe reglages" on reglages for all to authenticated using (true) with check (true);

-- Historique : lecture et ajout seulement. Aucune ligne ne peut être modifiée ni effacée.
drop policy if exists "lire historique" on interventions;
create policy "lire historique" on interventions for select to authenticated using (true);
drop policy if exists "ajouter historique" on interventions;
create policy "ajouter historique" on interventions for insert to authenticated with check (true);

-- Synchronisation en direct entre les appareils.
alter publication supabase_realtime add table panneaux, interventions, reglages;
