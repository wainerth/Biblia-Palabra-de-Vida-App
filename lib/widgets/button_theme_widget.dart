import 'package:flutter/material.dart';

class ButtonThemeWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final double width;
  final double height;
  final bool showIcon;
  final IconData icon;
  final Color colorIcon;
  const ButtonThemeWidget({
    super.key,
    this.onPressed,
    this.text,
    this.textStyle,
    this.buttonStyle,
    this.width = 150,
    this.height = 27,
    this.showIcon = false,
    this.icon = Icons.arrow_back,
    this.colorIcon = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: width, minHeight: height),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child:text != null ? Text(
          text!,
          style: textStyle,
        ): Icon(icon, color: colorIcon,),
      ),
    );
  }
}
