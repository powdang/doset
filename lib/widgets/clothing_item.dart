import 'package:flutter/material.dart';
import '../models/clothing_model.dart';

class ClothingItem extends StatelessWidget {
  final Clothing clothing;
  final VoidCallback? onTap;

  const ClothingItem({required this.clothing, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(clothing.name),
      subtitle: Text('${clothing.season} - ${clothing.category}'),
      trailing: Icon(
        clothing.isWashed ? Icons.check_circle : Icons.local_laundry_service,
        color: clothing.isWashed ? Colors.green : Colors.red,
      ),
      onTap: onTap,
    );
  }
}
