import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/shared/app_theme.dart';

/// Bottom sheet shown when tapping Save on a recipe: a one-tap "All Saved"
/// default, the user's existing collections, and a simple name-only flow
/// for creating a new collection.
class SaveBottomSheet extends ConsumerStatefulWidget {
  const SaveBottomSheet({super.key, required this.recipe});

  final Recipe recipe;

  static void show(BuildContext context, Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SaveBottomSheet(recipe: recipe),
    );
  }

  @override
  ConsumerState<SaveBottomSheet> createState() => _SaveBottomSheetState();
}

class _SaveBottomSheetState extends ConsumerState<SaveBottomSheet> {
  bool _creatingCollection = false;
  bool _busy = false;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    await action();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _createAndSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _busy = true);
    final notifier = ref.read(savedRecipesProvider.notifier);
    final collection = await notifier.createCollection(name);
    if (collection != null) {
      await notifier.saveToCollection(widget.recipe, collection.id);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(savedRecipesProvider);
    final isSaved = saved.isSaved(widget.recipe.id);
    final currentCollectionId = saved.collectionIdFor(widget.recipe.id);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            _creatingCollection ? 'New Collection' : 'Save Recipe',
            style: AppText.serif(fontSize: 22),
          ),
          const SizedBox(height: 16),
          if (_busy)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.pinkDeep),
              ),
            )
          else if (_creatingCollection)
            _buildCreateCollectionForm()
          else
            _buildOptionsList(saved, isSaved, currentCollectionId),
        ],
      ),
    );
  }

  Widget _buildOptionsList(
    SavedRecipesState saved,
    bool isSaved,
    String? currentCollectionId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _OptionTile(
          icon: Icons.bookmark_rounded,
          label: 'All Saved',
          selected: isSaved && currentCollectionId == null,
          onTap:
              () => _run(
                () => ref
                    .read(savedRecipesProvider.notifier)
                    .saveToAllSaved(widget.recipe),
              ),
        ),
        for (final collection in saved.collections)
          _OptionTile(
            icon: Icons.folder_rounded,
            label: collection.name,
            selected: isSaved && currentCollectionId == collection.id,
            onTap:
                () => _run(
                  () => ref
                      .read(savedRecipesProvider.notifier)
                      .saveToCollection(widget.recipe, collection.id),
                ),
          ),
        _OptionTile(
          icon: Icons.add_circle_outline,
          label: 'New Collection',
          onTap: () => setState(() => _creatingCollection = true),
        ),
        if (isSaved) ...[
          const Divider(height: 24, color: AppColors.pinkLight),
          _OptionTile(
            icon: Icons.delete_outline,
            label: 'Remove from Saved',
            iconColor: Colors.red[300],
            labelColor: Colors.red[300],
            onTap:
                () => _run(
                  () => ref
                      .read(savedRecipesProvider.notifier)
                      .removeFromSaved(widget.recipe.id),
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildCreateCollectionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'e.g. Make Later, Cookies',
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onSubmitted: (_) => _createAndSave(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _creatingCollection = false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brown,
                  side: const BorderSide(color: AppColors.pinkLight),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _createAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Create & Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? AppColors.pinkDeep, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: labelColor ?? AppColors.brown,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.pinkDeep,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
