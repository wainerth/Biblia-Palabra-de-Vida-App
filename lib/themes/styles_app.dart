import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/material.dart';
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
      return 40.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeTitle1 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 22.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 22.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 22.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeTitle2 {
    if (screenWidth <= SizeScreensApp().xsm) {
      return 28.sp;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 28.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 30.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 30.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 30.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeSubTitle {
    if (screenWidth <= SizeScreensApp().sm) {
      return 24.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 24.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 24.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
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
    if (screenWidth <= SizeScreensApp().xsm) {
      return 18.sp;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 18.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 18.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 18.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody3 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 10.sp;
    } else {
      return 14.sp;
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

  double get fontSizeBody24 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 24.sp;
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

  double get fontSizeBody28 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 28.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 28.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 28.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 28.sp;
    } else {
      return 16.sp;
    }
  }
  double get fontSizeBody32 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 32.sp;
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

  double get fontSizeBody10 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 10.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 10.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody12 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 12.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 12.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 12.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 12.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody15 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 15.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 15.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 15.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody16 {
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

  double get fontSizeBody17 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 17.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 17.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 17.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 17.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody14 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 16.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody18 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 18.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 16.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 18.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 18.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBody20 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 22.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 22.sp;
    } else {
      return 16.sp;
    }
  }

  double get fontSizeBtn {
    if (screenWidth <= SizeScreensApp().sm) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 14.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 14.sp;
    } else {
      return 14.sp;
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
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(239.0.sp, 41.0.sp);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(239.0.sp, 41.0.sp);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(239.0.sp, 41.0.sp);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(double.infinity, 41.sp);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(double.infinity, 41.sp);
    } else {
      return Size(700.0.sp, 80.0.sp);
    }
  }

  TextStyle get textWithGradient => TextStyle(
        fontFamily: "Erica One",
        fontSize: fontSizeTitle1,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textStyleTitle => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeTitle,
      fontWeight: FontWeight.normal);

  TextStyle get textStyleTitleAlegra => TextStyle(
        fontFamily: 'Alegreya Sans SC',
        fontSize: fontSizeTitle2,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );
  TextStyle get textStyleLevelNumber => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeBody15, //SizeTitle1,
      fontWeight: FontWeight.w300);

  TextStyle get textStyNameNumber => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeBody3,
      fontWeight: FontWeight.normal);
  TextStyle get textStyCalendar => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeBody3,
      fontWeight: FontWeight.normal,
      color: Color(0XFF12CBC4));
  TextStyle get textStyleCongratulation => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeBody32,
        fontWeight: FontWeight.normal,
        color: Color(0XFF12CBC4),
      );
  TextStyle get textStyCalendarWhite => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeBody3,
      fontWeight: FontWeight.normal,
      color: Color(0XFFFFFFFF));

  TextStyle get textStyCompleteLevelTitle => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeTitle1,
      fontWeight: FontWeight.normal);
  TextStyle get textStyCompleteLevelBody => TextStyle(
      fontFamily: 'Alfa Slab One',
      fontSize: fontSizeBody3,
      fontWeight: FontWeight.normal);

  TextStyle get textStyleTitleBlue => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeTitle1,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF12CBC4),
      );
  TextStyle get textStyleTitleOrange => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeSubTitle,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFFD8C43),
      );
  TextStyle get textStyleTitleRed => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeSubTitle,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFBF0000),
      );
  TextStyle get textStyleTitleWithe => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeSubTitle,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFFFFFFF),
      );
  TextStyle get textStyleWithe20 => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeBody20,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFFFFFFF),
      );
  TextStyle get textStyleTitleWithe24 => TextStyle(
        fontFamily: 'Alfa Slab One',
        fontSize: fontSizeBody24,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFFFFFFF),
      );

  // TextStyle(fontFamily: "Erica One", fontSize: fontSizeTitle,fontWeight: FontWeight.w800);

  TextStyle get textStyleSubTitle =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeSubTitle);

  TextStyle get textStyleBody1 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody1);

  TextStyle get textStyleBody2 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody2);

  TextStyle get textStyleBody3 =>
      TextStyle(fontFamily: "Erica One", fontSize: fontSizeBody2);
  TextStyle get textStyleBody4 => TextStyle(
      fontFamily: "Aclonica",
      fontSize: fontSizeBody3,
      color: const Color(0XFF000000),
      fontWeight: FontWeight.w400);
  TextStyle get textStyleBodyAso20 => TextStyle(
        fontFamily: "Alfa Slab One",
        fontSize: fontSizeBody3,
        color: const Color(0XFF000000),
      );

  TextStyle get textStyleBodyWhite4 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody3,
        color: const Color(0XFFFFFFFF),
      );

  TextStyle get textStyleBody5 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody3,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody6 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody12,
        color: const Color(0XFFFFF5F5),
      );

  TextStyle get textStyleBody7 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody2,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody18 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody18,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody12 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody12,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody15 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody15,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBodyOrange15 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody15,
        color: const Color(0XFFFD8C43),
      );
  TextStyle get textStyleBody16 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody16,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody17 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody17,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody20 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody20,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBodyRoboto20 => TextStyle(
        fontFamily: "Roboto",
        fontSize: fontSizeBody20,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody24 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody24,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBodyRoboto24 => TextStyle(
        fontFamily: "Roboto",
        fontSize: fontSizeBody24,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody28 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody28,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody32 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody32,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBodyAso32 => TextStyle(
        fontFamily: "Alfa Slab One",
        fontSize: fontSizeBody32,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody10 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody10,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody14 => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody14,
        color: const Color(0XFFFFF5F5),
      );
  TextStyle get textStyleBody2_14 => TextStyle(
        fontFamily: "Alfa Slab One",
        fontSize: fontSizeBody14,
        color: const Color(0xFFFD8C43),
      );
  TextStyle get chipLevels => TextStyle(
        fontFamily: "Aclonica",
        fontSize: 14.0,
        color: const Color(0XFF000000),
      );

  TextStyle get buttonTextStyle => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBtn,
      );
  TextStyle get textStyleSmallBlack => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBtn,
      );

  ButtonStyle get btnPrimary => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Radio del borde
          ),
        ),
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
          const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
          const EdgeInsets.symmetric(horizontal: 20),
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
  ButtonStyle get btnWidgetSmall => ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5.5, horizontal: 9.0),
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
          const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
        constraints: BoxConstraints(minHeight: 40.sp),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      );
  InputDecoration get inputDecorationOutlineStyle => InputDecoration(
        labelStyle: labelStyle,
        hintStyle: hintStyle,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 2.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: StyleColor.electricViolet),
        ),
        constraints: BoxConstraints(minHeight: 40.sp),
      );

  TextStyle get hintStyle => TextStyle(
        fontFamily: "Aclonica",
        color: const Color(0XFF746F6F),
        fontSize: fontSizeBody3,
        // height: 1.1,
        fontWeight: FontWeight.w400,
      );
  TextStyle get textStyleHintText => TextStyle(
        fontFamily: "Aclonica",
        fontSize: fontSizeBody3,
        color: const Color(0XFF746F6F),
        // height: 1.sp
      );
  TextStyle get labelStyle => TextStyle(
      fontFamily: "Aclonica",
      fontSize: fontSizeBody3,
      color: const Color(0XFF746F6F));

  BoxFit get fitImage {
    if (screenWidth <= SizeScreensApp().sm) {
      return BoxFit.fitHeight;
    } else if (screenWidth <= SizeScreensApp().sm) {
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

  Size get sizeTextFormField {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(MediaQuery.sizeOf(context).width, 43.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(MediaQuery.sizeOf(context).width, 43.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(MediaQuery.sizeOf(context).width, 43.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(MediaQuery.sizeOf(context).width * 0.6, 60.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(MediaQuery.sizeOf(context).width * 0.6, 70.0);
    } else {
      return Size(MediaQuery.sizeOf(context).width * 0.6, 60.0);
    }
  }

  Size get btnHeight {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(223.0, 35.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(MediaQuery.sizeOf(context).width* 0.8, 43.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(MediaQuery.sizeOf(context).width * 0.7, 43.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(MediaQuery.sizeOf(context).width * 0.6, 30.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(MediaQuery.sizeOf(context).width * 0.6, 70.0);
    } else {
      return Size(MediaQuery.sizeOf(context).width * 0.6, 60.0);
    }
  }

  Size get sizeImgLogin {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(220.0, 229.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(220.0, 229.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(304.0, 304.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(200, 200.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(200.0, 200.0);
    } else {
      return Size(304, 304.0);
    }
  }

  Size get sizeContainer {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(72.0, 72.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(90, 90.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(90.0, 90.0);
    } else {
      return Size(100.0, 100.0);
    }
  }

  Size get sizeContainerSub {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(52.0, 52.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(52.0, 52.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(70.0, 70.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(70, 70.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(80.0, 80.0);
    } else {
      return Size(90.0, 90.0);
    }
  }

  Size get sizeContainerLevel {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(120.0, 102.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(120.0, 102.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(150.0, 102.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(150.0, 102.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(190.0, 102.0);
    } else {
      return Size(250.0, 102.0);
    }
  }

  Size get sizeContainerCard {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().xsm) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(120.0, 120.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(130.0, 132.0);
    } else {
      return Size(90.0, 90.0);
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

  Size get sizeContainerAvatar {
    if (screenWidth <= SizeScreensApp().xsm) {
      return Size(39.0, 39.0);
    } else if (screenWidth <= SizeScreensApp().sm) {
      return Size(39.0, 39.0);
    } else if (screenWidth <= SizeScreensApp().md) {
      return Size(39.0, 39.0);
    } else if (screenWidth <= SizeScreensApp().lg) {
      return Size(90.0, 90.0);
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return Size(150.0, 250.0);
    } else {
      return Size(59.0, 59.0);
    }
  }

  double get radiusAvatar {
    if (screenWidth <= SizeScreensApp().xsm) {
      return 25.0;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 25.0;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 25.0;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 40.0;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 80.0;
    } else {
      return 30.0;
    }
  }

  double get sizeTextPosition {
    if (screenWidth <= SizeScreensApp().xsm) {
      return 153.0;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 153.0;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 153.0;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 300.0;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 400.0;
    } else {
      return 153.0;
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

  double get sizeBtn {
    if (screenWidth <= SizeScreensApp().xsm) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 20.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 20.sp;
    } else {
      return 20.sp;
    }
  }

  double get sizeIconBottomBar {
    if (screenWidth <= SizeScreensApp().xsm) {
      return 25.sp;
    } else if (screenWidth <= SizeScreensApp().sm) {
      return 25.sp;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 25.sp;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 25.sp;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 25.sp;
    } else {
      return 25.sp;
    }
  }

  Offset positionedLevels(double percentage) {
    // if (screenWidth <= SizeScreensApp().sm) {
    return Offset(screenWidth * percentage,
        MediaQuery.sizeOf(context).height * percentage);
  }

  double get heightSpacing1 {
    if (screenWidth <= SizeScreensApp().sm) {
      return 45.0;
    } else if (screenWidth <= SizeScreensApp().md) {
      return 45.0;
    } else if (screenWidth <= SizeScreensApp().lg) {
      return 45.0;
    } else if (screenWidth <= SizeScreensApp().xlg) {
      return 75.0;
    } else {
      return 20.0;
    }
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
