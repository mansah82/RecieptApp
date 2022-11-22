import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recipe_app/models/Recipe.dart';

class DetailPage extends StatefulWidget {
  final Recipe recipe;
  DetailPage({super.key, required this.recipe});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.network(
                    widget.recipe.image,
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
