import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class DummyUserRecipes {
  static List<Recipe> getDummyRecipes() {
    return [
      Recipe(
        id: 'dummy_1',
        name: 'Classic Pancakes',
        imageUrl:
            'https://images.unsplash.com/photo-1605491126280-66fb78876012?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHJvbGxlZCUyMHBhbmNha2VzfGVufDB8fDB8fHww',
        cookingTime: '20 mins',
        category: 'My Recipes',
        ingredients: [
          '2 cups all-purpose flour',
          '2 tablespoons sugar',
          '2 teaspoons baking powder',
          '1 teaspoon salt',
          '2 large eggs',
          '1 3/4 cups milk',
          '4 tablespoons melted butter',
          '1 teaspoon vanilla extract',
          'Butter for pan',
          'Maple syrup for serving',
        ],
        instructions: [
          'In a large bowl, whisk together flour, sugar, baking powder, and salt.',
          'In another bowl, beat eggs, then whisk in milk, melted butter, and vanilla.',
          'Pour wet ingredients into dry ingredients and stir until just combined. Don\'t overmix - lumps are okay!',
          'Heat a griddle or large skillet over medium heat. Lightly butter the surface.',
          'Pour 1/4 cup batter for each pancake onto the griddle.',
          'Cook until bubbles form on surface and edges look set, about 2-3 minutes.',
          'Flip and cook until golden brown on the other side, 1-2 minutes more.',
          'Serve immediately with butter and maple syrup.',
          'Keep cooked pancakes warm in a 200°F oven if needed.',
        ],
      ),

      Recipe(
        id: 'dummy_2',
        name: 'Blueberry Muffins',
        imageUrl:
            'https://images.unsplash.com/photo-1722251172860-39856cdd3bcd?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGJsdWJlcnJ5JTIwbXVmZmluc3xlbnwwfHwwfHx8MA%3D%3D',
        cookingTime: '35 mins',
        category: 'My Recipes',
        ingredients: [
          '2 cups all-purpose flour',
          '2/3 cup sugar',
          '2 teaspoons baking powder',
          '1/2 teaspoon salt',
          '1/3 cup melted butter',
          '1 large egg',
          '1 cup milk',
          '1 teaspoon vanilla extract',
          '1 cup fresh blueberries',
          '1 tablespoon flour (for coating berries)',
        ],
        instructions: [
          'Preheat oven to 400°F (200°C). Line a 12-cup muffin tin with paper liners.',
          'In a large bowl, whisk together 2 cups flour, sugar, baking powder, and salt.',
          'Toss blueberries with 1 tablespoon flour to prevent sinking.',
          'In another bowl, whisk together melted butter, egg, milk, and vanilla.',
          'Pour wet ingredients into dry ingredients and stir until just combined.',
          'Gently fold in the flour-coated blueberries.',
          'Divide batter evenly among muffin cups, filling each about 2/3 full.',
          'Bake for 20-25 minutes until tops are golden and a toothpick comes out clean.',
          'Cool in pan for 5 minutes, then transfer to a wire rack.',
          'Best served warm or at room temperature.',
        ],
      ),

      Recipe(
        id: 'dummy_3',
        name: 'Moist Banana Bread',
        imageUrl:
            'https://images.unsplash.com/photo-1632931057788-645c49bc0db5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8YmFuYW5hJTIwYnJlYWR8ZW58MHx8MHx8fDA%3D',
        cookingTime: '1 h 15 mins',
        category: 'My Recipes',
        ingredients: [
          '3 very ripe bananas, mashed',
          '1/3 cup melted butter',
          '3/4 cup sugar',
          '1 large egg, beaten',
          '1 teaspoon vanilla extract',
          '1 teaspoon baking soda',
          'Pinch of salt',
          '1 1/2 cups all-purpose flour',
          '1/2 cup chopped walnuts (optional)',
        ],
        instructions: [
          'Preheat oven to 350°F (175°C). Grease a 9x5 inch loaf pan.',
          'In a large mixing bowl, mash the ripe bananas until mostly smooth.',
          'Mix in melted butter with the mashed bananas.',
          'Add sugar, beaten egg, and vanilla extract. Mix well.',
          'Sprinkle baking soda and salt over the mixture and stir in.',
          'Add flour and mix until just incorporated. Don\'t overmix.',
          'Fold in chopped walnuts if using.',
          'Pour batter into prepared loaf pan and smooth the top.',
          'Bake for 60-65 minutes until a toothpick inserted in center comes out clean.',
          'Cool in pan for 10 minutes, then turn out onto wire rack.',
          'Slice when completely cool. Store covered for up to 1 week.',
        ],
      ),
    ];
  }
}
