-- Lets users delete their own collections without losing any saves.
-- Run in the Supabase SQL editor BEFORE testing "Delete collection".
--
-- How collections work: there is no separate link table. Each saved recipe
-- is one row in saved_recipes_sweettreats with a nullable collection_id
-- pointing at collections_sweettreats. So a recipe is in at most one
-- collection, and "removing it from a collection" means setting
-- collection_id back to null (it stays saved under All Saved).
--
-- Neither table is defined in any SQL file in this repo (they were made in
-- the dashboard), so this script doesn't assume anything about them. It:
--   1. ensures the collections table has a DELETE policy for the owner, and
--   2. makes deleting a collection set collection_id to null on its saved
--      rows (ON DELETE SET NULL) — never delete them, which CASCADE would.
-- Both steps are safe to re-run.

-- ============================================================
-- OPTIONAL — read-only: what's there today. Run on its own first if you
-- want to see the current policies and foreign key before changing them.
-- ============================================================
-- select tablename, policyname, cmd, qual, with_check
--   from pg_policies
--  where schemaname = 'public'
--    and tablename in ('collections_sweettreats', 'saved_recipes_sweettreats')
--  order by tablename, cmd;
--
-- select conname, pg_get_constraintdef(oid) as definition
--   from pg_constraint
--  where conrelid = 'public.saved_recipes_sweettreats'::regclass
--    and contype = 'f';

begin;

-- ---- 1. DELETE policy on collections (owner only) --------------------
-- Added only if the table has no DELETE policy at all, so an existing one
-- is left exactly as it is.
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'collections_sweettreats'
      and cmd in ('DELETE', 'ALL')
  ) then
    create policy "Users can delete their own collections"
      on public.collections_sweettreats
      for delete
      to authenticated
      using (auth.uid() = user_id);
  end if;
end $$;

-- ---- 2. Deleting a collection un-files its recipes, never unsaves them --
-- Drops whatever foreign key saved_recipes_sweettreats.collection_id has
-- today (it may be CASCADE, RESTRICT, or missing) and recreates it as
-- ON DELETE SET NULL. Rows pointing at a collection that no longer exists
-- are un-filed first, so the new constraint can be added.
do $$
declare
  fk record;
begin
  for fk in
    select c.conname
      from pg_constraint c
      join pg_attribute a
        on a.attrelid = c.conrelid and a.attnum = any (c.conkey)
     where c.conrelid = 'public.saved_recipes_sweettreats'::regclass
       and c.contype = 'f'
       and a.attname = 'collection_id'
  loop
    execute format(
      'alter table public.saved_recipes_sweettreats drop constraint %I',
      fk.conname
    );
  end loop;
end $$;

update public.saved_recipes_sweettreats s
   set collection_id = null
 where collection_id is not null
   and not exists (
     select 1 from public.collections_sweettreats c where c.id = s.collection_id
   );

alter table public.saved_recipes_sweettreats
  add constraint saved_recipes_sweettreats_collection_id_fkey
  foreign key (collection_id)
  references public.collections_sweettreats (id)
  on delete set null;

commit;

-- Check: should show one DELETE (or ALL) policy on collections_sweettreats,
-- and the collection_id foreign key ending in "ON DELETE SET NULL".
select tablename, policyname, cmd
  from pg_policies
 where schemaname = 'public'
   and tablename = 'collections_sweettreats'
 order by cmd;

select conname, pg_get_constraintdef(oid) as definition
  from pg_constraint
 where conrelid = 'public.saved_recipes_sweettreats'::regclass
   and contype = 'f';
