import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_model.dart';
import 'package:recipe_app/navbarpages/add_recipe_page.dart';

class MyRecipe extends StatefulWidget {
  const MyRecipe({super.key});

  @override
  State<MyRecipe> createState() => _MyRecipeState();
}

class _MyRecipeState extends State<MyRecipe> {
  Stream<List<Recipe>> getRecipesStream() {
    return FirebaseFirestore.instance
        .collection('recipes')
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
                        (index) => Container(
                          color: const Color.fromARGB(255, 239, 127, 107),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: CircleAvatar(
                                  //=> wight strok
                                  radius: 75,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: CircleAvatar(
                                    radius: 72,
                                    backgroundImage:
                                        NetworkImage(recipesList[index].image!),

                                    // NetworkImage(
                                    //   '${firebaseUser["addressImage"]}'),
                                  ),
                                ),
                              ),
                              Text(
                                recipesList[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 8, 8),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: IconButton(
                                        onPressed: () {
                                          isFavorite = !isFavorite;
                                          setState(() {
                                            //isFavorite = !isFavorite;
                                          });
                                          print(isFavorite);
                                        },
                                        icon: ImageIcon(
                                          AssetImage("assets/icons/fav.png"),
                                          color: isFavorite
                                              ? Color.fromARGB(
                                                  255, 239, 61, 100)
                                              : Color.fromARGB(
                                                  255, 249, 245, 246),
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
                      ),
                    );
                  }
                  return const Center(child: Text("check your connection"));
                });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 247, 88, 88),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddRecipePage()));
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
