import 'package:flutter/material.dart';

class RadioboxGroup extends StatelessWidget {
  String _selectedCategory = '';
  Function updateCategory;
  RadioboxGroup({super.key, required this.updateCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RadioListTile(
          title: const Text('T-Shirts'),
          value: 'T-Shirts',
          groupValue: _selectedCategory,
          onChanged: (value) {
            updateCategory(value);
          },
        ),
        RadioListTile(
          title: const Text('Jackets'),
          value: 'Jackets',
          groupValue: _selectedCategory,
          onChanged: (value) {
            updateCategory(value);
          },
        ),
        RadioListTile(
          title: const Text('Shoes'),
          value: 'Shoes',
          groupValue: _selectedCategory,
          onChanged: (value) {
            updateCategory(value);
          },
        ),
        RadioListTile(
          title: const Text('Sweaters'),
          value: 'Sweaters',
          groupValue: _selectedCategory,
          onChanged: (value) {
            updateCategory(value);
          },
        ),
      ],
    );
  }
}
