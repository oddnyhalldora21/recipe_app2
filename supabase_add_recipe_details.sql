-- Adds the extra Add/Edit Recipe form fields to recipes_sweettreats.
-- Run once in the Supabase SQL editor BEFORE installing the app build that
-- reads these columns (otherwise every recipe query fails).
--
-- All columns allow null: recipes created before this change have none of
-- these values, and the form only requires them for new recipes.
-- Prep/bake times are whole minutes so a total time can be calculated later.

alter table public.recipes_sweettreats
  add column description  text,
  add column oven_temp    text,
  add column prep_minutes integer check (prep_minutes >= 0),
  add column bake_minutes integer check (bake_minutes >= 0),
  add column servings     integer check (servings > 0),
  add column difficulty   text check (difficulty in ('easy', 'medium', 'hard')),
  add column tags         text[] not null default '{}',
  add column is_no_bake   boolean not null default false;
