import 'package:flutter/material.dart';
import 'package:nonsense_quiz/models/style.dart';
import 'package:go_router/go_router.dart';

class StyleListItem extends StatelessWidget {
  final Style style;
  final int stars;

  const StyleListItem({super.key, required this.style, required this.stars});

  @override
  Widget build(BuildContext context) {
    final isLocked = (style.id == '2' && stars < 5) ||
        (style.id == '3' && stars < 10) ||
        (style.id == '4' && stars < 15);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Image.asset(
          style.thumbnailPath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          style.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: LinearProgressIndicator(
          value: style.progress / 100,
          backgroundColor: Colors.grey[200],
          color: Theme.of(context).colorScheme.primary,
        ),
        trailing: isLocked ? const Icon(Icons.lock) : null,
        onTap: isLocked ? null : () => context.push('/quiz-set/${style.id}'),
      ),
    );
  }
}
