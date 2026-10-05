-- Adds the new "halloween" category: 12 public recipes owned by the
-- SweetTreatsTeam account, like the rest of the public catalog.
-- Run in the Supabase SQL editor. No app change is needed — categories come
-- straight from recipes_sweettreats.category, so "Halloween" appears on the
-- Home categories row, All Categories and its own category page after a
-- pull-to-refresh.
--
-- Safe to re-run: a recipe is skipped if a halloween recipe with the same
-- name already exists.
--
-- Steps are stored as "1. ...\n2. ..." (what the app writes); the app
-- splits steps on "<number>. ", so no step text contains that pattern.
-- No-bake recipes leave oven_temp and bake_minutes null, as elsewhere.
--
-- The category tile shows the photo of whichever halloween row the
-- catalog query returns first (usually the first inserted, but not
-- guaranteed).
--
-- Photos are free-licence images from Unsplash and Pexels; credits are in
-- the comment above each row.

begin;

insert into public.recipes_sweettreats
  (user_id, category, is_public, name, ingredients, steps, image_url,
   description, oven_temp, prep_minutes, bake_minutes, servings, difficulty,
   tags, is_no_bake)
select
  '652e1838-be79-42ee-96e4-9cabfd7a6e40'::uuid, 'halloween', true, v.name, v.ingredients, v.steps,
  v.image_url, v.description, v.oven_temp, v.prep_minutes, v.bake_minutes,
  v.servings, v.difficulty, v.tags, v.is_no_bake
