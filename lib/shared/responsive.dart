/// Number of grid columns for recipe cards based on the available width.
/// Phones stay at 2 columns (current behavior); wider layouts get more.
int recipeGridColumns(double width) {
  if (width >= 900) return 4; // large tablet / landscape
  if (width >= 600) return 3; // small tablet / phone landscape
  return 2; // phone portrait
}
