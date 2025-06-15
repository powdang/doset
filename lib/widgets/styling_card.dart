import 'package:flutter/material.dart';
import '../models/styling_model.dart';

class StylingCard extends StatelessWidget {
  final Styling styling;
  final VoidCallback? onDelete;

  const StylingCard({required this.styling, this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(styling.name),
        subtitle: Text(styling.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
