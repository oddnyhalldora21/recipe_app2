-- Catalog clean-up + recipe-detail backfill for the public recipes.
-- Review before running in the Supabase SQL editor.
--
-- STEP 1 (separate, read-only): reference check for the recipe being deleted.
-- STEP 2 (one transaction, all-or-nothing):
--   * delete "Ice Cream Sandwiches" (+ its favorites/saves)
--   * rename 2 recipes
--   * 179 backfill updates that only touch: description, oven_temp,
--     bake_minutes, prep_minutes, servings, difficulty, tags, is_no_bake.
--     Each matches one row by id; the `difficulty is null and description
--     is null` guard skips anything already filled in through the app.

-- ============================================================
-- STEP 1 — run this SELECT on its own first (read-only).
-- Counts every row that points at the recipe about to be deleted.
-- The app's public key can't see other users' favorites/saves, so this
-- has to run in the SQL editor to get the real answer.
-- ============================================================
select 'favorites_sweettreats' as table_name, count(*) as rows_referencing
  from public.favorites_sweettreats where recipe_id = '8f24daa4-7c82-44d6-890c-3b45371240e2'
union all
select 'saved_recipes_sweettreats (incl. collections)', count(*)
  from public.saved_recipes_sweettreats where recipe_id = '8f24daa4-7c82-44d6-890c-3b45371240e2';

-- ============================================================
-- STEP 2 — run everything below together.
-- ============================================================
begin;

-- ---- Delete "Ice Cream Sandwiches" ---------------------------------
-- Removes its favorites and saves first (they'd otherwise point at a
-- recipe that no longer exists), then the recipe row itself. The name
-- check means nothing is deleted if the id ever matched something else.
delete from public.favorites_sweettreats where recipe_id = '8f24daa4-7c82-44d6-890c-3b45371240e2';
delete from public.saved_recipes_sweettreats where recipe_id = '8f24daa4-7c82-44d6-890c-3b45371240e2';
delete from public.recipes_sweettreats
where id = '8f24daa4-7c82-44d6-890c-3b45371240e2' and name = 'Ice Cream Sandwiches';

-- ---- Rename recipes whose names didn't match their ingredients ----
update public.recipes_sweettreats set name = 'Vegan Dark Chocolate Mousse'
where id = '9aaa9b20-8333-4f53-b1ed-ac9ff85f4443' and name = 'White Chocolate Mousse';
update public.recipes_sweettreats set name = 'Sugar-Free Avocado Cocoa Mousse'
where id = '686d42f8-db78-4c6a-af2e-72b7b205e64a' and name = 'Cinnamon Mousse';

-- ---- Backfill ----

-- Chocolate Croissants :) (puff-pastry)
update public.recipes_sweettreats set
  description = 'Flaky puff pastry rolled around dark chocolate and baked until golden, an easy shortcut to bakery-style croissants.',
  oven_temp = '190°C', bake_minutes = 20, prep_minutes = 15, servings = 8,
  difficulty = 'easy', tags = array['breakfast','dark chocolate','quick']::text[], is_no_bake = false
where id = '412bca09-64e4-4018-8de2-b2562a2f8ace'
  and difficulty is null and description is null;

-- Decadent Chocolate Cake (chocolate)
update public.recipes_sweettreats set
  description = 'A moist two-layer cocoa cake made with buttermilk and hot coffee for deep chocolate flavour.',
  oven_temp = '180°C', bake_minutes = 35, prep_minutes = 20, servings = 12,
  difficulty = 'medium', tags = array['layer cake','celebration','coffee']::text[], is_no_bake = false
where id = '8704b652-932d-48e8-bcd0-bb2e6013ec4f'
  and difficulty is null and description is null;

-- Chocolate Cake Pops (chocolate)
update public.recipes_sweettreats set
  description = 'Bite-sized chocolate cake balls on sticks, dipped in a glossy chocolate shell and finished with sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 60, servings = 48,
  difficulty = 'medium', tags = array['party','kid-friendly','sprinkles']::text[], is_no_bake = false
where id = 'a3973ac5-a52b-476c-b10e-536736048b09'
  and difficulty is null and description is null;

-- Silky Chocolate Mousse (chocolate)
update public.recipes_sweettreats set
  description = 'Airy dark chocolate mousse lightened with whipped cream and egg whites, rich but light.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 6,
  difficulty = 'medium', tags = array['make-ahead','dinner party','dark chocolate']::text[], is_no_bake = true
where id = 'eaa01789-42f1-430c-995f-a4f2ee380bb7'
  and difficulty is null and description is null;

-- Chocolate Lava Cakes (chocolate)
update public.recipes_sweettreats set
  description = 'Individual chocolate cakes with a molten, gooey centre, best served warm with ice cream.',
  oven_temp = '220°C', bake_minutes = 14, prep_minutes = 15, servings = 4,
  difficulty = 'medium', tags = array['molten','date night','dinner party']::text[], is_no_bake = false
where id = '759fbdc9-1037-417f-89ea-feed1a47b980'
  and difficulty is null and description is null;

-- Chocolate Truffles (chocolate)
update public.recipes_sweettreats set
  description = 'Silky dark chocolate ganache truffles rolled in cocoa, chopped nuts or coconut.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 30,
  difficulty = 'easy', tags = array['ganache','gift','make-ahead']::text[], is_no_bake = true
where id = '6760bc51-7b52-4bf8-b8b3-de8f1079e479'
  and difficulty is null and description is null;

-- Chocolate Chip Cookies (chocolate)
update public.recipes_sweettreats set
  description = 'Classic golden chocolate chip cookies with crisp edges and soft, gooey middles.',
  oven_temp = '190°C', bake_minutes = 11, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['classic','chocolate chip','kid-friendly']::text[], is_no_bake = false
where id = '74d4dff2-0f0b-45b1-9f73-f48046630466'
  and difficulty is null and description is null;

-- Chocolate Fudge (chocolate)
update public.recipes_sweettreats set
  description = 'Rich, smooth dark chocolate fudge made with condensed milk, with optional walnuts.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['fudge','gift','walnuts']::text[], is_no_bake = true
where id = '787759dd-a031-4573-974d-508343a829fe'
  and difficulty is null and description is null;

-- Chocolate Cupcakes (chocolate)
update public.recipes_sweettreats set
  description = 'Moist, fluffy chocolate cupcakes ready for a swirl of chocolate buttercream.',
  oven_temp = '180°C', bake_minutes = 20, prep_minutes = 20, servings = 12,
  difficulty = 'easy', tags = array['cupcakes','party','buttercream']::text[], is_no_bake = false
where id = '0a00eef7-b422-4b5b-8830-29b05d363ae6'
  and difficulty is null and description is null;

-- Chocolate Bark (chocolate)
update public.recipes_sweettreats set
  description = 'Dark chocolate bark scattered with cranberries, almonds, pistachios and flaky sea salt.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['gift','nuts','sea salt']::text[], is_no_bake = true
where id = '6447bcfe-5c1c-49e4-9e28-888c5fa4d9df'
  and difficulty is null and description is null;

-- Vegan Chocolate Chip Cookies (vegan)
update public.recipes_sweettreats set
  description = 'Chewy, golden-edged chocolate chip cookies made entirely without dairy or eggs.',
  oven_temp = '190°C', bake_minutes = 11, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['dairy-free','chocolate chip','classic']::text[], is_no_bake = false
where id = '2eac8e01-c222-45a0-84ab-db59fe619306'
  and difficulty is null and description is null;

-- Vegan Brownies (vegan)
update public.recipes_sweettreats set
  description = 'Fudgy cocoa brownies made with coconut oil, no eggs or dairy needed.',
  oven_temp = '180°C', bake_minutes = 30, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['brownies','dairy-free','egg-free']::text[], is_no_bake = false
where id = '3c483c08-250b-45b5-ba3f-bb8573c9e687'
  and difficulty is null and description is null;

-- Vegan Banana Bread (vegan)
update public.recipes_sweettreats set
  description = 'Moist, cinnamon-spiced banana loaf made without eggs or dairy.',
  oven_temp = '180°C', bake_minutes = 65, prep_minutes = 15, servings = 10,
  difficulty = 'easy', tags = array['banana','breakfast','loaf']::text[], is_no_bake = false
where id = '5be4c0ec-77a8-482d-a3d6-62fd6fdd7140'
  and difficulty is null and description is null;

-- Vegan Chocolate Cake (vegan)
update public.recipes_sweettreats set
  description = 'A simple, fluffy egg-free chocolate cake topped with vegan chocolate frosting.',
  oven_temp = '180°C', bake_minutes = 35, prep_minutes = 15, servings = 10,
  difficulty = 'easy', tags = array['dairy-free','egg-free','celebration']::text[], is_no_bake = false
where id = '23624f97-2d9c-455b-ba3d-c5dc48cfa52d'
  and difficulty is null and description is null;

-- Vegan Coconut Macaroons (vegan)
update public.recipes_sweettreats set
  description = 'Chewy coconut macaroons sweetened with maple syrup, optionally dipped in dark chocolate.',
  oven_temp = '160°C', bake_minutes = 22, prep_minutes = 20, servings = 16,
  difficulty = 'easy', tags = array['coconut','maple','dairy-free']::text[], is_no_bake = false
where id = '294d15eb-3667-4897-b701-19935c4464ac'
  and difficulty is null and description is null;

-- Vegan Lemon Bars (vegan)
update public.recipes_sweettreats set
  description = 'A buttery shortbread base topped with a tangy coconut-lemon filling.',
  oven_temp = '160°C', bake_minutes = 50, prep_minutes = 20, servings = 16,
  difficulty = 'medium', tags = array['lemon','shortbread','dairy-free']::text[], is_no_bake = false
