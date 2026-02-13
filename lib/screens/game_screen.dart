import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordle/utils/game_status.dart';
import '../models/game_manager.dart'; // Importamos la lógica
import '../widgets/letter_box.dart';
import '../widgets/game_keyboard.dart';

import '../widgets/instructions_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  // Instanciamos la lógica aquí
  final GameManager game = GameManager();
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _showInstructions() {
    showDialog(context: context, builder: (_) => const InstructionsDialog());
  }

  void _triggerShake() {
    _shakeController.forward(from: 0).then((_) => _shakeController.reset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wordle"),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: _showInstructions, tooltip: "Instrucciones"),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                game.reset();
              });
            },
            tooltip: "Reiniciar",
          ),
        ],
      ),
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
                    _triggerShake();
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

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        double offset = 0;
        if (rowIndex == game.palabrasIntentadas.length) {
          offset = 10 * sin(_shakeController.value * 3 * 3.14159);
        }
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(game.wordLength, (letterIndex) {
          String letter = "";
          if (letterIndex < wordToDisplay.length) {
            letter = wordToDisplay[letterIndex];
          }

          LetterStatus status = game.getStatus(rowIndex, letterIndex);

          return LetterBox(letter: letter, status: status);
        }),
      ),
    );
  }

  void showGameOverDialog() {
    String title = game.status == GameStatus.won ? "¡Ganaste!" : "¡Perdiste!";
    String message = game.status == GameStatus.won
        ? "¡Felicidades! Adivinaste la palabra."
        : "La palabra era: ${game.palabraClave}";

    IconData icon = game.status == GameStatus.won ? Icons.emoji_events : Icons.sentiment_very_dissatisfied;
    Color color = game.status == GameStatus.won ? Colors.green : Colors.red;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text("¿Quieres jugar de nuevo?"),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                game.reset();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            child: const Text("Jugar de nuevo"),
          ),
        ],
      ),
    );
  }
}
