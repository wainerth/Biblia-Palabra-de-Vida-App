import 'package:flutter/material.dart';

class TextWithGradient extends StatelessWidget {
  final String text;
  final TextStyle font;
  final List<Color> colorList;
  const TextWithGradient(
      {super.key,
      required this.text,
      required this.font,
      this.colorList = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      // Contenedor para ajustar el tamaño si es necesario
      // height: 100, // Ajusta la altura según tu diseño
      child: ShaderMask(
        blendMode: BlendMode.srcIn, // Mezcla el degradado con el texto
        shaderCallback: (bounds) => LinearGradient(
          colors: colorList.isEmpty
              ? [
                  Color(0xFFAF01EF),
                  Color(0xFFC341F3),
                  Color(0xFF2DCEEB),
                  Colors.white
                ]
              : colorList,
          stops: [0.15, 0.59, 0.83, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: font,
        ),
      ),
    );
  }
}
