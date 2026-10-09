import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/widgets/recipe_card.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dedicated search screen: a search field at the top, live results below
/// as a scrollable grid of [RecipeCard]s — replaces the old floating
/// dropdown suggestions on Home.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  static const _maxRecentSearches = 8;

  final _controller = TextEditingController();
  String _query = '';
  List<String> _recentSearches = const [];

  /// Recent searches live on the device, kept apart per signed-in account.
  String get _recentSearchesKey =>
      'recent_searches_${Supabase.instance.client.auth.currentUser?.id ?? 'guest'}';

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_recentSearchesKey) ?? const [];
    if (mounted) setState(() => _recentSearches = saved);
  }

  Future<void> _saveRecentSearches(List<String> searches) async {
    setState(() => _recentSearches = searches);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, searches);
  }

  /// Moves [query] to the top of the list (dropping any case-insensitive
  /// duplicate) — called on submit or when a result is opened, so
  /// half-typed live queries are never recorded.
  void _rememberSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final updated =
        [
          trimmed,
          ..._recentSearches.where(
            (s) => s.toLowerCase() != trimmed.toLowerCase(),
          ),
        ].take(_maxRecentSearches).toList();
    _saveRecentSearches(updated);
  }

  void _removeRecentSearch(String query) {
    _saveRecentSearches(_recentSearches.where((s) => s != query).toList());
  }

  void _applyRecentSearch(String query) {
    _controller.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
    setState(() => _query = query);
    FocusScope.of(context).unfocus();
    _rememberSearch(query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearQuery() {
    _controller.clear();
    setState(() => _query = '');
  }

  /// Unchanged from the old RecipesSearchBar — matches recipe name,
  /// ingredients, or category (case-insensitive substring match).
  List<Recipe> _filterRecipes(List<Recipe> catalog, String query) {
    final lowercaseQuery = query.toLowerCase();

    return catalog.where((recipe) {
      final nameMatch = recipe.name.toLowerCase().contains(lowercaseQuery);

      final ingredientsMatch = recipe.ingredients.any(
        (ingredient) => ingredient.toLowerCase().contains(lowercaseQuery),
      );

      final categoryMatch = recipe.category.toLowerCase().contains(
        lowercaseQuery,
      );

      return nameMatch || ingredientsMatch || categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(recipesCatalogProvider).valueOrNull ?? const [];
    final hasQuery = _query.isNotEmpty;
    final results =
        hasQuery ? _filterRecipes(catalog, _query) : const <Recipe>[];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: AppShadows.card,
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value),
                  onSubmitted: _rememberSearch,
                  textInputAction: TextInputAction.search,
                  // The keyboard covers the bottom nav bar, so tapping
                  // anywhere else has to put it away or the page traps you.
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  style: const TextStyle(color: AppColors.brown),
                  decoration: InputDecoration(
                    hintText: 'what are we craving?',
                    hintStyle: TextStyle(
                      color: AppColors.brown.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.pinkDeep,
                    ),
                    suffixIcon:
                        hasQuery
                            ? IconButton(
                              tooltip: 'Clear search',
                              onPressed: _clearQuery,
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: AppColors.brown.withValues(alpha: 0.4),
                              ),
                            )
                            : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    !hasQuery
                        ? _recentSearches.isEmpty
                            ? _buildPrompt()
                            : _buildRecentSearches()
                        : results.isEmpty
                        ? _buildNoResults()
                        : GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: kRecipeCardWidth,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.68,
                              ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final recipe = results[index];
                            // RecipeCard handles its own tap, so record the
                            // search from a raw pointer listener — only for
                            // taps, not drags that end on a card.
                            Offset? downAt;
                            return Listener(
                              onPointerDown: (e) => downAt = e.position,
                              onPointerUp: (e) {
                                final start = downAt;
                                if (start != null &&
                                    (e.position - start).distance <
                                        kTouchSlop) {
                                  _rememberSearch(_query);
                                }
                              },
                              child: RecipeCard(
                                recipe: recipe,
                                heroTag: 'search_${recipe.id}',
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 48, color: AppColors.brown.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(
            'Search by name, ingredient, or category',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.brown.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Last searched',
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _saveRecentSearches(const []),
              style: TextButton.styleFrom(foregroundColor: AppColors.pinkDark),
              child: const Text('Clear'),
            ),
          ],
        ),
        for (final search in _recentSearches)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Icon(
              Icons.history,
              color: AppColors.brown.withValues(alpha: 0.5),
            ),
            title: Text(
              search,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.brown, fontSize: 15),
            ),
            trailing: IconButton(
              tooltip: 'Remove',
              onPressed: () => _removeRecentSearch(search),
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.brown.withValues(alpha: 0.4),
              ),
            ),
            onTap: () => _applyRecentSearch(search),
          ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: AppColors.brown.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'No recipes found for "$_query"',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.brown.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
