enum RecipeDifficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard');

  const RecipeDifficulty(this.label);
  final String label;

  /// Stored lowercase in recipes_sweettreats.difficulty; null for anything
  /// unrecognised or empty (older recipes have no difficulty).
  static RecipeDifficulty? fromDb(Object? value) {
    for (final difficulty in values) {
      if (difficulty.name == value) return difficulty;
    }
    return null;
  }
}

/// The optional-on-older-recipes details added to the Add/Edit form. All
/// nullable/empty by default since recipes created before these columns
/// existed have none of them.
class RecipeDetails {
  const RecipeDetails({
    this.description,
    this.ovenTemp,
    this.prepMinutes,
    this.bakeMinutes,
    this.servings,
    this.difficulty,
    this.tags = const [],
    this.isNoBake = false,
  });

  final String? description;
  final String? ovenTemp;
  final int? prepMinutes;
  final int? bakeMinutes;
  final int? servings;
  final RecipeDifficulty? difficulty;
  final List<String> tags;

  /// When true, [ovenTemp] and [bakeMinutes] don't apply and stay null.
  final bool isNoBake;

  factory RecipeDetails.fromRow(Map<String, dynamic> row) {
    return RecipeDetails(
      description: row['description'] as String?,
      ovenTemp: row['oven_temp'] as String?,
      prepMinutes: row['prep_minutes'] as int?,
      bakeMinutes: row['bake_minutes'] as int?,
      servings: row['servings'] as int?,
      difficulty: RecipeDifficulty.fromDb(row['difficulty']),
      tags: List<String>.from(row['tags'] as List? ?? const []),
      isNoBake: row['is_no_bake'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toRow() {
    return {
      'description': description,
      'oven_temp': ovenTemp,
      'prep_minutes': prepMinutes,
      'bake_minutes': bakeMinutes,
      'servings': servings,
      'difficulty': difficulty?.name,
      'tags': tags,
      'is_no_bake': isNoBake,
    };
  }
}

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
  final RecipeDetails details;

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
    this.details = const RecipeDetails(),
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
      details: RecipeDetails.fromRow(map),
    );
  }
}
