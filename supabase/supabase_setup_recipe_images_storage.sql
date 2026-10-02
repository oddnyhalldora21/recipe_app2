-- Storage setup for user-uploaded recipe photos (Add Recipe's photo picker).
-- Run this in the Supabase SQL editor (Dashboard > SQL Editor) — there's no
-- local Supabase CLI/migrations setup for this project, so schema and
-- storage changes are applied by hand, same as
-- supabase_migration_recipes.sql and supabase_update_recipe_images.sql.
--
-- Confirmed via the project's anon key before writing this file: no bucket
-- named 'recipe-images' exists yet (GET /storage/v1/bucket/recipe-images
-- returned 404 NoSuchBucket), and the anon key cannot create one itself
-- (POST /storage/v1/bucket returned 403 "new row violates row-level
-- security policy") — bucket creation needs to run with elevated
-- privileges, which the SQL editor has and the app's anon key deliberately
-- does not.

-- 1. Create the bucket as public (recipe photos are shown to every viewer
--    of a public recipe, logged in or not) — safe to re-run.
insert into storage.buckets (id, name, public)
values ('recipe-images', 'recipe-images', true)
on conflict (id) do nothing;

-- 2. Anyone can read/view recipe images (matches recipes_sweettreats itself
--    being publicly readable for public recipes).
drop policy if exists "Public read access for recipe images" on storage.objects;
create policy "Public read access for recipe images"
on storage.objects for select
using (bucket_id = 'recipe-images');

-- 3. Signed-in users can only upload into their own folder:
--    recipe-images/{auth.uid()}/<file>. storage.foldername(name) splits the
--    object path on '/' and returns it as an array, so index [1] is the
--    first path segment (the folder).
drop policy if exists "Users can upload their own recipe images" on storage.objects;
create policy "Users can upload their own recipe images"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'recipe-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);

-- Intentionally no update/delete policy yet — Add Recipe only ever inserts
-- a new file per photo (unique per-upload filename, never overwritten).
-- The upcoming Edit Recipe feature will likely want to replace/delete a
-- recipe's photo, which will need its own update/delete policies added
-- here at that point.
