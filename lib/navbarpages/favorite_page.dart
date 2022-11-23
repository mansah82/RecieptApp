import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/DetailPage.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/navbarpages/add_recipe_page.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  int? tappedIndex;
  Stream<List<Recipe>> getRecipesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorite')
        .snapshots()
        .map((event) {
      List<Recipe> recipes = [];
      for (var document in event.docs) {
        recipes.add(Recipe.fromMap(document.data()));
        print(recipes[0].ingredients);
      }

      return recipes;
    });
  }

  @override
  void initState() {
    super.initState();
    tappedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final getUser = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .snapshots();
    return Scaffold(
      body: StreamBuilder(
          stream: getUser,
          builder: (BuildContext context, AsyncSnapshot favoriteList) {
            return StreamBuilder<List<Recipe>>(
                stream: getRecipesStream(),
                builder: (context, snapshot2) {
                  if (favoriteList.hasData && snapshot2.hasData) {
                    List<Recipe> recipesList = snapshot2.data!;

                    var size = MediaQuery.of(context).size;
                    final double itemHeight =
                        (size.height - kToolbarHeight - 10) / 3;
                    final double itemWidth = size.width / 2;

                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (itemWidth / itemHeight),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      children: List<Widget>.generate(
                          recipesList.length, // same length as the data
                          (index) {
                        return MyButton(
                          recipe: recipesList[index],
                        );
                        //gridViewTile(recipesList, index);
                      }),
                    );
                  }
                  return const Center(child: Text("check your connection"));
                });
          }),
    );
  }
}

class MyButton extends StatefulWidget {
  final Recipe recipe;
  final auth = FirebaseAuth.instance.currentUser!.uid;

  MyButton({
    Key? key,
    required this.recipe,
  }) : super(key: key);
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

  void _deleteDoc({
    required Recipe recipe,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorite')
        .doc(recipe.id)
        .delete();
  }

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  // Default to non pressed
  bool pressAttention = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailPage(
                recipe: widget.recipe,
              ))),
      child: Container(
        color: const Color.fromARGB(255, 239, 127, 107),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: CircleAvatar(
                //=> wight strok
                radius: 75,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                child: CircleAvatar(
                  radius: 72,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80'),

                  // NetworkImage(
                  //   '${firebaseUser["addressImage"]}'),
                ),
              ),
            ),
            Text(
              widget.recipe.name,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          pressAttention = !pressAttention;
                          widget._deleteDoc(recipe: widget.recipe);

                          /*
                          widget._saveRecipeToUserSubcollection(
                              recipe: widget.recipe);
                              */
                        });
                      },
                      icon: const ImageIcon(
                        AssetImage("assets/icons/delete.png"),
                        color: Color.fromARGB(255, 249, 245, 246),
                        //Color.fromARGB(255, 239, 61, 100),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ), // Use the fullName property of each item
      ),
    );
  }
}
