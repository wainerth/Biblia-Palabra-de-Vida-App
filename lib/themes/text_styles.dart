import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStylesApp {
  final BuildContext context;
  TextStylesApp(this.context);

  double get screenWidth {
    // Retrieve the screen width from the context or another source
    return MediaQuery.of(context).size.width;
  }

  double get fontSizeTitle {
    if (screenWidth <= SizeScreensApp().sm) {
      return 48.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 68.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 78.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 80.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeTitle1 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 28.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 32.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 32.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 32.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeSubTitle {
    if (screenWidth <= SizeScreensApp().sm) {
      return 25.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 35.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 48.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 48.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody1 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 18.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 22.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 30.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 30.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody2 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 32.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 40.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 40.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody3 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 25.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 25.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBtn {
    if (screenWidth <= SizeScreensApp().sm) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 20.sp;
    } else {
      return 16.sp;
    }
  }

  Size get btnSize {
    if (screenWidth <= SizeScreensApp().sm) {
      return Size(293.0, 40.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(293.0, 65.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(double.infinity, 65.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(double.infinity, 80.0);
    } else {
      return Size(700.0, 80.0);
    }
  }

  TextStyle get textWhithGradient => GoogleFonts.getFont("Alfa Slab One",
      fontSize: fontSizeTitle1,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none);

  TextStyle get textStyleTitle => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeTitle, fontWeight: FontWeight.normal);
  TextStyle get textStyleTitleBlue => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeTitle1,
      fontWeight: FontWeight.normal,
      color: Color(0xFF12CBC4));

  // TextStyle(fontFamily: "Erica One", fontSize: fontSizeTitle,fontWeight: FontWeight.w800);

  TextStyle get textStyleSubTitle =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeSubTitle);

  TextStyle get textStyleBody1 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody1);

  TextStyle get textStyleBody2 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody2);

  TextStyle get textStyleBody3 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody2);

  TextStyle get buttonTextStyle => GoogleFonts.getFont(
        "Aclonica",
        fontSize: fontSizeBtn,
      );

  ButtonStyle get btnPrimary => ButtonStyle(
        minimumSize: MaterialStateProperty.all(btnSize),
        maximumSize: MaterialStateProperty.all(btnSize),
        foregroundColor:
            MaterialStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0XFF12CBC4)),
        textStyle: MaterialStateProperty.all(buttonTextStyle),
      );
  ButtonStyle get btnSecondary => ButtonStyle(
        minimumSize: MaterialStateProperty.all(btnSize),
        maximumSize: MaterialStateProperty.all(btnSize),
        foregroundColor:
            MaterialStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0XFFFD8C43)),
        textStyle: MaterialStateProperty.all(buttonTextStyle),
      );

  ButtonStyle get btnTertiary => ButtonStyle(
        minimumSize: MaterialStateProperty.all(btnSize),
        maximumSize: MaterialStateProperty.all(btnSize),
        foregroundColor:
            MaterialStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0XFF83A2A1)),
        textStyle: MaterialStateProperty.all(buttonTextStyle),
      );

    InputDecoration get InputDecorationStyle => InputDecoration(
        labelStyle: labelStyle,
        hintStyle: hintStyle ,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 5.88 , horizontal: 11)
      );

  TextStyle get hintStyle => GoogleFonts.getFont(
        "Aclonica",
        color: Color(0XFF746F6F),
        fontSize: 20,
      );
  TextStyle get labelStyle => GoogleFonts.getFont(
        "Aclonica",
        fontSize: 20,
        color: Color(0XFF746F6F)
      );
}

class SizeScreensApp {
  final double sm = 320;
  final double md = 375;
  final double lg = 425;
  final double xlg = 768;
}
