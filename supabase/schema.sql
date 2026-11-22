-- Tournez l'affichage : base de données partagée par l'équipe.
-- À coller en entier dans Supabase > SQL Editor > Run. Peut être relancé sans risque.

create table if not exists panneaux      (id text primary key, data jsonb not null);
create table if not exists interventions (id text primary key, data jsonb not null, created_at timestamptz not null default now());
create table if not exists reglages      (id text primary key, data jsonb not null);

alter table panneaux      enable row level security;
alter table interventions enable row level security;
alter table reglages      enable row level security;

-- Seul le compte « équipe » (equipe@exemple.fr, dont le mot de passe est le code d'équipe) accède aux données.
-- Même si quelqu'un parvenait à créer un autre compte, il ne verrait rien.
drop policy if exists "equipe panneaux" on panneaux;
create policy "equipe panneaux" on panneaux for all to authenticated using ((auth.jwt() ->> 'email') = 'equipe@exemple.fr') with check ((auth.jwt() ->> 'email') = 'equipe@exemple.fr');

drop policy if exists "equipe reglages" on reglages;
create policy "equipe reglages" on reglages for all to authenticated using ((auth.jwt() ->> 'email') = 'equipe@exemple.fr') with check ((auth.jwt() ->> 'email') = 'equipe@exemple.fr');

-- Historique : lecture et ajout seulement. Aucune ligne ne peut être modifiée ni effacée.
drop policy if exists "lire historique" on interventions;
create policy "lire historique" on interventions for select to authenticated using ((auth.jwt() ->> 'email') = 'equipe@exemple.fr');
drop policy if exists "ajouter historique" on interventions;
create policy "ajouter historique" on interventions for insert to authenticated with check ((auth.jwt() ->> 'email') = 'equipe@exemple.fr');

-- Synchronisation en direct entre les appareils.
do $$
declare t text;
begin
  foreach t in array array['panneaux','interventions','reglages'] loop
    if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
