import 'package:recipe_app/model/recipe.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<Recipe> favorites;
  final List<Recipe> myRecipe;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.favorites,
      required this.myRecipe});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'favorites': favorites,
      'myRecipe': myRecipe,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      favorites: List<Recipe>.from(map['favorites']),
      myRecipe: List<Recipe>.from(map['myRecipe']),
    );
  }
}
