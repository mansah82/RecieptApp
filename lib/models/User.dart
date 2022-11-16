import 'package:recipe_app/models/Recipe.dart';

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String email;
  final List<Recipe> favorites;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      required this.email,
      required this.favorites});
}
