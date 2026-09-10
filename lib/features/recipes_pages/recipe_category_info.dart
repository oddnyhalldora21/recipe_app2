import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';

/// A category shown in the Home "Categories" row, derived from whatever
/// categories actually exist in the recipe catalog rather than a hardcoded
/// list — so new categories added straight into recipes_sweettreats (like
/// "hormonal-health") show up automatically without a code change.
class RecipeCategoryInfo {
  const RecipeCategoryInfo({
    required this.slug,
    required this.displayName,
    required this.imageUrl,
  });

  /// The raw value stored in recipes_sweettreats.category (e.g. "no-bake").
  final String slug;
  final String displayName;
  final String imageUrl;
}

/// The original 8 categories keep their existing display names and order;
/// anything else discovered in the catalog is title-cased from its slug
/// and appended afterwards, alphabetically.
const _knownDisplayNames = {
  'chocolate': 'Chocolate',
  'puff-pastry': 'Puff Pastry',
  'gluten-free': 'Gluten Free',
  'frozen': 'Frozen',
  'cookies': 'Cookies',
  'vegan': 'Vegan',
  'no-bake': 'No Bake',
  'sugar-free': 'No Sugar',
};

const _priorityOrder = [
  'chocolate',
  'puff-pastry',
  'gluten-free',
  'frozen',
  'cookies',
  'vegan',
  'no-bake',
  'sugar-free',
];

String _displayNameForSlug(String slug) {
  final known = _knownDisplayNames[slug];
  if (known != null) return known;

  return slug
      .split('-')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

List<RecipeCategoryInfo> categoriesFromRecipes(List<Recipe> recipes) {
  final imageBySlug = <String, String>{};
  for (final recipe in recipes) {
    imageBySlug.putIfAbsent(recipe.category, () => recipe.imageUrl);
  }

  final slugs =
      imageBySlug.keys.toList()..sort((a, b) {
        final aIndex = _priorityOrder.indexOf(a);
        final bIndex = _priorityOrder.indexOf(b);
        if (aIndex != -1 && bIndex != -1) return aIndex.compareTo(bIndex);
        if (aIndex != -1) return -1;
        if (bIndex != -1) return 1;
        return _displayNameForSlug(a).compareTo(_displayNameForSlug(b));
      });

  return [
    for (final slug in slugs)
      RecipeCategoryInfo(
        slug: slug,
        displayName: _displayNameForSlug(slug),
        imageUrl: imageBySlug[slug]!,
      ),
  ];
}
