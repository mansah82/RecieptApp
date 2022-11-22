import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FilterListWidget<String>(
          listData: const [
            "Lactos Free",
            "Gluten Free",
            "Raw food",
            "Vegetarian",
          ],
          selectedListData: const [],
          onApplyButtonClick: (list) {
            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item;
          },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (text, query) {
            return text.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}
