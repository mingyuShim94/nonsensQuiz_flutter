import 'package:flutter/material.dart';
import 'package:nonsense_quiz/models/style.dart';
import 'package:nonsense_quiz/widgets/main/style_list_item.dart';
// import 'package:nonsense_quiz/widgets/main/style_list_item.dart';
// import 'package:nonsense_quiz/models/style.dart';

class StyleList extends StatelessWidget {
  final List<Style> styleList;
  final int stars;

  const StyleList({super.key, required this.styleList, required this.stars});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: styleList.length,
      itemBuilder: (context, index) {
        final style = styleList[index];
        return StyleListItem(style: style, stars: stars);
      },
    );
  }
}
