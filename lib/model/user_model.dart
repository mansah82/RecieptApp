import 'package:recipe_app/model/recipe.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<Recipe> favorites;
 

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.favorites,
      });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'favorites': favorites,
      
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      favorites: List<Recipe>.from(map['favorites']),
     
    );
  }
}
