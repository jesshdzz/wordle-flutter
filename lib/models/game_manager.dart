import 'dart:math';
import '../utils/game_status.dart';

class GameManager {
  late String palabraClave;
  final int wordLength = 5;
  final int maxAttempts = 6;

  final List<String> palabrasPosibles = [
    "PERRO",
    "GATOS",
    "CASAS",
    "ARBOL",
    "LIBRO",
    "MESAS",
    "SILLA",
    "FUEGO",
    "AGUAS",
    "RELOJ",
    "LAPIZ",
    "PAPEL",
    "FLOR",
    "NUBES",
    "COCHE",
    "AVION",
    "BARCO",
    "TREN",
    "PLAYA",
    "MONTE",
    "CARRO",
    "NOCHE",
    "TARDE",
    "LUNES",
    "HOTEL",
    "RADIO",
    "PIANO",
    "GUION",
    "ACTOR",
    "AUTOR",
  ];

  GameStatus status = GameStatus.playing;
  Map<String, LetterStatus> keyStatus = {};

  int intentoActual = 0; // En qué fila vamos (0 a 5)
  List<String> palabrasIntentadas = []; // Lista de palabras que el usuario ha intentado
  String palabraActual = ""; // Palabra que el usuario está escribiendo AHORA mismo

  GameManager() {
    reset();
  }

  void reset() {
    status = GameStatus.playing;
    palabraClave = palabrasPosibles[Random().nextInt(palabrasPosibles.length)];
    palabrasIntentadas.clear();
    palabraActual = "";
    keyStatus.clear();
    intentoActual = 0; // Aunque usamos length de la lista, es bueno resetear si se usara
  }

  void onType(String letra) {
    if (status != GameStatus.playing) return; // No permitir escribir si terminó
    if (palabraActual.length < wordLength) {
      palabraActual += letra.toUpperCase();
    }
  }

  void onDelete() {
    if (status != GameStatus.playing) return;
    if (palabraActual.isNotEmpty) {
      palabraActual = palabraActual.substring(0, palabraActual.length - 1);
    }
  }

  bool onEnter() {
    if (status != GameStatus.playing) return false;
    if (palabraActual.length != wordLength) return false; // No enviar si faltan letras

    // 1. Actualizar teclado (lógica visual)
    for (int i = 0; i < wordLength; i++) {
      String letter = palabraActual[i];
      LetterStatus currentStatus = LetterStatus.notInWord;

      if (palabraClave[i] == letter) {
        currentStatus = LetterStatus.correct;
      } else if (palabraClave.contains(letter)) {
        currentStatus = LetterStatus.inWord;
      }

      if (!keyStatus.containsKey(letter)) {
        keyStatus[letter] = currentStatus;
      } else {
        LetterStatus oldStatus = keyStatus[letter]!;
        if (currentStatus == LetterStatus.correct) {
          keyStatus[letter] = LetterStatus.correct;
        } else if (currentStatus == LetterStatus.inWord && oldStatus != LetterStatus.correct) {
          keyStatus[letter] = LetterStatus.inWord;
        }
      }
    }

    palabrasIntentadas.add(palabraActual);

    // 2. Verificar Victoria / Derrota
    if (palabraActual == palabraClave) {
      status = GameStatus.won;
    } else if (palabrasIntentadas.length >= maxAttempts) {
      status = GameStatus.lost;
    }

    palabraActual = "";
    return true;
  }

  LetterStatus getStatus(int rowIndex, int letterIndex) {
    if (rowIndex >= palabrasIntentadas.length) return LetterStatus.initial;

    String palabraIngresada = palabrasIntentadas[rowIndex];

    // Copia de las letras de la palabra clave para ir marcando las que ya "usamos"
    List<String> letrasDisponibles = palabraClave.split('');

    List<LetterStatus> estadosFila = List.filled(wordLength, LetterStatus.notInWord);

    // PASO 1: Identificar las verdes (posición correcta)
    for (int i = 0; i < wordLength; i++) {
      if (palabraIngresada[i] == palabraClave[i]) {
        estadosFila[i] = LetterStatus.correct;
        // Quitamos una instancia de esa letra de las disponibles
        letrasDisponibles.remove(palabraIngresada[i]);
      }
    }

    // PASO 2: Identificar las amarillas (letra existe pero en otra posición)
    for (int i = 0; i < wordLength; i++) {
      if (estadosFila[i] == LetterStatus.correct) continue;

      if (letrasDisponibles.contains(palabraIngresada[i])) {
        estadosFila[i] = LetterStatus.inWord;
        letrasDisponibles.remove(palabraIngresada[i]);
      }
    }

    return estadosFila[letterIndex];
  }

  bool get isGameOver => palabrasIntentadas.contains(palabraClave) || palabrasIntentadas.length >= maxAttempts;
}
