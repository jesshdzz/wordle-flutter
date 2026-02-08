enum LetterStatus {
  initial,    // Estado normal
  notInWord,  // Letra no existe. Color gris
  inWord,     // Letra existe pero no está en la posición correcta. Color amarillo
  correct,    // Letra existe y está en la posición correcta. Color verde
}