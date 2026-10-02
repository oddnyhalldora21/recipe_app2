import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/user_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/confirm_dialog.dart';
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
      // Over the whole app (app bar + nav bar) rather than inside the tab's
      // own navigator, whose area shrinks to a sliver once the keyboard is
      // up; the safe area keeps the top clear of the status bar.
      useRootNavigator: true,
      useSafeArea: true,
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
  final _descriptionController = TextEditingController();
  final _ovenTempController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _bakeTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _tagInputController = TextEditingController();

  bool _isLoading = false;
  bool _isPublic = false;
  bool _isNoBake = false;
  RecipeDifficulty? _difficulty;
  List<String> _tags = [];
  PickedPhoto? _pickedPhoto;

  static const _maxTags = 10;
  static const _maxTagLength = 24;

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

  /// Oven temp, bake time and difficulty are required for new recipes, but
  /// recipes created before these fields existed may save without them —
  /// unless they were already filled in, in which case they can't be
  /// cleared.
  RecipeDetails? get _originalDetails => widget.existingRecipe?.details;
  bool get _requireOvenTemp =>
      !_isNoBake && (!_isEditing || _originalDetails!.ovenTemp != null);
  bool get _requireBakeTime =>
      !_isNoBake && (!_isEditing || _originalDetails!.bakeMinutes != null);
  bool get _requireDifficulty =>
      !_isEditing || _originalDetails!.difficulty != null;

  /// Non-blocking nudge shown when editing an older recipe that's missing
  /// some of the baking details.
  bool get _showMissingDetailsHint {
    final original = _originalDetails;
    if (original == null) return false;
    final missingBaking =
        !original.isNoBake &&
        (original.ovenTemp == null || original.bakeMinutes == null);
    return missingBaking || original.difficulty == null;
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
      final details = existing.details;
      _descriptionController.text = details.description ?? '';
      _ovenTempController.text = details.ovenTemp ?? '';
      _prepTimeController.text = details.prepMinutes?.toString() ?? '';
      _bakeTimeController.text = details.bakeMinutes?.toString() ?? '';
      _servingsController.text = details.servings?.toString() ?? '';
      _isNoBake = details.isNoBake;
      _difficulty = details.difficulty;
      _tags = List.of(details.tags);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _descriptionController.dispose();
    _ovenTempController.dispose();
    _prepTimeController.dispose();
    _bakeTimeController.dispose();
    _servingsController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  String? _trimmedOrNull(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  RecipeDetails _buildDetails() {
    return RecipeDetails(
      description: _trimmedOrNull(_descriptionController),
      ovenTemp: _isNoBake ? null : _trimmedOrNull(_ovenTempController),
      prepMinutes: int.tryParse(_prepTimeController.text.trim()),
      bakeMinutes:
          _isNoBake ? null : int.tryParse(_bakeTimeController.text.trim()),
      servings: int.tryParse(_servingsController.text.trim()),
      difficulty: _difficulty,
      tags: _tags,
      isNoBake: _isNoBake,
    );
  }

  /// Turns whatever is typed in the tag field into tags — on enter, or as
  /// soon as a comma is typed — lowercased, trimmed and de-duplicated.
  void _addTagsFromInput() {
    final newTags = _tagInputController.text
        .split(',')
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .map(
          (tag) =>
              tag.length > _maxTagLength
                  ? tag.substring(0, _maxTagLength)
                  : tag,
        );
    setState(() {
      for (final tag in newTags) {
        if (_tags.length >= _maxTags) break;
        if (!_tags.contains(tag)) _tags.add(tag);
      }
      _tagInputController.clear();
    });
  }

  /// Optional whole-number fields: empty is fine, anything else must parse.
  String? _validateOptionalNumber(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final number = int.tryParse(text);
    if (number == null || number <= 0) return 'Enter a whole number';
    return null;
  }

  Future<void> _saveRecipe() async {
    // Catches a half-typed tag the user never confirmed with enter/comma.
    if (_tagInputController.text.trim().isNotEmpty) _addTagsFromInput();
    if (!_formKey.currentState!.validate()) return;

    if (_isPublic && _pickedPhoto == null && !_hasExistingUsablePhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a photo before making this recipe public.'),
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
            details: _buildDetails(),
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
            details: _buildDetails(),
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

    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Recipe',
      message:
          'Are you sure you want to delete the recipe? This action cannot be undone.',
      confirmLabel: 'Yes, delete',
    );
    if (!confirmed || !mounted) return;

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
    // Open over the root navigator, nothing else lifts the form above the
    // keyboard — so pad by its height (or the home indicator when it's
    // down), keeping the Save button just above it while the white sheet
    // still runs behind it.
    final bottomInset = math.max(
      MediaQuery.viewInsetsOf(context).bottom,
      MediaQuery.paddingOf(context).bottom,
    );

    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(bottom: bottomInset),
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeading('The basics'),

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
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Optional — a short intro to your recipe',
                      maxLines: 3,
                    ),

                    _buildSectionHeading('What you need'),

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

                    _buildSectionHeading('Baking'),

                    _buildBakingSection(),

                    _buildSectionHeading('Method'),

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

                    _buildSectionHeading('Extras'),

                    _buildTagsField(),

                    const SizedBox(height: 24),

                    _buildPublicToggle(),

                    // At the end of the form rather than pinned below it,
                    // so it doesn't eat space above the keyboard.
                    const SizedBox(height: 28),
                    Center(
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
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: AppText.label.copyWith(fontSize: 12, color: AppColors.pinkDark),
      ),
    );
  }

  Widget _buildBakingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showMissingDetailsHint) ...[
          Text(
            'This recipe is missing some baking details — add them whenever you like.',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
        ],
        _buildSwitchRow(
          title: 'No-bake recipe',
          subtitle: 'Skips oven temperature and bake time.',
          value: _isNoBake,
          onChanged: (value) => setState(() => _isNoBake = value),
        ),
        if (!_isNoBake) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _ovenTempController,
                  label: 'Oven temp',
                  hint: 'e.g. 180°C',
                  validator: (value) {
                    if (_requireOvenTemp &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _bakeTimeController,
                  label: 'Bake time',
                  hint: 'Minutes, e.g. 35',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty)
                      return _requireBakeTime ? 'Required' : null;
                    return _validateOptionalNumber(text);
                  },
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: _prepTimeController,
                label: 'Prep time',
                hint: 'Optional, minutes',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateOptionalNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _servingsController,
                label: 'Servings',
                hint: 'Optional, e.g. 12',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateOptionalNumber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDifficultyPicker(),
      ],
    );
  }

  Widget _buildDifficultyPicker() {
    return FormField<RecipeDifficulty>(
      initialValue: _difficulty,
      validator:
          (_) =>
              _requireDifficulty && _difficulty == null
                  ? 'Please choose a difficulty'
                  : null,
      builder:
          (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Difficulty'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final difficulty in RecipeDifficulty.values)
                    ChoiceChip(
                      label: Text(difficulty.label),
                      selected: _difficulty == difficulty,
                      showCheckmark: false,
                      selectedColor: AppColors.pinkDark,
                      backgroundColor: AppColors.pinkLight,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            _difficulty == difficulty
                                ? Colors.white
                                : AppColors.brown,
                      ),
                      onSelected: (_) {
                        setState(() => _difficulty = difficulty);
                        field.didChange(difficulty);
                      },
                    ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Tags'),
        const SizedBox(height: 8),
        TextField(
          controller: _tagInputController,
          enabled: _tags.length < _maxTags,
          textCapitalization: TextCapitalization.none,
          decoration: _inputDecoration(
            _tags.length < _maxTags
                ? 'Optional — type a tag and press enter'
                : 'Up to $_maxTags tags',
          ),
          onChanged: (value) {
            if (value.contains(',')) _addTagsFromInput();
          },
          // Keeps the keyboard up so several tags can be added in a row.
          onEditingComplete: _addTagsFromInput,
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in _tags)
                InputChip(
                  label: Text(tag),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.brown,
                  ),
                  backgroundColor: AppColors.pinkLight,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  deleteIconColor: AppColors.brown,
                  onDeleted: () => setState(() => _tags.remove(tag)),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brown,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          PinkToggleSwitch(value: value, onChanged: onChanged),
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.brown,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }
}
