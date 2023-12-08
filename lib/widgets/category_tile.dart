import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      trailing: category.isLocked ? Icon(Icons.lock) : null,
      onTap: () {
        // Dodaj logikę nawigacji do ekranu gry lub paywalla
      },
    );
  }
}
