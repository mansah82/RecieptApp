import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key, this.title}) : super(key: key);
  final String? title;
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  List<Diet>? selectedDietList = [];
  late FirebaseFirestore db;

  Future<void> _openFilterDialog() async {
    await FilterListDialog.display<Diet>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Select Special Diet',
      height: 500,
      listData: dietList,
      selectedListData: selectedDietList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (diet, query) {
        return diet.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedDietList = List.from(list!);
        });

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: _openFilterDialog,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                "Filter",
                style: TextStyle(color: Colors.white),
              ),
              // color: Colors.blue,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedDietList![index].name!),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: selectedDietList!.length,
            ),
          ),
        ],
      ),
    );
  }
}

class Diet {
  final String? name;
  Diet({this.name});
}

List<Diet> dietList = [
  Diet(name: "Vegetarian"),
  Diet(name: "Vego"),
  Diet(name: "Gluten free"),
  Diet(name: "Lactos free"),
  Diet(name: "Raw food"),
];
