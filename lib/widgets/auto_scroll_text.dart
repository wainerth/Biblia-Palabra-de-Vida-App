import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double maxWidth;
  final Duration scrollDuration;
  final Duration pauseDuration;

  const AutoScrollText(
    this.text, {
    Key? key,
    this.style,
    this.maxWidth = 150,
    this.scrollDuration = const Duration(seconds: 3),
    this.pauseDuration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  Timer? _timer;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartScroll();
    });
  }

  void _checkAndStartScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _startScrolling();
      }
    }
  }

  void _startScrolling() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: 
          widget.scrollDuration.inMilliseconds + widget.pauseDuration.inMilliseconds),
      (timer) {
        if (_isScrolling) return;
        _animateScroll();
      },
    );
    // Iniciar primera animación
    Future.delayed(Duration(milliseconds: 500), () {
      _animateScroll();
    });
  }

  void _animateScroll() async {
    if (!_scrollController.hasClients) return;
    
    _isScrolling = true;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    if (maxScroll > 0) {
      // Scroll hacia adelante
      await _scrollController.animateTo(
        maxScroll,
        duration: widget.scrollDuration,
        curve: Curves.linear,
      );
      
      // Pausa
      await Future.delayed(widget.pauseDuration);
      
      // Scroll hacia atrás
      if (mounted && _scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: widget.scrollDuration,
          curve: Curves.linear,
        );
        
        // Pausa antes de repetir
        await Future.delayed(widget.pauseDuration);
      }
    }
    _isScrolling = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        child: MouseRegion(
          onEnter: (_) {
            // Opcional: pausar al pasar el mouse
            // _timer?.cancel();
          },
          onExit: (_) {
            // Opcional: reanudar al salir
            // _startScrolling();
          },
          child: Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}