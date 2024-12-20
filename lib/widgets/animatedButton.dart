import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    Animation<Color?>? _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.lightBlue,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            // Acción al presionar el botón
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            // onPrimary: Colors.white,
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
