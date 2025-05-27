import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/features/profile_page/recipe_bottom_sheet.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, this.onRecipeSelected});

  final Function(Recipe)? onRecipeSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRecipes = ref.watch(userRecipesProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 181, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 181, 212),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 67, 47, 21),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 67, 47, 21)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center everything
          children: [
            // Centered Profile Section
            _buildCenteredProfileHeader(),

            const SizedBox(height: 40),

            // My Recipes Section Header
            _buildMyRecipesSection(userRecipes),
            const SizedBox(height: 20),

            // Add New Recipe Button
            _buildAddRecipeButton(context, ref),
            const SizedBox(height: 30),

            // User Recipes Grid
            _buildRecipesGrid(userRecipes),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredProfileHeader() {
    return Column(
      children: [
        // Centered Profile Picture
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 181, 212),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 67, 47, 21),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 67, 47, 21).withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
        ),

        const SizedBox(height: 20),

        // Centered Name
        const Text(
          'Oddný Halldóra',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Optional subtitle
        const Text(
          'Sweet Treat Creator',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 67, 47, 21),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMyRecipesSection(List<Recipe> userRecipes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Recipes (${userRecipes.length})',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
        ),
        if (userRecipes.isNotEmpty)
          TextButton(
            onPressed: () {
              print('See all user recipes');
            },
            child: const Text(
              'see all',
              style: TextStyle(color: Color.fromARGB(255, 67, 47, 21)),
            ),
          ),
      ],
    );
  }

  Widget _buildAddRecipeButton(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: () {
            AddRecipeBottomSheet.show(context);
          },

          icon: const Icon(Icons.add, color: Colors.white, size: 24),
          label: const Text(
            'Add New Recipe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 67, 47, 21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipesGrid(List<Recipe> userRecipes) {
    if (userRecipes.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 241, 181, 212),
            width: 2,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 60,
                color: Color.fromARGB(255, 67, 47, 21),
              ),
              SizedBox(height: 16),
              Text(
                'No recipes yet!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 67, 47, 21),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your first sweet treat recipe',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 67, 47, 21),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemCount: userRecipes.length > 6 ? 6 : userRecipes.length,
      itemBuilder: (context, index) {
        final recipe = userRecipes[index];
        return _buildUserRecipeCard(recipe);
      },
    );
  }

  Widget _buildUserRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        onRecipeSelected?.call(recipe);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 241, 181, 212),
                                Color.fromARGB(255, 248, 187, 208),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.cake,
                              size: 50,
                              color: Color.fromARGB(255, 67, 47, 21),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        67,
                        47,
                        21,
                      ).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'MINE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 16,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    recipe.cookingTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 67, 47, 21),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
