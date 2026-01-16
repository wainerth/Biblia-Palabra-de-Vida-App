import 'package:flutter/material.dart';

class AdaptiveSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    // Colores por defecto
    final Color finalBackgroundColor = backgroundColor ?? Colors.grey[800]!;
    final Color finalTextColor = textColor ?? Colors.white;
    
    // Para tablet: calcular márgenes
    final double tabletWidth = (screenWidth * 0.6).clamp(350.0, 500.0);
    
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: finalTextColor),
        textAlign: isTablet ? TextAlign.center : TextAlign.start,
      ),
      backgroundColor: finalBackgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: isTablet
          ? EdgeInsets.only(
              bottom: 20,
              left: (screenWidth - tabletWidth) / 2,
              right: (screenWidth - tabletWidth) / 2,
            )
          : EdgeInsets.zero,
      shape: isTablet
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )
          : null,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  // Método específico para "copiado"
  static void showCopiedMessage(BuildContext context, String text) {
    show(
      context: context,
      message: text,
      backgroundColor: Colors.green[700],
      textColor: Colors.white,
    );
  }
}