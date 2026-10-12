-- Lets users rename their own collections ("Edit name" on a collection).
-- Run in the Supabase SQL editor BEFORE testing "Edit name".
--
-- Without an UPDATE policy, row-level security makes the rename silently
-- match no rows, and the app shows "Could not rename this collection".
-- Adds an owner-only UPDATE policy, only if the table has no UPDATE (or ALL)
-- policy yet, so an existing one is left exactly as it is. Safe to re-run.

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'collections_sweettreats'
      and cmd in ('UPDATE', 'ALL')
  ) then
    create policy "Users can rename their own collections"
      on public.collections_sweettreats
      for update
      to authenticated
      using (auth.uid() = user_id)
      with check (auth.uid() = user_id);
  end if;
end $$;

-- Check: should show one UPDATE (or ALL) policy on collections_sweettreats.
select tablename, policyname, cmd
  from pg_policies
 where schemaname = 'public'
   and tablename = 'collections_sweettreats'
 order by cmd;
