import 'package:recipe_app/features/recipe_ingredients/class_recipes.dart';

class ChocolateRecipes {
  static List<Recipe> chocolateRecipes = [
    Recipe(
      id: '1',
      name: 'Classic Fudgy Brownies',
      imageUrl:
          'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
      cookingTime: '45 min',
      category: 'chocolate',
      ingredients: [
        '200g dark chocolate, chopped',
        '150g butter',
        '200g caster sugar',
        '3 large eggs',
        '75g plain flour',
        '30g cocoa powder',
        '1/2 tsp vanilla extract',
        'Pinch of salt',
        '100g chocolate chips (optional)',
      ],
      instructions: [
        'Preheat oven to 180°C. Line a 20cm square tin with parchment paper.',
        'Melt chocolate and butter in a double boiler until smooth.',
        'Remove from heat and whisk in sugar until combined.',
        'Beat in eggs one at a time, then add vanilla.',
        'Sift flour and cocoa powder, fold into mixture with salt.',
        'Add chocolate chips if using.',
        'Pour into prepared tin and bake for 25-30 min.',
        'Cool completely before cutting into squares.',
      ],
    ),

    Recipe(
      id: '2',
      name: 'Decadent Chocolate Cake',
      imageUrl:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
      cookingTime: '1 h 15 min',
      category: 'chocolate',
      ingredients: [
        '200g plain flour',
        '200g caster sugar',
        '75g cocoa powder',
        '2 tsp baking powder',
        '1 tsp baking soda',
        '2 eggs',
        '250ml buttermilk',
        '125ml vegetable oil',
        '2 tsp vanilla extract',
        '250ml hot coffee',
      ],
      instructions: [
        'Preheat oven to 180°C. Grease two 20cm cake tins.',
        'Mix all dry ingredients in a large bowl.',
        'Whisk eggs, buttermilk, oil, and vanilla in another bowl.',
        'Combine wet and dry ingredients.',
        'Gradually add hot coffee, mixing until smooth.',
        'Divide between tins and bake for 30-35 min.',
        'Cool completely before frosting.',
        'Frost with your favorite chocolate buttercream.',
      ],
    ),

    Recipe(
      id: '3',
      name: 'Chocolate Cake Pops',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1667031518595-9cb4b0d504ef?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y2hvY29sYXRlJTIwYmFya3xlbnwwfHwwfHx8MA%3D%3D',
      cookingTime: '2 h',
      category: 'chocolate',
      ingredients: [
        '1 box chocolate cake mix (plus ingredients called for)',
        '450g cream cheese frosting',
        '700g chocolate candy coating',
        '48 cake pop sticks',
        'Sprinkles for decoration',
      ],
      instructions: [
        'Bake cake according to package directions. Cool completely.',
        'Crumble cake into fine crumbs.',
        'Mix crumbs with frosting until well combined.',
        'Roll mixture into 48 balls, place on baking sheet.',
        'Chill for 2 h.',
        'Melt chocolate coating according to package directions.',
        'Dip stick 1cm into chocolate, then insert into cake ball.',
        'Dip entire cake pop into chocolate, tap off excess.',
        'Add sprinkles before chocolate sets. Place in styrofoam to dry.',
      ],
    ),

    Recipe(
      id: '4',
      name: 'Silky Chocolate Mousse',
      imageUrl:
          'https://bakewithzoha.com/wp-content/uploads/2024/10/chocolate-mousse-featured.jpg',
      cookingTime: '30 min + 4 h ',
      category: 'chocolate',
      ingredients: [
        '200g dark chocolate (70%), chopped',
        '6 large eggs, separated',
        '75g caster sugar',
        '300ml double cream',
        '2 tbsp coffee liqueur (optional)',
        'Pinch of salt',
      ],
      instructions: [
        'Melt chocolate in double boiler until smooth. Cool slightly.',
        'Whisk egg yolks with half the sugar until pale.',
        'Stir melted chocolate and liqueur into yolk mixture.',
        'Whip cream to soft peaks.',
        'Beat egg whites with salt until foamy, gradually add remaining sugar.',
        'Beat until stiff peaks form.',
        'Fold 1/3 of whites into chocolate mixture.',
        'Fold in whipped cream, then remaining whites.',
        'Spoon into glasses, chill for 4 h before serving.',
      ],
    ),

    Recipe(
      id: '5',
      name: 'Chocolate Lava Cakes',
      imageUrl:
          'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=400',
      cookingTime: '25 min',
      category: 'chocolate',
      ingredients: [
        '100g dark chocolate, chopped',
        '100g butter',
        '2 large eggs',
        '2 large egg yolks',
        '60g caster sugar',
        '2 tbsp plain flour',
        'Butter for ramekins',
        'Cocoa powder for dusting',
      ],
      instructions: [
        'Preheat oven to 220°C. Butter 4 ramekins and dust with cocoa.',
        'Melt chocolate and butter in double boiler.',
        'Whisk eggs, egg yolks, and sugar until thick and pale.',
        'Stir in melted chocolate mixture and flour.',
        'Divide between ramekins.',
        'Bake for 12-14 min until edges are firm but center jiggles.',
        'Let stand 1 minute, then run knife around edges.',
        'Invert onto plates and serve immediately with ice cream.',
      ],
    ),

    Recipe(
      id: '6',
      name: 'Chocolate Truffles',
      imageUrl:
          'https://whatjessicabakednext.com/wp-content/uploads/2023/01/Choc-Truffles-WJBN.jpg',
      cookingTime: '45 min + 2 h ',
      category: 'chocolate',
      ingredients: [
        '400g dark chocolate, finely chopped',
        '300ml double cream',
        '2 tbsp butter',
        '2 tbsp brandy or rum (optional)',
        'Cocoa powder for rolling',
        'Chopped nuts (optional)',
        'Shredded coconut (optional)',
      ],
      instructions: [
        'Place chocolate in a large bowl.',
        'Heat cream in a saucepan until just simmering.',
        'Pour hot cream over chocolate, let sit 2 min.',
        'Stir from center outward until smooth.',
        'Stir in butter and alcohol if using.',
        'Cover and chill for 2 h until firm.',
        'Using a spoon, scoop mixture and roll into balls.',
        'Roll in cocoa powder, nuts, or coconut.',
        'Store in refrigerator for up to 1 week.',
      ],
    ),

    Recipe(
      id: '7',
      name: 'Chocolate Chip Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400',
      cookingTime: '25 min',
      category: 'chocolate',
      ingredients: [
        '225g plain flour',
        '1 tsp baking soda',
        '1 tsp salt',
        '225g butter, softened',
        '150g brown sugar',
        '100g caster sugar',
        '2 large eggs',
        '2 tsp vanilla extract',
        '350g chocolate chips',
      ],
      instructions: [
        'Preheat oven to 190°C.',
        'Mix flour, baking soda, and salt in a bowl.',
        'Cream butter and both sugars until light and fluffy.',
        'Beat in eggs one at a time, then vanilla.',
        'Gradually mix in flour mixture.',
        'Stir in chocolate chips.',
        'Drop rounded tablespoons onto ungreased baking sheets.',
        'Bake 9-11 min until golden brown.',
        'Cool on baking sheet for 2 min before removing.',
      ],
    ),

    Recipe(
      id: '8',
      name: 'Chocolate Fudge',
      imageUrl:
          'https://media.istockphoto.com/id/1185416324/photo/homemade-raw-milk-free-sugar-free-vegan-chocolate-brownies-or-fudge.webp?a=1&b=1&s=612x612&w=0&k=20&c=aWzJkgAAXtoWvaJdrzf_X5LsLMkpZhCY5iK9AJ6IbXM=',
      cookingTime: '20 min + 2 h ',
      category: 'chocolate',
      ingredients: [
        '400g dark chocolate, chopped',
        '397g sweetened condensed milk',
        '50g butter',
        '1 tsp vanilla extract',
        '100g chopped walnuts (optional)',
        'Pinch of salt',
      ],
      instructions: [
        'Line a 20cm square tin with parchment paper.',
        'Melt chocolate, condensed milk, and butter in double boiler.',
        'Stir constantly until smooth and thick (about 10 min).',
        'Remove from heat, stir in vanilla, salt, and nuts if using.',
        'Pour into prepared tin and smooth top.',
        'Refrigerate for 2 h until set.',
        'Cut into squares and serve.',
        'Store covered in refrigerator for up to 1 week.',
      ],
    ),

    Recipe(
      id: '9',
      name: 'Chocolate Cupcakes',
      imageUrl:
          'https://www.lifeloveandsugar.com/wp-content/uploads/2023/06/Chocolate-Cupcakes-Recipe3.jpg',
      cookingTime: '35 min',
      category: 'chocolate',
      ingredients: [
        '175g plain flour',
        '175g caster sugar',
        '40g cocoa powder',
        '1.5 tsp baking powder',
        '1/2 tsp salt',
        '2 eggs',
        '175ml milk',
        '85ml vegetable oil',
        '1 tsp vanilla extract',
        '175ml hot water',
      ],
      instructions: [
        'Preheat oven to 180°C. Line muffin tin with paper cases.',
        'Mix flour, sugar, cocoa, baking powder, and salt.',
        'Beat eggs, milk, oil, and vanilla in another bowl.',
        'Combine wet and dry ingredients.',
        'Gradually stir in hot water until smooth.',
        'Fill cases 2/3 full.',
        'Bake 18-20 min until toothpick comes out clean.',
        'Cool completely before frosting with chocolate buttercream.',
      ],
    ),

    Recipe(
      id: '10',
      name: 'Chocolate Bark',
      imageUrl:
          'https://images.unsplash.com/photo-1679143121492-820c69266ab8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGNob2NvbGF0ZSUyMGJhcmt8ZW58MHx8MHx8fDA%3D',
      cookingTime: '15 min + 1 h ',
      category: 'chocolate',
      ingredients: [
        '500g dark chocolate, chopped',
        '100g dried cranberries',
        '100g chopped almonds',
        '50g pistachios, chopped',
        '2 tbsp sea salt flakes',
        '50g white chocolate, melted (for drizzling)',
      ],
      instructions: [
        'Line a large baking sheet with parchment paper.',
        'Melt dark chocolate in double boiler until smooth.',
        'Pour onto prepared baking sheet, spread to 1cm thickness.',
        'Sprinkle cranberries, almonds, and pistachios over chocolate.',
        'Gently press toppings into chocolate.',
        'Drizzle with melted white chocolate.',
        'Sprinkle with sea salt.',
        'Refrigerate for 1 h until set.',
        'Break into pieces and store in airtight container.',
      ],
    ),
  ];

  // Method to get all chocolate recipes
  static List<Recipe> getAllChocolateRecipes() {
    return chocolateRecipes;
  }

  // Method to get recipe by id
  static Recipe? getRecipeById(String id) {
    try {
      return chocolateRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }
}