where id = 'b6615d15-7521-4de6-bd10-131dd3f1a010'
  and difficulty is null and description is null;

-- Gluten-Free Brownies (gluten-free)
update public.recipes_sweettreats set
  description = 'Fudgy almond-flour brownies sweetened with coconut sugar and studded with dark chocolate.',
  oven_temp = '180°C', bake_minutes = 30, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['brownies','almond flour','coconut sugar']::text[], is_no_bake = false
where id = 'dc17f7d8-5a52-405e-b988-18e1dc951493'
  and difficulty is null and description is null;

-- Vegan Oatmeal Cookies (vegan)
update public.recipes_sweettreats set
  description = 'Chewy, cinnamon-spiced oat cookies with raisins or chocolate chips.',
  oven_temp = '180°C', bake_minutes = 15, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['oats','cinnamon','dairy-free']::text[], is_no_bake = false
where id = 'da0b5de4-1ddd-46b7-b91c-7ebb3c93ae9a'
  and difficulty is null and description is null;

-- White Chocolate Mousse (vegan)
update public.recipes_sweettreats set
  description = 'Silky blended tofu mousse with melted vegan chocolate, finished with fresh berries and mint.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 4,
  difficulty = 'easy', tags = array['tofu','dairy-free','make-ahead']::text[], is_no_bake = true
where id = '9aaa9b20-8333-4f53-b1ed-ac9ff85f4443'
  and difficulty is null and description is null;

-- Vegan Energy Balls (vegan)
update public.recipes_sweettreats set
  description = 'Date, almond and cocoa energy balls with chia seeds, a quick naturally sweet snack.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 16,
  difficulty = 'easy', tags = array['energy bites','dates','snack']::text[], is_no_bake = true
where id = '12402331-e00b-435f-8562-179a80f9a7d6'
  and difficulty is null and description is null;

-- Vegan Apple Crisp (vegan)
update public.recipes_sweettreats set
  description = 'Cinnamon-spiced baked apples under a crunchy oat crumble, made with vegan butter.',
  oven_temp = '190°C', bake_minutes = 40, prep_minutes = 20, servings = 8,
  difficulty = 'easy', tags = array['apples','cinnamon','dairy-free']::text[], is_no_bake = false
where id = '9f307b3e-567b-452c-8539-da2c5777b537'
  and difficulty is null and description is null;

-- Classic Sugar Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Soft, buttery sugar cookies rolled in coloured sugar for a sparkly crunch.',
  oven_temp = '190°C', bake_minutes = 10, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['kid-friendly','buttery','classic']::text[], is_no_bake = false
where id = '59597b0c-b2df-4cc5-90db-1649ac2e53a2'
  and difficulty is null and description is null;

-- Double Chocolate Chip Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Rich cocoa cookies loaded with white chocolate chips, set at the edges and soft in the middle.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['cocoa','white chocolate','chewy']::text[], is_no_bake = false
where id = '7155a86c-5aa8-4015-9805-775ad9b1ca17'
  and difficulty is null and description is null;

-- Snickerdoodles (cookies)
update public.recipes_sweettreats set
  description = 'Soft, pillowy cookies with a tangy bite from cream of tartar, rolled in cinnamon sugar.',
  oven_temp = '200°C', bake_minutes = 10, prep_minutes = 20, servings = 36,
  difficulty = 'easy', tags = array['cinnamon sugar','classic','soft']::text[], is_no_bake = false
where id = '44f20f59-1af5-4a1d-991c-b303577b846a'
  and difficulty is null and description is null;

-- Chia Seed Pudding (gluten-free)
update public.recipes_sweettreats set
  description = 'Creamy coconut-milk chia pudding sweetened with maple syrup and topped with berries and nuts.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['breakfast','coconut','make-ahead']::text[], is_no_bake = true
where id = '20b16b35-ae9d-4503-bffa-913facff7fa1'
  and difficulty is null and description is null;

-- Oatmeal Raisin Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Chewy, cinnamon-spiced oat cookies packed with plump raisins.',
  oven_temp = '180°C', bake_minutes = 15, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['oats','raisins','cinnamon']::text[], is_no_bake = false
where id = '03a43c93-32f1-4313-baf5-c128b24f4bb2'
  and difficulty is null and description is null;

-- Peanut Butter Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Soft peanut butter cookies with the classic fork-pressed crisscross pattern.',
  oven_temp = '190°C', bake_minutes = 12, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['peanut butter','classic','kid-friendly']::text[], is_no_bake = false
where id = 'fa98f7d6-bff6-4752-8bea-a7e55a2935d5'
  and difficulty is null and description is null;

-- Gingerbread Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Warmly spiced molasses cookies cut into shapes and decorated with royal icing.',
  oven_temp = '180°C', bake_minutes = 10, prep_minutes = 30, servings = 24,
  difficulty = 'medium', tags = array['christmas','spiced','decorating']::text[], is_no_bake = false
where id = '3a2bf97a-09a0-4d5f-bb39-367036eaef49'
  and difficulty is null and description is null;

-- Shortbread Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Melt-in-the-mouth butter shortbread baked in a round and cut into wedges.',
  oven_temp = '160°C', bake_minutes = 30, prep_minutes = 10, servings = 16,
  difficulty = 'easy', tags = array['buttery','classic','shortbread']::text[], is_no_bake = false
where id = 'b7175955-88df-4c78-a90a-c8bc8e767bb8'
  and difficulty is null and description is null;

-- Lemon Crinkle Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Bright, zesty lemon cookies rolled in powdered sugar so they crackle as they bake.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 20, servings = 30,
  difficulty = 'easy', tags = array['lemon','citrus','crinkle']::text[], is_no_bake = false
where id = '587fabcf-f2d5-4e4e-964d-fe1926b1f709'
  and difficulty is null and description is null;

-- Thumbprint Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Buttery walnut-coated cookies with a jewel of jam pressed into the centre.',
  oven_temp = '180°C', bake_minutes = 18, prep_minutes = 30, servings = 30,
  difficulty = 'medium', tags = array['jam','walnuts','holiday']::text[], is_no_bake = false
where id = 'a48f1938-7f2a-4bcb-84bb-e85be2663c81'
  and difficulty is null and description is null;

-- Chocolate Crinkle Cookies (cookies)
update public.recipes_sweettreats set
  description = 'Fudgy chocolate cookies rolled in powdered sugar for a crackled, snowy finish.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 20, servings = 30,
  difficulty = 'easy', tags = array['cocoa','crinkle','holiday']::text[], is_no_bake = false
where id = 'ad6a3f40-c47c-40bd-8856-aca32c4e7012'
  and difficulty is null and description is null;

-- Sugar-Free Chocolate Chip Cookies (sugar-free)
update public.recipes_sweettreats set
  description = 'Almond-flour chocolate chip cookies sweetened with erythritol instead of sugar.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['almond flour','low carb','chocolate chip']::text[], is_no_bake = false
where id = '3b292108-1402-4461-abda-fadc33a36322'
  and difficulty is null and description is null;

-- Sugar-Free Brownies (sugar-free)
update public.recipes_sweettreats set
  description = 'Fudgy almond-flour brownies sweetened with erythritol, with optional walnuts.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['brownies','almond flour','low carb']::text[], is_no_bake = false
where id = '09e770d1-ae96-46fe-9eda-3ee6b91be53f'
  and difficulty is null and description is null;

-- Sugar-Free Banana Muffins (sugar-free)
update public.recipes_sweettreats set
  description = 'Moist banana muffins made with almond flour and cinnamon, with no added sugar.',
  oven_temp = '180°C', bake_minutes = 22, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['banana','muffins','almond flour']::text[], is_no_bake = false
where id = '6fce1f1c-bc10-4d59-8a3b-519c80f1d69e'
  and difficulty is null and description is null;

-- Cinnamon Mousse (sugar-free)
update public.recipes_sweettreats set
  description = 'Silky avocado and cocoa mousse sweetened with erythritol and topped with fresh berries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['avocado','cocoa','make-ahead']::text[], is_no_bake = true
where id = '686d42f8-db78-4c6a-af2e-72b7b205e64a'
  and difficulty is null and description is null;

-- Sugar-Free Lemon Bars (sugar-free)
update public.recipes_sweettreats set
  description = 'Tangy lemon bars on an almond-flour crust, sweetened with erythritol.',
  oven_temp = '160°C', bake_minutes = 40, prep_minutes = 15, servings = 16,
  difficulty = 'medium', tags = array['lemon','almond flour','low carb']::text[], is_no_bake = false
where id = '73ac4f67-5137-40e0-a880-428f437ece37'
  and difficulty is null and description is null;

-- Sugar-Free Peanut Butter Cookies (sugar-free)
update public.recipes_sweettreats set
  description = 'Five-ingredient flourless peanut butter cookies with a fork-pressed crisscross top.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 10, servings = 24,
  difficulty = 'easy', tags = array['peanut butter','flourless','low carb']::text[], is_no_bake = false
where id = '4b4b562d-35b1-44c7-91a6-ba4ced3670e7'
  and difficulty is null and description is null;

-- Sugar-Free Chia Pudding (sugar-free)
update public.recipes_sweettreats set
  description = 'Overnight chia pudding made with almond milk and sugar-free maple syrup, topped with berries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['breakfast','almond milk','make-ahead']::text[], is_no_bake = true
where id = '03ecc3f3-3033-4be0-87f3-e89a369cab8a'
  and difficulty is null and description is null;

