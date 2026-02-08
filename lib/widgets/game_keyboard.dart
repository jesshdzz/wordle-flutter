import 'package:flutter/material.dart';
import 'package:wordle/utils/game_status.dart';
import '../models/game_manager.dart'; // Para acceder a los tipos

class GameKeyboard extends StatelessWidget {
  // Necesitamos recibir el Manager para saber los colores y enviar las teclas
  final GameManager game;
  final Function(String) onKeyPressed; // Callback cuando tocan letra
  final VoidCallback onEnter; // Callback Enter
  final VoidCallback onDelete; // Callback Borrar

  const GameKeyboard({
    super.key,
    required this.game,
    required this.onKeyPressed,
    required this.onEnter,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRow(["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]),
        buildRow(["A", "S", "D", "F", "G", "H", "J", "K", "L", "⌫"]),
        buildRow(["Z", "X", "C", "V", "B", "N", "M", "ENTER"]),
      ],
    );
  }

  Widget buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        double width = (key.length > 1) ? 54 : 30;

        Color bgColor = Colors.grey.shade300; // Default
        LetterStatus? status = game.keyStatus[key];

        if (status == LetterStatus.correct)
          bgColor = Colors.green;
        else if (status == LetterStatus.inWord)
          bgColor = Colors.orangeAccent;
        else if (status == LetterStatus.notInWord)
          bgColor = Colors.grey.shade600;

        return Container(
          margin: const EdgeInsets.all(3),
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () {
                if (key == "ENTER") {
                  onEnter();
                } else if (key == "⌫") {
                  onDelete();
                } else {
                  onKeyPressed(key);
                }
              },
              child: Container(
                width: width,
                height: 50,
                alignment: Alignment.center,
                child: key == "⌫"
                    ? const Icon(Icons.backspace_outlined, size: 18)
                    : Text(
                        key,
                        style: TextStyle(fontSize: key.length > 1 ? 12 : 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
