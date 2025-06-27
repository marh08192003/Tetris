import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class TetrominoPreview extends StatelessWidget {
  final List<Vector2> blocks;
  final Color color;
  final double blockSize;

  const TetrominoPreview({
    super.key,
    required this.blocks,
    required this.color,
    this.blockSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final minX = blocks.map((v) => v.x).reduce((a, b) => a < b ? a : b);
    final minY = blocks.map((v) => v.y).reduce((a, b) => a < b ? a : b);

    return SizedBox(
      width: blockSize * 4,
      height: blockSize * 4,
      child: Stack(
        children: blocks.map((v) {
          final x = v.x - minX;
          final y = v.y - minY;
          return Positioned(
            left: x * blockSize,
            top: y * blockSize,
            child: Container(
              width: blockSize,
              height: blockSize,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