-- Sugar-Free Apple Crisp (sugar-free)
update public.recipes_sweettreats set
  description = 'Cinnamon-baked apples under a crunchy almond crumble, sweetened without sugar.',
  oven_temp = '190°C', bake_minutes = 35, prep_minutes = 20, servings = 8,
  difficulty = 'easy', tags = array['apples','almond flour','cinnamon']::text[], is_no_bake = false
where id = '62bd9e18-a4da-481d-a050-be0f41517bec'
  and difficulty is null and description is null;

-- Oat Flour Banana Muffins (gluten-free)
update public.recipes_sweettreats set
  description = 'Honey-sweetened banana muffins made with oat flour, with optional chocolate chips.',
  oven_temp = '180°C', bake_minutes = 22, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['banana','muffins','oat flour']::text[], is_no_bake = false
where id = 'f701bcd4-64b2-481a-84a9-2aa153731015'
  and difficulty is null and description is null;

-- Sugar-Free Chocolate Cake (sugar-free)
update public.recipes_sweettreats set
  description = 'A moist almond-flour chocolate cake sweetened with erythritol and applesauce.',
  oven_temp = '180°C', bake_minutes = 35, prep_minutes = 15, servings = 10,
  difficulty = 'easy', tags = array['almond flour','low carb','cocoa']::text[], is_no_bake = false
where id = '144102c4-fc8d-48a6-979a-4b6dad249a1b'
  and difficulty is null and description is null;

-- Sugar-Free Energy Bites (sugar-free)
update public.recipes_sweettreats set
  description = 'Oat, almond butter and flaxseed energy bites with sugar-free chocolate chips.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['energy bites','oats','snack']::text[], is_no_bake = true
where id = '61ddfa73-559a-4dc8-8552-f89d6191a043'
  and difficulty is null and description is null;

-- Flourless Chocolate Cookies (gluten-free)
update public.recipes_sweettreats set
  description = 'Glossy, crackle-topped flourless cookies made with cocoa and egg whites.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 10, servings = 20,
  difficulty = 'easy', tags = array['flourless','cocoa','fudgy']::text[], is_no_bake = false
where id = 'd131bc6b-f359-4be9-bb4b-120b3cfc3365'
  and difficulty is null and description is null;

-- Almond Flour Lemon Bars (gluten-free)
update public.recipes_sweettreats set
  description = 'Tangy lemon curd bars on a golden almond-flour crust, dusted with powdered sugar.',
  oven_temp = '160°C', bake_minutes = 40, prep_minutes = 15, servings = 16,
  difficulty = 'medium', tags = array['lemon','almond flour','citrus']::text[], is_no_bake = false
where id = 'f541e14e-1791-4d63-9a3e-86effc7b33f1'
  and difficulty is null and description is null;

-- Coconut Macaroons (gluten-free)
update public.recipes_sweettreats set
  description = 'Golden, chewy coconut macaroons with optional dark chocolate-dipped bottoms.',
  oven_temp = '160°C', bake_minutes = 25, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['coconut','dark chocolate','chewy']::text[], is_no_bake = false
where id = '7e85e7ca-2cff-43f2-845e-b26e2a3b72e2'
  and difficulty is null and description is null;

-- Rice Flour Vanilla Cupcakes (gluten-free)
update public.recipes_sweettreats set
  description = 'Light, fluffy vanilla cupcakes made with a rice-flour blend, ready for buttercream.',
  oven_temp = '180°C', bake_minutes = 20, prep_minutes = 20, servings = 12,
  difficulty = 'medium', tags = array['cupcakes','vanilla','rice flour']::text[], is_no_bake = false
where id = '883ca995-bb89-4a0f-a8cd-10be3c5c13b2'
  and difficulty is null and description is null;

-- Peanut Butter Energy Balls (gluten-free)
update public.recipes_sweettreats set
  description = 'Peanut butter, oat and honey energy balls with mini chocolate chips and flaxseed.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['peanut butter','energy bites','snack']::text[], is_no_bake = true
where id = '616e3bba-1231-4125-9045-c3bbd9859d23'
  and difficulty is null and description is null;

-- Flourless Peanut Butter Cookies (gluten-free)
update public.recipes_sweettreats set
  description = 'Chewy flourless peanut butter cookies with an optional handful of chocolate chips.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 10, servings = 24,
  difficulty = 'easy', tags = array['peanut butter','flourless','chewy']::text[], is_no_bake = false
where id = '030108a1-bc71-4dd6-b619-18570a6d9e0e'
  and difficulty is null and description is null;

-- Coconut Flour Lemon Cake (gluten-free)
update public.recipes_sweettreats set
  description = 'A tender, honey-sweetened coconut-flour lemon cake finished with a zesty lemon glaze.',
  oven_temp = '160°C', bake_minutes = 40, prep_minutes = 20, servings = 10,
  difficulty = 'medium', tags = array['lemon','coconut flour','glaze']::text[], is_no_bake = false
where id = 'a06380b5-737b-473e-ba0e-654e57705706'
  and difficulty is null and description is null;

-- Classic Vanilla Ice Cream (frozen)
update public.recipes_sweettreats set
  description = 'Rich, custard-based vanilla ice cream churned until silky smooth.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 6,
  difficulty = 'medium', tags = array['custard','summer','ice cream maker']::text[], is_no_bake = true
where id = '0ad51e24-3225-433b-be9a-f6f308769c6d'
  and difficulty is null and description is null;

-- Strawberry Popsicles (frozen)
update public.recipes_sweettreats set
  description = 'Bright, fruity strawberry popsicles made with just a handful of ingredients.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 8,
  difficulty = 'easy', tags = array['strawberry','summer','kid-friendly']::text[], is_no_bake = true
where id = 'cbd19187-d7dc-4bef-987a-b99f6c8a3c8d'
  and difficulty is null and description is null;

-- Strawberry Gelato (frozen)
update public.recipes_sweettreats set
  description = 'Creamy strawberry gelato with a smooth custard base and real fruit.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 6,
  difficulty = 'medium', tags = array['strawberry','custard','ice cream maker']::text[], is_no_bake = true
where id = '1d36f93b-20b3-4d55-9d18-432537d6283f'
  and difficulty is null and description is null;

-- Mango Sorbet (frozen)
update public.recipes_sweettreats set
  description = 'Refreshing mango sorbet brightened with lime juice and zest.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 6,
  difficulty = 'easy', tags = array['mango','dairy-free','ice cream maker']::text[], is_no_bake = true
where id = '6e4b23d1-26d1-414b-a63a-04cb620102d1'
  and difficulty is null and description is null;

-- Frozen Yogurt Bark (frozen)
update public.recipes_sweettreats set
  description = 'Honey-sweetened Greek yogurt frozen with berries, nuts and chocolate, then snapped into pieces.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['yogurt','berries','snack']::text[], is_no_bake = true
where id = '039a2e5d-18c2-46ad-aee6-1c148e2fae6b'
  and difficulty is null and description is null;

-- Banana Nice Cream (frozen)
update public.recipes_sweettreats set
  description = 'One-ingredient-style banana soft serve blended until creamy, with your favourite toppings.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['banana','dairy-free','quick']::text[], is_no_bake = true
where id = '44112b5c-c3c9-4c3d-93cf-9136ee98c2f8'
  and difficulty is null and description is null;

-- Coconut Popsicles (frozen)
update public.recipes_sweettreats set
  description = 'Creamy coconut popsicles with condensed milk, plus an optional zingy lime twist.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 8,
  difficulty = 'easy', tags = array['coconut','lime','summer']::text[], is_no_bake = true
where id = '6aabec14-a37b-425f-af85-6527c9a36351'
  and difficulty is null and description is null;

-- Chocolate Fudge Pops (frozen)
update public.recipes_sweettreats set
  description = 'Old-fashioned chocolate fudge pops made from a silky cooked cocoa pudding.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 8,
  difficulty = 'easy', tags = array['fudge pops','cocoa','kid-friendly']::text[], is_no_bake = true
where id = 'fe9a4698-c622-4dd1-af72-9e56a69f7839'
  and difficulty is null and description is null;

-- Affogato Ice Cream (frozen)
update public.recipes_sweettreats set
  description = 'Vanilla ice cream drowned in hot espresso, with an optional splash of amaretto.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 4,
  difficulty = 'easy', tags = array['espresso','italian','quick']::text[], is_no_bake = true
where id = 'c0ea6a05-49ff-42ca-9442-04cd25593bf7'
  and difficulty is null and description is null;

-- No-Bake Chocolate Oat Cookies (no-bake)
update public.recipes_sweettreats set
  description = 'Fudgy chocolate–peanut butter oat cookies that set on the counter, no oven needed.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['peanut butter','oats','quick']::text[], is_no_bake = true
where id = 'd14594d8-78e7-4dfe-b40d-646dd2f8d3b9'
  and difficulty is null and description is null;

-- Peanut Butter Balls (no-bake)
update public.recipes_sweettreats set
  description = 'Sweet peanut butter balls dipped in melted chocolate and finished with a pinch of sea salt.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 30,
  difficulty = 'easy', tags = array['peanut butter','chocolate-dipped','sea salt']::text[], is_no_bake = true
where id = 'e355ba72-4d0b-4e76-8e09-42362153b6d4'
  and difficulty is null and description is null;

-- Rice Crispy Treats (no-bake)
update public.recipes_sweettreats set
  description = 'Chewy, buttery marshmallow and crispy rice squares made in the microwave.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 24,
  difficulty = 'easy', tags = array['marshmallow','kid-friendly','quick']::text[], is_no_bake = true
where id = 'eae7adaa-ebba-4311-a3b0-9489e4c80197'
  and difficulty is null and description is null;

