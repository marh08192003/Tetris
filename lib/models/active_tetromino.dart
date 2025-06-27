import 'package:vector_math/vector_math_64.dart';
import 'tetrominoData.dart';

class ActiveTetromino {
  final TetrominoType type;
  final int rotationIndex;
  final Vector2 position;

  ActiveTetromino({
    required this.type,
    required this.rotationIndex,
    required this.position,
  });
}