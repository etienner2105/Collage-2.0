-- Tournez l'affichage : base de données.
-- À coller en entier dans Supabase > SQL Editor > Run.

-- Membres autorisés (trois au maximum).
create table if not exists membres (
  id  uuid primary key references auth.users(id) on delete cascade,
  nom text not null
);

create or replace function est_membre() returns boolean
language sql security definer stable set search_path = public
as $$ select exists (select 1 from membres where id = auth.uid()) $$;

create or replace function max_trois() returns trigger
language plpgsql as $$
begin
  if (select count(*) from membres) >= 3 then
    raise exception 'Trois membres maximum';
  end if;
  return new;
end $$;

drop trigger if exists membres_max on membres;
create trigger membres_max before insert on membres
for each row execute function max_trois();

-- Données de l'application.
create table if not exists panneaux      (id text primary key, data jsonb not null);
create table if not exists interventions (id text primary key, data jsonb not null, created_at timestamptz not null default now());
create table if not exists reglages      (id text primary key, data jsonb not null);

alter table membres       enable row level security;
alter table panneaux      enable row level security;
alter table interventions enable row level security;
alter table reglages      enable row level security;

-- Les membres lisent la liste des membres. Personne ne la modifie depuis le site.
drop policy if exists "lire membres" on membres;
create policy "lire membres" on membres for select to authenticated using (est_membre());

-- Panneaux et réglages : les membres lisent, ajoutent, modifient, suppriment.
drop policy if exists "membres panneaux" on panneaux;
create policy "membres panneaux" on panneaux for all to authenticated
  using (est_membre()) with check (est_membre());
drop policy if exists "membres reglages" on reglages;
create policy "membres reglages" on reglages for all to authenticated
  using (est_membre()) with check (est_membre());

-- Historique : lecture et ajout seulement. Personne ne peut modifier ni effacer une ligne,
-- et chaque ligne doit porter l'identifiant de la personne connectée.
drop policy if exists "lire historique" on interventions;
create policy "lire historique" on interventions for select to authenticated using (est_membre());
drop policy if exists "ajouter historique" on interventions;
create policy "ajouter historique" on interventions for insert to authenticated
  with check (est_membre() and data->>'auteurId' = auth.uid()::text);

-- Synchronisation en temps réel entre les trois membres.
alter publication supabase_realtime add table panneaux, interventions, reglages;

-- ÉTAPE FINALE, après avoir créé les trois utilisateurs (voir le README) :
-- remplace les adresses et les prénoms, puis exécute ces trois lignes.
-- insert into membres (id, nom) select id, 'Prénom 1' from auth.users where email = 'adresse1@exemple.fr';
-- insert into membres (id, nom) select id, 'Prénom 2' from auth.users where email = 'adresse2@exemple.fr';
-- insert into membres (id, nom) select id, 'Prénom 3' from auth.users where email = 'adresse3@exemple.fr';
