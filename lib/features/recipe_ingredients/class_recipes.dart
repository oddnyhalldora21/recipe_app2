class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final String cookingTime;
  final String category;
  final DateTime? createdAt;
  final bool isPublic;
  final String? userId;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.cookingTime,
    required this.category,
    this.createdAt,
    this.isPublic = true,
    this.userId,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    final stepsText = map['steps'] as String? ?? '';
    final instructions =
        stepsText
            .split(RegExp(r'\d+\.\s+'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

    return Recipe(
      id: map['id'] as String,
      userId: map['user_id'] as String?,
      name: map['name'] as String,
      ingredients: List<String>.from(map['ingredients'] as List<dynamic>),
      instructions: instructions,
      // recipes_sweettreats has no cooking_time column yet.
      cookingTime: '',
      category: map['category'] as String,
      imageUrl: map['image_url'] as String,
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(map['created_at'] as String)
              : null,
      isPublic: map['is_public'] as bool? ?? true,
    );
  }
}
