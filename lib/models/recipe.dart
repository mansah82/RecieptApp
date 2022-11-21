import 'package:recipe_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class Recipe {
  final String? id;
  final String? image;
  final String createdBy;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> labels;

  Recipe({
    this.id,
    required this.image,
    required this.createdBy,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.labels,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'createdBy': createdBy,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'labels': labels,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      image: map['image'] ?? '',
      createdBy: map['createdBy'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ingredients: List<String>.from(map['ingredients']),
      labels: List<String>.from(map['labels']),
    );
  }
}
