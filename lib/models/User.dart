import 'package:recipe_app/models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