-- Chocolate Truffles (no-bake)
update public.recipes_sweettreats set
  description = 'Glossy dark chocolate ganache truffles rolled in cocoa, nuts or coconut.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 24,
  difficulty = 'easy', tags = array['ganache','gift','make-ahead']::text[], is_no_bake = true
where id = 'e4bed289-4585-4e2f-a7b2-4d7bdce260ad'
  and difficulty is null and description is null;

-- No-Bake Cheesecake (no-bake)
update public.recipes_sweettreats set
  description = 'Creamy whipped cheesecake on a buttery graham-cracker crust, topped with fresh berries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 25, servings = 12,
  difficulty = 'easy', tags = array['cheesecake','berries','make-ahead']::text[], is_no_bake = true
where id = 'fe4adcb9-d02d-4733-8775-df22afa1a321'
  and difficulty is null and description is null;

-- Chocolate Bark (no-bake)
update public.recipes_sweettreats set
  description = 'Dark chocolate bark topped with cranberries, almonds, pistachios and flaky sea salt.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['gift','nuts','sea salt']::text[], is_no_bake = true
where id = '30332168-5dff-4662-830d-c478328c81ca'
  and difficulty is null and description is null;

-- Oreo Balls (no-bake)
update public.recipes_sweettreats set
  description = 'Cookies-and-cream truffles made from crushed sandwich cookies and cream cheese, dipped in white chocolate.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 36,
  difficulty = 'easy', tags = array['oreo','cream cheese','party']::text[], is_no_bake = true
where id = '83139010-83ab-49e5-9e5b-5cf05bfa252e'
  and difficulty is null and description is null;

-- Peanut Butter Fudge (no-bake)
update public.recipes_sweettreats set
  description = 'Smooth, sweet peanut butter fudge cut into squares, ready to share.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['peanut butter','fudge','gift']::text[], is_no_bake = true
where id = 'b7276794-3e02-4283-ae60-ce10978e2060'
  and difficulty is null and description is null;

-- Coconut Balls (no-bake)
update public.recipes_sweettreats set
  description = 'Chewy coconut and condensed milk balls, optionally dipped in dark chocolate.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 24,
  difficulty = 'easy', tags = array['coconut','condensed milk','gift']::text[], is_no_bake = true
where id = 'e75eed22-98e8-41a7-a839-bda551d43534'
  and difficulty is null and description is null;

-- Cerial Squares (no-bake)
update public.recipes_sweettreats set
  description = 'Cereal squares coated in melted chocolate and peanut butter, then tossed in powdered sugar.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['peanut butter','snack','party']::text[], is_no_bake = true
where id = '48302d23-af85-4cd7-a083-ea351ef78704'
  and difficulty is null and description is null;

-- Classic Apple Turnovers (puff-pastry)
update public.recipes_sweettreats set
  description = 'Golden puff pastry triangles filled with cinnamon-spiced apples and topped with crunchy sugar.',
  oven_temp = '200°C', bake_minutes = 25, prep_minutes = 20, servings = 6,
  difficulty = 'easy', tags = array['apples','cinnamon','pastry']::text[], is_no_bake = false
where id = '07bb7437-5c37-4ecb-a1d2-8ac1f86426d6'
  and difficulty is null and description is null;

-- Berry Puff Pastry Tart (puff-pastry)
update public.recipes_sweettreats set
  description = 'A crisp, puffed pastry tart piled with jammy mixed berries and an apricot glaze.',
  oven_temp = '200°C', bake_minutes = 30, prep_minutes = 15, servings = 8,
  difficulty = 'easy', tags = array['berries','tart','summer']::text[], is_no_bake = false
where id = '349ba456-89a2-4bb8-a635-910b9963f8da'
  and difficulty is null and description is null;

-- Classic Fudgy Brownies (chocolate)
update public.recipes_sweettreats set
  description = 'Dense, fudgy brownies made with melted dark chocolate and a crackly top.',
  oven_temp = '180°C', bake_minutes = 30, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['brownies','fudgy','classic']::text[], is_no_bake = false
where id = 'c243aabb-3c50-457c-8d26-fbde640b5fa6'
  and difficulty is null and description is null;

-- Cinnamon Sugar Palmiers (puff-pastry)
update public.recipes_sweettreats set
  description = 'Crisp, caramelised cinnamon-sugar palmiers made from just a few ingredients.',
  oven_temp = '200°C', bake_minutes = 20, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['cinnamon sugar','pastry','crispy']::text[], is_no_bake = false
where id = '8e34ff37-9d21-43cb-956a-d7c222aa382a'
  and difficulty is null and description is null;

-- Cream Cheese Danish (puff-pastry)
update public.recipes_sweettreats set
  description = 'Pinwheel puff pastry danishes with a sweet vanilla cream cheese centre and fresh berries.',
  oven_temp = '190°C', bake_minutes = 22, prep_minutes = 20, servings = 9,
  difficulty = 'medium', tags = array['cream cheese','breakfast','berries']::text[], is_no_bake = false
where id = '4a57b062-ffe2-435e-a27a-aeb80727379a'
  and difficulty is null and description is null;

-- Nutella Puff Pastry Twists (puff-pastry)
update public.recipes_sweettreats set
  description = 'Flaky puff pastry twists filled with Nutella and sprinkled with chopped hazelnuts.',
  oven_temp = '200°C', bake_minutes = 18, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['nutella','hazelnut','quick']::text[], is_no_bake = false
where id = '4c2548d9-6ce0-4b22-8b19-a3ea3ced66f4'
  and difficulty is null and description is null;

-- Pear and Almond Galette (puff-pastry)
update public.recipes_sweettreats set
  description = 'A rustic puff pastry galette with sliced pears over almond frangipane, finished with honey.',
  oven_temp = '190°C', bake_minutes = 35, prep_minutes = 20, servings = 6,
  difficulty = 'easy', tags = array['pear','almond','rustic']::text[], is_no_bake = false
where id = '0b39f409-aeb0-4e62-ab62-29567f19bcc4'
  and difficulty is null and description is null;

-- Strawberry Napoleon (puff-pastry)
update public.recipes_sweettreats set
  description = 'Crisp layers of puff pastry stacked with vanilla whipped cream and sweet strawberries.',
  oven_temp = '200°C', bake_minutes = 20, prep_minutes = 25, servings = 6,
  difficulty = 'medium', tags = array['strawberry','cream','layered']::text[], is_no_bake = false
where id = 'f540a417-bd25-4f1a-9fad-a2ea4bdc7d1e'
  and difficulty is null and description is null;

-- Banana Cream Puffs (puff-pastry)
update public.recipes_sweettreats set
  description = 'Golden puff pastry squares split and filled with banana whipped cream.',
  oven_temp = '200°C', bake_minutes = 20, prep_minutes = 20, servings = 8,
  difficulty = 'easy', tags = array['banana','cream','pastry']::text[], is_no_bake = false
where id = '8bae9435-a86b-4471-9acc-dfe52959ddf7'
  and difficulty is null and description is null;

-- Caramel Apple Strudel (puff-pastry)
update public.recipes_sweettreats set
  description = 'A golden puff pastry strudel rolled around caramel-cinnamon apples.',
  oven_temp = '190°C', bake_minutes = 40, prep_minutes = 20, servings = 8,
  difficulty = 'medium', tags = array['apples','caramel','cinnamon']::text[], is_no_bake = false
where id = '4ab2ccfe-d3f1-49d5-9944-e39c912240f2'
  and difficulty is null and description is null;

-- Birthday Cake Fudge (birthday)
update public.recipes_sweettreats set
  description = 'Creamy white chocolate fudge studded with cake crumbs and rainbow sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 16,
  difficulty = 'easy', tags = array['fudge','sprinkles','white chocolate']::text[], is_no_bake = true
where id = '385aadb3-fb1c-4689-a8cd-47b194cd5231'
  and difficulty is null and description is null;

-- Sprinkle Marshmallow Treats (birthday)
update public.recipes_sweettreats set
  description = 'Chewy marshmallow cereal bars made extra festive with rainbow sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 16,
  difficulty = 'easy', tags = array['marshmallow','sprinkles','kid-friendly']::text[], is_no_bake = true
where id = 'd0b2e72b-c03f-46af-acbe-f9dcb32488ae'
  and difficulty is null and description is null;

-- Birthday Cake Milkshake (birthday)
update public.recipes_sweettreats set
  description = 'A thick vanilla milkshake blended with cake crumbs and topped with whipped cream and sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['milkshake','sprinkles','quick']::text[], is_no_bake = true
where id = 'bbc9f6c3-dc79-4ae3-9f5c-143c5294952d'
  and difficulty is null and description is null;

-- Birthday Cake Ice Cream (birthday)
update public.recipes_sweettreats set
  description = 'Sweet vanilla ice cream swirled with cake crumbs and rainbow sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 6,
  difficulty = 'easy', tags = array['ice cream maker','sprinkles','party']::text[], is_no_bake = true
where id = '276344f3-aab6-415a-8328-1b914f1f314b'
  and difficulty is null and description is null;

-- Warm Spiced Pumpkin Bites (hormonal-health)
update public.recipes_sweettreats set
  description = 'Pumpkin-spiced oat and almond butter bites, lightly sweetened with honey.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['energy bites','pumpkin spice','snack']::text[], is_no_bake = true
where id = '053ec99e-f075-4c3d-90ea-b0d630014d76'
  and difficulty is null and description is null;

