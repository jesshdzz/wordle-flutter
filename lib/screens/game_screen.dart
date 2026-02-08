import 'package:flutter/material.dart';
import 'package:wordle/utils/game_status.dart';
import '../models/game_manager.dart'; // Importamos la lógica
import '../widgets/letter_box.dart';
import '../widgets/game_keyboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  // Instanciamos la lógica aquí
  final GameManager game = GameManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wordle")),
      body: Column(
        children: [
          // ZONA DEL TABLERO
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(game.maxAttempts, (index) {
                    return buildRow(index);
                  }),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: GameKeyboard(
              game: game, // Le pasamos el juego para que sepa los colores
              onKeyPressed: (key) {
                setState(() {
                  game.onType(key);
                });
              },
              onDelete: () {
                setState(() {
                  game.onDelete();
                });
              },
              onEnter: () {
                setState(() {
                  if (game.palabraActual.length < game.wordLength) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("¡Faltan letras!"), duration: Duration(milliseconds: 500)),
                    );
                    return;
                  }

                  if (game.onEnter()) {
                    if (game.isGameOver) {
                      showGameOverDialog();
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(int rowIndex) {
    String wordToDisplay = "";

    if (rowIndex < game.palabrasIntentadas.length) {
      wordToDisplay = game.palabrasIntentadas[rowIndex];
    } else if (rowIndex == game.palabrasIntentadas.length) {
      wordToDisplay = game.palabraActual;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(game.wordLength, (letterIndex) {
        String letter = "";
        if (letterIndex < wordToDisplay.length) {
          letter = wordToDisplay[letterIndex];
        }

        LetterStatus status = game.getStatus(rowIndex, letterIndex);

        return LetterBox(letter: letter, status: status);
      }),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Fin del Juego"),
        content: Text("La palabra era ${game.palabraClave}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí podrías reiniciar el juego
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
