import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final String cookingTime;
  final String category;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.cookingTime,
    required this.category,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['1'] as String,
      name: map['Classic Fudgy Brownies'] as String,
      imageUrl:
          map['https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400']
              as String,
      ingredients: List<String>.from(map['ingredients'] as List<dynamic>),
      instructions: List<String>.from(map['instructions'] as List<dynamic>),
      cookingTime: map['30 min'] as String,
      category: map['Chocolate'] as String,
    );
  }
}