-- Turmeric Golden Milk Bites (hormonal-health)
update public.recipes_sweettreats set
  description = 'Cashew and date bites spiced like golden milk with turmeric, cinnamon and black pepper.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['turmeric','cashews','energy bites']::text[], is_no_bake = true
where id = '34f08338-ca58-4801-b476-6af05390d058'
  and difficulty is null and description is null;

-- Sweet Potato Brownies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Fudgy flourless brownies made with sweet potato, almond butter and honey.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['sweet potato','brownies','flourless']::text[], is_no_bake = false
where id = '7c3018dc-1a80-44d9-8e60-a5489993930d'
  and difficulty is null and description is null;

-- Sweet Potato and Chocolate Chip Blondies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Soft sweet potato and almond butter blondies dotted with chocolate chips.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['sweet potato','blondies','chocolate chip']::text[], is_no_bake = false
where id = '861b911b-e474-4949-ad21-03a3aacdc7a0'
  and difficulty is null and description is null;

-- Spinach Chocolate Brownies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Rich dark chocolate brownies with a secret handful of blended spinach.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['hidden veggies','brownies','spinach']::text[], is_no_bake = false
where id = '297bfed5-3a57-47ed-b478-3cb9c80aa460'
  and difficulty is null and description is null;

-- Soothing Peppermint Cacao Bites (hormonal-health)
update public.recipes_sweettreats set
  description = 'Cool peppermint and cacao bites made from cashews and dates.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['peppermint','cacao','energy bites']::text[], is_no_bake = true
where id = '6b774406-9bbc-4be0-a15c-b71df58e4b97'
  and difficulty is null and description is null;

-- Sesame and Tahini Energy Balls (hormonal-health)
update public.recipes_sweettreats set
  description = 'Date and tahini energy balls rolled in toasted sesame seeds.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['tahini','sesame','energy bites']::text[], is_no_bake = true
where id = 'b369d4b4-5016-49e1-95e4-265ac5098d87'
  and difficulty is null and description is null;

-- Raspberry Leaf Tea Cookies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Simple buttery cookies flavoured with finely ground raspberry leaf tea.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['tea','buttery','simple']::text[], is_no_bake = false
where id = '7b9af83d-3fa8-468c-a4c0-c1d70314a0af'
  and difficulty is null and description is null;

-- Magnesium-Rich Dark Chocolate Bark (hormonal-health)
update public.recipes_sweettreats set
  description = 'Dark chocolate bark scattered with almonds, pumpkin seeds and cranberries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['bark','pumpkin seeds','almonds']::text[], is_no_bake = true
where id = 'b8379aae-70a9-4d38-8bb0-cac776732df6'
  and difficulty is null and description is null;

-- Maca and Cacao Bliss Balls (hormonal-health)
update public.recipes_sweettreats set
  description = 'Date and almond bliss balls flavoured with cacao and maca powder.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['maca','cacao','energy bites']::text[], is_no_bake = true
where id = 'cf7b95c6-2212-494b-8cef-bb9bfb9f211c'
  and difficulty is null and description is null;

-- Iron-Rich Date and Nut Bars (hormonal-health)
update public.recipes_sweettreats set
  description = 'Chewy date and mixed nut bars with cocoa and chia seeds.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['dates','nuts','snack bars']::text[], is_no_bake = true
where id = '631598a5-3a6f-4146-b28c-2c18ada4d1be'
  and difficulty is null and description is null;

-- Ginger Molasses Cookies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Soft, chewy cookies warmly spiced with ginger, cinnamon and molasses.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['ginger','molasses','spiced']::text[], is_no_bake = false
where id = '5d606cde-7fc8-4051-ae95-a9756a826d56'
  and difficulty is null and description is null;

-- Flaxseed Chocolate Energy Balls (hormonal-health)
update public.recipes_sweettreats set
  description = 'Oat, flaxseed and cocoa energy balls bound with honey and almond butter.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['flaxseed','energy bites','oats']::text[], is_no_bake = true
where id = 'f1d39c90-d975-4a35-82f9-79cb8f8605bc'
  and difficulty is null and description is null;

-- Dark Chocolate Magnesium Bites (hormonal-health)
update public.recipes_sweettreats set
  description = 'Toasted pumpkin seed clusters bound with almond butter and dark chocolate.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['pumpkin seeds','dark chocolate','snack']::text[], is_no_bake = true
where id = '8acc5416-fafd-4cef-ad16-ead0073b6c43'
  and difficulty is null and description is null;

-- Dark Chocolate Banana Bites (hormonal-health)
update public.recipes_sweettreats set
  description = 'Frozen banana slices dipped in dark chocolate and sprinkled with pumpkin seeds.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 6,
  difficulty = 'easy', tags = array['banana','frozen treat','pumpkin seeds']::text[], is_no_bake = true
where id = 'b2026827-9ea4-4842-8a81-c506833f7ef4'
  and difficulty is null and description is null;

-- Dark Chocolate Avocado Mousse (hormonal-health)
update public.recipes_sweettreats set
  description = 'Silky dark chocolate avocado mousse sweetened with honey and topped with berries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['avocado','make-ahead','honey']::text[], is_no_bake = true
where id = 'ace982bf-a389-472c-ac3d-ad024da4b1dd'
  and difficulty is null and description is null;

-- Cinnamon Ginger Cookies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Simple brown-sugar cookies warmly spiced with cinnamon and ginger.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['ginger','cinnamon','spiced']::text[], is_no_bake = false
where id = 'd9ef6533-e978-4b59-93db-d2e7617cb23a'
  and difficulty is null and description is null;

-- Chia and Cacao Pudding (hormonal-health)
update public.recipes_sweettreats set
  description = 'Overnight chia pudding made with almond milk, cacao and a drizzle of honey.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['breakfast','cacao','make-ahead']::text[], is_no_bake = true
where id = 'fbf89d05-fd96-47b1-b249-17d6eeffbba9'
  and difficulty is null and description is null;

-- Chamomile Honey Cookies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Delicate honey-sweetened cookies flavoured with ground chamomile flowers.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['chamomile','honey','tea']::text[], is_no_bake = false
where id = '5a4e07c6-3927-4ea0-a886-4a5ca80cc817'
  and difficulty is null and description is null;

-- Cacao Nib Oat Bars (hormonal-health)
update public.recipes_sweettreats set
  description = 'Chewy oat bars with crunchy cacao nibs, bound with honey and almond butter.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['oats','cacao nibs','snack bars']::text[], is_no_bake = true
where id = '1284af2e-4f03-47e7-9ed0-0c5f95a2579d'
  and difficulty is null and description is null;

-- Cacao Avocado Truffles (hormonal-health)
update public.recipes_sweettreats set
  description = 'Creamy avocado and cacao truffles dipped in a crisp dark chocolate shell.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 16,
  difficulty = 'easy', tags = array['avocado','cacao','truffles']::text[], is_no_bake = true
where id = '71037e9c-bc91-4d88-8e38-34f430cd4f5f'
  and difficulty is null and description is null;

-- Cacao and Walnut Energy Bites (hormonal-health)
update public.recipes_sweettreats set
  description = 'Walnut, date and cacao energy bites with a touch of coconut oil.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['walnuts','cacao','energy bites']::text[], is_no_bake = true
where id = '174b9d34-d1e9-44ee-8bc4-27fb5c432ba5'
  and difficulty is null and description is null;

-- Beetroot Chocolate Brownies (hormonal-health)
update public.recipes_sweettreats set
  description = 'Moist, deep-red brownies made with beetroot purée and honey.',
  oven_temp = '180°C', bake_minutes = 30, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['beetroot','brownies','hidden veggies']::text[], is_no_bake = false
where id = '604e9ac9-83e4-41a6-9926-638ddde61a95'
  and difficulty is null and description is null;

-- Banana Oat Muffins with Flaxseed (hormonal-health)
update public.recipes_sweettreats set
  description = 'Flourless banana oat muffins with flaxseed and cinnamon, sweetened with honey.',
  oven_temp = '180°C', bake_minutes = 20, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['banana','muffins','flaxseed']::text[], is_no_bake = false
where id = '1341250d-94c5-4865-914d-ef76053b2085'
  and difficulty is null and description is null;

-- Almond and Date Energy Bars (hormonal-health)
update public.recipes_sweettreats set
  description = 'Four-ingredient almond and date bars with chia seeds and vanilla.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['dates','almonds','snack bars']::text[], is_no_bake = true
where id = 'a3c33b10-d5c2-4e6a-af83-328a9ec7ad33'
  and difficulty is null and description is null;

-- Zucchini Chocolate Muffins (healthy)
update public.recipes_sweettreats set
  description = 'Whole-wheat chocolate muffins with hidden zucchini, sweetened with honey instead of refined sugar.',
  oven_temp = '180°C', bake_minutes = 20, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['muffins','hidden veggies','whole wheat']::text[], is_no_bake = false
where id = 'cbd76dee-10bd-4425-8e60-fdff426e32f7'
  and difficulty is null and description is null;

-- Watermelon Pizza (healthy)
update public.recipes_sweettreats set
  description = 'A fresh watermelon slice topped like a pizza with Greek yogurt, granola, berries and mint.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['watermelon','summer','kid-friendly']::text[], is_no_bake = true
where id = 'fa9e870e-45a3-4813-b330-41cf8141445c'
  and difficulty is null and description is null;

-- Sweet Potato Toast with Almond Butter (healthy)
update public.recipes_sweettreats set
  description = 'Toasted sweet potato slices topped with almond butter, banana and cinnamon.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['breakfast','sweet potato','almond butter']::text[], is_no_bake = false
where id = '013f1cc5-8bcf-4bec-b7b0-cccd927ab69c'
  and difficulty is null and description is null;

