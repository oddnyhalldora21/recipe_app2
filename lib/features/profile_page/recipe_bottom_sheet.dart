import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/photo_picker_field.dart';
import 'package:recipe_app/shared/pink_toggle_switch.dart';
import 'package:recipe_app/shared/primary_button.dart';
import 'package:recipe_app/shared/recipe_image_upload_service.dart';

/// What the form did before closing, so the caller (the recipe detail
/// page's edit button) can react — Add-mode callers ignore the result.
sealed class RecipeFormResult {}

class RecipeUpdated extends RecipeFormResult {
  RecipeUpdated(this.recipe);
  final Recipe recipe;
}

class RecipeDeleted extends RecipeFormResult {}

class AddRecipeBottomSheet extends ConsumerStatefulWidget {
  const AddRecipeBottomSheet({super.key, this.existingRecipe});

  /// When non-null, the form opens pre-filled in edit mode: submitting
  /// updates this recipe instead of creating a new one, and a delete
  /// option is shown.
  final Recipe? existingRecipe;

  static Future<RecipeFormResult?> show(
    BuildContext context, {
    Recipe? existingRecipe,
  }) {
    return showModalBottomSheet<RecipeFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AddRecipeBottomSheet(existingRecipe: existingRecipe),
    );
  }

  @override
  ConsumerState<AddRecipeBottomSheet> createState() =>
      _AddRecipeBottomSheetState();
}

class _AddRecipeBottomSheetState extends ConsumerState<AddRecipeBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _isLoading = false;
  bool _isPublic = false;
  PickedPhoto? _pickedPhoto;

  bool get _isEditing => widget.existingRecipe != null;

  /// True when the recipe being edited already has a real photo (not the
  /// hardcoded placeholder) — lets a public recipe stay public on save
  /// without forcing a new photo to be picked, and without a failed
  /// re-upload wiping out a working photo.
  bool get _hasExistingUsablePhoto {
    final existing = widget.existingRecipe;
    if (existing == null) return false;
    return existing.imageUrl.isNotEmpty &&
        !existing.imageUrl.contains('via.placeholder.com');
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.existingRecipe;
    if (existing != null) {
      _nameController.text = existing.name;
      _ingredientsController.text = existing.ingredients.join('\n');
      _instructionsController.text = existing.instructions.join('\n');
      _isPublic = existing.isPublic;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isPublic && _pickedPhoto == null && !_hasExistingUsablePhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add a photo before making this recipe public.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final ingredientsList =
        _ingredientsController.text
            .split('\n')
            .where((ingredient) => ingredient.trim().isNotEmpty)
            .map((ingredient) => ingredient.trim())
            .toList();

    final instructionsList =
        _instructionsController.text
            .split('\n')
            .where((instruction) => instruction.trim().isNotEmpty)
            .map((instruction) => instruction.trim())
            .toList();

    final name = _nameController.text.trim();

    // Editing an existing recipe keeps its current photo by default;
    // otherwise (Add) falls back to the placeholder. A failed upload below
    // leaves this untouched, so editing never overwrites a working photo
    // with the placeholder just because a re-upload attempt failed.
    var imageUrl =
        widget.existingRecipe?.imageUrl ??
        'https://via.placeholder.com/300x200/F1B5D4/432F15?text=My+Recipe';
    final pickedPhoto = _pickedPhoto;
    if (pickedPhoto != null) {
      final uploadedUrl = await RecipeImageUploadService.upload(
        bytes: pickedPhoto.bytes,
        fileExtension: pickedPhoto.extension,
      );
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      } else if (_isPublic && !_hasExistingUsablePhoto) {
        // No usable photo to fall back to (new public recipe, or an
        // existing one that never had a real photo) — block entirely.
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not upload your photo. Please try again before making this recipe public.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      } else if (mounted) {
        // Either private (falls back to the placeholder or the existing
        // photo — imageUrl already defaults to whichever applies) or
        // public with an existing usable photo to fall back to. Either
        // way the save isn't blocked, just note the new photo didn't
        // make it.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasExistingUsablePhoto
                  ? 'Could not upload your new photo — kept the existing one.'
                  : 'Could not upload your photo — saving with a placeholder image instead.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    Recipe? updatedRecipe;
    bool success;
    if (_isEditing) {
      updatedRecipe = await ref
          .read(userRecipesProvider.notifier)
          .updateRecipe(
            recipeId: widget.existingRecipe!.id,
            name: name,
            imageUrl: imageUrl,
            ingredients: ingredientsList,
            instructions: instructionsList,
            category: widget.existingRecipe!.category,
            isPublic: _isPublic,
          );
      success = updatedRecipe != null;
    } else {
      success = await ref
          .read(userRecipesProvider.notifier)
          .addRecipe(
            name: name,
            imageUrl: imageUrl,
            ingredients: ingredientsList,
            instructions: instructionsList,
            category: 'My Recipes',
            isPublic: _isPublic,
          );
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    Navigator.of(
      context,
    ).pop(success && _isEditing ? RecipeUpdated(updatedRecipe!) : null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (_isEditing
                  ? 'Recipe "$name" updated successfully!'
                  : 'Recipe "$name" added successfully!')
              : 'Could not save your recipe — please try again.',
        ),
        backgroundColor: success ? AppColors.brown : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmAndDelete() async {
    final existing = widget.existingRecipe;
    if (existing == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Recipe'),
            content: const Text(
              'Are you sure you want to delete the recipe? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.pinkLight,
                  foregroundColor: AppColors.brown,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.pinkDark,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes, delete'),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    final success = await ref
        .read(userRecipesProvider.notifier)
        .removeRecipe(existing.id);
    if (!mounted) return;

    if (success) {
      // The catalog cache may still hold this recipe if it was public —
      // drop it so it doesn't linger stale on Home/All Recipes/etc.
      ref.invalidate(recipesCatalogProvider);
      Navigator.of(context).pop(RecipeDeleted());
      return;
    }
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not delete this recipe — please try again.'),
        backgroundColor: Colors.redAccent,
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
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Edit Recipe' : 'Add New Recipe',
                  style: AppText.serif(fontSize: 24),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.brown),
                ),
              ],
            ),
          ),

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

                    PhotoPickerField(
                      initialImageUrl:
                          _hasExistingUsablePhoto
                              ? widget.existingRecipe!.imageUrl
                              : null,
                      onChanged:
                          (photo) => setState(() => _pickedPhoto = photo),
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

                    const SizedBox(height: 20),

                    _buildPublicToggle(),

                    if (_isEditing) ...[
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton.icon(
                          onPressed: _isLoading ? null : _confirmAndDelete,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          label: const Text(
                            'Delete Recipe',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
              onPressed: _isLoading ? null : _saveRecipe,
              child:
                  _isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                      : Text(
                        _isEditing ? 'Save Changes' : 'Save Recipe',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Make this recipe public',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brown,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isPublic
                      ? 'Anyone can find this in All Recipes.'
                      : 'Only you can see this recipe.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          PinkToggleSwitch(
            value: _isPublic,
            onChanged: (value) => setState(() => _isPublic = value),
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
            color: AppColors.brown,
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
              borderSide: const BorderSide(color: AppColors.brown, width: 2),
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
