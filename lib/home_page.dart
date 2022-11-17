import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/favorite.dart';
import 'package:recipe_app/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageNo = [
    const Favorite(),
    const Home(),
    const Home(),
    const Favorite(),
    const Home()
  ];
  int selectedPage = 2;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email!),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _pageNo[selectedPage],
      bottomNavigationBar: ConvexAppBar.badge(
        const {3: ''},
        items: const [
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/home.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/home.png"),
                  color: Color.fromARGB(255, 237, 57, 87)),
              title: "Home"),
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/trending.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/trending.png"),
                  color: Color.fromARGB(255, 237, 57, 87)),
              title: "trending"),
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/list.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/list.png"),
                  color: Color.fromARGB(255, 237, 57, 87)),
              title: "My Recept"),
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/fave.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/fave.png"),
                  color: Color.fromARGB(255, 237, 57, 87)),
              title: "favorite"),
          TabItem(
              icon: ImageIcon(
                AssetImage("assets/icons/more.png"),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              activeIcon: ImageIcon(AssetImage("assets/icons/more.png"),
                  color: Color.fromARGB(255, 237, 57, 87)),
              title: "More")
        ],
        backgroundColor: const Color.fromARGB(255, 237, 57, 87),
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
