import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
    late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
     _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

  
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child){
          return Transform.scale(
            scale: _animation.value,
            child: child,
           );
        },
        child: Image.asset(
          'assets/kawaii_fire.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
