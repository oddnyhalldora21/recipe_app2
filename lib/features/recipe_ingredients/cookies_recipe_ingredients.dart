import 'package:recipe_app/features/recipe_ingredients/class_recipes.dart';

class CookieRecipes {
  static List<Recipe> cookieRecipes = [
    Recipe(
      id: '31',
      name: 'Classic Sugar Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400',
      cookingTime: '25 minutes',
      category: 'cookies',
      ingredients: [
        '2 3/4 cups plain flour',
        '1 tsp baking soda',
        '1/2 tsp salt',
        '1 cup butter, softened',
        '1 1/2 cups granulated sugar',
        '1 large egg',
        '1 tsp vanilla extract',
        'Colored sugar for rolling',
      ],
      instructions: [
        'Preheat oven to 190°C.',
        'Mix flour, baking soda, and salt in a bowl.',
        'Cream butter and sugar until light and fluffy.',
        'Beat in egg and vanilla extract.',
        'Gradually blend in flour mixture.',
        'Shape dough into walnut-sized balls.',
        'Roll balls in colored sugar.',
        'Place 5cm apart on ungreased baking sheets.',
        'Bake 8-10 minutes until lightly golden.',
        'Cool on baking sheet for 2 minutes before removing.',
      ],
    ),

    Recipe(
      id: '32',
      name: 'Double Chocolate Chip Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400',
      cookingTime: '30 minutes',
      category: 'cookies',
      ingredients: [
        '1 1/4 cups plain flour',
        '1/3 cup unsweetened cocoa powder',
        '1/2 tsp baking soda',
        '1/2 tsp salt',
        '1/2 cup butter, softened',
        '1/2 cup brown sugar',
        '1/4 cup granulated sugar',
        '1 large egg',
        '1 tsp vanilla extract',
        '1 cup white chocolate chips',
      ],
      instructions: [
        'Preheat oven to 180°C. Line baking sheets with parchment.',
        'Whisk flour, cocoa powder, baking soda, and salt.',
        'Cream butter and both sugars until fluffy.',
        'Beat in egg and vanilla extract.',
        'Gradually mix in flour mixture until just combined.',
        'Stir in white chocolate chips.',
        'Drop rounded tablespoons onto prepared baking sheets.',
        'Bake 10-12 minutes until edges are set.',
        'Cool on baking sheet for 5 minutes.',
        'Transfer to wire rack to cool completely.',
      ],
    ),

    Recipe(
      id: '33',
      name: 'Snickerdoodles',
      imageUrl:
          'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400',
      cookingTime: '25 minutes',
      category: 'cookies',
      ingredients: [
        '2 3/4 cups plain flour',
        '2 tsp cream of tartar',
        '1 tsp baking soda',
        '1/2 tsp salt',
        '1 cup butter, softened',
        '1 1/2 cups granulated sugar',
        '2 large eggs',
        'Coating: 2 tbsp sugar',
        '2 tsp ground cinnamon',
      ],
      instructions: [
        'Preheat oven to 200°C.',
        'Mix flour, cream of tartar, baking soda, and salt.',
        'Cream butter and 1 1/2 cups sugar until light and fluffy.',
        'Beat in eggs one at a time.',
        'Gradually blend in flour mixture.',
        'Mix 2 tbsp sugar and cinnamon in small bowl.',
        'Shape dough into walnut-sized balls.',
        'Roll each ball in cinnamon-sugar mixture.',
        'Place 5cm apart on ungreased baking sheets.',
        'Bake 8-10 minutes until lightly golden but still soft.',
      ],
    ),

    Recipe(
      id: '34',
      name: 'Oatmeal Raisin Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1564355808561-86f5eac0addd?w=400',
      cookingTime: '30 minutes',
      category: 'cookies',
      ingredients: [
        '1 cup plain flour',
        '1 tsp baking soda',
        '1 tsp ground cinnamon',
        '1/2 tsp salt',
        '1 cup butter, softened',
        '3/4 cup brown sugar',
        '1/2 cup granulated sugar',
        '2 large eggs',
        '1 tsp vanilla extract',
        '3 cups old-fashioned oats',
        '1 cup raisins',
      ],
      instructions: [
        'Preheat oven to 180°C.',
        'Mix flour, baking soda, cinnamon, and salt.',
        'Cream butter and both sugars until fluffy.',
        'Beat in eggs and vanilla extract.',
        'Gradually mix in flour mixture.',
        'Stir in oats and raisins.',
        'Drop rounded tablespoons onto ungreased baking sheets.',
        'Bake 12-15 minutes until golden brown.',
        'Cool on baking sheet for 2 minutes.',
        'Remove to wire rack to cool completely.',
      ],
    ),

    Recipe(
      id: '35',
      name: 'Peanut Butter Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=400',
      cookingTime: '20 minutes',
      category: 'cookies',
      ingredients: [
        '1 1/4 cups plain flour',
        '3/4 tsp baking soda',
        '1/2 tsp salt',
        '1/2 cup butter, softened',
        '1/2 cup peanut butter',
        '1/2 cup granulated sugar',
        '1/2 cup brown sugar',
        '1 large egg',
        '1 tsp vanilla extract',
      ],
      instructions: [
        'Preheat oven to 190°C.',
        'Mix flour, baking soda, and salt in a bowl.',
        'Cream butter, peanut butter, and both sugars until fluffy.',
        'Beat in egg and vanilla extract.',
        'Gradually blend in flour mixture.',
        'Roll dough into walnut-sized balls.',
        'Place on ungreased baking sheets.',
        'Flatten with fork in crisscross pattern.',
        'Bake 10-12 minutes until lightly golden.',
        'Cool on baking sheet for 2 minutes before removing.',
      ],
    ),

    Recipe(
      id: '36',
      name: 'Gingerbread Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1545558014-8692077e9b5c?w=400',
      cookingTime: '45 minutes + chilling time',
      category: 'cookies',
      ingredients: [
        '3 cups plain flour',
        '2 tsp ground ginger',
        '1 tsp baking soda',
        '1 tsp ground cinnamon',
        '1/2 tsp ground cloves',
        '1/2 tsp salt',
        '3/4 cup butter, softened',
        '1 cup brown sugar',
        '1/2 cup molasses',
        '1 large egg',
        'Royal icing for decorating',
      ],
      instructions: [
        'Mix flour, ginger, baking soda, cinnamon, cloves, and salt.',
        'Cream butter and brown sugar until fluffy.',
        'Beat in molasses and egg.',
        'Gradually mix in flour mixture.',
        'Divide dough in half, wrap in plastic, chill 2 hours.',
        'Preheat oven to 180°C.',
        'Roll dough to 6mm thickness on floured surface.',
        'Cut with cookie cutters, place on lined baking sheets.',
        'Bake 8-10 minutes until edges are lightly browned.',
        'Cool completely before decorating with royal icing.',
      ],
    ),

    Recipe(
      id: '37',
      name: 'Shortbread Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      cookingTime: '35 minutes',
      category: 'cookies',
      ingredients: [
        '2 cups plain flour',
        '1/2 tsp salt',
        '1 cup butter, softened',
        '2/3 cup powdered sugar',
        '1 tsp vanilla extract',
      ],
      instructions: [
        'Preheat oven to 160°C.',
        'Mix flour and salt in a bowl.',
        'Cream butter and powdered sugar until light and fluffy.',
        'Beat in vanilla extract.',
        'Gradually mix in flour mixture until just combined.',
        'Press dough into ungreased 23cm round pan.',
        'Score into 16 wedges with knife.',
        'Prick all over with fork.',
        'Bake 25-30 minutes until lightly golden.',
        'Cut along score lines while warm, cool in pan.',
      ],
    ),

    Recipe(
      id: '38',
      name: 'Lemon Crinkle Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400',
      cookingTime: '25 minutes',
      category: 'cookies',
      ingredients: [
        '2 1/4 cups plain flour',
        '1/2 tsp baking soda',
        '1/2 tsp salt',
        '1/2 cup butter, softened',
        '1 cup granulated sugar',
        '1 large egg',
        '2 tbsp lemon zest',
        '2 tbsp fresh lemon juice',
        '1/2 tsp vanilla extract',
        'Powdered sugar for rolling',
      ],
      instructions: [
        'Preheat oven to 180°C. Line baking sheets with parchment.',
        'Mix flour, baking soda, and salt.',
        'Cream butter and granulated sugar until fluffy.',
        'Beat in egg, lemon zest, lemon juice, and vanilla.',
        'Gradually mix in flour mixture.',
        'Chill dough for 30 minutes.',
        'Roll dough into walnut-sized balls.',
        'Roll each ball in powdered sugar.',
        'Place on prepared baking sheets.',
        'Bake 10-12 minutes until edges are lightly golden.',
      ],
    ),

    Recipe(
      id: '39',
      name: 'Thumbprint Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1549012419-cec214fd2636?w=400',
      cookingTime: '30 minutes',
      category: 'cookies',
      ingredients: [
        '2 cups plain flour',
        '1/2 tsp salt',
        '1 cup butter, softened',
        '2/3 cup brown sugar',
        '2 large egg yolks',
        '1 tsp vanilla extract',
        '2 large egg whites, lightly beaten',
        '1 1/2 cups finely chopped walnuts',
        '1/3 cup jam or preserves',
      ],
      instructions: [
        'Preheat oven to 180°C. Line baking sheets with parchment.',
        'Mix flour and salt in a bowl.',
        'Cream butter and brown sugar until fluffy.',
        'Beat in egg yolks and vanilla.',
        'Gradually mix in flour mixture.',
        'Roll dough into walnut-sized balls.',
        'Dip each ball in beaten egg whites, then roll in chopped nuts.',
        'Place on prepared baking sheets.',
        'Make indentation in center with thumb.',
        'Fill each indentation with 1/2 tsp jam.',
        'Bake 15-18 minutes until lightly golden.',
      ],
    ),

    Recipe(
      id: '40',
      name: 'Chocolate Crinkle Cookies',
      imageUrl:
          'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400',
      cookingTime: '25 minutes + chilling time',
      category: 'cookies',
      ingredients: [
        '1 cup plain flour',
        '1/2 cup unsweetened cocoa powder',
        '1 tsp baking powder',
        '1/4 tsp salt',
        '1 1/2 cups granulated sugar',
        '1/2 cup vegetable oil',
        '2 large eggs',
        '1 tsp vanilla extract',
        '1/2 cup powdered sugar for rolling',
      ],
      instructions: [
        'Mix flour, cocoa powder, baking powder, and salt.',
        'Beat granulated sugar and oil until combined.',
        'Beat in eggs one at a time, then vanilla.',
        'Gradually mix in flour mixture.',
        'Cover and chill dough for at least 4 hours.',
        'Preheat oven to 180°C. Line baking sheets with parchment.',
        'Roll chilled dough into walnut-sized balls.',
        'Roll each ball in powdered sugar until completely coated.',
        'Place on prepared baking sheets.',
        'Bake 10-12 minutes until cookies are cracked and set.',
      ],
    ),
  ];

  // Method to get all cookie recipes
  static List<Recipe> getAllCookieRecipes() {
    return cookieRecipes;
  }

  // Method to get recipe by id
  static Recipe? getRecipeById(String id) {
    try {
      return cookieRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }
}
