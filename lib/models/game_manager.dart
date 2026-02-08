import 'dart:math';
import '../utils/game_status.dart';

class GameManager {
  final int wordLength = 5;
  final int maxAttempts = 6;

  // Palabras posibles (5 letras)
  static const List<String> _palabrasPosibles = [
    "PERRO",
    "GATO",
    "LAPIZ",
    "LIBRO",
    "ARBOL",
    "CASAS",
    "MESAS",
    "SILLA",
    "RELOJ",
    "CARRO",
    "PLAYA",
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

  late final String palabraClave;

  GameManager() {
    palabraClave = _palabrasPosibles[Random().nextInt(_palabrasPosibles.length)];
  }

  Map<String, LetterStatus> keyStatus = {};
  List<String> palabrasIntentadas = []; // Lista de palabras que el usuario ha intentado
  String palabraActual = ""; // Palabra que el usuario está escribiendo AHORA mismo

  void onType(String letra) {
    if (palabraActual.length < wordLength) {
      palabraActual += letra.toUpperCase();
    }
  }

  void onDelete() {
    if (palabraActual.isNotEmpty) {
      palabraActual = palabraActual.substring(0, palabraActual.length - 1);
    }
  }

  bool onEnter() {
    if (palabraActual.length != wordLength) return false; // No enviar si faltan letras

    for (int i = 0; i < wordLength; i++) {
      String letter = palabraActual[i];

      // Obtenemos el estatus de esta letra en este intento específico
      // Nota: Usamos una versión simplificada de tu lógica aquí o reutilizamos el resultado visual
      // Para efectos del teclado, la prioridad es: GREEN > YELLOW > GRAY

      LetterStatus currentStatus = LetterStatus.notInWord; // Por defecto
      if (palabraClave[i] == letter) {
        currentStatus = LetterStatus.correct;
      } else if (palabraClave.contains(letter)) {
        currentStatus = LetterStatus.inWord;
      }

      // 2. Actualizamos el mapa del teclado SOLO si mejoramos el estado
      // (Si ya era Verde, no puede bajar a Amarillo o Gris)
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
    palabraActual = "";

    // TODO: Implementar lógica de victoria/derrota
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