-- Roasted Cinnamon Chickpeas (healthy)
update public.recipes_sweettreats set
  description = 'Crunchy oven-roasted chickpeas tossed in cinnamon sugar.',
  oven_temp = '200°C', bake_minutes = 30, prep_minutes = 5, servings = 4,
  difficulty = 'easy', tags = array['chickpeas','cinnamon','snack']::text[], is_no_bake = false
where id = '5202ac9f-fd50-4914-ab4e-7d7700decb4e'
  and difficulty is null and description is null;

-- Pumpkin Spice Energy Bites (healthy)
update public.recipes_sweettreats set
  description = 'Pumpkin spice oat bites with almond butter and maple syrup.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['pumpkin spice','energy bites','snack']::text[], is_no_bake = true
where id = 'f5bcc5bb-46a7-4b30-ba74-4765f11c896a'
  and difficulty is null and description is null;

-- Protein Peanut Butter Balls (healthy)
update public.recipes_sweettreats set
  description = 'Four-ingredient peanut butter protein balls with oats and honey.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['protein','peanut butter','snack']::text[], is_no_bake = true
where id = 'd03f306c-311f-4ef0-a80e-1c1211731f2a'
  and difficulty is null and description is null;

-- Protein Brownie Bites (healthy)
update public.recipes_sweettreats set
  description = 'Fudgy black bean brownie bites boosted with chocolate protein powder.',
  oven_temp = '180°C', bake_minutes = 15, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['protein','black beans','brownies']::text[], is_no_bake = false
where id = 'a1337aa9-198f-45de-99c4-e54a69a27a31'
  and difficulty is null and description is null;

-- Overnight Oats with Berries (healthy)
update public.recipes_sweettreats set
  description = 'Creamy overnight oats with yogurt and honey, topped with fresh berries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 1,
  difficulty = 'easy', tags = array['breakfast','berries','make-ahead']::text[], is_no_bake = true
where id = '79db86f0-6d97-4acb-ad3f-a7b4c3bf09c8'
  and difficulty is null and description is null;

-- Oat and Honey Granola Bars (healthy)
update public.recipes_sweettreats set
  description = 'Chewy baked oat bars with honey, peanut butter, dried fruit and seeds.',
  oven_temp = '170°C', bake_minutes = 20, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['granola','oats','snack bars']::text[], is_no_bake = false
where id = '4363efea-de84-4817-be12-87cd08d010c8'
  and difficulty is null and description is null;

-- Mixed Berry Chia Jam (healthy)
update public.recipes_sweettreats set
  description = 'Quick mixed-berry jam thickened with chia seeds and sweetened with honey.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['berries','jam','chia']::text[], is_no_bake = true
where id = 'f7175233-d3fe-4308-89b5-1f19c4fa6a00'
  and difficulty is null and description is null;

-- Mango Coconut Bites (healthy)
update public.recipes_sweettreats set
  description = 'Tropical dried mango and coconut bites with a touch of honey.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['mango','coconut','energy bites']::text[], is_no_bake = true
where id = '3d4d2997-1f7c-48ca-afd2-47a782609af9'
  and difficulty is null and description is null;

-- Greek Yogurt Cheesecake Bites (healthy)
update public.recipes_sweettreats set
  description = 'Mini frozen cheesecake bites made with Greek yogurt and honey, topped with graham crumbs.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['cheesecake','yogurt','frozen treat']::text[], is_no_bake = true
where id = '2853bd0f-e369-4603-83ac-96397bed5c7d'
  and difficulty is null and description is null;

-- Greek Yogurt Berry Bark (healthy)
update public.recipes_sweettreats set
  description = 'Frozen honey yogurt bark topped with berries, granola and chia seeds.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['yogurt','berries','frozen treat']::text[], is_no_bake = true
where id = '1575a2a2-30ab-4dfc-b61f-3d51a29291eb'
  and difficulty is null and description is null;

-- Frozen Yogurt Grapes (healthy)
update public.recipes_sweettreats set
  description = 'Juicy grapes coated in honey yogurt and frozen into bite-sized snacks.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['grapes','yogurt','frozen treat']::text[], is_no_bake = true
where id = '297e7dc4-7b28-41bd-a950-dc97c3f1ebfd'
  and difficulty is null and description is null;

-- Frozen Banana Bites (healthy)
update public.recipes_sweettreats set
  description = 'Frozen banana slices dipped in dark chocolate and sprinkled with chopped peanuts.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['banana','peanuts','frozen treat']::text[], is_no_bake = true
where id = 'eabbe088-c498-4381-8c3d-d8423b0831df'
  and difficulty is null and description is null;

-- Energy Bites with Dates and Almonds (healthy)
update public.recipes_sweettreats set
  description = 'Simple date, almond and cocoa energy bites with a pinch of salt.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['dates','almonds','energy bites']::text[], is_no_bake = true
where id = '02a43174-bb31-4cbc-bc4f-f673252a1838'
  and difficulty is null and description is null;

-- Dark Chocolate Dipped Strawberries (healthy)
update public.recipes_sweettreats set
  description = 'Fresh strawberries dipped in glossy dark chocolate and chilled until set.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 4,
  difficulty = 'easy', tags = array['strawberries','dark chocolate','date night']::text[], is_no_bake = true
where id = '55d67762-da22-4e36-8e03-d69c692683ab'
  and difficulty is null and description is null;

-- Coconut Yogurt Parfait (healthy)
update public.recipes_sweettreats set
  description = 'Layers of coconut yogurt, crunchy granola and berries, finished with shredded coconut.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 1,
  difficulty = 'easy', tags = array['breakfast','coconut','berries']::text[], is_no_bake = true
where id = '0fad5c85-a190-4d85-8d5f-068ed0f3506e'
  and difficulty is null and description is null;

-- Chia Pudding with Mango (healthy)
update public.recipes_sweettreats set
  description = 'Coconut-milk chia pudding sweetened with maple syrup and topped with fresh mango.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['mango','coconut','breakfast']::text[], is_no_bake = true
where id = '990d5d19-7f08-432e-9146-b2a3179f7645'
  and difficulty is null and description is null;

-- Carrot Cake Energy Balls (healthy)
update public.recipes_sweettreats set
  description = 'Carrot cake-inspired energy balls with oats, dates, walnuts and cinnamon.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['carrot cake','energy bites','walnuts']::text[], is_no_bake = true
where id = '46c28716-8145-4e57-91bf-556599349809'
  and difficulty is null and description is null;

-- Berry Oat Crumble Cups (healthy)
update public.recipes_sweettreats set
  description = 'Individual berry crumbles baked in ramekins under a golden oat topping.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 4,
  difficulty = 'easy', tags = array['berries','crumble','individual']::text[], is_no_bake = false
where id = '1f41bd68-7613-4e32-a629-d4682b38fef4'
  and difficulty is null and description is null;

-- Berry Nice Cream (healthy)
update public.recipes_sweettreats set
  description = 'Creamy berry and banana soft serve blended straight from frozen.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 2,
  difficulty = 'easy', tags = array['berries','banana','quick']::text[], is_no_bake = true
where id = '27ddc400-5e86-405d-a5ef-1d9b389c20fb'
  and difficulty is null and description is null;

-- Banana Oat Cookies with No Added Sugar (healthy)
update public.recipes_sweettreats set
  description = 'Four-ingredient banana oat cookies with raisins and cinnamon, with no added sugar.',
  oven_temp = '180°C', bake_minutes = 15, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['banana','oats','no added sugar']::text[], is_no_bake = false
where id = '45180ebb-6933-4f2d-8b83-82b883d05133'
  and difficulty is null and description is null;

-- Baked Stuffed Apples (healthy)
update public.recipes_sweettreats set
  description = 'Whole baked apples stuffed with honey, oats, walnuts and cinnamon.',
  oven_temp = '190°C', bake_minutes = 30, prep_minutes = 15, servings = 4,
  difficulty = 'easy', tags = array['apples','walnuts','cinnamon']::text[], is_no_bake = false
where id = '2956d8cc-f014-4c0b-8c68-b7c578606d68'
  and difficulty is null and description is null;

-- Baked Pear with Honey and Walnuts (healthy)
update public.recipes_sweettreats set
  description = 'Tender baked pear halves drizzled with honey and topped with cinnamon walnuts.',
  oven_temp = '190°C', bake_minutes = 20, prep_minutes = 5, servings = 4,
  difficulty = 'easy', tags = array['pear','walnuts','honey']::text[], is_no_bake = false
where id = 'db09aca5-795a-4085-ac7b-88d26994cb11'
  and difficulty is null and description is null;

-- Baked Banana Boats (healthy)
update public.recipes_sweettreats set
  description = 'Warm foil-baked bananas stuffed with melting chocolate, nuts and marshmallows.',
  oven_temp = '190°C', bake_minutes = 15, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['banana','campfire','marshmallow']::text[], is_no_bake = false
where id = 'e3ece39c-609a-44b5-88d3-c40060d5d250'
  and difficulty is null and description is null;

-- Baked Apple Chips with Cinnamon (healthy)
update public.recipes_sweettreats set
  description = 'Crisp, slow-baked apple chips dusted with cinnamon.',
  oven_temp = '100°C', bake_minutes = 120, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['apples','cinnamon','snack']::text[], is_no_bake = false
where id = '37560ac5-e48c-4feb-b14b-4aaad8f31050'
  and difficulty is null and description is null;

-- Avocado Chocolate Pudding (healthy)
update public.recipes_sweettreats set
  description = 'Smooth chocolate avocado pudding sweetened with maple syrup.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['avocado','maple','make-ahead']::text[], is_no_bake = true
