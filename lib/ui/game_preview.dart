import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:tetris/models/tetrominoData.dart';
import 'GameBoard.dart';
import 'package:tetris/models/active_tetromino.dart';

class GamePreview extends StatefulWidget {
  const GamePreview({super.key});

  @override
  State<GamePreview> createState() => _GamePreviewState();
}

class _GamePreviewState extends State<GamePreview> {
  late List<List<Color?>> board;
  late ActiveTetromino activeTetromino;
  Timer? gravityTimer;

  @override
  void initState() {
    super.initState();

    board = List.generate(26, (_) => List.generate(10, (_) => null));
    activeTetromino = ActiveTetromino(
      type: TetrominoType.T,
      rotationIndex: 0,
      position: Vector2(4, 0),
    );

    gravityTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        activeTetromino = ActiveTetromino(
          type: activeTetromino.type,
          rotationIndex: activeTetromino.rotationIndex,
          position: activeTetromino.position + Vector2(0, 1), // mover abajo
        );
      });
    });
  }

  @override
  void dispose() {
    gravityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Gameboard(board: board, activeTetromino: activeTetromino),
      ),
    );
  }
}
