import 'dart:convert';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<String> images;

  ImageGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.memory(
          base64.decode(images[index]),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
