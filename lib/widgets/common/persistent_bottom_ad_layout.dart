import 'package:flutter/material.dart';
import 'package:nonsense_quiz/widgets/common/ad_banner.dart';

class PersistentBottomAdLayout extends StatelessWidget {
  final Widget child;

  const PersistentBottomAdLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const AdBanner(),
      ],
    );
  }
}
