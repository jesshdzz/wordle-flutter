# Proyecto: Wordle

## Propósito
Este proyecto es una implementación del juego Wordle desarrollado en Flutter. Su objetivo principal es ofrecer una experiencia de juego de adivinanza de palabras al estilo del juego original, replicando la mecánica original donde el usuario debe deducir una palabra oculta de 5 letras en un máximo de 6 intentos.

## Características Principales
- **Selección Aleatoria de Palabras**: El sistema elige una palabra al azar de una lista predefinida al iniciar cada partida.
- **Sistema de Pistas Visuales**:
  - Verde: La letra está en la palabra y en la posición correcta.
  - Amarillo: La letra está en la palabra pero en una posición incorrecta.
  - Gris: La letra no se encuentra en la palabra.
- **Validación de Input**: Se impide el envío de palabras con menos de 5 letras.
- **Estados de Juego**: Control de flujo entre estados de juego activo, victoria y derrota.
- **Reinicio**: Funcionalidad para reiniciar la partida en cualquier momento sin cerrar la aplicación.
- **Interfaz Adaptable**: Diseño responsivo y teclado en pantalla integrado.

## Componentes del Proyecto
El proyecto se estructura en los siguientes componentes clave:
- **GameScreen**: Pantalla principal que orquesta la interfaz de usuario, incluyendo el tablero de juego y la barra de acciones.
- **GameKeyboard**: Widget personalizado que simula un teclado QWERTY, gestionando la entrada de caracteres y mostrando el estado de las letras ya utilizadas.
- **LetterBox**: Componente individual que representa cada celda del tablero, encargado de mostrar las letras y sus colores correspondientes según el estado.
- **InstructionsDialog**: Ventana modal que presenta las reglas del juego y ejemplos visuales al usuario.

## Modelos de Datos
- **GameManager**: Clase central que maneja la lógica de negocio. Administra la palabra clave, los intentos del usuario, el estado actual del juego y la validación de las palabras ingresadas.
- **GameStatus**: Enumeración que define los posibles estados de la partida (jugando, ganado, perdido).
- **LetterStatus**: Enumeración para clasificar el estado de cada letra (inicial, no en palabra, en palabra, correcta).

## Jugabilidad
1. El juego inicia seleccionando una palabra oculta de 5 letras.
2. El usuario ingresa una palabra utilizando el teclado en pantalla.
3. Al presionar "ENTER", el sistema evalúa la palabra y actualiza los colores de las letras en el tablero y en el teclado.
4. El usuario dispone de 6 intentos para adivinar la palabra correcta.
5. El juego finaliza cuando el usuario acierta la palabra (Victoria) o agota sus intentos (Derrota), mostrando un cuadro de diálogo con el resultado y la opción de volver a jugar.