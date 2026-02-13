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
      mainAxisSize: MainAxisSize.min,
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
        // Use flex factor to give Enter/Backspace more space if needed
        int flex = (key.length > 1) ? 2 : 1;

        return Expanded(
          flex: flex,
          child: Container(
            margin: const EdgeInsets.all(2), // Reduce margin slightly
            height: 50, // Keep height somewhat fixed or use aspect ratio
            decoration: BoxDecoration(
              color: _getKeyColor(key),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  if (key == "ENTER") {
                    onEnter();
                  } else if (key == "⌫") {
                    onDelete();
                  } else {
                    onKeyPressed(key);
                  }
                },
                child: Center(
                  child: key == "⌫"
                      ? const Icon(Icons.backspace_outlined, size: 20)
                      : Text(
                          key,
                          style: TextStyle(
                            fontSize: key.length > 1 ? 12 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getKeyColor(String key) {
    Color bgColor = Colors.grey.shade300; // Default
    LetterStatus? status = game.keyStatus[key];

    if (status == LetterStatus.correct) {
      bgColor = Colors.green;
    } else if (status == LetterStatus.inWord) {
      bgColor = Colors.orangeAccent;
    } else if (status == LetterStatus.notInWord) {
      bgColor = Colors.grey.shade600;
    }
    return bgColor;
  }
}
