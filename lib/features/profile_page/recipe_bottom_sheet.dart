import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';

class AddRecipeBottomSheet extends ConsumerStatefulWidget {
  const AddRecipeBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddRecipeBottomSheet(),
    );
  }

  @override
  ConsumerState<AddRecipeBottomSheet> createState() =>
      _AddRecipeBottomSheetState();
}

class _AddRecipeBottomSheetState extends ConsumerState<AddRecipeBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _cookingTimeController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Create ingredient list from text input
    final ingredientsList =
        _ingredientsController.text
            .split('\n')
            .where((ingredient) => ingredient.trim().isNotEmpty)
            .map((ingredient) => ingredient.trim())
            .toList();

    // Create instruction list from text input
    final instructionsList =
        _instructionsController.text
            .split('\n')
            .where((instruction) => instruction.trim().isNotEmpty)
            .map((instruction) => instruction.trim())
            .toList();

    // Create the new recipe
    final newRecipe = Recipe(
      id:
          DateTime.now().millisecondsSinceEpoch
              .toString(), // Simple ID generation
      name: _nameController.text.trim(),
      imageUrl:
          _imageUrlController.text.trim().isEmpty
              ? 'https://via.placeholder.com/300x200/F1B5D4/432F15?text=My+Recipe'
              : _imageUrlController.text.trim(),
      cookingTime: _cookingTimeController.text.trim(),
      category: 'My Recipes', // Default category for user recipes
      ingredients: ingredientsList,
      instructions: instructionsList,
    );

    // Add to user recipes
    ref.read(userRecipesProvider.notifier).addRecipe(newRecipe);

    setState(() {
      _isLoading = false;
    });

    // Close the bottom sheet
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recipe "${newRecipe.name}" added successfully!'),
        backgroundColor: const Color.fromARGB(255, 67, 47, 21),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Recipe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 67, 47, 21),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Recipe Name',
                      hint: 'Enter your recipe name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a recipe name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Describe your delicious recipe',
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _cookingTimeController,
                      label: 'Cooking Time',
                      hint: 'e.g., 30 mins, 1 hour',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter cooking time';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _imageUrlController,
                      label: 'Image URL (Optional)',
                      hint: 'Paste an image URL for your recipe',
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _ingredientsController,
                      label: 'Ingredients',
                      hint:
                          'Enter each ingredient on a new line\nExample:\n2 cups flour\n1 cup sugar\n3 eggs',
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter ingredients';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _instructionsController,
                      label: 'Instructions',
                      hint:
                          'Enter each step on a new line\nExample:\nPreheat oven to 350°F\nMix dry ingredients\nAdd wet ingredients',
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter instructions';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 67, 47, 21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                        : const Text(
                          'Save Recipe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 67, 47, 21),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 67, 47, 21),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
