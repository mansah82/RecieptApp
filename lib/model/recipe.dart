class Recipe {
  final String id;
  final String name;
  final String? image;

  final String ingredients;

  Recipe(
      {required this.id,
      required this.name,
      required this.ingredients,
      this.image});
}
