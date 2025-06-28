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
      type: TetrominoType.values[DateTime.now().millisecondsSinceEpoch % 7],
      rotationIndex: 0,
      position: Vector2(4, 0),
    );

    gravityTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      final nextPos = activeTetromino.position + Vector2(0, 1);
      final colides = checkCollision(nextPos, activeTetromino.rotationIndex);

      if (colides) {
        //Fijar la ficha en el tablero
        final blocks = tetrominoDataMap[activeTetromino.type]!
            .rotations[activeTetromino.rotationIndex];

        bool gameover = false;

        for (final block in blocks) {
          final x = activeTetromino.position.x + block.x;
          final y = activeTetromino.position.y + block.y;

          if (y >= 0 && y < 26 && x >= 0 && x < 10) {
            if (y < 6) gameover = true; //Supera el limite superior

            board[y.toInt()][x.toInt()] =
                tetrominoDataMap[activeTetromino.type]!.color;
          }
        }

        if (gameover) {
          gravityTimer?.cancel(); //Detiene la gravedad
          gravityTimer = null;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('GAME OVER'),
              content: const Text('exceeded the allowed play area'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Reiniciar app o cerrar
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        //Crear nueva ficha
        activeTetromino = ActiveTetromino(
          type: TetrominoType.values[DateTime.now().millisecondsSinceEpoch % 7],
          rotationIndex: 0,
          position: Vector2(4, 0),
        );
      } else {
        setState(() {
          activeTetromino = ActiveTetromino(
            type: activeTetromino.type,
            rotationIndex: activeTetromino.rotationIndex,
            position: activeTetromino.position + Vector2(0, 1), // mover abajo
          );
        });
      }
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
      floatingActionButton: FloatingActionButton(
        onPressed: rotateTetromino,
        backgroundColor: Colors.white,
        child: const Icon(Icons.rotate_left, color: Colors.black,),
        ),
    );
  }

  bool checkCollision(Vector2 newPosition, int rotationIndex) {
    final blocks =
        tetrominoDataMap[activeTetromino.type]!.rotations[rotationIndex];

    for (final block in blocks) {
      final x = newPosition.x + block.x;
      final y = newPosition.y + block.y;

      //Limites del tablero
      if (x < 0 || x >= 10 || y >= 26) return true;

      //Colision otra ficha colocada
      if (y >= 0 && board[y.toInt()][x.toInt()] != null) return true;
    }
    return false;
  }

  void rotateTetromino() {
    final newRotation = (activeTetromino.rotationIndex + 1) % 4;

    //Comprobar colisiones antes de rotar
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
}
