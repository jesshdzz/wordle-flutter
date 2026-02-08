import 'package:flutter/material.dart';
import '../widgets/letter_box.dart';
import '../utils/game_status.dart';

class InstructionsDialog extends StatelessWidget {
  const InstructionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: const TextStyle(fontSize: 14, color: Colors.black),
      title: const Text("Cómo jugar"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Adivina la palabra oculta en 6 intentos."),
            const SizedBox(height: 10),
            const Text("Cada intento debe ser una palabra válida de 5 letras."),
            const SizedBox(height: 10),
            const Text(
              "Después de cada intento, el color de las letras cambiará para mostrar qué tan cerca estás de acertar la palabra.",
            ),
            const SizedBox(height: 20),
            const Text("Ejemplos", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildExampleRow(
              "GATOS",
              0,
              LetterStatus.correct,
              "La letra G está en la palabra y en la posición correcta.",
            ),
            const SizedBox(height: 10),
            buildExampleRow(
              "PIANO",
              2,
              LetterStatus.inWord,
              "La letra A está en la palabra pero en la posición incorrecta.",
            ),
            const SizedBox(height: 10),
            buildExampleRow("LUNES", 4, LetterStatus.notInWord, "La letra S no está en la palabra."),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("¡JUGAR!"))],
    );
  }

  Widget buildExampleRow(String word, int targetIndex, LetterStatus targetStatus, String explanation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(word.length, (index) {
            return Expanded(
              child: Transform.scale(
                scale: 0.8,
                child: LetterBox(
                  letter: word[index],
                  status: index == targetIndex ? targetStatus : LetterStatus.initial,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(explanation, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
