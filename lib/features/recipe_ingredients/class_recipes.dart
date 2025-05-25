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
}
