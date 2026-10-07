-- Adds the optional "Recipe notes" field (tips, substitutions, storage...)
-- to recipes_sweettreats.
-- Run once in the Supabase SQL editor BEFORE installing the app build that
-- reads this column (otherwise every recipe query fails).
--
-- Nullable: existing recipes have no notes, and the app stores empty notes
-- as null.

alter table public.recipes_sweettreats
  add column notes text;
