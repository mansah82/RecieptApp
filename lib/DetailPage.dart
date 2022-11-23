import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recipe_app/models/recipe.dart';

class DetailPage extends StatefulWidget {
  final Recipe recipe;
  DetailPage({super.key, required this.recipe});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  void _saveRecipeToUserSubcollection({
    required Recipe recipe,
  }) async {
    final myRecipe = Recipe(
      id: recipe.id,
      image: recipe.image,
      createdBy: recipe.createdBy,
      name: recipe.name,
      description: recipe.description,
      ingredients: recipe.ingredients,
      labels: recipe.labels,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth)
        .collection('favorite')
        .doc(recipe.id)
        .set(myRecipe.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 88, 88),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.recipe.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.network(
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white),
                          child: Icon(Icons.favorite_outline_outlined,
                              color: Colors.black),
                        ),
                        onTap: () {
                          _saveRecipeToUserSubcollection(recipe: widget.recipe);

                          print('Favorited');
                        },
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.recipe.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Categories',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    ...widget.recipe.labels.map((label) => Text(label)),
                  ],
                ),
              ),
              Divider(
                height: 1.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    Text(
                      widget.recipe.description,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Ingredients',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    ...widget.recipe.ingredients
                        .map((ingredient) => Text(ingredient)),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
