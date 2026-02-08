import 'package:flutter/material.dart';
import '../utils/game_status.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final LetterStatus status;

  const LetterBox({
    super.key,
    required this.letter,
    this.status = LetterStatus.initial,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color borderColor;

    switch (status) {
      case LetterStatus.correct:
        color = Colors.green;
        borderColor = Colors.green;
        break;
      case LetterStatus.inWord:
        color = Colors.orangeAccent;
        borderColor = Colors.orangeAccent;
        break;
      case LetterStatus.notInWord:
        color = Colors.grey;
        borderColor = Colors.grey;
        break;
      default:
        color = Colors.transparent;
        borderColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        letter.toUpperCase(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: status == LetterStatus.initial ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
