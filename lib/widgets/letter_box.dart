import 'package:flutter/material.dart';
import '../utils/game_status.dart';

class LetterBox extends StatefulWidget {
  final String letter;
  final LetterStatus status;

  const LetterBox({super.key, required this.letter, this.status = LetterStatus.initial});

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    if (widget.status != LetterStatus.initial) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant LetterBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Flip animation trigger
    if (widget.status != oldWidget.status && widget.status != LetterStatus.initial) {
      _controller.forward(from: 0);
    }

    // Pop animation trigger (when typing a new letter)
    if (widget.letter.isNotEmpty &&
        widget.letter != oldWidget.letter &&
        widget.status == LetterStatus.initial) {
      _controller.duration = const Duration(milliseconds: 150);
      _controller.forward(from: 0).then((_) => _controller.reverse());
    }

    // Reset controller if we go back to empty/initial (e.g. backspace)
    if (widget.status == LetterStatus.initial &&
        oldWidget.status != LetterStatus.initial) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Pop animation (Scaling)
        if (widget.status == LetterStatus.initial) {
          // Simple scale effect: 1.0 -> 1.1 -> 1.0
          double scale = 1.0;
          if (_controller.isAnimating && _controller.duration!.inMilliseconds < 200) {
            scale = 1.0 + (_controller.value * 0.1);
          }
          return Transform.scale(
            scale: scale,
            child: buildBox(widget.status, widget.letter),
          );
        }

        double angle = _controller.value * 3.14159; // PI
        LetterStatus statusToShow = widget.status;
        String letterToShow = widget.letter;

        if (_controller.value <= 0.5) {
          statusToShow = LetterStatus.initial;
        } else {
          statusToShow = widget.status;
          angle = angle - 3.14159;
        }

        double rotateX = 0.0;
        if (_controller.value <= 0.5) {
          rotateX = _controller.value * 3.14159;
          statusToShow = LetterStatus.initial;
        } else {
          rotateX = (_controller.value - 1) * 3.14159;
          statusToShow = widget.status;
        }

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(rotateX),
          alignment: Alignment.center,
          child: buildBox(statusToShow, letterToShow),
        );
      },
    );
  }

  Widget buildBox(LetterStatus status, String letter) {
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
        if (letter.isNotEmpty) {
          borderColor = Colors.grey.shade600;
        }
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