where id = '7e8d4c5b-c728-4c70-ad11-3f7a33ebc24b'
  and difficulty is null and description is null;

-- Apple Nachos (healthy)
update public.recipes_sweettreats set
  description = 'Crisp apple slices drizzled with peanut butter and chocolate and topped with granola.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 2,
  difficulty = 'easy', tags = array['apples','peanut butter','snack']::text[], is_no_bake = true
where id = 'f42d2228-1e3c-4ed8-b7e2-bdcdfbbdd028'
  and difficulty is null and description is null;

-- Almond Butter Stuffed Dates (healthy)
update public.recipes_sweettreats set
  description = 'Sweet dates stuffed with almond butter and finished with sea salt and pistachios.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['dates','almond butter','sea salt']::text[], is_no_bake = true
where id = 'ffb8f9ed-0717-4db2-bdd2-a8e09c3f64c7'
  and difficulty is null and description is null;

-- White Chocolate Raspberry Blondies (chocolate)
update public.recipes_sweettreats set
  description = 'Chewy brown-sugar blondies studded with white chocolate chips and fresh raspberries.',
  oven_temp = '180°C', bake_minutes = 30, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['blondies','raspberry','white chocolate']::text[], is_no_bake = false
where id = '444e793a-68bf-4a84-a46f-0b1d06dd3d41'
  and difficulty is null and description is null;

-- Triple Chocolate Cookies (chocolate)
update public.recipes_sweettreats set
  description = 'Rich cocoa cookies loaded with dark chocolate chunks and white chocolate chips.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 30,
  difficulty = 'easy', tags = array['dark chocolate','white chocolate','cocoa']::text[], is_no_bake = false
where id = 'c8bbb037-1480-4582-b7bb-1fc55ba63ad4'
  and difficulty is null and description is null;

-- Spicy Chocolate Chili Cookies (chocolate)
update public.recipes_sweettreats set
  description = 'Deep cocoa cookies with a warming kick of cayenne and cinnamon.',
  oven_temp = '180°C', bake_minutes = 10, prep_minutes = 15, servings = 30,
  difficulty = 'easy', tags = array['spicy','cayenne','cinnamon']::text[], is_no_bake = false
where id = '3b24c12b-d67e-4823-bc72-04f8715fa559'
  and difficulty is null and description is null;

-- Salted Chocolate Caramel Bars (chocolate)
update public.recipes_sweettreats set
  description = 'Layered bars of buttery shortbread crust, salted caramel and dark chocolate.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 16,
  difficulty = 'easy', tags = array['salted caramel','shortbread','bars']::text[], is_no_bake = true
where id = '4f078794-beb3-4a42-93d2-5405cf796657'
  and difficulty is null and description is null;

-- Rocky Road Bark (chocolate)
update public.recipes_sweettreats set
  description = 'Dark chocolate bark loaded with marshmallows, almonds and cranberries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 16,
  difficulty = 'easy', tags = array['rocky road','marshmallow','almonds']::text[], is_no_bake = true
where id = '47c3a101-9fed-4ffc-80aa-e6abf3dd349a'
  and difficulty is null and description is null;

-- Nutella Stuffed Cookies (chocolate)
update public.recipes_sweettreats set
  description = 'Brown-sugar cookies wrapped around a gooey hidden centre of Nutella.',
  oven_temp = '180°C', bake_minutes = 14, prep_minutes = 25, servings = 18,
  difficulty = 'medium', tags = array['nutella','stuffed','brown sugar']::text[], is_no_bake = false
where id = 'fa30232d-0801-49a6-89e2-f18af20596a0'
  and difficulty is null and description is null;

-- Molten Chocolate Mug Cake (chocolate)
update public.recipes_sweettreats set
  description = 'A gooey single-serve chocolate cake with a molten centre, ready in 90 seconds in the microwave.',
  oven_temp = null, bake_minutes = null, prep_minutes = 5, servings = 1,
  difficulty = 'easy', tags = array['microwave','single serve','quick']::text[], is_no_bake = true
where id = 'df65b74a-4de9-4763-ae3b-39b55246b8ae'
  and difficulty is null and description is null;

-- Mint Chocolate Brownies (chocolate)
update public.recipes_sweettreats set
  description = 'Fudgy dark chocolate brownies with a cool hint of peppermint.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['mint','brownies','fudgy']::text[], is_no_bake = false
where id = 'becdad6a-c751-4a11-ad62-434257b58df3'
  and difficulty is null and description is null;

-- Malted Chocolate Cookies (chocolate)
update public.recipes_sweettreats set
  description = 'Chewy cocoa cookies made with malted milk powder and crushed malt balls.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 30,
  difficulty = 'easy', tags = array['malted','cocoa','crunchy']::text[], is_no_bake = false
where id = '3f27a7fe-37be-480e-852f-ff12ef9db3d8'
  and difficulty is null and description is null;

-- Fudgy Chocolate Zucchini Cake (chocolate)
update public.recipes_sweettreats set
  description = 'A moist, fudgy chocolate cake made with grated zucchini.',
  oven_temp = '175°C', bake_minutes = 40, prep_minutes = 15, servings = 12,
  difficulty = 'easy', tags = array['hidden veggies','zucchini','cocoa']::text[], is_no_bake = false
where id = '779f4e31-632c-460f-9b2f-03da9fc165d3'
  and difficulty is null and description is null;

-- Dark Chocolate Almond Clusters (chocolate)
update public.recipes_sweettreats set
  description = 'Toasted whole almonds clustered in dark chocolate and finished with sea salt.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['almonds','sea salt','dark chocolate']::text[], is_no_bake = true
where id = 'a656d08b-87e9-42ee-9b72-8fa2e14d5f3f'
  and difficulty is null and description is null;

-- Chocolate Tiramisu Cups (chocolate)
update public.recipes_sweettreats set
  description = 'Individual tiramisu cups layered with espresso-soaked ladyfingers and mascarpone cream.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 4,
  difficulty = 'easy', tags = array['tiramisu','espresso','mascarpone']::text[], is_no_bake = true
where id = '24fef25e-5376-446c-be74-5e4ee5db6b87'
  and difficulty is null and description is null;

-- Chocolate Raspberry Cake (chocolate)
update public.recipes_sweettreats set
  description = 'A rich buttermilk chocolate cake folded with fresh raspberries.',
  oven_temp = '180°C', bake_minutes = 35, prep_minutes = 20, servings = 12,
  difficulty = 'medium', tags = array['raspberry','buttermilk','celebration']::text[], is_no_bake = false
where id = '070af633-64b5-448f-a489-71c0ad210c4a'
  and difficulty is null and description is null;

-- Chocolate Pretzel Bites (chocolate)
update public.recipes_sweettreats set
  description = 'Salty mini pretzels half-dipped in chocolate and topped with pretzel crumbs.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 24,
  difficulty = 'easy', tags = array['pretzels','salty-sweet','snack']::text[], is_no_bake = true
where id = '522cf2c5-a270-47a2-974d-880e667efc96'
  and difficulty is null and description is null;

-- Chocolate Peppermint Bark (chocolate)
update public.recipes_sweettreats set
  description = 'Layered dark and white chocolate bark topped with crushed candy canes.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['peppermint','christmas','white chocolate']::text[], is_no_bake = true
where id = '4e904911-1307-4948-bdc5-da9202654a95'
  and difficulty is null and description is null;

-- Chocolate Peanut Butter Cups (chocolate)
update public.recipes_sweettreats set
  description = 'Homemade chocolate cups filled with sweetened peanut butter.',
  oven_temp = null, bake_minutes = null, prep_minutes = 20, servings = 12,
  difficulty = 'easy', tags = array['peanut butter','cups','homemade']::text[], is_no_bake = true
where id = 'fc8e5be0-e442-49b1-9740-d2d9b6c749e6'
  and difficulty is null and description is null;

-- Chocolate Orange Truffles (chocolate)
update public.recipes_sweettreats set
  description = 'Dark chocolate ganache truffles infused with orange zest and rolled in cocoa.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 24,
  difficulty = 'easy', tags = array['orange','ganache','gift']::text[], is_no_bake = true
where id = '786e3aa7-2cf7-4214-b0ef-9762bf78c0ce'
  and difficulty is null and description is null;

-- Chocolate Hazelnut Tart (chocolate)
update public.recipes_sweettreats set
  description = 'A silky dark chocolate ganache tart topped with toasted hazelnuts.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 10,
  difficulty = 'easy', tags = array['hazelnut','ganache','tart']::text[], is_no_bake = true
where id = '71254bde-0e8c-4453-9620-1b830a71165d'
  and difficulty is null and description is null;

-- Chocolate Espresso Cookies (chocolate)
update public.recipes_sweettreats set
  description = 'Deep cocoa cookies with a bold hit of espresso.',
  oven_temp = '180°C', bake_minutes = 10, prep_minutes = 15, servings = 30,
  difficulty = 'easy', tags = array['espresso','coffee','cocoa']::text[], is_no_bake = false
where id = '45c1cb49-5f75-4698-b34e-31d11268a20d'
  and difficulty is null and description is null;

-- Chocolate Coconut Macaroons (chocolate)
update public.recipes_sweettreats set
  description = 'Chewy coconut macaroons with dark chocolate-dipped bottoms.',
  oven_temp = '160°C', bake_minutes = 20, prep_minutes = 15, servings = 20,
  difficulty = 'easy', tags = array['coconut','condensed milk','dark chocolate']::text[], is_no_bake = false
where id = '1596df95-aba6-4b67-8d90-a5303a7aad85'
  and difficulty is null and description is null;

