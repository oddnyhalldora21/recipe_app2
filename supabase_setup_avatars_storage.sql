-- Storage setup for user-uploaded profile avatars (Profile page's avatar
-- picker). Run this in the Supabase SQL editor (Dashboard > SQL Editor) —
-- there's no local Supabase CLI/migrations setup for this project, so
-- schema and storage changes are applied by hand, same as
-- supabase_setup_recipe_images_storage.sql.

-- 1. Create the bucket as public (avatars are shown on public profiles to
--    every viewer, logged in or not) — safe to re-run.
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- 2. Anyone can read/view avatars.
drop policy if exists "Public read access for avatars" on storage.objects;
create policy "Public read access for avatars"
on storage.objects for select
using (bucket_id = 'avatars');

-- 3. Signed-in users can only upload into their own folder:
--    avatars/{auth.uid()}/<file>.
drop policy if exists "Users can upload their own avatar" on storage.objects;
create policy "Users can upload their own avatar"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);

-- Intentionally no update/delete policy yet — each upload gets a unique
-- filename (never overwritten), matching recipe images' current setup.
