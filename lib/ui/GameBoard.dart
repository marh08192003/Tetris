import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tetris/models/active_tetromino.dart';
import 'package:tetris/models/tetrominoData.dart';

class Gameboard extends StatelessWidget{
  final int columns;
  final int rows;
  final double cellSize;
  final List<List<Color?>> board;
  final ActiveTetromino? activeTetromino;

  const Gameboard({
    super.key,
    this.columns = 10,
    this.rows = 26, //20 usables + 6 preview
    this.cellSize = 20.0,
    required this.board,
    this.activeTetromino,
  });
  
  @override
  Widget build(BuildContext context) {

    //Calcular las celdas activas de la ficha actual
    final currentBlocks = <Vector2, Color>{};
    if(activeTetromino != null){
      final data = tetrominoDataMap[activeTetromino!.type]!;
      final rotation = data.rotations[activeTetromino!.rotationIndex];
      final origin = activeTetromino!.position;

      for (var offset in rotation){
        final x = origin.x.toInt() + offset.x.toInt();
        final y = origin.y.toInt() + offset.y.toInt();

        if(x >= 0 && x < columns && y >= 0 && y < rows){
          currentBlocks[Vector2(x.toDouble(), y.toDouble())] = data.color;
        }
      }
    }

    return Column(
      children: List.generate(rows, (y){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(columns, (x){
            final color = currentBlocks[Vector2(x.toDouble(), y.toDouble())] ??
              board[y][x] ??
              (y < 6 ? const Color.fromARGB(255, 36, 36, 36) : const Color.fromARGB(255, 0, 0, 0)); //Previsualizacion superior
            return Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.white, width: 0.5),
              ),
            );
          }),
        );
      }),
    );
  }
}