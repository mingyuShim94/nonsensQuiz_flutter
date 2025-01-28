import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Nonsense Quiz'),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // 설정 화면으로 이동하는 로직 추가
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
