import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StylesApp {
  final BuildContext context;
  StylesApp(this.context);

  double get screenWidth {
    // Retrieve the screen width from the context or another source
    return MediaQuery.of(context).size.width;
  }

/** tamaño e fuentes */ ///
  double get fontSizeTitle {
    if (screenWidth <= SizeScreensApp().xsm) {
      return 36.sp;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 36.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 36.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 48.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 60.sp;
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
      return 35.sp;
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
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody4 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 24.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 24.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 24.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody5 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
    } else {
      return 16.sp;
    }
  }
  double get fontSizeBody6 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 12.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 12.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 12.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBtn {
    if (screenWidth <= SizeScreensApp().sm) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 20.sp;
    } else {
      return 16.sp;
    }
  }

  Size get btnSize {
    if (screenWidth <= SizeScreensApp().sm) {
      return Size(293.0.sp, 65.0.sp);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(293.0.sp, 65.0.sp);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(double.infinity, 65.0.sp);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(double.infinity, 80.0.sp);
    } else {
      return Size(700.0.sp, 80.0.sp);
    }
  }

  Size get btnSizeSmall {
    if (screenWidth <= SizeScreensApp().sm) {
      return Size(239.0.sp, 41.0.sp);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(239.0.sp, 41.0.sp);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(double.infinity, 41.0.sp);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(double.infinity, 80.0.sp);
    } else {
      return Size(700.0.sp, 80.0.sp);
    }
  }

  TextStyle get textWithGradient => GoogleFonts.getFont(
        "Erica One",
        fontSize: fontSizeTitle1,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textStyleTitle => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeTitle, fontWeight: FontWeight.normal);
  TextStyle get textStyleLevelNumber => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeTitle1, fontWeight: FontWeight.normal);

  TextStyle get textStyNameNumber => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeBody3, fontWeight: FontWeight.normal);

  TextStyle get textStyCompleteLevelTitle =>
      GoogleFonts.getFont('Alfa Slab One',
          fontSize: fontSizeTitle1, fontWeight: FontWeight.normal);
  TextStyle get textStyCompleteLevelBody => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeBody3, fontWeight: FontWeight.normal);

  TextStyle get textStyleTitleBlue => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeTitle1,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF12CBC4));
  TextStyle get textStyleTitleOrange => GoogleFonts.getFont('Alfa Slab One',
      fontSize: fontSizeSubTitle,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFFD8C43));

  // TextStyle(fontFamily: "Erica One", fontSize: fontSizeTitle,fontWeight: FontWeight.w800);

  TextStyle get textStyleSubTitle =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeSubTitle);

  TextStyle get textStyleBody1 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody1);

  TextStyle get textStyleBody2 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody2);

  TextStyle get textStyleBody3 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody2);
  TextStyle get textStyleBody4 => GoogleFonts.getFont(
        "Aclonica",
        fontSize: fontSizeBody3,
        color: const Color(0XFF000000),
      );

  TextStyle get textStyleBody5 => GoogleFonts.getFont(
        "Aclonica",
        fontSize: fontSizeBody4,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody6 => GoogleFonts.getFont(
        "Aclonica",
        fontSize: fontSizeBody6,
        color: const Color(0XFFFFF5F5),
      );

  TextStyle get textStyleBody7 => GoogleFonts.getFont(
        "Aclonica",
        fontSize: fontSizeBody2,
        color: const Color(0XFFFFF5F5),
      );

  TextStyle get buttonTextStyle => GoogleFonts.getFont(
        "Aclonica",
        fontSize: fontSizeBtn,
      );

  ButtonStyle get btnPrimary => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radio del borde
        )),
        minimumSize: WidgetStateProperty.all(btnSize),
        maximumSize: WidgetStateProperty.all(btnSize),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFF12CBC4)),
        textStyle: WidgetStateProperty.all(buttonTextStyle),
      );

  ButtonStyle get btnSecondary => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radio del borde
        )),
        shadowColor: const WidgetStatePropertyAll(Color(0XFF000000)),
        minimumSize: WidgetStateProperty.all(btnSize),
        maximumSize: WidgetStateProperty.all(btnSize),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFD8C43)),
        textStyle: WidgetStateProperty.all(buttonTextStyle),
      );
  ButtonStyle get btnSecondarySmall => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 11.5, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radio del borde
        )),
        shadowColor: const WidgetStatePropertyAll(Color(0XFF000000)),
        minimumSize: WidgetStateProperty.all(btnSizeSmall),
        maximumSize: WidgetStateProperty.all(btnSizeSmall),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFD8C43)),
        textStyle: WidgetStateProperty.all(buttonTextStyle),
      );

  ButtonStyle get btnTertiary => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radio del borde
        )),
        minimumSize: WidgetStateProperty.all(btnSize),
        maximumSize: WidgetStateProperty.all(btnSize),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFF83A2A1)),
        textStyle: WidgetStateProperty.all(buttonTextStyle),
      );

  ButtonStyle get btnTransparent => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radio del borde
        )),
        minimumSize: WidgetStateProperty.all(btnSize),
        maximumSize: WidgetStateProperty.all(btnSize),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFF000000)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        textStyle: WidgetStateProperty.all(buttonTextStyle),
        side: WidgetStateProperty.all(
            const BorderSide(color: Colors.black, width: 2.0)),
      );
  ButtonStyle get btnTransparentSmall => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 11.5, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radio del borde
        )),
        minimumSize: WidgetStateProperty.all(btnSizeSmall),
        maximumSize: WidgetStateProperty.all(btnSizeSmall),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFF000000)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0XFFFFFFFF)),
        textStyle: WidgetStateProperty.all(buttonTextStyle),
        side: WidgetStateProperty.all(
            const BorderSide(color: Colors.black, width: 2.0)),
      );

  InputDecoration get inputDecorationStyle => InputDecoration(
      labelStyle: labelStyle,
      hintStyle: hintStyle,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 5.88, horizontal: 5));

  TextStyle get hintStyle => GoogleFonts.getFont(
        "Aclonica",
        color: const Color(0XFF746F6F),
        fontSize: fontSizeBody3,
        height: 1.1,
        fontWeight: FontWeight.w400,
      );
  TextStyle get labelStyle => GoogleFonts.getFont("Aclonica",
      fontSize: fontSizeBody3, color: const Color(0XFF746F6F));

  BoxFit get fitImage {
    if (screenWidth <= SizeScreensApp().sm) {
      return BoxFit.fitHeight;
    } else if (screenWidth <= SizeScreensApp().md) {
      return BoxFit.fitHeight;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return BoxFit.fill;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return BoxFit.fill;
    } else {
      return BoxFit.fill;
    }
  }

  Size get sizeContainer {
    if (screenWidth <= SizeScreensApp().sm) {
      return Size(72.0, 72.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(90.0, 90.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(90, 90.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(90.0, 90.0); // Ajustar estos valores según tus necesidades
    } else {
      return Size(100.0, 100.0); // Ajustar estos valores según tus necesidades
    }
  }

  Size get sizeContainerSub {
    if (screenWidth <= SizeScreensApp().sm) {
      return Size(52.0, 52.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(70.0, 70.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(70, 70.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(80.0, 80.0); // Ajustar estos valores según tus necesidades
    } else {
      return Size(90.0, 90.0); // Ajustar estos valores según tus necesidades
    }
  }

  Size get sizeContainerLevel {
    if (screenWidth <= SizeScreensApp().sm) {
      return Size(120.0, 102.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(150.0, 102.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(150.0, 102.0); // Ajustar estos valores según tus necesidades
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(190.0, 102.0); // Ajustar estos valores según tus necesidades
    } else {
      return Size(250.0, 102.0); // Ajustar estos valores según tus necesidades
    }
  }

  double get minHeightContentPage {
    if (screenWidth <= SizeScreensApp().xsm) {
      return MediaQuery.of(context).size.height - 130;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return MediaQuery.of(context).size.height - 130;
    } else if (screenWidth <= SizeScreensApp().md) {
      return MediaQuery.of(context).size.height - 130;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return MediaQuery.of(context).size.height;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return MediaQuery.of(context).size.height;
    } else {
      return MediaQuery.of(context).size.height;
    }
  }

  double get imgResponsive {
    if (screenWidth <= SizeScreensApp().xsm) {
      return MediaQuery.sizeOf(context).width;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return MediaQuery.sizeOf(context).width;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 400.0;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 400.0;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 400.0;
    } else {
      return 400.0;
    }
  }

  Offset positionedLevels(double percentage) {
    // if (screenWidth <= SizeScreensApp().sm) {
    return Offset(screenWidth * percentage,
        MediaQuery.sizeOf(context).height * percentage);
  }
}

class SizeScreensApp {
  final double xsm = 360;
  final double sm = 414;
  final double md = 480;
  final double lg = 720;
  final double xlg = 1024; //tabletas
}

// Teléfonos pequeños:

// Ancho: 320px - 360px
// Altura: 568px - 640px
// Teléfonos medianos:

// Ancho: 375px - 414px
// Altura: 667px - 736px
// Teléfonos grandes:

// Ancho: 414px - 480px
// Altura: 736px - 853px
// Tabletas pequeñas:

// Ancho: 600px - 720px
// Altura: 960px - 1024px
// Tabletas grandes:

// Ancho: 768px - 1024px
// Altura: 1024px - 1366px
// Pantallas de escritorio:

// Ancho: 1024px y superior
// Altura: 768px y superior
