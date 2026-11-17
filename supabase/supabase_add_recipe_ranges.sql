-- Optional upper ends for prep time, bake time and servings, so a recipe
-- can show a range like "Bake 20-25 min" or "Serves 16-18". Null means a
-- single value, so existing recipes are unchanged. Safe to re-run.
alter table public.recipes_sweettreats
  add column if not exists prep_minutes_max integer check (prep_minutes_max >= 0),
  add column if not exists bake_minutes_max integer check (bake_minutes_max >= 0),
  add column if not exists servings_max integer check (servings_max > 0);
