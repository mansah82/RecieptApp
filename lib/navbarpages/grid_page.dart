import 'package:flutter/material.dart';
import 'package:recipe_app/filter.dart';

import 'package:recipe_app/filter.dart';

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 247, 88, 88),
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
}
