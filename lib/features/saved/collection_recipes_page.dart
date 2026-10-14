import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_catalog_provider.dart';
import 'package:recipe_app/features/recipe_ingredients/recipes_index.dart';
import 'package:recipe_app/features/saved/saved_recipes_provider.dart';
import 'package:recipe_app/features/saved/recipe_folder_view.dart';
import 'package:recipe_app/shared/app_theme.dart';
import 'package:recipe_app/shared/confirm_dialog.dart';

/// Shows just the recipes filed under one named collection.
class CollectionRecipesPage extends ConsumerWidget {
  const CollectionRecipesPage({super.key, required this.collection});

  final RecipeCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedRecipesProvider);
    final catalog = ref.watch(recipesCatalogProvider);
    // Read the live entry so a rename shows straight away; fall back to the
    // one passed in while it's being deleted.
    final current = saved.collections.firstWhere(
      (c) => c.id == collection.id,
      orElse: () => collection,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: catalog.when(
            data:
                (allRecipes) => _CollectionBody(
                  collection: current,
                  recipes: recipesForLocation(saved, collection.id, allRecipes),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: AppColors.pinkDeep),
                ),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    'Could not load this collection.',
                    style: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

enum _RecipeAction { move, remove }

enum _CollectionAction { rename, delete }

class _CollectionBody extends ConsumerWidget {
  const _CollectionBody({required this.collection, required this.recipes});

  final RecipeCollection collection;
  final List<Recipe> recipes;

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showDone(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _RenameCollectionDialog(initialName: collection.name),
    );
    if (name == null || name == collection.name || !context.mounted) return;

    final success = await ref
        .read(savedRecipesProvider.notifier)
        .renameCollection(collection.id, name);
    if (!context.mounted) return;
    if (success) {
      _showDone(context, 'Collection renamed');
    } else {
      // Includes the update matching zero rows, as a missing UPDATE policy
      // does silently; the old name stays since state only changes on success.
      _showError(context, "Couldn't rename collection");
    }
  }

  /// Deletes only the collection — its recipes stay saved under All Saved.
  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete collection?',
      message:
          'This only deletes the collection. The recipes inside stay saved.',
      confirmLabel: 'Yes, delete',
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(savedRecipesProvider.notifier)
        .deleteCollection(collection.id);
    if (!context.mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      _showError(
        context,
        'Could not delete this collection — please try again.',
      );
    }
  }

  Future<void> _openRecipeMenu(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    final action = await showModalBottomSheet<_RecipeAction>(
      context: context,
      shape: _sheetShape,
      builder:
          (sheetContext) => _SheetFrame(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.drive_file_move_outline,
                  color: AppColors.pinkDeep,
                ),
                title: const Text('Move to another collection'),
                onTap: () => Navigator.pop(sheetContext, _RecipeAction.move),
              ),
              ListTile(
                leading: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.pinkDeep,
                ),
                title: const Text('Remove from this collection'),
                onTap: () => Navigator.pop(sheetContext, _RecipeAction.remove),
              ),
            ],
          ),
    );
    if (!context.mounted) return;

    switch (action) {
      case _RecipeAction.remove:
        await _remove(context, ref, recipe);
      case _RecipeAction.move:
        await _move(context, ref, recipe);
      case null:
        break;
    }
  }

  /// Un-files the recipe after a confirm; it stays saved under All Saved.
  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove from collection?',
      message: 'The recipe stays in All Saved.',
      confirmLabel: 'Yes, remove',
    );
    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(savedRecipesProvider.notifier)
        .saveToAllSaved(recipe);
    if (!context.mounted) return;
    if (success) {
      _showDone(context, 'Removed from ${collection.name}');
    } else {
      _showError(context, 'Could not remove this recipe — please try again.');
    }
  }

  /// A saved recipe sits in one collection at a time, so filing it under
  /// another collection takes it out of this one in the same step.
  Future<void> _move(BuildContext context, WidgetRef ref, Recipe recipe) async {
    final others = [
      for (final other in ref.read(savedRecipesProvider).collections)
        if (other.id != collection.id) other,
    ];

    final target = await showModalBottomSheet<RecipeCollection>(
      context: context,
      shape: _sheetShape,
      isScrollControlled: true,
      builder:
          (sheetContext) => _SheetFrame(
            title: 'Move to…',
            children: [
              if (others.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 4, 24, 12),
                  child: Text(
                    'You have no other collections yet. Create one from the '
                    'save button on any recipe.',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final other in others)
                        ListTile(
                          leading: const Icon(
                            Icons.folder_rounded,
                            color: AppColors.pinkDeep,
                          ),
                          title: Text(other.name),
                          onTap: () => Navigator.pop(sheetContext, other),
                        ),
                    ],
                  ),
                ),
            ],
          ),
    );
    if (target == null || !context.mounted) return;

    final success = await ref
        .read(savedRecipesProvider.notifier)
        .saveToCollection(recipe, target.id);
    if (!context.mounted) return;
    if (success) {
      _showDone(context, 'Moved to ${target.name}');
    } else {
      _showError(context, 'Could not move this recipe — please try again.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RecipeFolderView(
      icon: Icons.folder_rounded,
      title: collection.name,
      recipes: recipes,
      heroTagPrefix: 'collection_${collection.id}',
      emptyState: const FolderEmptyMessage('No recipes in this collection yet'),
      headerAction: PopupMenuButton<_CollectionAction>(
        tooltip: 'Collection options',
        icon: const Icon(Icons.more_vert_rounded, color: AppColors.brown),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onSelected:
            (action) => switch (action) {
              _CollectionAction.rename => _rename(context, ref),
              _CollectionAction.delete => _confirmAndDelete(context, ref),
            },
        itemBuilder:
            (context) => const [
              PopupMenuItem(
                value: _CollectionAction.rename,
                child: Text('Edit collection'),
              ),
              PopupMenuItem(
                value: _CollectionAction.delete,
                child: Text('Delete collection'),
              ),
            ],
      ),
      // The page's `context`, not the card's: the menu needs a context that
      // stays mounted after the card leaves the grid.
      onRecipeMorePressed: (recipe) => _openRecipeMenu(context, ref, recipe),
    );
  }
}

/// Name field prefilled with the current name, styled like
/// [showConfirmDialog]. Pops the trimmed new name, or null on Cancel.
class _RenameCollectionDialog extends StatefulWidget {
  const _RenameCollectionDialog({required this.initialName});

  final String initialName;

  @override
  State<_RenameCollectionDialog> createState() =>
      _RenameCollectionDialogState();
}

class _RenameCollectionDialogState extends State<_RenameCollectionDialog> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit collection'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
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
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.pink,
            foregroundColor: AppColors.brown,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.pinkDark,
            foregroundColor: Colors.white,
          ),
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

const _sheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
);

/// Drag handle, optional title and options for the collection sheets, on
/// the app's white bottom-sheet theme.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(title!, style: AppText.serif(fontSize: 20)),
              ),
            ...children,
          ],
        ),
      ),
    );
  }
}