from (values
  -- Pumpkin Spice Cupcakes (photo: Pexels, Gabby K)
  ('Pumpkin Spice Cupcakes',
   array['200g plain flour', '150g light brown sugar', '2 tsp baking powder', '2 tsp pumpkin spice', '1/2 tsp salt', '2 eggs', '200g pumpkin purée', '120ml vegetable oil', '1 tsp vanilla extract', '200g cream cheese', '75g butter, softened', '250g icing sugar', '1/2 tsp ground cinnamon']::text[],
   E'1. Preheat oven to 180°C and line a 12-hole muffin tin with paper cases.\n2. Whisk the flour, brown sugar, baking powder, pumpkin spice and salt in a large bowl.\n3. In another bowl whisk the eggs, pumpkin purée, oil and vanilla until smooth.\n4. Stir the wet mixture into the dry ingredients until just combined.\n5. Divide between the cases and bake for 18-20 minutes, until a skewer comes out clean.\n6. Cool completely on a wire rack.\n7. Beat the cream cheese and butter, then beat in the icing sugar and cinnamon until fluffy.\n8. Pipe the frosting onto the cupcakes and dust with a little extra cinnamon.',
   'https://images.pexels.com/photos/5634028/pexels-photo-5634028.jpeg?auto=compress&cs=tinysrgb&w=400',
   'Soft pumpkin cupcakes warmed with pumpkin spice and topped with cinnamon cream cheese frosting.',
   '180°C', 20, 20, 12, 'easy',
   array['pumpkin', 'cream cheese', 'autumn']::text[], false),
  -- Ghost Cupcakes (photo: Unsplash, Stacy)
  ('Ghost Cupcakes',
   array['175g plain flour', '150g caster sugar', '1½ tsp baking powder', '1/4 tsp salt', '115g butter, softened', '2 eggs', '120ml milk', '2 tsp vanilla extract', '3 egg whites', '200g caster sugar (for the frosting)', '1/4 tsp cream of tartar', '24 mini chocolate chips']::text[],
   E'1. Preheat oven to 180°C and line a muffin tin with 12 paper cases.\n2. Beat the butter and sugar until pale, then beat in the eggs one at a time.\n3. Mix the flour, baking powder and salt, then fold into the batter alternately with the milk and half the vanilla.\n4. Divide between the cases and bake for 18-20 minutes, then cool completely.\n5. Whisk the egg whites, frosting sugar and cream of tartar in a heatproof bowl over simmering water until the sugar dissolves.\n6. Take off the heat and whisk on high speed until thick, glossy and cool.\n7. Beat in the remaining vanilla, then pipe a tall swirl onto each cupcake to make a ghost.\n8. Press in two mini chocolate chips for eyes.',
   'https://images.unsplash.com/photo-1766186930331-a4a45ae2c662?w=400',
   'Vanilla cupcakes crowned with tall swirls of marshmallowy meringue frosting, piped into little ghosts.',
   '180°C', 40, 20, 12, 'medium',
   array['meringue', 'vanilla', 'kids party']::text[], false),
  -- Witch Finger Cookies (photo: Pexels, Vera Krumova)
  ('Witch Finger Cookies',
   array['225g butter, softened', '100g icing sugar', '1 egg', '1 tsp vanilla extract', '1 tsp almond extract', '300g plain flour', '1 tsp baking powder', '1/2 tsp salt', '24 whole blanched almonds', 'red decorating gel']::text[],
   E'1. Beat the butter, icing sugar, egg, vanilla and almond extract until smooth.\n2. Mix in the flour, baking powder and salt, then chill the dough for 30 minutes.\n3. Preheat oven to 175°C and line two baking trays.\n4. Roll heaped teaspoons of dough into thin finger shapes.\n5. Press an almond into one end for the nail and squeeze the middle to make knuckles.\n6. Score a few lines across each knuckle with a knife.\n7. Bake for 18-20 minutes until lightly golden, then cool on the tray.\n8. Lift each almond, add a dab of red gel underneath and press it back in.',
   'https://images.pexels.com/photos/29170530/pexels-photo-29170530.jpeg?auto=compress&cs=tinysrgb&w=400',
   'Buttery almond shortbread shaped into knobbly witch fingers with almond nails and a red gel trim.',
   '175°C', 30, 20, 24, 'medium',
   array['shortbread', 'almond', 'spooky']::text[], false),
  -- Graveyard Dirt Cups (photo: Pexels, Mou Foto Diseno)
  ('Graveyard Dirt Cups',
   array['500ml cold milk', '100g instant chocolate pudding mix', '200ml double cream', '2 tbsp icing sugar', '12 chocolate sandwich cookies', '6 shortbread fingers', 'red writing icing', 'gummy worms']::text[],
   E'1. Whisk the milk and pudding mix for 2 minutes, then chill until set.\n2. Whip the cream with the icing sugar to soft peaks and fold into the pudding.\n3. Crush the sandwich cookies into fine crumbs in a bag with a rolling pin.\n4. Layer pudding and crumbs in six glasses, finishing with a thick layer of crumbs.\n5. Write RIP on the shortbread fingers with writing icing.\n6. Push a tombstone into each cup and add a few gummy worms.\n7. Chill for at least 1 hour before serving.',
   'https://images.pexels.com/photos/37325357/pexels-photo-37325357.jpeg?auto=compress&cs=tinysrgb&w=400',
   'Chocolate pudding layered with crushed cookie dirt and topped with biscuit tombstones.',
   null, 25, null, 6, 'easy',
   array['chocolate pudding', 'kids party', 'make-ahead']::text[], true),
  -- Caramel Apples (photo: Unsplash, Hansheng Zhao)
  ('Caramel Apples',
   array['6 small apples', '6 wooden sticks', '200g light brown sugar', '120ml double cream', '60g butter', '60ml golden syrup', '1/2 tsp salt', '1 tsp vanilla extract', '100g roasted peanuts, chopped']::text[],
   E'1. Wash and thoroughly dry the apples, remove the stalks and push a stick into each.\n2. Line a tray with baking paper and lightly butter it.\n3. Heat the sugar, cream, butter, golden syrup and salt in a saucepan, stirring until melted.\n4. Boil without stirring until it reaches 120°C on a sugar thermometer.\n5. Take off the heat, stir in the vanilla and let it cool for 5 minutes.\n6. Dip each apple in the caramel, turning to coat, and let the excess drip off.\n7. Roll the bottom half in chopped peanuts and stand on the tray.\n8. Leave to set for 30 minutes before serving.',
   'https://images.unsplash.com/photo-1789315461400-d100994ed1c8?w=400',
   'Crisp apples dipped in homemade buttery caramel and rolled in chopped roasted peanuts.',
   null, 30, null, 6, 'medium',
   array['caramel', 'apples', 'peanuts']::text[], true),
  -- Monster Brownies (photo: Unsplash, Salah Ait Mokhtar)
  ('Monster Brownies',
   array['185g dark chocolate', '185g butter', '3 eggs', '250g caster sugar', '85g plain flour', '40g cocoa powder', '1/4 tsp salt', '16 pink and white marshmallows', '32 candy eyes', 'colourful sprinkles']::text[],
   E'1. Preheat oven to 180°C and line a 20cm square tin.\n2. Melt the chocolate and butter together, then cool slightly.\n3. Whisk the eggs and sugar until thick and pale, then fold in the chocolate mixture.\n4. Sift in the flour, cocoa and salt and fold until just combined.\n5. Pour into the tin and bake for 25 minutes, until just set in the middle.\n6. Cool completely, then cut into 16 squares.\n7. Snip the marshmallows in half and press one onto each brownie as a mouth.\n8. Stick on candy eyes and sprinkles with a dab of melted chocolate.',
   'https://images.unsplash.com/photo-1734212530934-e28be789e1db?w=400',
   'Fudgy dark chocolate brownies turned into silly monsters with candy eyes and marshmallow mouths.',
   '180°C', 30, 25, 16, 'easy',
   array['fudgy', 'kids party', 'dark chocolate']::text[], false),
  -- Pumpkin Cheesecake (photo: Unsplash, Serghey Savchuk)
  ('Pumpkin Cheesecake',
   array['250g digestive biscuits', '100g butter, melted', '600g cream cheese', '150g light brown sugar', '250g pumpkin purée', '3 eggs', '2 tbsp plain flour', '2 tsp pumpkin spice', '1 tsp vanilla extract', '2 tbsp pumpkin seeds']::text[],
   E'1. Preheat oven to 160°C and line the base of a 23cm springform tin.\n2. Crush the biscuits, mix with the melted butter and press firmly into the tin.\n3. Beat the cream cheese and brown sugar until smooth.\n4. Beat in the pumpkin purée, flour, pumpkin spice and vanilla.\n5. Add the eggs one at a time, mixing on low just until combined.\n6. Pour over the base and bake for 55-60 minutes, until set with a slight wobble.\n7. Turn off the oven and leave the cheesecake inside with the door ajar for 1 hour.\n8. Chill for at least 4 hours, then scatter with pumpkin seeds before serving.',
   'https://images.unsplash.com/photo-1702745100358-8379ba0e59c9?w=400',
   'Creamy spiced pumpkin cheesecake on a buttery biscuit base, finished with toasted pumpkin seeds.',
   '160°C', 30, 60, 12, 'medium',
   array['pumpkin', 'cheesecake', 'autumn']::text[], false),
  -- Monster Truffles (photo: Pexels, Karina Ustiuzhanina)
  ('Monster Truffles',
   array['200g dark chocolate, chopped', '150ml double cream', '25g butter', '50g desiccated coconut', 'green food colouring', '50g orange sprinkles', '40 candy eyes']::text[],
   E'1. Heat the cream and butter until steaming and pour over the chopped chocolate.\n2. Leave for 2 minutes, then stir until smooth and glossy.\n3. Chill for 2 hours until firm enough to scoop.\n4. Rub a few drops of green colouring into the coconut until evenly tinted.\n5. Roll teaspoons of ganache into balls.\n6. Roll half in the green coconut and half in the orange sprinkles.\n7. Press two candy eyes onto each truffle.\n8. Keep chilled until serving.',
   'https://images.pexels.com/photos/14122742/pexels-photo-14122742.jpeg?auto=compress&cs=tinysrgb&w=400',
   'Dark chocolate ganache truffles rolled in green coconut and orange sprinkles, with candy eyes.',
   null, 40, null, 20, 'easy',
   array['ganache', 'gift', 'kids party']::text[], true),
  -- Ghost Marshmallow Hot Chocolate (photo: Pexels, Betul Nur)
  ('Ghost Marshmallow Hot Chocolate',
   array['500ml whole milk', '100g milk chocolate, chopped', '2 tbsp cocoa powder', '1 tbsp caster sugar', '1/2 tsp vanilla extract', '3 tbsp chocolate sauce', '6 large marshmallows', 'black writing icing']::text[],
   E'1. Flatten each marshmallow slightly and pinch the bottom edge to make a ghost shape.\n2. Draw two eyes and a mouth on each ghost with black writing icing.\n3. Drizzle chocolate sauce around the inside rim of two mugs.\n4. Heat the milk in a saucepan until steaming but not boiling.\n5. Whisk in the chocolate, cocoa, sugar and vanilla until smooth.\n6. Pour into the mugs and float three marshmallow ghosts on top of each.',
   'https://images.pexels.com/photos/10976073/pexels-photo-10976073.jpeg?auto=compress&cs=tinysrgb&w=400',
   'Rich, creamy hot chocolate topped with little marshmallow ghosts and a chocolate-drizzled mug.',
   null, 15, null, 2, 'easy',
   array['hot chocolate', 'drink', 'cosy']::text[], true),
  -- Jack-o'-Lantern Cookies (photo: Pexels, Nathanjhilton)
  ('Jack-o''-Lantern Cookies',
   array['225g butter, softened', '200g caster sugar', '1 egg', '1 tsp vanilla extract', '375g plain flour', '1/2 tsp baking powder', '1/4 tsp salt', '300g royal icing sugar', 'orange food colouring', 'black food colouring']::text[],
   E'1. Cream the butter and sugar until light, then beat in the egg and vanilla.\n2. Mix in the flour, baking powder and salt to form a dough.\n3. Roll out between baking paper to 5mm thick and chill for 30 minutes.\n4. Preheat oven to 180°C and line two baking trays.\n5. Cut out pumpkin shapes and bake for 10-12 minutes until the edges are just golden.\n6. Cool completely on a wire rack.\n7. Mix the royal icing sugar with water, tint most of it orange and a little black.\n8. Flood the cookies with orange icing and let it set for 1 hour.\n9. Pipe jack-o''-lantern faces with the black icing.',
   'https://images.pexels.com/photos/5748380/pexels-photo-5748380.jpeg?auto=compress&cs=tinysrgb&w=400',
   'Crisp vanilla cut-out cookies flooded with orange icing and piped with jack-o''-lantern faces.',
   '180°C', 60, 12, 12, 'medium',
   array['cut-out cookies', 'royal icing', 'pumpkin']::text[], false),
  -- Graveyard Dirt Cake (photo: Unsplash, Sung Jin Cho)
  ('Graveyard Dirt Cake',
   array['300g chocolate sandwich cookies', '225g cream cheese, softened', '60g butter, softened', '100g icing sugar', '700ml cold milk', '200g instant chocolate pudding mix', '300ml double cream', '100g white chocolate', '6 shortbread fingers', 'black writing icing', 'gummy worms']::text[],
   E'1. Crush the sandwich cookies into fine crumbs and set aside.\n2. Beat the cream cheese, butter and icing sugar until smooth.\n3. Whisk the milk and pudding mix for 2 minutes and let it thicken.\n4. Whip the cream to soft peaks.\n5. Fold the cream cheese mixture and whipped cream into the pudding.\n6. Spread half the crumbs in a 23x33cm dish, add the pudding mixture and top with the remaining crumbs.\n7. Pipe melted white chocolate into ghost shapes on baking paper and let them set.\n8. Write RIP on the shortbread fingers and give the ghosts eyes with writing icing.\n9. Decorate with the tombstones, ghosts and gummy worms, then chill for 4 hours.',
   'https://images.unsplash.com/photo-1704723143269-daf108fe9ac4?w=400',
   'A no-bake chocolate pudding cake under a layer of cookie dirt, decorated with tombstones and white chocolate ghosts.',
   null, 45, null, 12, 'easy',
   array['chocolate pudding', 'party', 'make-ahead']::text[], true),
  -- Ghost Strawberries (photo: Unsplash, serjan midili)
  ('Ghost Strawberries',
   array['20 large strawberries', '200g white chocolate', '1 tsp coconut oil', '40 candy eyes']::text[],
   E'1. Wash the strawberries and dry them completely.\n2. Line a tray with baking paper.\n3. Melt the white chocolate with the coconut oil in short bursts in the microwave, stirring often.\n4. Holding the leaves, dip each strawberry and let the excess drip off.\n5. Lay on the tray and press on two candy eyes before the chocolate sets.\n6. Chill for 15 minutes until firm.',
   'https://images.unsplash.com/photo-1694807929406-6fc850cdbfb0?w=400',
   'Fresh strawberries dipped in white chocolate and given candy eyes to turn them into little ghosts.',
   null, 20, null, 20, 'easy',
   array['strawberries', 'white chocolate', 'quick']::text[], true)
) as v(name, ingredients, steps, image_url, description, oven_temp,
       prep_minutes, bake_minutes, servings, difficulty, tags, is_no_bake)
where not exists (
  select 1 from public.recipes_sweettreats r
  where r.category = 'halloween' and r.name = v.name
);

commit;

-- Check: should list all 12, public, owned by SweetTreatsTeam.
select name, is_public, is_no_bake, oven_temp, difficulty, image_url
from public.recipes_sweettreats
where category = 'halloween'
order by created_at;
