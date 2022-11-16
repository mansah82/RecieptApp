import 'package:recipe_app/models/User.dart';

class Recipe {
  final String? id;
  final User createdBy;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> labels;

  Recipe({
    this.id,
    required this.createdBy,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.labels,
  });
}
