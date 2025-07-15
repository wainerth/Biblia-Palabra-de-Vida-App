import 'package:flutter/material.dart';

class ButtonThemeWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final double? width;
  final double? height;
  final bool showIcon;
  final IconData icon;
  final bool textWithImage;
  final String image;
  final Color colorIcon;
  final bool textCenter;
  final bool loading;
  final bool disabled;
  const ButtonThemeWidget(
      {super.key,
      this.onPressed,
      this.text,
      this.textStyle,
      this.buttonStyle,
      this.width,
      this.height,
      this.showIcon = false,
      this.icon = Icons.arrow_back,
      this.colorIcon = Colors.black,
      this.textCenter = false,
      this.textWithImage = false,
      this.image = '',
      this.loading = false,
      this.disabled = false
      })
      : assert(!textWithImage || text != null,
            'Text is required when textWithImage is true');

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width ?? double.infinity,
        minHeight: height ?? 0,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: textWithImage
          ? TextButton(
              onPressed: loading || disabled ? null : onPressed,
              style: buttonStyle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text!,
                    textAlign: textCenter ? TextAlign.center : TextAlign.start,
                    style: textStyle,
                  ),
                  SizedBox(
                    width: 26.0,
                    child: Image.asset(image),
                  ),
                ],
              ))
          : TextButton(
              onPressed: loading || disabled ? null : onPressed,
              style: buttonStyle,
              child: text != null
                  ? Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                text!,
                                textAlign: textCenter
                                    ? TextAlign.center
                                    : TextAlign.left,
                                style: textStyle,
                              ),
                            )),
                        if (showIcon) ...[
                          Expanded(
                            flex: 0,
                            child: Icon(
                              icon,
                              color: colorIcon,
                            ),
                          )
                        ]
                      ],
                    )
                  : Icon(icon)),
    );
  }
}
