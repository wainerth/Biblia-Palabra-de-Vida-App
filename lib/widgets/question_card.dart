import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final int numberQuestion;
  final int totalQuestions;
  final int failedAttempts;
  final double fontSize;
  final bool isTablet;
  
  // Nuevas propiedades para TTS
  final bool isTtsEnabled;
  final VoidCallback? onSpeakQuestion;
  final bool isSpeaking;

  const QuestionCard({
    super.key,
    required this.question,
    required this.numberQuestion,
    required this.totalQuestions,
    required this.failedAttempts,
    required this.fontSize,
    this.isTablet = false,
    // Nuevos parámetros TTS
    this.isTtsEnabled = false,
    this.onSpeakQuestion,
    this.isSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return _buildTabletCard(context);
    }
    return _buildMobileCard(context);
  }

  Widget _buildMobileCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: isTtsEnabled && onSpeakQuestion != null
              ? onSpeakQuestion
              : null,
          child: Container(
            constraints: BoxConstraints(minHeight: 68.0),
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 15.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0XFFFFBB00),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  offset: Offset(0.0, 4.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                      decoration: isTtsEnabled
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
                // Botón TTS para móvil
                if (isTtsEnabled && onSpeakQuestion != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: isSpeaking
                            ? Colors.blue.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: isSpeaking ? Colors.blue : Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isSpeaking ? Icons.stop : Icons.volume_up,
                          size: 16.0,
                          color: isSpeaking ? Colors.blue : Colors.black,
                        ),
                        onPressed: onSpeakQuestion,
                        padding: EdgeInsets.zero,
                        tooltip: isSpeaking ? "Detener" : "Escuchar pregunta",
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          right: 10,
          child: _buildAttemptsCounter(context),
        ),
      ],
    );
  }

  Widget _buildTabletCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0XFFFFBB00),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: Offset(0.0, 4.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Pregunta $numberQuestion de $totalQuestions",
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Row(
                children: [
                  // Botón TTS para tablet
                  if (isTtsEnabled && onSpeakQuestion != null)
                    Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: isSpeaking
                              ? Colors.blue.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: isSpeaking ? Colors.blue : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isSpeaking ? Icons.stop : Icons.volume_up,
                            size: 18.0,
                            color: isSpeaking ? Colors.blue : Colors.black,
                          ),
                          onPressed: onSpeakQuestion,
                          padding: EdgeInsets.zero,
                          tooltip: isSpeaking ? "Detener" : "Escuchar pregunta",
                        ),
                      ),
                    ),
                  _buildAttemptsCounter(context),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: isTtsEnabled && onSpeakQuestion != null
                ? onSpeakQuestion
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: Colors.black,
                          fontSize: fontSize,
                          decoration: isTtsEnabled
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationColor: Colors.blue,
                        ),
                  ),
                ),
                // Icono indicador TTS
                if (isTtsEnabled && onSpeakQuestion != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.volume_up,
                      size: 16.0,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
          // Mensaje de ayuda para TTS
          if (isTtsEnabled && onSpeakQuestion != null)
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 12.0,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    "Toca la pregunta para escucharla",
                    style: StylesApp(context).textStyleBody10.copyWith(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttemptsCounter(BuildContext context) {
    return Row(
      children: [
        Text(
          "Oportunidades: ",
          style: StylesApp(context).textStyleBody12.copyWith(
                color: StyleColor.grayDark,
                fontSize: 12,
              ),
        ),
        ...List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(left: 4),
            child: Image.asset(
              failedAttempts <= (2 - index)
                  ? "assets/fire_rachaActive.png"
                  : "assets/fire_rachaInactive.png",
              width: 20,
            ),
          );
        }),
      ],
    );
  }
}