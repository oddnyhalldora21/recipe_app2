import 'package:recipe_app/features/recipe_ingredients/class_recipes.dart';

class FrozenTreatsRecipes {
  static List<Recipe> frozenTreatsRecipes = [
    Recipe(
      id: '21',
      name: 'Classic Vanilla Ice Cream',
      imageUrl:
          'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=400',
      cookingTime: '30 minutes + 4 hours freezing',
      category: 'frozen',
      ingredients: [
        '2 cups heavy cream',
        '1 cup whole milk',
        '3/4 cup granulated sugar',
        '6 large egg yolks',
        '2 tsp vanilla extract',
        'Pinch of salt',
      ],
      instructions: [
        'Heat cream and milk in a saucepan until just simmering.',
        'Whisk egg yolks and sugar until pale and thick.',
        'Slowly pour hot cream into yolks, whisking constantly.',
        'Return mixture to saucepan and cook over low heat, stirring constantly.',
        'Cook until mixture coats the back of a spoon (170°F).',
        'Remove from heat, stir in vanilla and salt.',
        'Strain through fine-mesh sieve and cool completely.',
        'Churn in ice cream maker according to manufacturer instructions.',
        'Transfer to container and freeze for at least 4 hours.',
      ],
    ),

    Recipe(
      id: '22',
      name: 'Strawberry Popsicles',
      imageUrl:
          'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
      cookingTime: '15 minutes + 6 hours freezing',
      category: 'frozen',
      ingredients: [
        '500g fresh strawberries, hulled',
        '1/2 cup granulated sugar',
        '2 tbsp fresh lemon juice',
        '1/4 cup water',
        '1 tbsp honey (optional)',
      ],
      instructions: [
        'Blend strawberries, sugar, lemon juice, water, and honey until smooth.',
        'Strain mixture if you want smooth popsicles (optional).',
        'Taste and adjust sweetness if needed.',
        'Pour mixture into popsicle molds, leaving 1cm space at top.',
        'Insert popsicle sticks.',
        'Freeze for at least 6 hours or overnight.',
        'To remove, run warm water over outside of molds.',
        'Store in freezer for up to 3 months.',
      ],
    ),

    Recipe(
      id: '23',
      name: 'Chocolate Gelato',
      imageUrl:
          'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400',
      cookingTime: '45 minutes + 4 hours freezing',
      category: 'frozen',
      ingredients: [
        '2 cups whole milk',
        '1/2 cup heavy cream',
        '3/4 cup granulated sugar',
        '5 large egg yolks',
        '1/3 cup unsweetened cocoa powder',
        '200g dark chocolate, finely chopped',
        '1 tsp vanilla extract',
        'Pinch of salt',
      ],
      instructions: [
        'Heat milk and cream in a saucepan until steaming.',
        'Whisk egg yolks, sugar, and cocoa powder until smooth.',
        'Slowly add hot milk mixture to egg mixture, whisking constantly.',
        'Return to saucepan and cook over medium-low heat, stirring constantly.',
        'Cook until mixture coats spoon and reaches 170°F.',
        'Remove from heat, add chopped chocolate, stir until melted.',
        'Add vanilla and salt, strain through fine-mesh sieve.',
        'Cool completely, then churn in ice cream maker.',
        'Freeze for at least 4 hours before serving.',
      ],
    ),

    Recipe(
      id: '24',
      name: 'Mango Sorbet',
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      cookingTime: '20 minutes + 4 hours freezing',
      category: 'frozen',
      ingredients: [
        '4 large ripe mangoes, peeled and chopped',
        '3/4 cup granulated sugar',
        '1/2 cup water',
        '3 tbsp fresh lime juice',
        '1 tbsp lime zest',
        'Pinch of salt',
      ],
      instructions: [
        'Make simple syrup by boiling water and sugar until sugar dissolves.',
        'Cool syrup completely.',
        'Puree mangoes in blender until completely smooth.',
        'Add cooled syrup, lime juice, lime zest, and salt to mango puree.',
        'Blend until well combined.',
        'Strain mixture through fine-mesh sieve if desired.',
        'Churn in ice cream maker according to manufacturer instructions.',
        'Transfer to container and freeze for at least 4 hours.',
        'Let soften 5-10 minutes before serving.',
      ],
    ),

    Recipe(
      id: '25',
      name: 'Ice Cream Sandwiches',
      imageUrl:
          'https://images.unsplash.com/photo-1567206563064-6f60f40a2b57?w=400',
      cookingTime: '45 minutes + 2 hours freezing',
      category: 'frozen',
      ingredients: [
        'Cookies: 2 1/4 cups plain flour',
        '1 tsp baking soda',
        '1 tsp salt',
        '1 cup butter, softened',
        '3/4 cup brown sugar',
        '1/2 cup granulated sugar',
        '2 large eggs',
        '2 tsp vanilla extract',
        '2 cups chocolate chips',
        'Filling: 1 liter vanilla ice cream, softened',
      ],
      instructions: [
        'Preheat oven to 190°C. Line baking sheets with parchment.',
        'Mix flour, baking soda, and salt in a bowl.',
        'Cream butter and both sugars until fluffy.',
        'Beat in eggs and vanilla.',
        'Gradually mix in flour mixture, then chocolate chips.',
        'Drop large spoonfuls onto baking sheets, flatten slightly.',
        'Bake 10-12 minutes until golden. Cool completely.',
        'Spread softened ice cream on flat side of one cookie.',
        'Top with another cookie, press gently.',
        'Wrap in plastic and freeze for 2 hours before serving.',
      ],
    ),

    Recipe(
      id: '26',
      name: 'Frozen Yogurt Bark',
      imageUrl:
          'https://images.unsplash.com/photo-1481391319762-47dff72954d9?w=400',
      cookingTime: '10 minutes + 3 hours freezing',
      category: 'frozen',
      ingredients: [
        '2 cups Greek yogurt',
        '3 tbsp honey',
        '1 tsp vanilla extract',
        '1/2 cup mixed berries',
        '1/4 cup chopped nuts',
        '2 tbsp mini chocolate chips',
        '1 tbsp chia seeds (optional)',
      ],
      instructions: [
        'Line a baking sheet with parchment paper.',
        'Mix Greek yogurt, honey, and vanilla until smooth.',
        'Spread mixture evenly on prepared baking sheet to 1cm thickness.',
        'Sprinkle berries, nuts, chocolate chips, and chia seeds over yogurt.',
        'Gently press toppings into yogurt.',
        'Freeze for at least 3 hours until completely solid.',
        'Break into pieces with your hands or knife.',
        'Store in freezer in airtight container for up to 1 month.',
        'Let sit 2-3 minutes before eating if very hard.',
      ],
    ),

    Recipe(
      id: '27',
      name: 'Banana Nice Cream',
      imageUrl:
          'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd?w=400',
      cookingTime: '10 minutes',
      category: 'frozen',
      ingredients: [
        '4 ripe bananas, sliced and frozen',
        '2-3 tbsp milk of choice',
        '1 tbsp peanut butter (optional)',
        '1 tsp vanilla extract',
        '1 tbsp honey or maple syrup (optional)',
        'Toppings: chocolate chips, nuts, berries',
      ],
      instructions: [
        'Freeze banana slices for at least 2 hours.',
        'Add frozen bananas to food processor.',
        'Process until bananas break down into crumbs.',
        'Add milk, peanut butter, vanilla, and sweetener if using.',
        'Continue processing until smooth and creamy.',
        'Scrape down sides as needed.',
        'Serve immediately for soft-serve consistency.',
        'Or freeze for 1-2 hours for firmer ice cream.',
        'Top with desired toppings before serving.',
      ],
    ),

    Recipe(
      id: '28',
      name: 'Coconut Popsicles',
      imageUrl:
          'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
      cookingTime: '15 minutes + 6 hours freezing',
      category: 'frozen',
      ingredients: [
        '1 can (400ml) coconut milk',
        '1/2 cup condensed milk',
        '1/4 cup granulated sugar',
        '1 tsp vanilla extract',
        '1/4 cup shredded coconut',
        '2 tbsp lime juice (optional)',
        '1 tbsp lime zest (optional)',
      ],
      instructions: [
        'Whisk coconut milk, condensed milk, and sugar until sugar dissolves.',
        'Stir in vanilla extract and shredded coconut.',
        'Add lime juice and zest if making lime coconut version.',
        'Pour mixture into popsicle molds.',
        'Insert popsicle sticks.',
        'Freeze for at least 6 hours or overnight.',
        'To remove, run warm water over molds briefly.',
        'Store in freezer for up to 2 months.',
        'Let sit 1-2 minutes before eating if very hard.',
      ],
    ),

    Recipe(
      id: '29',
      name: 'Chocolate Fudge Pops',
      imageUrl:
          'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=400',
      cookingTime: '20 minutes + 6 hours freezing',
      category: 'frozen',
      ingredients: [
        '2 cups whole milk',
        '1/2 cup heavy cream',
        '1/2 cup granulated sugar',
        '1/3 cup unsweetened cocoa powder',
        '2 tbsp cornstarch',
        '100g dark chocolate, chopped',
        '1 tsp vanilla extract',
        'Pinch of salt',
      ],
      instructions: [
        'Whisk milk, cream, sugar, cocoa powder, and cornstarch in saucepan.',
        'Cook over medium heat, whisking constantly, until thickened.',
        'Remove from heat, add chopped chocolate, whisk until melted.',
        'Stir in vanilla and salt.',
        'Cool mixture to room temperature.',
        'Pour into popsicle molds, leaving space at top.',
        'Insert sticks and freeze for at least 6 hours.',
        'Run warm water over molds to remove popsicles.',
        'Store in freezer for up to 3 months.',
      ],
    ),

    Recipe(
      id: '30',
      name: 'Affogato Ice Cream',
      imageUrl:
          'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400',
      cookingTime: '5 minutes',
      category: 'frozen',
      ingredients: [
        '4 scoops vanilla ice cream',
        '4 shots hot espresso',
        '2 tbsp amaretto (optional)',
        '4 small amaretti cookies',
        'Dark chocolate shavings for garnish',
      ],
      instructions: [
        'Place one scoop of vanilla ice cream in each serving glass.',
        'Prepare hot espresso shots.',
        'Add amaretto to espresso if using.',
        'Just before serving, pour hot espresso over ice cream.',
        'The hot coffee will partially melt the ice cream.',
        'Garnish with amaretti cookies and chocolate shavings.',
        'Serve immediately with small spoons.',
        'Enjoy the contrast of hot and cold.',
        'Best consumed within 2-3 minutes of assembly.',
      ],
    ),
  ];

  // Method to get all frozen treats recipes
  static List<Recipe> getAllFrozenTreatsRecipes() {
    return frozenTreatsRecipes;
  }

  // Method to get recipe by id
  static Recipe? getRecipeById(String id) {
    try {
      return frozenTreatsRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }
}
