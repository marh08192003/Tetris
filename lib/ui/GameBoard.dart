import 'package:flutter/material.dart';

class Gameboard extends StatelessWidget{
  final int columns;
  final int rows;
  final double cellSize;

  const Gameboard({
    super.key,
    this.columns = 10,
    this.rows = 26, //20 usables + 6 preview
    this.cellSize = 20.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows, (y){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(columns, (x){
            return Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: y < 6 ? const Color.fromARGB(255, 36, 36, 36) : const Color.fromARGB(255, 0, 0, 0), //Previsualizacion superior
                border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
              ),
            );
          }),
        );
      }),
    );
  }
}