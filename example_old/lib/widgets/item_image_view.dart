import 'dart:typed_data';

import 'package:flutter/material.dart';

class ItemImageView extends StatelessWidget {
  final Uint8List bytes;
  const ItemImageView({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
