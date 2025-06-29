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
  int scoreCount = 0;

  @override
  void initState() {
    super.initState();

    board = List.generate(26, (_) => List.generate(10, (_) => null));
    activeTetromino = ActiveTetromino(
      type: TetrominoType.values[DateTime.now().millisecondsSinceEpoch % 7],
      rotationIndex: 0,
      position: Vector2(4, 0),
    );

    startGravity();
  }

  void startGravity() {
    gravityTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      final nextPos = activeTetromino.position + Vector2(0, 1);
      final colides = checkCollision(nextPos, activeTetromino.rotationIndex);

      if (colides) {
        fixTetromino();
      } else {
        setState(() {
          activeTetromino = ActiveTetromino(
            type: activeTetromino.type,
            rotationIndex: activeTetromino.rotationIndex,
            position: nextPos,
          );
        });
      }
    });
  }

  void fixTetromino() {
    final blocks = tetrominoDataMap[activeTetromino.type]!
        .rotations[activeTetromino.rotationIndex];

    bool gameover = false;

    for (final block in blocks) {
      final x = activeTetromino.position.x + block.x;
      final y = activeTetromino.position.y + block.y;

      if (y >= 0 && y < 26 && x >= 0 && x < 10) {
        if (y < 6) gameover = true;
        board[y.toInt()][x.toInt()] =
            tetrominoDataMap[activeTetromino.type]!.color;
      }
    }

    if (gameover) {
      gravityTimer?.cancel();
      gravityTimer = null;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('GAME OVER'),
          content: const Text('exceeded the allowed play area'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // 👇 Eliminar filas y sumar puntaje
    final eliminadas = deleteRow();
    setState(() {
      switch (eliminadas) {
        case 1:
          scoreCount += 10;
          break;
        case 2:
          scoreCount += 20;
          break;
        case 3:
          scoreCount += 30;
          break;
        case 4:
          scoreCount += 40;
          break;
      }

      // 👇 Nueva ficha
      activeTetromino = ActiveTetromino(
        type: TetrominoType.values[DateTime.now().millisecondsSinceEpoch % 7],
        rotationIndex: 0,
        position: Vector2(4, 0),
      );
    });
  }

  int deleteRow() {
    int deleteRows = 0;

    for (int y = board.length - 1; y >= 0; y--) {
      bool completeRow = true;

      for (int x = 0; x < board[y].length; x++) {
        if (board[y][x] == null) {
          completeRow = false;
          break;
        }
      }

      if (completeRow) {
        board.removeAt(y);
        board.insert(0, List.generate(10, (_) => null));
        deleteRows++;
        y++; // Revisar de nuevo la misma fila
      }
    }

    return deleteRows;
  }

  void hardDrop() {
    Vector2 dropPos = activeTetromino.position;

    while (!checkCollision(
      dropPos + Vector2(0, 1),
      activeTetromino.rotationIndex,
    )) {
      dropPos += Vector2(0, 1);
    }

    activeTetromino = ActiveTetromino(
      type: activeTetromino.type,
      rotationIndex: activeTetromino.rotationIndex,
      position: dropPos,
    );

    fixTetromino();
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
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'PUNTAJE: $scoreCount',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Gameboard(board: board, activeTetromino: activeTetromino),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: rotateTetromino,
            backgroundColor: Colors.white,
            child: const Icon(Icons.rotate_left, color: Colors.black),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: moveTetrominoLeft,
            backgroundColor: Colors.white,
            child: const Icon(Icons.arrow_left_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: moveTetrominoRight,
            backgroundColor: Colors.white,
            child: const Icon(Icons.arrow_right_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: softDrop,
            backgroundColor: Colors.white,
            child: const Icon(Icons.arrow_drop_down_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: hardDrop,
            backgroundColor: Colors.white,
            child: const Icon(Icons.vertical_align_bottom),
          ),
        ],
      ),
    );
  }

  bool checkCollision(Vector2 newPosition, int rotationIndex) {
    final blocks =
        tetrominoDataMap[activeTetromino.type]!.rotations[rotationIndex];

    for (final block in blocks) {
      final x = newPosition.x + block.x;
      final y = newPosition.y + block.y;

      if (x < 0 || x >= 10 || y >= 26) return true;
      if (y >= 0 && board[y.toInt()][x.toInt()] != null) return true;
    }
    return false;
  }

  void rotateTetromino() {
    final newRotation = (activeTetromino.rotationIndex + 1) % 4;
    if (!checkCollision(activeTetromino.position, newRotation)) {
      setState(() {
        activeTetromino = ActiveTetromino(
          type: activeTetromino.type,
          rotationIndex: newRotation,
          position: activeTetromino.position,
        );
      });
    }
  }

  void moveTetrominoLeft() {
    final newPosition = activeTetromino.position + Vector2(-1, 0);
    if (!checkCollision(newPosition, activeTetromino.rotationIndex)) {
      setState(() {
        activeTetromino = ActiveTetromino(
          type: activeTetromino.type,
          rotationIndex: activeTetromino.rotationIndex,
          position: newPosition,
        );
      });
    }
  }

  void moveTetrominoRight() {
    final newPosition = activeTetromino.position + Vector2(1, 0);
    if (!checkCollision(newPosition, activeTetromino.rotationIndex)) {
      setState(() {
        activeTetromino = ActiveTetromino(
          type: activeTetromino.type,
          rotationIndex: activeTetromino.rotationIndex,
          position: newPosition,
        );
      });
    }
  }

  void softDrop() {
    final newPosition = activeTetromino.position + Vector2(0, 1);
    if (!checkCollision(newPosition, activeTetromino.rotationIndex)) {
      setState(() {
        activeTetromino = ActiveTetromino(
          type: activeTetromino.type,
          rotationIndex: activeTetromino.rotationIndex,
          position: newPosition,
        );
      });
    }
  }
}
