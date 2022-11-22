import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/filter.dart';
import 'package:recipe_app/main.dart';

import 'package:recipe_app/navbarpages/favorite_page.dart';
import 'package:recipe_app/navbarpages/my_recipe_page.dart';
import 'package:recipe_app/navbarpages/grid_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageNo = [
    const MyRecipe(),
    const GridPage(),
    const Favorite(),
  ];
  int selectedPage = 1;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 88, 88),
        title: Text(
          "Recipe App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => null,
              icon: GestureDetector(
                child: PopupMenuButton<int>(
                  elevation: 2,
                  color: Color.fromARGB(173, 251, 251, 251),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Center(
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 248, 74, 74),
                          ),
                        ),
                      ),
                    ),
                  ],
                  initialValue: 0,
                  onSelected: (value) {
                    print("clik shod");
                    switch (value) {
                      case 1:
                        {
                          FirebaseAuth.instance.signOut();
                          break;
                        }
                    }
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ))
        ],
      ),
      body: _pageNo[selectedPage],
      bottomNavigationBar: ConvexAppBar.badge(
        const {3: ''},
        items: const [
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/list.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/list.png"),
                  color: Color.fromARGB(255, 247, 88, 88)),
              title: "My Recipes"),
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/home.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/home.png"),
                  color: Color.fromARGB(255, 247, 88, 88)),
              title: "Home"),
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/fave.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/fave.png"),
                  color: Color.fromARGB(255, 247, 88, 88)),
              title: "Favorites"),
        ],
        backgroundColor: Color.fromARGB(255, 247, 88, 88),
        initialActiveIndex: selectedPage,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
            print(selectedPage);
          });
        },
      ),
    );
  }
}
