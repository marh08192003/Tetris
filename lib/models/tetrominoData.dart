import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

enum TetrominoType { O, I, S, Z, L, J, T }

class TetrominoData {
  final TetrominoType type;
  final Color color;
  final List<List<Vector2>> rotations;

  const TetrominoData({
    required this.type,
    required this.color,
    required this.rotations,
  });
}

final Map<TetrominoType, TetrominoData> tetrominoDataMap = {
  //O
  TetrominoType.O: TetrominoData(
    type: TetrominoType.O,
    color: Colors.yellow,
    rotations: [
      [Vector2(0, 0), Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)], // 0°
      [Vector2(0, 0), Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)], // 90°
      [Vector2(0, 0), Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)], // 180°
      [Vector2(0, 0), Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)], // 270°
    ],
  ),

  //I
  TetrominoType.I: TetrominoData(
    type: TetrominoType.I,
    color: Colors.cyan,
    rotations: [
      [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)], // 0°
      [Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(1, 2)], // 90°
      [Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)], // 180°
      [Vector2(0, -1), Vector2(0, 0), Vector2(0, 1), Vector2(0, 2)], // 270°
    ],
  ),

  //S
  TetrominoType.S: TetrominoData(
    type: TetrominoType.S,
    color: Colors.green,
    rotations: [
      [Vector2(1, 0), Vector2(0, 0), Vector2(0, 1), Vector2(-1, 1)], // 0°
      [Vector2(0, -1), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1)], // 90°
      [Vector2(1, -1), Vector2(0, -1), Vector2(0, 0), Vector2(-1, 0)], // 180°
      [Vector2(-1, -1), Vector2(-1, 0), Vector2(0, 0), Vector2(0, 1)], // 270°
    ],
  ),

  //Z
  TetrominoType.Z: TetrominoData(
    type: TetrominoType.Z,
    color: Colors.red,
    rotations: [
      [Vector2(-1, 0), Vector2(0, 0), Vector2(0, 1), Vector2(1, 1)], // 0°
      [Vector2(0, 1), Vector2(0, 0), Vector2(1, 0), Vector2(1, -1)], // 90°
      [Vector2(-1, -1), Vector2(0, -1), Vector2(0, 0), Vector2(1, 0)], // 180°
      [Vector2(-1, 1), Vector2(-1, 0), Vector2(0, 0), Vector2(0, -1)], // 270°
    ],
  ),

  //L
  TetrominoType.L: TetrominoData(
    type: TetrominoType.L,
    color: Colors.blueAccent,
    rotations: [
      [Vector2(0, -1), Vector2(0, 0), Vector2(0, 1), Vector2(1, 1)], // 0°
      [Vector2(-1, 1), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0)], // 90°
      [Vector2(-1, -1), Vector2(0, -1), Vector2(0, 0), Vector2(0, 1)], // 180°
      [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(1, -1)], // 270°
    ],
  ),

  //J
  TetrominoType.J: TetrominoData(
    type: TetrominoType.J,
    color: Colors.orange,
    rotations: [
      [Vector2(0, -1), Vector2(0, 0), Vector2(0, 1), Vector2(-1, 1)], // 0°
      [Vector2(-1, -1), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0)], // 90°
      [Vector2(0, -1), Vector2(0, 0), Vector2(0, 1), Vector2(1, -1)], //180°
      [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1)], //270°
    ],
  ),

  //T
  TetrominoType.T: TetrominoData(
    type: TetrominoType.T,
    color: Colors.deepPurple,
    rotations: [
      [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)], // 0°
      [Vector2(0, -1), Vector2(0, 0), Vector2(0, 1), Vector2(1, 0)], // 90°
      [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(0, -1)], // 180°
      [Vector2(0, -1), Vector2(0, 0), Vector2(0, 1), Vector2(-1, 0)], // 270°
    ],
  ),
};
