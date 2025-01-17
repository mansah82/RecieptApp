import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/filter.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_model.dart';
import 'package:recipe_app/navbarpages/add_recipe_page.dart';
import 'package:recipe_app/filterListClass.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _MyGridState();
}

class _MyGridState extends State<GridPage> {
  int? tappedIndex;
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
                    late List<bool> pressedAttentions =
                        recipesList.map((e) => false).toList();
                    var size = MediaQuery.of(context).size;
                    final double itemHeight =
                        (size.height - kToolbarHeight - 10) / 3;
                    final double itemWidth = size.width / 2;
                    print(snapshot2);

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
                        //print(recipesList[index].labels);

                        //Får filtreringen att fungera, renderingen fungerar inte.
                        //Tror recipeList overridar filterList, om ni kollar logg
                        //när man klickat i protein går in och ur sidan igen så
                        //står till chili con carne under print(filteredList[0].name)
                        if (FilterList.FilterlistArray.any((item) =>
                            recipesList[index].labels.contains(item))) {
                          List<Recipe> filteredList = [];
                          print(filteredList.length);

                          for (var recipe in recipesList) {
                            if (FilterList.FilterlistArray.any(
                                (element) => recipe.labels.contains(element))) {
                              print(recipe.labels);
                              filteredList.add(recipe);
                            }
                          }
                          print(filteredList[0].name);

                          if (filteredList.isNotEmpty) {
                            return MyButton(recipe: filteredList[0]);
                          }
                        }

                        return MyButton(recipe: recipesList[index]);

                        //gridViewTile(recipesList, index);
                      }),
                    );
                  }
                  return const Center(child: Text("check your connection"));
                });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 247, 88, 88),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FilterPage()));
        },
        tooltip: 'Search',
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  Container gridViewTile(List<Recipe> recipesList, int index) {
    return Container(
      color: const Color.fromARGB(255, 239, 127, 107),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: CircleAvatar(
              //=> wight strok
              radius: 75,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              child: CircleAvatar(
                radius: 72,
                backgroundImage: NetworkImage(recipesList[index].image!),

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
                    onPressed: () => setState(() {
                      tappedIndex = index;
                    }),
                    icon: ImageIcon(
                      AssetImage("assets/icons/fav.png"),
                      color: tappedIndex == index
                          ? Color.fromARGB(255, 249, 245, 246)
                          : Color.fromARGB(255, 243, 99, 135),
                      //Color.fromARGB(255, 239, 61, 100),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ), // Use the fullName property of each item
    );
  }
}

class MyButton extends StatefulWidget {
  final Recipe recipe;

  const MyButton({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  // Default to non pressed
  bool pressAttention = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 239, 127, 107),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: CircleAvatar(
              //=> wight strok
              radius: 75,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              child: CircleAvatar(
                radius: 72,
                backgroundImage: NetworkImage(widget.recipe.image!),

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
                      });
                    },
                    icon: ImageIcon(
                      AssetImage("assets/icons/fav.png"),
                      color: pressAttention
                          ? Color.fromARGB(255, 249, 245, 246)
                          : Color.fromARGB(255, 243, 99, 135),
                      //Color.fromARGB(255, 239, 61, 100),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ), // Use the fullName property of each item
    );
  }
}