-- Chocolate Chip Pancakes (chocolate)
update public.recipes_sweettreats set
  description = 'Fluffy chocolate chip pancakes cooked on the griddle.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['breakfast','pancakes','chocolate chip']::text[], is_no_bake = true
where id = '6212889e-7dac-4b6c-a2db-67344d3351a2'
  and difficulty is null and description is null;

-- Chocolate Chip Banana Muffins (chocolate)
update public.recipes_sweettreats set
  description = 'Moist banana muffins packed with chocolate chips.',
  oven_temp = '180°C', bake_minutes = 20, prep_minutes = 10, servings = 12,
  difficulty = 'easy', tags = array['banana','muffins','chocolate chip']::text[], is_no_bake = false
where id = '076f720c-fc1e-443d-b735-085de0240867'
  and difficulty is null and description is null;

-- Chocolate Cherry Brownies (chocolate)
update public.recipes_sweettreats set
  description = 'Fudgy dark chocolate brownies studded with juicy halved cherries.',
  oven_temp = '180°C', bake_minutes = 30, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['cherry','brownies','fudgy']::text[], is_no_bake = false
where id = 'd634c8e6-17ea-4bec-8026-5cf5ee99a3c7'
  and difficulty is null and description is null;

-- Chocolate Caramel Popcorn (chocolate)
update public.recipes_sweettreats set
  description = 'Caramel-coated popcorn drizzled with chocolate and a sprinkle of sea salt.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 8,
  difficulty = 'easy', tags = array['popcorn','caramel','sea salt']::text[], is_no_bake = true
where id = '54088cec-b2a3-4a6a-9abd-6e35c94d10eb'
  and difficulty is null and description is null;

-- Chocolate Banana Bread (chocolate)
update public.recipes_sweettreats set
  description = 'A moist cocoa banana loaf studded with chocolate chips.',
  oven_temp = '175°C', bake_minutes = 60, prep_minutes = 15, servings = 10,
  difficulty = 'easy', tags = array['banana','loaf','chocolate chip']::text[], is_no_bake = false
where id = '2c755b29-934a-4d11-8674-0ce23e44da74'
  and difficulty is null and description is null;

-- Vanilla Confetti Donuts (birthday)
update public.recipes_sweettreats set
  description = 'Fluffy baked vanilla donuts finished with glaze and rainbow sprinkles.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 20, servings = 12,
  difficulty = 'easy', tags = array['donuts','sprinkles','glazed']::text[], is_no_bake = false
where id = '196590d6-ae3b-473b-88b0-2d35ad674065'
  and difficulty is null and description is null;

-- Vanilla Birthday Sheet Cake (birthday)
update public.recipes_sweettreats set
  description = 'A classic buttery vanilla sheet cake that feeds a crowd.',
  oven_temp = '175°C', bake_minutes = 35, prep_minutes = 20, servings = 20,
  difficulty = 'easy', tags = array['vanilla','sheet cake','party']::text[], is_no_bake = false
where id = '83edeff4-f561-4098-8b18-32649afca5e9'
  and difficulty is null and description is null;

-- Vanilla Bean Birthday Cake Jars (birthday)
update public.recipes_sweettreats set
  description = 'Layers of crumbled vanilla cake, whipped cream, sprinkles and berries in individual jars.',
  oven_temp = null, bake_minutes = null, prep_minutes = 15, servings = 4,
  difficulty = 'easy', tags = array['cake jars','whipped cream','berries']::text[], is_no_bake = true
where id = '78d352af-8855-4497-957f-525b938cd0e3'
  and difficulty is null and description is null;

-- Sprinkle Sugar Cookies (birthday)
update public.recipes_sweettreats set
  description = 'Soft, buttery sugar cookies topped with colourful sprinkles.',
  oven_temp = '190°C', bake_minutes = 10, prep_minutes = 15, servings = 36,
  difficulty = 'easy', tags = array['sprinkles','sugar cookies','kid-friendly']::text[], is_no_bake = false
where id = '43b6415e-72b5-4a16-b6f0-787123c0fdb5'
  and difficulty is null and description is null;

-- Rainbow Sprinkle Cookies (birthday)
update public.recipes_sweettreats set
  description = 'Buttery vanilla cookies packed with rainbow sprinkles.',
  oven_temp = '180°C', bake_minutes = 12, prep_minutes = 15, servings = 30,
  difficulty = 'easy', tags = array['sprinkles','funfetti','kid-friendly']::text[], is_no_bake = false
where id = '845db38a-1966-44c9-9d85-2aa2bf3d15e8'
  and difficulty is null and description is null;

-- Pinata Cupcakes (birthday)
update public.recipes_sweettreats set
  description = 'Vanilla cupcakes hiding a surprise centre of mini candies under the frosting.',
  oven_temp = null, bake_minutes = null, prep_minutes = 30, servings = 12,
  difficulty = 'medium', tags = array['cupcakes','surprise','party']::text[], is_no_bake = false
where id = '3bb33cb2-21b9-4ddd-8315-74b1abd0ff48'
  and difficulty is null and description is null;

-- Party Popcorn Sweet Sprinkle Mix (birthday)
update public.recipes_sweettreats set
  description = 'Sweet and salty popcorn tossed in white chocolate and rainbow sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 8,
  difficulty = 'easy', tags = array['popcorn','white chocolate','sprinkles']::text[], is_no_bake = true
where id = 'd371ab6d-bd97-45e3-9903-15244527f988'
  and difficulty is null and description is null;

-- Number Cake (birthday)
update public.recipes_sweettreats set
  description = 'A sheet cake cut into a number shape and decorated with frosting and fresh berries.',
  oven_temp = null, bake_minutes = null, prep_minutes = 45, servings = 16,
  difficulty = 'medium', tags = array['number cake','berries','celebration']::text[], is_no_bake = false
where id = 'ce02cf22-660c-4065-b04e-8c3e74b624ea'
  and difficulty is null and description is null;

-- Layered Rainbow Cake (birthday)
update public.recipes_sweettreats set
  description = 'A show-stopping cake of brightly coloured layers stacked with frosting.',
  oven_temp = '175°C', bake_minutes = null, prep_minutes = 45, servings = 16,
  difficulty = 'hard', tags = array['rainbow','layer cake','celebration']::text[], is_no_bake = false
where id = '235abc4c-57ae-4ec6-8e0f-65f19c8f3698'
  and difficulty is null and description is null;

-- Funfetti Cupcakes (birthday)
update public.recipes_sweettreats set
  description = 'Fluffy vanilla cupcakes speckled with rainbow sprinkles.',
  oven_temp = '180°C', bake_minutes = 20, prep_minutes = 20, servings = 12,
  difficulty = 'easy', tags = array['cupcakes','funfetti','sprinkles']::text[], is_no_bake = false
where id = '1702cf61-a140-4892-b05e-1c8e140a0258'
  and difficulty is null and description is null;

-- Confetti Waffles (birthday)
update public.recipes_sweettreats set
  description = 'Golden waffles studded with sprinkles for a festive birthday breakfast.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 4,
  difficulty = 'easy', tags = array['waffles','breakfast','sprinkles']::text[], is_no_bake = true
where id = '06ee1c25-d050-457a-8ac7-53d9d0d775de'
  and difficulty is null and description is null;

-- Confetti Blondies (birthday)
update public.recipes_sweettreats set
  description = 'Chewy brown-sugar blondies with white chocolate chips and rainbow sprinkles.',
  oven_temp = '180°C', bake_minutes = 25, prep_minutes = 15, servings = 16,
  difficulty = 'easy', tags = array['blondies','sprinkles','white chocolate']::text[], is_no_bake = false
where id = '3beed152-ac2e-447f-8cda-0a4cd9f61588'
  and difficulty is null and description is null;

-- Confetti Birthday Cake (birthday)
update public.recipes_sweettreats set
  description = 'A buttery vanilla funfetti cake speckled with rainbow sprinkles.',
  oven_temp = '175°C', bake_minutes = 30, prep_minutes = 25, servings = 12,
  difficulty = 'medium', tags = array['funfetti','layer cake','sprinkles']::text[], is_no_bake = false
where id = 'd88a14d6-2efd-445e-b8d6-5364fe559d6d'
  and difficulty is null and description is null;

-- Birthday Cake Truffles (birthday)
update public.recipes_sweettreats set
  description = 'Cake and frosting truffles dipped in candy melts and topped with sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 45, servings = 30,
  difficulty = 'medium', tags = array['truffles','sprinkles','party']::text[], is_no_bake = true
where id = '2144a3fb-1959-44e6-b47b-f0c251251f03'
  and difficulty is null and description is null;

-- Birthday Cake Rice Krispie Treats (birthday)
update public.recipes_sweettreats set
  description = 'Vanilla marshmallow rice cereal squares packed with rainbow sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 10, servings = 16,
  difficulty = 'easy', tags = array['marshmallow','sprinkles','kid-friendly']::text[], is_no_bake = true
where id = '03afd6b3-c473-4b0e-abed-e9a389c8f7f6'
  and difficulty is null and description is null;

-- Birthday Cake Pops (birthday)
update public.recipes_sweettreats set
  description = 'Vanilla cake pops dipped in white chocolate and coated in rainbow sprinkles.',
  oven_temp = null, bake_minutes = null, prep_minutes = 60, servings = 30,
  difficulty = 'medium', tags = array['cake pops','sprinkles','party']::text[], is_no_bake = true
where id = '2bdfa3c2-ff59-46ec-9e57-4b1da3f76f13'
  and difficulty is null and description is null;

commit;
