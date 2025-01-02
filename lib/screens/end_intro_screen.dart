import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class EndIntroScreen extends StatelessWidget {
  const EndIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: CustomPaint(
              painter: WisdomPathPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class WisdomPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withValues(alpha: 255); //
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1890438, size.height * 0.9699030);
    path_1.lineTo(size.width * 0.4021483, size.height * 0.9528703);
    path_1.lineTo(size.width * 0.4382990, size.height * 1.172862);
    path_1.lineTo(size.width * 0.3023325, size.height * 1.183727);
    path_1.lineTo(size.width * 0.1890438, size.height * 0.9699030);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.2955957, size.height * 0.9613867),
        Offset(size.width * 0.3683541, size.height * 1.178446),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.6879498, size.height * 0.9571636);
    path_2.lineTo(size.width * 0.4724952, size.height * 0.9500864);
    path_2.lineTo(size.width * 0.4792775, size.height * 1.170759);
    path_2.lineTo(size.width * 0.6167440, size.height * 1.175269);
    path_2.lineTo(size.width * 0.6879498, size.height * 0.9571636);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.5802225, size.height * 0.9536250),
        Offset(size.width * 0.5499928, size.height * 1.173084),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.7183062, size.height * 0.9905794);
    path_3.lineTo(size.width * 0.8983852, size.height * 1.012257);
    path_3.lineTo(size.width * 0.7749163, size.height * 1.191834);
    path_3.lineTo(size.width * 0.6600191, size.height * 1.178002);
    path_3.lineTo(size.width * 0.7183062, size.height * 0.9905794);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.8083469, size.height * 1.001418),
        Offset(size.width * 0.7158110, size.height * 1.184720),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_3, paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = const Color(0xffE8F3FF).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.01674641, size.height * 0.02803738,
                size.width * 0.9904306, size.height * 0.9766355),
            bottomRight: Radius.circular(size.width * 0.07177033),
            bottomLeft: Radius.circular(size.width * 0.07177033),
            topLeft: Radius.circular(size.width * 0.07177033),
            topRight: Radius.circular(size.width * 0.07177033)),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.2252156, size.height * 0.3827488);
    path_5.cubicTo(
        size.width * 0.2654019,
        size.height * 0.4172839,
        size.width * 0.1662883,
        size.height * 0.4580280,
        size.width * 0.08472679,
        size.height * 0.4579439);
    path_5.cubicTo(
        size.width * 0.008237871,
        size.height * 0.4578645,
        size.width * -0.07984522,
        size.height * 0.4149755,
        size.width * -0.05576172,
        size.height * 0.3915374);
    path_5.cubicTo(
        size.width * -0.03167847,
        size.height * 0.3681005,
        size.width * 0.009788900,
        size.height * 0.3727640,
        size.width * 0.05662919,
        size.height * 0.3690771);
    path_5.cubicTo(
        size.width * 0.1225179,
        size.height * 0.3638914,
        size.width * 0.1923304,
        size.height * 0.3544871,
        size.width * 0.2252156,
        size.height * 0.3827488);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = const Color(0xff12CBC4).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.1177766, size.height * 0.4468271);
    path_6.cubicTo(
        size.width * 0.08571986,
        size.height * 0.4539720,
        size.width * 0.05347584,
        size.height * 0.4520864,
        size.width * 0.02576316,
        size.height * 0.4447079);
    path_6.cubicTo(
        size.width * -0.001962416,
        size.height * 0.4373271,
        size.width * -0.02514306,
        size.height * 0.4244498,
        size.width * -0.03899115,
        size.height * 0.4096332);
    path_6.cubicTo(
        size.width * -0.04590981,
        size.height * 0.4022313,
        size.width * -0.04633038,
        size.height * 0.3971764,
        size.width * -0.04230431,
        size.height * 0.3935082);
    path_6.cubicTo(
        size.width * -0.03826196,
        size.height * 0.3898248,
        size.width * -0.02963947,
        size.height * 0.3874416,
        size.width * -0.01795694,
        size.height * 0.3855117);
    path_6.cubicTo(
        size.width * -0.009362105,
        size.height * 0.3840923,
        size.width * 0.0007863158,
        size.height * 0.3829334,
        size.width * 0.01182038,
        size.height * 0.3816729);
    path_6.cubicTo(
        size.width * 0.01576986,
        size.height * 0.3812220,
        size.width * 0.01983278,
        size.height * 0.3807570,
        size.width * 0.02397847,
        size.height * 0.3802640);
    path_6.cubicTo(
        size.width * 0.03968182,
        size.height * 0.3783937,
        size.width * 0.05652440,
        size.height * 0.3761051,
        size.width * 0.07270167,
        size.height * 0.3725000);
    path_6.cubicTo(
        size.width * 0.08856555,
        size.height * 0.3689638,
        size.width * 0.1013117,
        size.height * 0.3656694,
        size.width * 0.1121593,
        size.height * 0.3628657);
    path_6.lineTo(size.width * 0.1127301, size.height * 0.3627173);
    path_6.cubicTo(
        size.width * 0.1237103,
        size.height * 0.3598797,
        size.width * 0.1327167,
        size.height * 0.3575631,
        size.width * 0.1410816,
        size.height * 0.3560129);
    path_6.cubicTo(
        size.width * 0.1494330,
        size.height * 0.3544650,
        size.width * 0.1571194,
        size.height * 0.3536869,
        size.width * 0.1654452,
        size.height * 0.3539229);
    path_6.cubicTo(
        size.width * 0.1737768,
        size.height * 0.3541589,
        size.width * 0.1827916,
        size.height * 0.3554112,
        size.width * 0.1937933,
        size.height * 0.3579556);
    path_6.cubicTo(
        size.width * 0.2110797,
        size.height * 0.3619533,
        size.width * 0.2189856,
        size.height * 0.3685701,
        size.width * 0.2201622,
        size.height * 0.3764883);
    path_6.cubicTo(
        size.width * 0.2213423,
        size.height * 0.3844287,
        size.width * 0.2157517,
        size.height * 0.3936939,
        size.width * 0.2059321,
        size.height * 0.4029357);
    path_6.cubicTo(
        size.width * 0.1862897,
        size.height * 0.4214217,
        size.width * 0.1498804,
        size.height * 0.4396717,
        size.width * 0.1177766,
        size.height * 0.4468271);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.001188361;
    paint_6_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.1139172, size.height * 0.4402185);
    path_7.cubicTo(
        size.width * 0.05692584,
        size.height * 0.4529206,
        size.width * 0.0006808589,
        size.height * 0.4351449,
        size.width * -0.02246029,
        size.height * 0.4103867);
    path_7.cubicTo(
        size.width * -0.02823230,
        size.height * 0.4042114,
        size.width * -0.02838038,
        size.height * 0.3999638,
        size.width * -0.02470144,
        size.height * 0.3968400);
    path_7.cubicTo(
        size.width * -0.02099806,
        size.height * 0.3936963,
        size.width * -0.01331888,
        size.height * 0.3915970,
        size.width * -0.002949928,
        size.height * 0.3898505);
    path_7.cubicTo(
        size.width * 0.004675933,
        size.height * 0.3885643,
        size.width * 0.01365813,
        size.height * 0.3874836,
        size.width * 0.02342610,
        size.height * 0.3863084);
    path_7.cubicTo(
        size.width * 0.02692297,
        size.height * 0.3858879,
        size.width * 0.03052033,
        size.height * 0.3854556,
        size.width * 0.03419234,
        size.height * 0.3849965);
    path_7.cubicTo(
        size.width * 0.04809833,
        size.height * 0.3832593,
        size.width * 0.06302656,
        size.height * 0.3811565,
        size.width * 0.07742488,
        size.height * 0.3779474);
    path_7.cubicTo(
        size.width * 0.09147584,
        size.height * 0.3748166,
        size.width * 0.1027993,
        size.height * 0.3719206,
        size.width * 0.1124411,
        size.height * 0.3694556);
    path_7.lineTo(size.width * 0.1130861, size.height * 0.3692909);
    path_7.cubicTo(
        size.width * 0.1228761,
        size.height * 0.3667886,
        size.width * 0.1309048,
        size.height * 0.3647477,
        size.width * 0.1383352,
        size.height * 0.3633586);
    path_7.cubicTo(
        size.width * 0.1457536,
        size.height * 0.3619708,
        size.width * 0.1525505,
        size.height * 0.3612395,
        size.width * 0.1598624,
        size.height * 0.3613528);
    path_7.cubicTo(
        size.width * 0.1671785,
        size.height * 0.3614650,
        size.width * 0.1750507,
        size.height * 0.3624241,
        size.width * 0.1846160,
        size.height * 0.3644463);
    path_7.cubicTo(
        size.width * 0.1921502,
        size.height * 0.3660397,
        size.width * 0.1975644,
        size.height * 0.3682079,
        size.width * 0.2011854,
        size.height * 0.3707991);
    path_7.cubicTo(
        size.width * 0.2048067,
        size.height * 0.3733902,
        size.width * 0.2066569,
        size.height * 0.3764217,
        size.width * 0.2070100,
        size.height * 0.3797570);
    path_7.cubicTo(
        size.width * 0.2077172,
        size.height * 0.3864369,
        size.width * 0.2024151,
        size.height * 0.3943154,
        size.width * 0.1933797,
        size.height * 0.4022266);
    path_7.cubicTo(
        size.width * 0.1753086,
        size.height * 0.4180491,
        size.width * 0.1424782,
        size.height * 0.4338528,
        size.width * 0.1139172,
        size.height * 0.4402185);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.001188361;
    paint_7_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.1111916, size.height * 0.4337418);
    path_8.cubicTo(
        size.width * 0.06283110,
        size.height * 0.4445210,
        size.width * 0.01608624,
        size.height * 0.4304614,
        size.width * -0.002591555,
        size.height * 0.4104790);
    path_8.cubicTo(
        size.width * -0.007246770,
        size.height * 0.4054988,
        size.width * -0.007225144,
        size.height * 0.4020596,
        size.width * -0.004052895,
        size.height * 0.3995047);
    path_8.cubicTo(
        size.width * -0.0008499019,
        size.height * 0.3969252,
        size.width * 0.005662416,
        size.height * 0.3951589,
        size.width * 0.01445022,
        size.height * 0.3936565);
    path_8.cubicTo(
        size.width * 0.02091045,
        size.height * 0.3925514,
        size.width * 0.02850526,
        size.height * 0.3916028,
        size.width * 0.03676794,
        size.height * 0.3905713);
    path_8.cubicTo(
        size.width * 0.03972679,
        size.height * 0.3902009,
        size.width * 0.04277129,
        size.height * 0.3898213,
        size.width * 0.04587990,
        size.height * 0.3894194);
    path_8.cubicTo(
        size.width * 0.05764761,
        size.height * 0.3878984,
        size.width * 0.07029067,
        size.height * 0.3860701,
        size.width * 0.08252321,
        size.height * 0.3833435);
    path_8.cubicTo(
        size.width * 0.09445766,
        size.height * 0.3806834,
        size.width * 0.1040871,
        size.height * 0.3782371,
        size.width * 0.1122852,
        size.height * 0.3761554);
    path_8.lineTo(size.width * 0.1128340, size.height * 0.3760152);
    path_8.cubicTo(
        size.width * 0.1211591,
        size.height * 0.3739007,
        size.width * 0.1279821,
        size.height * 0.3721764,
        size.width * 0.1342799,
        size.height * 0.3709883);
    path_8.cubicTo(
        size.width * 0.1405667,
        size.height * 0.3698026,
        size.width * 0.1463050,
        size.height * 0.3691565,
        size.width * 0.1524474,
        size.height * 0.3691928);
    path_8.cubicTo(
        size.width * 0.1585923,
        size.height * 0.3692301,
        size.width * 0.1651806,
        size.height * 0.3699509,
        size.width * 0.1731636,
        size.height * 0.3715257);
    path_8.cubicTo(
        size.width * 0.1794431,
        size.height * 0.3727640,
        size.width * 0.1839129,
        size.height * 0.3744848,
        size.width * 0.1868629,
        size.height * 0.3765584);
    path_8.cubicTo(
        size.width * 0.1898134,
        size.height * 0.3786320,
        size.width * 0.1912699,
        size.height * 0.3810771,
        size.width * 0.1914610,
        size.height * 0.3837839);
    path_8.cubicTo(
        size.width * 0.1918440,
        size.height * 0.3892079,
        size.width * 0.1871419,
        size.height * 0.3956624,
        size.width * 0.1792844,
        size.height * 0.4021787);
    path_8.cubicTo(
        size.width * 0.1635722,
        size.height * 0.4152103,
        size.width * 0.1354335,
        size.height * 0.4283388,
        size.width * 0.1111916,
        size.height * 0.4337418);
    path_8.close();

    Paint paint_8_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.001188361;
    paint_8_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_8, paint_8_stroke);

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.1084672, size.height * 0.4272652);
    path_9.cubicTo(
        size.width * 0.06872416,
        size.height * 0.4361227,
        size.width * 0.03148660,
        size.height * 0.4257722,
        size.width * 0.01727833,
        size.height * 0.4105701);
    path_9.cubicTo(
        size.width * 0.01374278,
        size.height * 0.4067886,
        size.width * 0.01392976,
        size.height * 0.4041577,
        size.width * 0.01659280,
        size.height * 0.4021717);
    path_9.cubicTo(
        size.width * 0.01929612,
        size.height * 0.4001554,
        size.width * 0.02464522,
        size.height * 0.3987208,
        size.width * 0.03185263,
        size.height * 0.3974614);
    path_9.cubicTo(
        size.width * 0.03714785,
        size.height * 0.3965374,
        size.width * 0.04335598,
        size.height * 0.3957208,
        size.width * 0.05011364,
        size.height * 0.3948318);
    path_9.cubicTo(
        size.width * 0.05253445,
        size.height * 0.3945140,
        size.width * 0.05502560,
        size.height * 0.3941869,
        size.width * 0.05757057,
        size.height * 0.3938411);
    path_9.cubicTo(
        size.width * 0.06719976,
        size.height * 0.3925350,
        size.width * 0.07755694,
        size.height * 0.3909825,
        size.width * 0.08762297,
        size.height * 0.3887395);
    path_9.cubicTo(
        size.width * 0.09744019,
        size.height * 0.3865514,
        size.width * 0.1053754,
        size.height * 0.3845537,
        size.width * 0.1121299,
        size.height * 0.3828528);
    path_9.lineTo(size.width * 0.1125823, size.height * 0.3827395);
    path_9.cubicTo(
        size.width * 0.1194423,
        size.height * 0.3810129,
        size.width * 0.1250603,
        size.height * 0.3796051,
        size.width * 0.1302263,
        size.height * 0.3786180);
    path_9.cubicTo(
        size.width * 0.1353825,
        size.height * 0.3776332,
        size.width * 0.1400644,
        size.height * 0.3770713,
        size.width * 0.1450388,
        size.height * 0.3770327);
    path_9.cubicTo(
        size.width * 0.1500144,
        size.height * 0.3769942,
        size.width * 0.1553191,
        size.height * 0.3774778,
        size.width * 0.1617196,
        size.height * 0.3786051);
    path_9.cubicTo(
        size.width * 0.1667450,
        size.height * 0.3794907,
        size.width * 0.1702672,
        size.height * 0.3807652,
        size.width * 0.1725438,
        size.height * 0.3823189);
    path_9.cubicTo(
        size.width * 0.1748199,
        size.height * 0.3838727,
        size.width * 0.1758828,
        size.height * 0.3857290,
        size.width * 0.1759129,
        size.height * 0.3878072);
    path_9.cubicTo(
        size.width * 0.1759737,
        size.height * 0.3919755,
        size.width * 0.1718744,
        size.height * 0.3970047,
        size.width * 0.1651943,
        size.height * 0.4021285);
    path_9.cubicTo(
        size.width * 0.1518409,
        size.height * 0.4123692,
        size.width * 0.1283926,
        size.height * 0.4228236,
        size.width * 0.1084672,
        size.height * 0.4272652);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.001188361;
    paint_9_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.03110048, size.height * 0.2873832);
    path_10.cubicTo(
        size.width * 0.03110048,
        size.height * 0.2830164,
        size.width * 0.03110048,
        size.height * 0.2808318,
        size.width * 0.03302344,
        size.height * 0.2792056);
    path_10.cubicTo(
        size.width * 0.03428349,
        size.height * 0.2781402,
        size.width * 0.03609545,
        size.height * 0.2772547,
        size.width * 0.03827751,
        size.height * 0.2766402);
    path_10.cubicTo(
        size.width * 0.04160837,
        size.height * 0.2757009,
        size.width * 0.04608014,
        size.height * 0.2757009,
        size.width * 0.05502392,
        size.height * 0.2757009);
    path_10.cubicTo(
        size.width * 0.06396770,
        size.height * 0.2757009,
        size.width * 0.06843947,
        size.height * 0.2757009,
        size.width * 0.07177033,
        size.height * 0.2766402);
    path_10.cubicTo(
        size.width * 0.07395239,
        size.height * 0.2772547,
        size.width * 0.07576435,
        size.height * 0.2781402,
        size.width * 0.07702440,
        size.height * 0.2792056);
    path_10.cubicTo(
        size.width * 0.07894737,
        size.height * 0.2808318,
        size.width * 0.07894737,
        size.height * 0.2830164,
        size.width * 0.07894737,
        size.height * 0.2873832);
    path_10.lineTo(size.width * 0.07894737, size.height * 0.7359813);
    path_10.cubicTo(
        size.width * 0.07894737,
        size.height * 0.7403481,
        size.width * 0.07894737,
        size.height * 0.7425327,
        size.width * 0.07702440,
        size.height * 0.7441589);
    path_10.cubicTo(
        size.width * 0.07576435,
        size.height * 0.7452243,
        size.width * 0.07395239,
        size.height * 0.7461098,
        size.width * 0.07177033,
        size.height * 0.7467243);
    path_10.cubicTo(
        size.width * 0.06843947,
        size.height * 0.7476636,
        size.width * 0.06396770,
        size.height * 0.7476636,
        size.width * 0.05502392,
        size.height * 0.7476636);
    path_10.cubicTo(
        size.width * 0.04608014,
        size.height * 0.7476636,
        size.width * 0.04160837,
        size.height * 0.7476636,
        size.width * 0.03827751,
        size.height * 0.7467243);
    path_10.cubicTo(
        size.width * 0.03609545,
        size.height * 0.7461098,
        size.width * 0.03428349,
        size.height * 0.7452243,
        size.width * 0.03302344,
        size.height * 0.7441589);
    path_10.cubicTo(
        size.width * 0.03110048,
        size.height * 0.7425327,
        size.width * 0.03110048,
        size.height * 0.7403481,
        size.width * 0.03110048,
        size.height * 0.7359813);
    path_10.lineTo(size.width * 0.03110048, size.height * 0.2873832);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = const Color(0xffFFF7F1).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.03110048, size.height * 0.3773364);
    path_11.cubicTo(
        size.width * 0.03110048,
        size.height * 0.3751332,
        size.width * 0.03110048,
        size.height * 0.3740327,
        size.width * 0.03250191,
        size.height * 0.3733481);
    path_11.cubicTo(
        size.width * 0.03390335,
        size.height * 0.3726636,
        size.width * 0.03615885,
        size.height * 0.3726636,
        size.width * 0.04066986,
        size.height * 0.3726636);
    path_11.lineTo(size.width * 0.06937799, size.height * 0.3726636);
    path_11.cubicTo(
        size.width * 0.07388900,
        size.height * 0.3726636,
        size.width * 0.07614450,
        size.height * 0.3726636,
        size.width * 0.07754593,
        size.height * 0.3733481);
    path_11.cubicTo(
        size.width * 0.07894737,
        size.height * 0.3740327,
        size.width * 0.07894737,
        size.height * 0.3751332,
        size.width * 0.07894737,
        size.height * 0.3773364);
    path_11.lineTo(size.width * 0.07894737, size.height * 0.7359813);
    path_11.cubicTo(
        size.width * 0.07894737,
        size.height * 0.7403481,
        size.width * 0.07894737,
        size.height * 0.7425327,
        size.width * 0.07702440,
        size.height * 0.7441589);
    path_11.cubicTo(
        size.width * 0.07576435,
        size.height * 0.7452243,
        size.width * 0.07395239,
        size.height * 0.7461098,
        size.width * 0.07177033,
        size.height * 0.7467243);
    path_11.cubicTo(
        size.width * 0.06843947,
        size.height * 0.7476636,
        size.width * 0.06396770,
        size.height * 0.7476636,
        size.width * 0.05502392,
        size.height * 0.7476636);
    path_11.cubicTo(
        size.width * 0.04608014,
        size.height * 0.7476636,
        size.width * 0.04160837,
        size.height * 0.7476636,
        size.width * 0.03827751,
        size.height * 0.7467243);
    path_11.cubicTo(
        size.width * 0.03609545,
        size.height * 0.7461098,
        size.width * 0.03428349,
        size.height * 0.7452243,
        size.width * 0.03302344,
        size.height * 0.7441589);
    path_11.cubicTo(
        size.width * 0.03110048,
        size.height * 0.7425327,
        size.width * 0.03110048,
        size.height * 0.7403481,
        size.width * 0.03110048,
        size.height * 0.7359813);
    path_11.lineTo(size.width * 0.03110048, size.height * 0.3773364);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = const Color(0xffF27728).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.03110048, size.height * 0.5518096);
    path_12.cubicTo(
        size.width * 0.03110048,
        size.height * 0.5508914,
        size.width * 0.03219976,
        size.height * 0.5500596,
        size.width * 0.03391100,
        size.height * 0.5496811);
    path_12.lineTo(size.width * 0.07218852, size.height * 0.5412150);
    path_12.cubicTo(
        size.width * 0.07535598,
        size.height * 0.5405140,
        size.width * 0.07894737,
        size.height * 0.5416449,
        size.width * 0.07894737,
        size.height * 0.5433423);
    path_12.lineTo(size.width * 0.07894737, size.height * 0.5540421);
    path_12.cubicTo(
        size.width * 0.07894737,
        size.height * 0.5549825,
        size.width * 0.07779282,
        size.height * 0.5558306,
        size.width * 0.07601770,
        size.height * 0.5561951);
    path_12.lineTo(size.width * 0.03774019, size.height * 0.5640572);
    path_12.cubicTo(
        size.width * 0.03458660,
        size.height * 0.5647044,
        size.width * 0.03110048,
        size.height * 0.5635736,
        size.width * 0.03110048,
        size.height * 0.5619030);
    path_12.lineTo(size.width * 0.03110048, size.height * 0.5518096);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.03110048, size.height * 0.5237722);
    path_13.cubicTo(
        size.width * 0.03110048,
        size.height * 0.5228540,
        size.width * 0.03219976,
        size.height * 0.5220222,
        size.width * 0.03391100,
        size.height * 0.5216437);
    path_13.lineTo(size.width * 0.07218852, size.height * 0.5131776);
    path_13.cubicTo(
        size.width * 0.07535598,
        size.height * 0.5124766,
        size.width * 0.07894737,
        size.height * 0.5136075,
        size.width * 0.07894737,
        size.height * 0.5153049);
    path_13.lineTo(size.width * 0.07894737, size.height * 0.5260047);
    path_13.cubicTo(
        size.width * 0.07894737,
        size.height * 0.5269451,
        size.width * 0.07779282,
        size.height * 0.5277932,
        size.width * 0.07601770,
        size.height * 0.5281577);
    path_13.lineTo(size.width * 0.03774019, size.height * 0.5360199);
    path_13.cubicTo(
        size.width * 0.03458660,
        size.height * 0.5366671,
        size.width * 0.03110048,
        size.height * 0.5355362,
        size.width * 0.03110048,
        size.height * 0.5338657);
    path_13.lineTo(size.width * 0.03110048, size.height * 0.5237722);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.03110048, size.height * 0.4957348);
    path_14.cubicTo(
        size.width * 0.03110048,
        size.height * 0.4948166,
        size.width * 0.03219976,
        size.height * 0.4939848,
        size.width * 0.03391100,
        size.height * 0.4936063);
    path_14.lineTo(size.width * 0.07218852, size.height * 0.4851402);
    path_14.cubicTo(
        size.width * 0.07535598,
        size.height * 0.4844393,
        size.width * 0.07894737,
        size.height * 0.4855701,
        size.width * 0.07894737,
        size.height * 0.4872675);
    path_14.lineTo(size.width * 0.07894737, size.height * 0.4979673);
    path_14.cubicTo(
        size.width * 0.07894737,
        size.height * 0.4989077,
        size.width * 0.07779282,
        size.height * 0.4997558,
        size.width * 0.07601770,
        size.height * 0.5001203);
    path_14.lineTo(size.width * 0.03774019, size.height * 0.5079825);
    path_14.cubicTo(
        size.width * 0.03458660,
        size.height * 0.5086297,
        size.width * 0.03110048,
        size.height * 0.5074988,
        size.width * 0.03110048,
        size.height * 0.5058283);
    path_14.lineTo(size.width * 0.03110048, size.height * 0.4957348);
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.03110048, size.height * 0.4676974);
    path_15.cubicTo(
        size.width * 0.03110048,
        size.height * 0.4667792,
        size.width * 0.03219976,
        size.height * 0.4659474,
        size.width * 0.03391100,
        size.height * 0.4655689);
    path_15.lineTo(size.width * 0.07218852, size.height * 0.4571028);
    path_15.cubicTo(
        size.width * 0.07535598,
        size.height * 0.4564019,
        size.width * 0.07894737,
        size.height * 0.4575327,
        size.width * 0.07894737,
        size.height * 0.4592301);
    path_15.lineTo(size.width * 0.07894737, size.height * 0.4699299);
    path_15.cubicTo(
        size.width * 0.07894737,
        size.height * 0.4708703,
        size.width * 0.07779282,
        size.height * 0.4717185,
        size.width * 0.07601770,
        size.height * 0.4720829);
    path_15.lineTo(size.width * 0.03774019, size.height * 0.4799451);
    path_15.cubicTo(
        size.width * 0.03458660,
        size.height * 0.4805923,
        size.width * 0.03110048,
        size.height * 0.4794614,
        size.width * 0.03110048,
        size.height * 0.4777909);
    path_15.lineTo(size.width * 0.03110048, size.height * 0.4676974);
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.03110048, size.height * 0.4396600);
    path_16.cubicTo(
        size.width * 0.03110048,
        size.height * 0.4387418,
        size.width * 0.03219976,
        size.height * 0.4379100,
        size.width * 0.03391100,
        size.height * 0.4375315);
    path_16.lineTo(size.width * 0.07218852, size.height * 0.4290654);
    path_16.cubicTo(
        size.width * 0.07535598,
        size.height * 0.4283645,
        size.width * 0.07894737,
        size.height * 0.4294953,
        size.width * 0.07894737,
        size.height * 0.4311928);
    path_16.lineTo(size.width * 0.07894737, size.height * 0.4418925);
    path_16.cubicTo(
        size.width * 0.07894737,
        size.height * 0.4428329,
        size.width * 0.07779282,
        size.height * 0.4436811,
        size.width * 0.07601770,
        size.height * 0.4440456);
    path_16.lineTo(size.width * 0.03774019, size.height * 0.4519077);
    path_16.cubicTo(
        size.width * 0.03458660,
        size.height * 0.4525549,
        size.width * 0.03110048,
        size.height * 0.4514241,
        size.width * 0.03110048,
        size.height * 0.4497535);
    path_16.lineTo(size.width * 0.03110048, size.height * 0.4396600);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.03110048, size.height * 0.4116227);
    path_17.cubicTo(
        size.width * 0.03110048,
        size.height * 0.4107044,
        size.width * 0.03219976,
        size.height * 0.4098727,
        size.width * 0.03391100,
        size.height * 0.4094942);
    path_17.lineTo(size.width * 0.07218852, size.height * 0.4010280);
    path_17.cubicTo(
        size.width * 0.07535598,
        size.height * 0.4003271,
        size.width * 0.07894737,
        size.height * 0.4014579,
        size.width * 0.07894737,
        size.height * 0.4031554);
    path_17.lineTo(size.width * 0.07894737, size.height * 0.4138551);
    path_17.cubicTo(
        size.width * 0.07894737,
        size.height * 0.4147956,
        size.width * 0.07779282,
        size.height * 0.4156437,
        size.width * 0.07601770,
        size.height * 0.4160082);
    path_17.lineTo(size.width * 0.03774019, size.height * 0.4238703);
    path_17.cubicTo(
        size.width * 0.03458660,
        size.height * 0.4245175,
        size.width * 0.03110048,
        size.height * 0.4233867,
        size.width * 0.03110048,
        size.height * 0.4217161);
    path_17.lineTo(size.width * 0.03110048, size.height * 0.4116227);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.03110048, size.height * 0.3835853);
    path_18.cubicTo(
        size.width * 0.03110048,
        size.height * 0.3826671,
        size.width * 0.03219976,
        size.height * 0.3818353,
        size.width * 0.03391100,
        size.height * 0.3814568);
    path_18.lineTo(size.width * 0.07218852, size.height * 0.3729907);
    path_18.cubicTo(
        size.width * 0.07535598,
        size.height * 0.3722897,
        size.width * 0.07894737,
        size.height * 0.3734206,
        size.width * 0.07894737,
        size.height * 0.3751180);
    path_18.lineTo(size.width * 0.07894737, size.height * 0.3858178);
    path_18.cubicTo(
        size.width * 0.07894737,
        size.height * 0.3867582,
        size.width * 0.07779282,
        size.height * 0.3876063,
        size.width * 0.07601770,
        size.height * 0.3879708);
    path_18.lineTo(size.width * 0.03774019, size.height * 0.3958329);
    path_18.cubicTo(
        size.width * 0.03458660,
        size.height * 0.3964801,
        size.width * 0.03110048,
        size.height * 0.3953493,
        size.width * 0.03110048,
        size.height * 0.3936787);
    path_18.lineTo(size.width * 0.03110048, size.height * 0.3835853);
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.03110048, size.height * 0.5798470);
    path_19.cubicTo(
        size.width * 0.03110048,
        size.height * 0.5789287,
        size.width * 0.03219976,
        size.height * 0.5780970,
        size.width * 0.03391100,
        size.height * 0.5777185);
    path_19.lineTo(size.width * 0.07218852, size.height * 0.5692523);
    path_19.cubicTo(
        size.width * 0.07535598,
        size.height * 0.5685514,
        size.width * 0.07894737,
        size.height * 0.5696822,
        size.width * 0.07894737,
        size.height * 0.5713797);
    path_19.lineTo(size.width * 0.07894737, size.height * 0.5820794);
    path_19.cubicTo(
        size.width * 0.07894737,
        size.height * 0.5830199,
        size.width * 0.07779282,
        size.height * 0.5838680,
        size.width * 0.07601770,
        size.height * 0.5842325);
    path_19.lineTo(size.width * 0.03774019, size.height * 0.5920946);
    path_19.cubicTo(
        size.width * 0.03458660,
        size.height * 0.5927418,
        size.width * 0.03110048,
        size.height * 0.5916110,
        size.width * 0.03110048,
        size.height * 0.5899404);
    path_19.lineTo(size.width * 0.03110048, size.height * 0.5798470);
    path_19.close();

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.03110048, size.height * 0.6078843);
    path_20.cubicTo(
        size.width * 0.03110048,
        size.height * 0.6069661,
        size.width * 0.03219976,
        size.height * 0.6061343,
        size.width * 0.03391100,
        size.height * 0.6057558);
    path_20.lineTo(size.width * 0.07218852, size.height * 0.5972897);
    path_20.cubicTo(
        size.width * 0.07535598,
        size.height * 0.5965888,
        size.width * 0.07894737,
        size.height * 0.5977196,
        size.width * 0.07894737,
        size.height * 0.5994171);
    path_20.lineTo(size.width * 0.07894737, size.height * 0.6101168);
    path_20.cubicTo(
        size.width * 0.07894737,
        size.height * 0.6110572,
        size.width * 0.07779282,
        size.height * 0.6119054,
        size.width * 0.07601770,
        size.height * 0.6122699);
    path_20.lineTo(size.width * 0.03774019, size.height * 0.6201320);
    path_20.cubicTo(
        size.width * 0.03458660,
        size.height * 0.6207792,
        size.width * 0.03110048,
        size.height * 0.6196484,
        size.width * 0.03110048,
        size.height * 0.6179778);
    path_20.lineTo(size.width * 0.03110048, size.height * 0.6078843);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.03110048, size.height * 0.6359217);
    path_21.cubicTo(
        size.width * 0.03110048,
        size.height * 0.6350035,
        size.width * 0.03219976,
        size.height * 0.6341717,
        size.width * 0.03391100,
        size.height * 0.6337932);
    path_21.lineTo(size.width * 0.07218852, size.height * 0.6253271);
    path_21.cubicTo(
        size.width * 0.07535598,
        size.height * 0.6246262,
        size.width * 0.07894737,
        size.height * 0.6257570,
        size.width * 0.07894737,
        size.height * 0.6274544);
    path_21.lineTo(size.width * 0.07894737, size.height * 0.6381542);
    path_21.cubicTo(
        size.width * 0.07894737,
        size.height * 0.6390946,
        size.width * 0.07779282,
        size.height * 0.6399428,
        size.width * 0.07601770,
        size.height * 0.6403072);
    path_21.lineTo(size.width * 0.03774019, size.height * 0.6481694);
    path_21.cubicTo(
        size.width * 0.03458660,
        size.height * 0.6488166,
        size.width * 0.03110048,
        size.height * 0.6476857,
        size.width * 0.03110048,
        size.height * 0.6460152);
    path_21.lineTo(size.width * 0.03110048, size.height * 0.6359217);
    path_21.close();

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.03110048, size.height * 0.6639591);
    path_22.cubicTo(
        size.width * 0.03110048,
        size.height * 0.6630409,
        size.width * 0.03219976,
        size.height * 0.6622091,
        size.width * 0.03391100,
        size.height * 0.6618306);
    path_22.lineTo(size.width * 0.07218852, size.height * 0.6533645);
    path_22.cubicTo(
        size.width * 0.07535598,
        size.height * 0.6526636,
        size.width * 0.07894737,
        size.height * 0.6537944,
        size.width * 0.07894737,
        size.height * 0.6554918);
    path_22.lineTo(size.width * 0.07894737, size.height * 0.6661916);
    path_22.cubicTo(
        size.width * 0.07894737,
        size.height * 0.6671320,
        size.width * 0.07779282,
        size.height * 0.6679801,
        size.width * 0.07601770,
        size.height * 0.6683446);
    path_22.lineTo(size.width * 0.03774019, size.height * 0.6762068);
    path_22.cubicTo(
        size.width * 0.03458660,
        size.height * 0.6768540,
        size.width * 0.03110048,
        size.height * 0.6757231,
        size.width * 0.03110048,
        size.height * 0.6740526);
    path_22.lineTo(size.width * 0.03110048, size.height * 0.6639591);
    path_22.close();

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.03110048, size.height * 0.6919965);
    path_23.cubicTo(
        size.width * 0.03110048,
        size.height * 0.6910783,
        size.width * 0.03219976,
        size.height * 0.6902465,
        size.width * 0.03391100,
        size.height * 0.6898680);
    path_23.lineTo(size.width * 0.07218852, size.height * 0.6814019);
    path_23.cubicTo(
        size.width * 0.07535598,
        size.height * 0.6807009,
        size.width * 0.07894737,
        size.height * 0.6818318,
        size.width * 0.07894737,
        size.height * 0.6835292);
    path_23.lineTo(size.width * 0.07894737, size.height * 0.6942290);
    path_23.cubicTo(
        size.width * 0.07894737,
        size.height * 0.6951694,
        size.width * 0.07779282,
        size.height * 0.6960175,
        size.width * 0.07601770,
        size.height * 0.6963820);
    path_23.lineTo(size.width * 0.03774019, size.height * 0.7042442);
    path_23.cubicTo(
        size.width * 0.03458660,
        size.height * 0.7048914,
        size.width * 0.03110048,
        size.height * 0.7037605,
        size.width * 0.03110048,
        size.height * 0.7020900);
    path_23.lineTo(size.width * 0.03110048, size.height * 0.6919965);
    path_23.close();

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.03110048, size.height * 0.7200339);
    path_24.cubicTo(
        size.width * 0.03110048,
        size.height * 0.7191157,
        size.width * 0.03219976,
        size.height * 0.7182839,
        size.width * 0.03391100,
        size.height * 0.7179054);
    path_24.lineTo(size.width * 0.07218852, size.height * 0.7094393);
    path_24.cubicTo(
        size.width * 0.07535598,
        size.height * 0.7087383,
        size.width * 0.07894737,
        size.height * 0.7098692,
        size.width * 0.07894737,
        size.height * 0.7115666);
    path_24.lineTo(size.width * 0.07894737, size.height * 0.7222664);
    path_24.cubicTo(
        size.width * 0.07894737,
        size.height * 0.7232068,
        size.width * 0.07779282,
        size.height * 0.7240549,
        size.width * 0.07601770,
        size.height * 0.7244194);
    path_24.lineTo(size.width * 0.03774019, size.height * 0.7322815);
    path_24.cubicTo(
        size.width * 0.03458660,
        size.height * 0.7329287,
        size.width * 0.03110048,
        size.height * 0.7317979,
        size.width * 0.03110048,
        size.height * 0.7301273);
    path_24.lineTo(size.width * 0.03110048, size.height * 0.7200339);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.03110048, size.height * 0.7480713);
    path_25.cubicTo(
        size.width * 0.03110048,
        size.height * 0.7471530,
        size.width * 0.03219976,
        size.height * 0.7463213,
        size.width * 0.03391100,
        size.height * 0.7459428);
    path_25.lineTo(size.width * 0.07218852, size.height * 0.7374766);
    path_25.cubicTo(
        size.width * 0.07535598,
        size.height * 0.7367757,
        size.width * 0.07894737,
        size.height * 0.7379065,
        size.width * 0.07894737,
        size.height * 0.7396040);
    path_25.lineTo(size.width * 0.07894737, size.height * 0.7503037);
    path_25.cubicTo(
        size.width * 0.07894737,
        size.height * 0.7512442,
        size.width * 0.07779282,
        size.height * 0.7520923,
        size.width * 0.07601770,
        size.height * 0.7524568);
    path_25.lineTo(size.width * 0.03774019, size.height * 0.7603189);
    path_25.cubicTo(
        size.width * 0.03458660,
        size.height * 0.7609661,
        size.width * 0.03110048,
        size.height * 0.7598353,
        size.width * 0.03110048,
        size.height * 0.7581647);
    path_25.lineTo(size.width * 0.03110048, size.height * 0.7480713);
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.03110048, size.height * 0.5503026);
    path_26.lineTo(size.width * 0.07894737, size.height * 0.5397196);
    path_26.lineTo(size.width * 0.07894737, size.height * 0.5555935);
    path_26.lineTo(size.width * 0.03110048, size.height * 0.5654206);
    path_26.lineTo(size.width * 0.03110048, size.height * 0.5503026);
    path_26.close();

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(size.width * 0.03110048, size.height * 0.5783400);
    path_27.lineTo(size.width * 0.07894737, size.height * 0.5677570);
    path_27.lineTo(size.width * 0.07894737, size.height * 0.5836308);
    path_27.lineTo(size.width * 0.03110048, size.height * 0.5934579);
    path_27.lineTo(size.width * 0.03110048, size.height * 0.5783400);
    path_27.close();

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(size.width * 0.03110048, size.height * 0.6063773);
    path_28.lineTo(size.width * 0.07894737, size.height * 0.5957944);
    path_28.lineTo(size.width * 0.07894737, size.height * 0.6116682);
    path_28.lineTo(size.width * 0.03110048, size.height * 0.6214953);
    path_28.lineTo(size.width * 0.03110048, size.height * 0.6063773);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(size.width * 0.03110048, size.height * 0.6344147);
    path_29.lineTo(size.width * 0.07894737, size.height * 0.6238318);
    path_29.lineTo(size.width * 0.07894737, size.height * 0.6397056);
    path_29.lineTo(size.width * 0.03110048, size.height * 0.6495327);
    path_29.lineTo(size.width * 0.03110048, size.height * 0.6344147);
    path_29.close();

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(size.width * 0.03110048, size.height * 0.6624521);
    path_30.lineTo(size.width * 0.07894737, size.height * 0.6518692);
    path_30.lineTo(size.width * 0.07894737, size.height * 0.6677430);
    path_30.lineTo(size.width * 0.03110048, size.height * 0.6775701);
    path_30.lineTo(size.width * 0.03110048, size.height * 0.6624521);
    path_30.close();

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);

    Path path_31 = Path();
    path_31.moveTo(size.width * 0.03110048, size.height * 0.6904895);
    path_31.lineTo(size.width * 0.07894737, size.height * 0.6799065);
    path_31.lineTo(size.width * 0.07894737, size.height * 0.6957804);
    path_31.lineTo(size.width * 0.03110048, size.height * 0.7056075);
    path_31.lineTo(size.width * 0.03110048, size.height * 0.6904895);
    path_31.close();

    Paint paint_31_fill = Paint()..style = PaintingStyle.fill;
    paint_31_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_fill);

    Path path_32 = Path();
    path_32.moveTo(size.width * 0.03110048, size.height * 0.7185269);
    path_32.lineTo(size.width * 0.07894737, size.height * 0.7079439);
    path_32.lineTo(size.width * 0.07894737, size.height * 0.7238178);
    path_32.lineTo(size.width * 0.03110048, size.height * 0.7336449);
    path_32.lineTo(size.width * 0.03110048, size.height * 0.7185269);
    path_32.close();

    Paint paint_32_fill = Paint()..style = PaintingStyle.fill;
    paint_32_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_32, paint_32_fill);

    Path path_33 = Path();
    path_33.moveTo(size.width * 0.03110048, size.height * 0.7465643);
    path_33.lineTo(size.width * 0.07894737, size.height * 0.7359813);
    path_33.lineTo(size.width * 0.07894737, size.height * 0.7518551);
    path_33.lineTo(size.width * 0.03110048, size.height * 0.7616822);
    path_33.lineTo(size.width * 0.03110048, size.height * 0.7465643);
    path_33.close();

    Paint paint_33_fill = Paint()..style = PaintingStyle.fill;
    paint_33_fill.color = const Color(0xffE26B1E).withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_fill);

    Paint paint_34_fill = Paint()..style = PaintingStyle.fill;
    paint_34_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.01674641, size.height * 0.02803738,
            size.width * 0.8971292, size.height * 0.05140187),
        paint_34_fill);

    Paint paint_35_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_35_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.8225670, size.height * 0.04731308,
                size.width * 0.05023923, size.height * 0.01207161),
            bottomRight: Radius.circular(size.width * 0.005183421),
            bottomLeft: Radius.circular(size.width * 0.005183421),
            topLeft: Radius.circular(size.width * 0.005183421),
            topRight: Radius.circular(size.width * 0.005183421)),
        paint_35_stroke);

    Paint paint_35_fill = Paint()..style = PaintingStyle.fill;
    paint_35_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.8225670, size.height * 0.04731308,
                size.width * 0.05023923, size.height * 0.01207161),
            bottomRight: Radius.circular(size.width * 0.005183421),
            bottomLeft: Radius.circular(size.width * 0.005183421),
            topLeft: Radius.circular(size.width * 0.005183421),
            topRight: Radius.circular(size.width * 0.005183421)),
        paint_35_fill);

    Path path_36 = Path();
    path_36.moveTo(size.width * 0.8763947, size.height * 0.05101250);
    path_36.lineTo(size.width * 0.8763947, size.height * 0.05568540);
    path_36.cubicTo(
        size.width * 0.8783206,
        size.height * 0.05528972,
        size.width * 0.8795718,
        size.height * 0.05436904,
        size.width * 0.8795718,
        size.height * 0.05334895);
    path_36.cubicTo(
        size.width * 0.8795718,
        size.height * 0.05232897,
        size.width * 0.8783206,
        size.height * 0.05140829,
        size.width * 0.8763947,
        size.height * 0.05101250);
    path_36.close();

    Paint paint_36_fill = Paint()..style = PaintingStyle.fill;
    paint_36_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_36, paint_36_fill);

    Paint paint_37_fill = Paint()..style = PaintingStyle.fill;
    paint_37_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.8261555, size.height * 0.04906542,
                size.width * 0.04306220, size.height * 0.008566974),
            bottomRight: Radius.circular(size.width * 0.003189785),
            bottomLeft: Radius.circular(size.width * 0.003189785),
            topLeft: Radius.circular(size.width * 0.003189785),
            topRight: Radius.circular(size.width * 0.003189785)),
        paint_37_fill);

    Path path_38 = Path();
    path_38.moveTo(size.width * 0.7910694, size.height * 0.04939778);
    path_38.cubicTo(
        size.width * 0.7963923,
        size.height * 0.04939790,
        size.width * 0.8015096,
        size.height * 0.05039568,
        size.width * 0.8053684,
        size.height * 0.05218493);
    path_38.cubicTo(
        size.width * 0.8056579,
        size.height * 0.05232301,
        size.width * 0.8061220,
        size.height * 0.05232126,
        size.width * 0.8064091,
        size.height * 0.05218096);
    path_38.lineTo(size.width * 0.8091842, size.height * 0.05081379);
    path_38.cubicTo(
        size.width * 0.8093301,
        size.height * 0.05074264,
        size.width * 0.8094115,
        size.height * 0.05064626,
        size.width * 0.8094091,
        size.height * 0.05054591);
    path_38.cubicTo(
        size.width * 0.8094091,
        size.height * 0.05044568,
        size.width * 0.8093254,
        size.height * 0.05034977,
        size.width * 0.8091794,
        size.height * 0.05027944);
    path_38.cubicTo(
        size.width * 0.7990550,
        size.height * 0.04554544,
        size.width * 0.7830837,
        size.height * 0.04554544,
        size.width * 0.7729593,
        size.height * 0.05027944);
    path_38.cubicTo(
        size.width * 0.7728110,
        size.height * 0.05034965,
        size.width * 0.7727297,
        size.height * 0.05044556,
        size.width * 0.7727273,
        size.height * 0.05054591);
    path_38.cubicTo(
        size.width * 0.7727249,
        size.height * 0.05064614,
        size.width * 0.7728062,
        size.height * 0.05074252,
        size.width * 0.7729522,
        size.height * 0.05081379);
    path_38.lineTo(size.width * 0.7757297, size.height * 0.05218096);
    path_38.cubicTo(
        size.width * 0.7760144,
        size.height * 0.05232150,
        size.width * 0.7764785,
        size.height * 0.05232325,
        size.width * 0.7767703,
        size.height * 0.05218493);
    path_38.cubicTo(
        size.width * 0.7806268,
        size.height * 0.05039556,
        size.width * 0.7857464,
        size.height * 0.04939778,
        size.width * 0.7910694,
        size.height * 0.04939778);
    path_38.close();
    path_38.moveTo(size.width * 0.7910694, size.height * 0.05384591);
    path_38.cubicTo(
        size.width * 0.7939928,
        size.height * 0.05384579,
        size.width * 0.7968134,
        size.height * 0.05437605,
        size.width * 0.7989809,
        size.height * 0.05533376);
    path_38.cubicTo(
        size.width * 0.7992751,
        size.height * 0.05546974,
        size.width * 0.7997368,
        size.height * 0.05546671,
        size.width * 0.8000215,
        size.height * 0.05532710);
    path_38.lineTo(size.width * 0.8027967, size.height * 0.05395993);
    path_38.cubicTo(
        size.width * 0.8029426,
        size.height * 0.05388820,
        size.width * 0.8030215,
        size.height * 0.05379089,
        size.width * 0.8030215,
        size.height * 0.05368984);
    path_38.cubicTo(
        size.width * 0.8030191,
        size.height * 0.05358879,
        size.width * 0.8029330,
        size.height * 0.05349229,
        size.width * 0.8027847,
        size.height * 0.05342208);
    path_38.cubicTo(
        size.width * 0.7961842,
        size.height * 0.05042629,
        size.width * 0.7859617,
        size.height * 0.05042629,
        size.width * 0.7793612,
        size.height * 0.05342208);
    path_38.cubicTo(
        size.width * 0.7792105,
        size.height * 0.05349229,
        size.width * 0.7791268,
        size.height * 0.05358879,
        size.width * 0.7791244,
        size.height * 0.05368995);
    path_38.cubicTo(
        size.width * 0.7791220,
        size.height * 0.05379100,
        size.width * 0.7792033,
        size.height * 0.05388832,
        size.width * 0.7793493,
        size.height * 0.05395993);
    path_38.lineTo(size.width * 0.7821220, size.height * 0.05532710);
    path_38.cubicTo(
        size.width * 0.7824091,
        size.height * 0.05546671,
        size.width * 0.7828708,
        size.height * 0.05546974,
        size.width * 0.7831627,
        size.height * 0.05533376);
    path_38.cubicTo(
        size.width * 0.7853301,
        size.height * 0.05437675,
        size.width * 0.7881483,
        size.height * 0.05384650,
        size.width * 0.7910694,
        size.height * 0.05384591);
    path_38.close();
    path_38.moveTo(size.width * 0.7966244, size.height * 0.05683867);
    path_38.cubicTo(
        size.width * 0.7966292,
        size.height * 0.05694007,
        size.width * 0.7965478,
        size.height * 0.05703773,
        size.width * 0.7963995,
        size.height * 0.05710876);
    path_38.lineTo(size.width * 0.7916029, size.height * 0.05947091);
    path_38.cubicTo(
        size.width * 0.7914617,
        size.height * 0.05954042,
        size.width * 0.7912703,
        size.height * 0.05957944,
        size.width * 0.7910694,
        size.height * 0.05957944);
    path_38.cubicTo(
        size.width * 0.7908684,
        size.height * 0.05957944,
        size.width * 0.7906770,
        size.height * 0.05954042,
        size.width * 0.7905383,
        size.height * 0.05947091);
    path_38.lineTo(size.width * 0.7857392, size.height * 0.05710876);
    path_38.cubicTo(
        size.width * 0.7855909,
        size.height * 0.05703773,
        size.width * 0.7855096,
        size.height * 0.05693995,
        size.width * 0.7855144,
        size.height * 0.05683855);
    path_38.cubicTo(
        size.width * 0.7855191,
        size.height * 0.05673715,
        size.width * 0.7856077,
        size.height * 0.05664124,
        size.width * 0.7857632,
        size.height * 0.05657325);
    path_38.cubicTo(
        size.width * 0.7888254,
        size.height * 0.05530888,
        size.width * 0.7933134,
        size.height * 0.05530888,
        size.width * 0.7963780,
        size.height * 0.05657325);
    path_38.cubicTo(
        size.width * 0.7965311,
        size.height * 0.05664124,
        size.width * 0.7966220,
        size.height * 0.05673727,
        size.width * 0.7966244,
        size.height * 0.05683867);
    path_38.close();

    Paint paint_38_fill = Paint()..style = PaintingStyle.fill;
    paint_38_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_38, paint_38_fill);

    Path path_39 = Path();
    path_39.moveTo(size.width * 0.7583732, size.height * 0.04789720);
    path_39.lineTo(size.width * 0.7559809, size.height * 0.04789720);
    path_39.cubicTo(
        size.width * 0.7546603,
        size.height * 0.04789720,
        size.width * 0.7535885,
        size.height * 0.04842021,
        size.width * 0.7535885,
        size.height * 0.04906542);
    path_39.lineTo(size.width * 0.7535885, size.height * 0.05919007);
    path_39.cubicTo(
        size.width * 0.7535885,
        size.height * 0.05983528,
        size.width * 0.7546603,
        size.height * 0.06035829,
        size.width * 0.7559809,
        size.height * 0.06035829);
    path_39.lineTo(size.width * 0.7583732, size.height * 0.06035829);
    path_39.cubicTo(
        size.width * 0.7596938,
        size.height * 0.06035829,
        size.width * 0.7607656,
        size.height * 0.05983528,
        size.width * 0.7607656,
        size.height * 0.05919007);
    path_39.lineTo(size.width * 0.7607656, size.height * 0.04906542);
    path_39.cubicTo(
        size.width * 0.7607656,
        size.height * 0.04842021,
        size.width * 0.7596938,
        size.height * 0.04789720,
        size.width * 0.7583732,
        size.height * 0.04789720);
    path_39.close();
    path_39.moveTo(size.width * 0.7448158, size.height * 0.05062301);
    path_39.lineTo(size.width * 0.7472081, size.height * 0.05062301);
    path_39.cubicTo(
        size.width * 0.7485311,
        size.height * 0.05062301,
        size.width * 0.7496005,
        size.height * 0.05114603,
        size.width * 0.7496005,
        size.height * 0.05179124);
    path_39.lineTo(size.width * 0.7496005, size.height * 0.05919007);
    path_39.cubicTo(
        size.width * 0.7496005,
        size.height * 0.05983528,
        size.width * 0.7485311,
        size.height * 0.06035829,
        size.width * 0.7472081,
        size.height * 0.06035829);
    path_39.lineTo(size.width * 0.7448158, size.height * 0.06035829);
    path_39.cubicTo(
        size.width * 0.7434952,
        size.height * 0.06035829,
        size.width * 0.7424234,
        size.height * 0.05983528,
        size.width * 0.7424234,
        size.height * 0.05919007);
    path_39.lineTo(size.width * 0.7424234, size.height * 0.05179124);
    path_39.cubicTo(
        size.width * 0.7424234,
        size.height * 0.05114603,
        size.width * 0.7434952,
        size.height * 0.05062301,
        size.width * 0.7448158,
        size.height * 0.05062301);
    path_39.close();
    path_39.moveTo(size.width * 0.7360455, size.height * 0.05334895);
    path_39.lineTo(size.width * 0.7336531, size.height * 0.05334895);
    path_39.cubicTo(
        size.width * 0.7323301,
        size.height * 0.05334895,
        size.width * 0.7312608,
        size.height * 0.05387196,
        size.width * 0.7312608,
        size.height * 0.05451717);
    path_39.lineTo(size.width * 0.7312608, size.height * 0.05919007);
    path_39.cubicTo(
        size.width * 0.7312608,
        size.height * 0.05983528,
        size.width * 0.7323301,
        size.height * 0.06035829,
        size.width * 0.7336531,
        size.height * 0.06035829);
    path_39.lineTo(size.width * 0.7360455, size.height * 0.06035829);
    path_39.cubicTo(
        size.width * 0.7373660,
        size.height * 0.06035829,
        size.width * 0.7384378,
        size.height * 0.05983528,
        size.width * 0.7384378,
        size.height * 0.05919007);
    path_39.lineTo(size.width * 0.7384378, size.height * 0.05451717);
    path_39.cubicTo(
        size.width * 0.7384378,
        size.height * 0.05387196,
        size.width * 0.7373660,
        size.height * 0.05334895,
        size.width * 0.7360455,
        size.height * 0.05334895);
    path_39.close();
    path_39.moveTo(size.width * 0.7248804, size.height * 0.05568540);
    path_39.lineTo(size.width * 0.7224880, size.height * 0.05568540);
    path_39.cubicTo(
        size.width * 0.7211675,
        size.height * 0.05568540,
        size.width * 0.7200957,
        size.height * 0.05620841,
        size.width * 0.7200957,
        size.height * 0.05685362);
    path_39.lineTo(size.width * 0.7200957, size.height * 0.05919007);
    path_39.cubicTo(
        size.width * 0.7200957,
        size.height * 0.05983528,
        size.width * 0.7211675,
        size.height * 0.06035829,
        size.width * 0.7224880,
        size.height * 0.06035829);
    path_39.lineTo(size.width * 0.7248804, size.height * 0.06035829);
    path_39.cubicTo(
        size.width * 0.7262010,
        size.height * 0.06035829,
        size.width * 0.7272727,
        size.height * 0.05983528,
        size.width * 0.7272727,
        size.height * 0.05919007);
    path_39.lineTo(size.width * 0.7272727, size.height * 0.05685362);
    path_39.cubicTo(
        size.width * 0.7272727,
        size.height * 0.05620841,
        size.width * 0.7262010,
        size.height * 0.05568540,
        size.width * 0.7248804,
        size.height * 0.05568540);
    path_39.close();

    Paint paint_39_fill = Paint()..style = PaintingStyle.fill;
    paint_39_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_39, paint_39_fill);

    Path path_40 = Path();
    path_40.moveTo(size.width * 0.08625239, size.height * 0.05243096);
    path_40.cubicTo(
        size.width * 0.08625239,
        size.height * 0.05116460,
        size.width * 0.08712847,
        size.height * 0.05012640,
        size.width * 0.08888062,
        size.height * 0.04931636);
    path_40.cubicTo(
        size.width * 0.09064474,
        size.height * 0.04850070,
        size.width * 0.09289904,
        size.height * 0.04809287,
        size.width * 0.09564426,
        size.height * 0.04809287);
    path_40.cubicTo(
        size.width * 0.09748995,
        size.height * 0.04809287,
        size.width * 0.09912536,
        size.height * 0.04830105,
        size.width * 0.1005505,
        size.height * 0.04871741);
    path_40.cubicTo(
        size.width * 0.1019756,
        size.height * 0.04913388,
        size.width * 0.1031146,
        size.height * 0.04973855,
        size.width * 0.1039672,
        size.height * 0.05053143);
    path_40.cubicTo(
        size.width * 0.1051586,
        size.height * 0.05156390,
        size.width * 0.1057545,
        size.height * 0.05286449,
        size.width * 0.1057545,
        size.height * 0.05443306);
    path_40.cubicTo(
        size.width * 0.1057545,
        size.height * 0.05650946,
        size.width * 0.1048493,
        size.height * 0.05813224,
        size.width * 0.1030385,
        size.height * 0.05930164);
    path_40.cubicTo(
        size.width * 0.1012280,
        size.height * 0.06046530,
        size.width * 0.09871651,
        size.height * 0.06104708,
        size.width * 0.09550407,
        size.height * 0.06104708);
    path_40.cubicTo(
        size.width * 0.09319115,
        size.height * 0.06104708,
        size.width * 0.09122297,
        size.height * 0.06074194,
        size.width * 0.08959904,
        size.height * 0.06013166);
    path_40.cubicTo(
        size.width * 0.08797536,
        size.height * 0.05951554,
        size.width * 0.08697656,
        size.height * 0.05869988,
        size.width * 0.08660287,
        size.height * 0.05768446);
    path_40.lineTo(size.width * 0.09110598, size.height * 0.05768446);
    path_40.cubicTo(
        size.width * 0.09139809,
        size.height * 0.05815222,
        size.width * 0.09193541,
        size.height * 0.05852301,
        size.width * 0.09271818,
        size.height * 0.05879685);
    path_40.cubicTo(
        size.width * 0.09351244,
        size.height * 0.05906495,
        size.width * 0.09445263,
        size.height * 0.05919895,
        size.width * 0.09553923,
        size.height * 0.05919895);
    path_40.cubicTo(
        size.width * 0.09738469,
        size.height * 0.05919895,
        size.width * 0.09882751,
        size.height * 0.05880257,
        size.width * 0.09986699,
        size.height * 0.05800958);
    path_40.cubicTo(
        size.width * 0.1009067,
        size.height * 0.05721110,
        size.width * 0.1014266,
        size.height * 0.05610444,
        size.width * 0.1014266,
        size.height * 0.05468984);
    path_40.lineTo(size.width * 0.1012689, size.height * 0.05468984);
    path_40.lineTo(size.width * 0.1011811, size.height * 0.05468984);
    path_40.lineTo(size.width * 0.1011287, size.height * 0.05468984);
    path_40.cubicTo(
        size.width * 0.1005330,
        size.height * 0.05527734,
        size.width * 0.09966268,
        size.height * 0.05573364,
        size.width * 0.09851794,
        size.height * 0.05605876);
    path_40.cubicTo(
        size.width * 0.09737321,
        size.height * 0.05637827,
        size.width * 0.09605885,
        size.height * 0.05653797,
        size.width * 0.09457536,
        size.height * 0.05653797);
    path_40.cubicTo(
        size.width * 0.09216914,
        size.height * 0.05653797,
        size.width * 0.09017727,
        size.height * 0.05615012,
        size.width * 0.08860048,
        size.height * 0.05537430);
    path_40.cubicTo(
        size.width * 0.08703517,
        size.height * 0.05459848,
        size.width * 0.08625239,
        size.height * 0.05361741,
        size.width * 0.08625239,
        size.height * 0.05243096);
    path_40.close();
    path_40.moveTo(size.width * 0.09068541, size.height * 0.05236250);
    path_40.cubicTo(
        size.width * 0.09068541,
        size.height * 0.05306974,
        size.width * 0.09115287,
        size.height * 0.05365164,
        size.width * 0.09208732,
        size.height * 0.05410794);
    path_40.cubicTo(
        size.width * 0.09302177,
        size.height * 0.05455853,
        size.width * 0.09421340,
        size.height * 0.05478388,
        size.width * 0.09566172,
        size.height * 0.05478388);
    path_40.cubicTo(
        size.width * 0.09711029,
        size.height * 0.05478388,
        size.width * 0.09830766,
        size.height * 0.05455853,
        size.width * 0.09925383,
        size.height * 0.05410794);
    path_40.cubicTo(
        size.width * 0.1002000,
        size.height * 0.05365736,
        size.width * 0.1006730,
        size.height * 0.05308692,
        size.width * 0.1006730,
        size.height * 0.05239673);
    path_40.cubicTo(
        size.width * 0.1006730,
        size.height * 0.05170082,
        size.width * 0.1001943,
        size.height * 0.05111612,
        size.width * 0.09923636,
        size.height * 0.05064264);
    path_40.cubicTo(
        size.width * 0.09827847,
        size.height * 0.05016916,
        size.width * 0.09709282,
        size.height * 0.04993248,
        size.width * 0.09567919,
        size.height * 0.04993248);
    path_40.cubicTo(
        size.width * 0.09426579,
        size.height * 0.04993248,
        size.width * 0.09308014,
        size.height * 0.05016636,
        size.width * 0.09212225,
        size.height * 0.05063411);
    path_40.cubicTo(
        size.width * 0.09116435,
        size.height * 0.05109614,
        size.width * 0.09068541,
        size.height * 0.05167220,
        size.width * 0.09068541,
        size.height * 0.05236250);
    path_40.close();
    path_40.moveTo(size.width * 0.1103459, size.height * 0.05957547);
    path_40.cubicTo(
        size.width * 0.1103459,
        size.height * 0.05918189,
        size.width * 0.1106089,
        size.height * 0.05885958,
        size.width * 0.1111344,
        size.height * 0.05860853);
    path_40.cubicTo(
        size.width * 0.1116600,
        size.height * 0.05835187,
        size.width * 0.1123318,
        size.height * 0.05822360,
        size.width * 0.1131495,
        size.height * 0.05822360);
    path_40.cubicTo(
        size.width * 0.1139789,
        size.height * 0.05822360,
        size.width * 0.1146505,
        size.height * 0.05835187,
        size.width * 0.1151646,
        size.height * 0.05860853);
    path_40.cubicTo(
        size.width * 0.1156902,
        size.height * 0.05885958,
        size.width * 0.1159531,
        size.height * 0.05918189,
        size.width * 0.1159531,
        size.height * 0.05957547);
    path_40.cubicTo(
        size.width * 0.1159531,
        size.height * 0.05996332,
        size.width * 0.1156902,
        size.height * 0.06028563,
        size.width * 0.1151646,
        size.height * 0.06054229);
    path_40.cubicTo(
        size.width * 0.1146505,
        size.height * 0.06079895,
        size.width * 0.1139789,
        size.height * 0.06092734,
        size.width * 0.1131495,
        size.height * 0.06092734);
    path_40.cubicTo(
        size.width * 0.1123318,
        size.height * 0.06092734,
        size.width * 0.1116600,
        size.height * 0.06079895,
        size.width * 0.1111344,
        size.height * 0.06054229);
    path_40.cubicTo(
        size.width * 0.1106089,
        size.height * 0.06028563,
        size.width * 0.1103459,
        size.height * 0.05996332,
        size.width * 0.1103459,
        size.height * 0.05957547);
    path_40.close();
    path_40.moveTo(size.width * 0.1103459, size.height * 0.05316671);
    path_40.cubicTo(
        size.width * 0.1103459,
        size.height * 0.05277313,
        size.width * 0.1106089,
        size.height * 0.05245082,
        size.width * 0.1111344,
        size.height * 0.05219988);
    path_40.cubicTo(
        size.width * 0.1116600,
        size.height * 0.05194322,
        size.width * 0.1123318,
        size.height * 0.05181484,
        size.width * 0.1131495,
        size.height * 0.05181484);
    path_40.cubicTo(
        size.width * 0.1139789,
        size.height * 0.05181484,
        size.width * 0.1146505,
        size.height * 0.05194322,
        size.width * 0.1151646,
        size.height * 0.05219988);
    path_40.cubicTo(
        size.width * 0.1156902,
        size.height * 0.05245082,
        size.width * 0.1159531,
        size.height * 0.05277313,
        size.width * 0.1159531,
        size.height * 0.05316671);
    path_40.cubicTo(
        size.width * 0.1159531,
        size.height * 0.05355467,
        size.width * 0.1156902,
        size.height * 0.05387699,
        size.width * 0.1151646,
        size.height * 0.05413364);
    path_40.cubicTo(
        size.width * 0.1146505,
        size.height * 0.05438458,
        size.width * 0.1139789,
        size.height * 0.05451005,
        size.width * 0.1131495,
        size.height * 0.05451005);
    path_40.cubicTo(
        size.width * 0.1123318,
        size.height * 0.05451005,
        size.width * 0.1116600,
        size.height * 0.05438458,
        size.width * 0.1111344,
        size.height * 0.05413364);
    path_40.cubicTo(
        size.width * 0.1106089,
        size.height * 0.05387699,
        size.width * 0.1103459,
        size.height * 0.05355467,
        size.width * 0.1103459,
        size.height * 0.05316671);
    path_40.close();
    path_40.moveTo(size.width * 0.1200012, size.height * 0.05844603);
    path_40.lineTo(size.width * 0.1200012, size.height * 0.05647804);
    path_40.cubicTo(
        size.width * 0.1220572,
        size.height * 0.05462991,
        size.width * 0.1254916,
        size.height * 0.05193750,
        size.width * 0.1303043,
        size.height * 0.04840093);
    path_40.lineTo(size.width * 0.1366823, size.height * 0.04840093);
    path_40.lineTo(size.width * 0.1366823, size.height * 0.05658072);
    path_40.lineTo(size.width * 0.1400990, size.height * 0.05658072);
    path_40.lineTo(size.width * 0.1400990, size.height * 0.05844603);
    path_40.lineTo(size.width * 0.1366823, size.height * 0.05844603);
    path_40.lineTo(size.width * 0.1366823, size.height * 0.06074766);
    path_40.lineTo(size.width * 0.1323543, size.height * 0.06074766);
    path_40.lineTo(size.width * 0.1323543, size.height * 0.05844603);
    path_40.lineTo(size.width * 0.1200012, size.height * 0.05844603);
    path_40.close();
    path_40.moveTo(size.width * 0.1241890, size.height * 0.05663213);
    path_40.lineTo(size.width * 0.1324244, size.height * 0.05663213);
    path_40.lineTo(size.width * 0.1324244, size.height * 0.05019766);
    path_40.lineTo(size.width * 0.1321792, size.height * 0.05019766);
    path_40.cubicTo(
        size.width * 0.1294457,
        size.height * 0.05217138,
        size.width * 0.1267823,
        size.height * 0.05427336,
        size.width * 0.1241890,
        size.height * 0.05650374);
    path_40.lineTo(size.width * 0.1241890, size.height * 0.05663213);
    path_40.close();
    path_40.moveTo(size.width * 0.1431486, size.height * 0.05278178);
    path_40.lineTo(size.width * 0.1431486, size.height * 0.05065970);
    path_40.lineTo(size.width * 0.1497545, size.height * 0.04840093);
    path_40.lineTo(size.width * 0.1542577, size.height * 0.04840093);
    path_40.lineTo(size.width * 0.1542577, size.height * 0.06074766);
    path_40.lineTo(size.width * 0.1497368, size.height * 0.06074766);
    path_40.lineTo(size.width * 0.1497368, size.height * 0.05062547);
    path_40.lineTo(size.width * 0.1494390, size.height * 0.05062547);
    path_40.lineTo(size.width * 0.1431486, size.height * 0.05278178);
    path_40.close();

    Paint paint_40_fill = Paint()..style = PaintingStyle.fill;
    paint_40_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_40, paint_40_fill);

    Path path_41 = Path();
    path_41.moveTo(size.width * 0.1862261, size.height * 0.2594614);
    path_41.cubicTo(
        size.width * 0.1207440,
        size.height * 0.2535374,
        size.width * 0.03388206,
        size.height * 0.2293902,
        size.width * 0.01868124,
        size.height * 0.2250643);
    path_41.cubicTo(
        size.width * 0.01722641,
        size.height * 0.2246507,
        size.width * 0.01636388,
        size.height * 0.2238960,
        size.width * 0.01636388,
        size.height * 0.2230736);
    path_41.lineTo(size.width * 0.01636388, size.height * -0.003504673);
    path_41.cubicTo(
        size.width * 0.01636388,
        size.height * -0.004795058,
        size.width * 0.01850608,
        size.height * -0.005841121,
        size.width * 0.02114859,
        size.height * -0.005841121);
    path_41.lineTo(size.width * 1.143541, size.height * -0.005841121);
    path_41.cubicTo(
        size.width * 1.146184,
        size.height * -0.005841121,
        size.width * 1.148325,
        size.height * -0.004795023,
        size.width * 1.148325,
        size.height * -0.003504638);
    path_41.lineTo(size.width * 1.148325, size.height * 1.024397);
    path_41.cubicTo(
        size.width * 1.148325,
        size.height * 1.025687,
        size.width * 1.146184,
        size.height * 1.026734,
        size.width * 1.143541,
        size.height * 1.026734);
    path_41.lineTo(size.width * 0.2551029, size.height * 1.026734);
    path_41.cubicTo(
        size.width * 0.2006060,
        size.height * 1.029065,
        size.width * 0.1486550,
        size.height * 1.029442,
        size.width * 0.1066911,
        size.height * 1.029093);
    path_41.cubicTo(
        size.width * 0.1006184,
        size.height * 1.029043,
        size.width * 0.1007689,
        size.height * 1.026734,
        size.width * 0.1068423,
        size.height * 1.026734);
    path_41.lineTo(size.width * 0.2551029, size.height * 1.026734);
    path_41.cubicTo(
        size.width * 0.3662512,
        size.height * 1.021978,
        size.width * 0.4879904,
        size.height * 1.009091,
        size.width * 0.5572057,
        size.height * 0.9776460);
    path_41.cubicTo(
        size.width * 0.6011172,
        size.height * 0.9576974,
        size.width * 0.5625574,
        size.height * 0.9263902,
        size.width * 0.6482512,
        size.height * 0.9192103);
    path_41.cubicTo(
        size.width * 0.7222919,
        size.height * 0.9130058,
        size.width * 0.5589043,
        size.height * 0.8986811,
        size.width * 0.6319450,
        size.height * 0.8905759);
    path_41.cubicTo(
        size.width * 0.6740694,
        size.height * 0.8859007,
        size.width * 0.7388230,
        size.height * 0.8424264,
        size.width * 0.7189139,
        size.height * 0.8081799);
    path_41.cubicTo(
        size.width * 0.6822225,
        size.height * 0.7450689,
        size.width * 0.5680766,
        size.height * 0.8017523,
        size.width * 0.5218732,
        size.height * 0.7625993);
    path_41.cubicTo(
        size.width * 0.4790957,
        size.height * 0.7263481,
        size.width * 0.4050096,
        size.height * 0.7111752,
        size.width * 0.4050096,
        size.height * 0.6714393);
    path_41.cubicTo(
        size.width * 0.4050096,
        size.height * 0.6290829,
        size.width * 0.4668301,
        size.height * 0.6017932,
        size.width * 0.5572057,
        size.height * 0.5849533);
    path_41.cubicTo(
        size.width * 0.5979713,
        size.height * 0.5773563,
        size.width * 0.7116579,
        size.height * 0.5719556,
        size.width * 0.7447321,
        size.height * 0.5533972);
    path_41.cubicTo(
        size.width * 0.7879904,
        size.height * 0.5291250,
        size.width * 0.7202727,
        size.height * 0.4949311,
        size.width * 0.6835813,
        size.height * 0.4815199);
    path_41.cubicTo(
        size.width * 0.6249043,
        size.height * 0.4600713,
        size.width * 0.6411483,
        size.height * 0.4308925,
        size.width * 0.5857416,
        size.height * 0.4078902);
    path_41.cubicTo(
        size.width * 0.5400383,
        size.height * 0.3889159,
        size.width * 0.4735526,
        size.height * 0.3968119,
        size.width * 0.4457751,
        size.height * 0.3722430);
    path_41.cubicTo(
        size.width * 0.4023971,
        size.height * 0.3338773,
        size.width * 0.5951029,
        size.height * 0.3235526,
        size.width * 0.5857416,
        size.height * 0.2810829);
    path_41.cubicTo(
        size.width * 0.5803014,
        size.height * 0.2563925,
        size.width * 0.5722153,
        size.height * 0.2341168,
        size.width * 0.5191555,
        size.height * 0.2243995);
    path_41.cubicTo(
        size.width * 0.4457751,
        size.height * 0.2109591,
        size.width * 0.3172177,
        size.height * 0.2713107,
        size.width * 0.1862261,
        size.height * 0.2594614);
    path_41.close();

    Paint paint_41_fill = Paint()..style = PaintingStyle.fill;
    paint_41_fill.color = const Color(0xff12CBC4).withOpacity(1.0);
    canvas.drawPath(path_41, paint_41_fill);

    Path path_42 = Path();
    path_42.moveTo(size.width * 0.6472727, size.height * 0.6720864);
    path_42.cubicTo(
        size.width * 0.6472727,
        size.height * 0.6720864,
        size.width * 0.7152703,
        size.height * 0.6678143,
        size.width * 0.7117033,
        size.height * 0.6438154);
    path_42.cubicTo(
        size.width * 0.7081364,
        size.height * 0.6198154,
        size.width * 0.6832297,
        size.height * 0.5968119,
        size.width * 0.7322010,
        size.height * 0.5710350);
    path_42.cubicTo(
        size.width * 0.7685263,
        size.height * 0.5519147,
        size.width * 0.7861842,
        size.height * 0.5668061,
        size.width * 0.8284522,
        size.height * 0.5465245);
    path_42.cubicTo(
        size.width * 0.8707225,
        size.height * 0.5262430,
        size.width * 0.7802105,
        size.height * 0.4752605,
        size.width * 0.8284522,
        size.height * 0.4553808);
    path_42.cubicTo(
        size.width * 0.8728636,
        size.height * 0.4370806,
        size.width * 0.8482297,
        size.height * 0.4588855,
        size.width * 0.8482297,
        size.height * 0.4588855);

    Paint paint_42_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004784689;
    paint_42_stroke.color = const Color(0xffFFFEFF).withOpacity(0.5);
    paint_42_stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path_42, paint_42_stroke);

    Paint paint_42_fill = Paint()..style = PaintingStyle.fill;
    paint_42_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_42, paint_42_fill);

    Path path_43 = Path();
    path_43.moveTo(size.width * 0.6618014, size.height * 0.6806869);
    path_43.cubicTo(
        size.width * 0.6618014,
        size.height * 0.6806869,
        size.width * 0.7465478,
        size.height * 0.6705748,
        size.width * 0.7429809,
        size.height * 0.6465748);
    path_43.cubicTo(
        size.width * 0.7394139,
        size.height * 0.6225759,
        size.width * 0.7145048,
        size.height * 0.5995713,
        size.width * 0.7634761,
        size.height * 0.5737944);
    path_43.cubicTo(
        size.width * 0.7998014,
        size.height * 0.5546752,
        size.width * 0.8174593,
        size.height * 0.5695666,
        size.width * 0.8597297,
        size.height * 0.5492850);
    path_43.cubicTo(
        size.width * 0.9019976,
        size.height * 0.5290035,
        size.width * 0.8114856,
        size.height * 0.4780199,
        size.width * 0.8597297,
        size.height * 0.4581402);
    path_43.cubicTo(
        size.width * 0.9041388,
        size.height * 0.4398400,
        size.width * 0.8795048,
        size.height * 0.4616449,
        size.width * 0.8795048,
        size.height * 0.4616449);

    Paint paint_43_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004784689;
    paint_43_stroke.color = const Color(0xffFFFEFF).withOpacity(1.0);
    paint_43_stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path_43, paint_43_stroke);

    Paint paint_43_fill = Paint()..style = PaintingStyle.fill;
    paint_43_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_43, paint_43_fill);

    Path path_44 = Path();
    path_44.moveTo(size.width * 0.8229665, size.height * 0.4556075);
    path_44.cubicTo(
        size.width * 0.8229665,
        size.height * 0.4556075,
        size.width * 0.8578660,
        size.height * 0.4195187,
        size.width * 0.8373206,
        size.height * 0.4001168);
    path_44.cubicTo(
        size.width * 0.8051340,
        size.height * 0.3697231,
        size.width * 0.7096005,
        size.height * 0.4232103,
        size.width * 0.6578947,
        size.height * 0.4001168);
    path_44.cubicTo(
        size.width * 0.6177440,
        size.height * 0.3821846,
        size.width * 0.6192225,
        size.height * 0.3612664,
        size.width * 0.6196172,
        size.height * 0.3346963);
    path_44.cubicTo(
        size.width * 0.6200024,
        size.height * 0.3087839,
        size.width * 0.6578947,
        size.height * 0.2710280,
        size.width * 0.6578947,
        size.height * 0.2710280);
    path_44.cubicTo(
        size.width * 0.6578947,
        size.height * 0.2710280,
        size.width * 0.7446962,
        size.height * 0.2511706,
        size.width * 0.7380383,
        size.height * 0.2289720);
    path_44.cubicTo(
        size.width * 0.7319330,
        size.height * 0.2086110,
        size.width * 0.6796842,
        size.height * 0.2129603,
        size.width * 0.6507177,
        size.height * 0.1980140);
    path_44.cubicTo(
        size.width * 0.6240909,
        size.height * 0.1842745,
        size.width * 0.6024115,
        size.height * 0.1763400,
        size.width * 0.5956938,
        size.height * 0.1577103);
    path_44.cubicTo(
        size.width * 0.5889354,
        size.height * 0.1389673,
        size.width * 0.6237057,
        size.height * 0.1293236,
        size.width * 0.6196172,
        size.height * 0.1103972);
    path_44.cubicTo(
        size.width * 0.6102081,
        size.height * 0.06684836,
        size.width * 0.4258373,
        size.height * 0.05023364,
        size.width * 0.4258373,
        size.height * 0.05023364);

    Paint paint_44_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_44_stroke.color = const Color(0xffFFFEFF).withOpacity(1.0);
    paint_44_stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path_44, paint_44_stroke);

    Paint paint_44_fill = Paint()..style = PaintingStyle.fill;
    paint_44_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_44, paint_44_fill);

    Path path_45 = Path();
    path_45.moveTo(size.width * 0.8239856, size.height * 0.9996729);
    path_45.cubicTo(
        size.width * 0.8239856,
        size.height * 0.9996729,
        size.width * 0.8032201,
        size.height * 0.9618762,
        size.width * 0.8248780,
        size.height * 0.9361776);
    path_45.cubicTo(
        size.width * 0.8465359,
        size.height * 0.9104790,
        size.width * 0.9118732,
        size.height * 0.8878785,
        size.width * 0.8861483,
        size.height * 0.8488306);
    path_45.cubicTo(
        size.width * 0.8670670,
        size.height * 0.8198668,
        size.width * 0.8146579,
        size.height * 0.8350900,
        size.width * 0.7909522,
        size.height * 0.8035561);
    path_45.cubicTo(
        size.width * 0.7672464,
        size.height * 0.7720222,
        size.width * 0.8165239,
        size.height * 0.7430210,
        size.width * 0.7869665,
        size.height * 0.7106367);
    path_45.cubicTo(
        size.width * 0.7597608,
        size.height * 0.6808236,
        size.width * 0.6459330,
        size.height * 0.6761717,
        size.width * 0.6459330,
        size.height * 0.6761717);

    Paint paint_45_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004784689;
    paint_45_stroke.color = const Color(0xffFFFEFF).withOpacity(0.5);
    paint_45_stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path_45, paint_45_stroke);

    Paint paint_45_fill = Paint()..style = PaintingStyle.fill;
    paint_45_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_45, paint_45_fill);

    Path path_46 = Path();
    path_46.moveTo(size.width * 0.8239880, size.height * 0.9996729);
    path_46.cubicTo(
        size.width * 0.8239880,
        size.height * 0.9996729,
        size.width * 0.8032201,
        size.height * 0.9618762,
        size.width * 0.8248780,
        size.height * 0.9361776);
    path_46.cubicTo(
        size.width * 0.8465359,
        size.height * 0.9104790,
        size.width * 0.9118732,
        size.height * 0.8878785,
        size.width * 0.8861483,
        size.height * 0.8488306);
    path_46.cubicTo(
        size.width * 0.8670670,
        size.height * 0.8198668,
        size.width * 0.8146579,
        size.height * 0.8350900,
        size.width * 0.7909522,
        size.height * 0.8035561);
    path_46.cubicTo(
        size.width * 0.7672464,
        size.height * 0.7720222,
        size.width * 0.8165239,
        size.height * 0.7430210,
        size.width * 0.7869689,
        size.height * 0.7106367);
    path_46.cubicTo(
        size.width * 0.7597608,
        size.height * 0.6808236,
        size.width * 0.6435407,
        size.height * 0.6779241,
        size.width * 0.6435407,
        size.height * 0.6779241);

    Paint paint_46_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004784689;
    paint_46_stroke.color = const Color(0xffFFFEFF).withOpacity(1.0);
    paint_46_stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path_46, paint_46_stroke);

    Paint paint_46_fill = Paint()..style = PaintingStyle.fill;
    paint_46_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_46, paint_46_fill);

    Paint paint_47_fill = Paint()..style = PaintingStyle.fill;
    paint_47_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.8624402, size.height * 0.4515187),
        size.width * 0.03468900, paint_47_fill);

    Path path_48 = Path();
    path_48.moveTo(size.width * 0.3464330, size.height * 0.1779486);
    path_48.cubicTo(
        size.width * 0.3051842,
        size.height * 0.2057208,
        size.width * 0.2454426,
        size.height * 0.2179136,
        size.width * 0.1825184,
        size.height * 0.2184042);
    path_48.cubicTo(
        size.width * 0.1195641,
        size.height * 0.2188949,
        size.width * 0.05343995,
        size.height * 0.2076682,
        size.width * -0.0003903541,
        size.height * 0.1886040);
    path_48.cubicTo(
        size.width * -0.02728373,
        size.height * 0.1790783,
        size.width * -0.03817871,
        size.height * 0.1705093,
        size.width * -0.03857201,
        size.height * 0.1622150);
    path_48.cubicTo(
        size.width * -0.03896699,
        size.height * 0.1538879,
        size.width * -0.02880191,
        size.height * 0.1456180,
        size.width * -0.01241208,
        size.height * 0.1366659);
    path_48.cubicTo(
        size.width * -0.0003543373,
        size.height * 0.1300806,
        size.width * 0.01492285,
        size.height * 0.1232009,
        size.width * 0.03153373,
        size.height * 0.1157221);
    path_48.cubicTo(
        size.width * 0.03747967,
        size.height * 0.1130449,
        size.width * 0.04359617,
        size.height * 0.1102907,
        size.width * 0.04979737,
        size.height * 0.1074456);
    path_48.cubicTo(
        size.width * 0.07328493,
        size.height * 0.09666881,
        size.width * 0.09790646,
        size.height * 0.08461822,
        size.width * 0.1187251,
        size.height * 0.07060164);
    path_48.cubicTo(
        size.width * 0.1391400,
        size.height * 0.05685701,
        size.width * 0.1546301,
        size.height * 0.04502617,
        size.width * 0.1678127,
        size.height * 0.03495783);
    path_48.lineTo(size.width * 0.1685062, size.height * 0.03442815);
    path_48.cubicTo(
        size.width * 0.1818505,
        size.height * 0.02423680,
        size.width * 0.1928172,
        size.height * 0.01589661,
        size.width * 0.2042129,
        size.height * 0.009194544);
    path_48.cubicTo(
        size.width * 0.2155904,
        size.height * 0.002503353,
        size.width * 0.2273610,
        size.height * -0.002533096,
        size.width * 0.2422799,
        size.height * -0.006117056);
    path_48.cubicTo(
        size.width * 0.2572105,
        size.height * -0.009703376,
        size.width * 0.2753708,
        size.height * -0.01185386,
        size.width * 0.2995789,
        size.height * -0.01271542);
    path_48.cubicTo(
        size.width * 0.3376124,
        size.height * -0.01406916,
        size.width * 0.3646364,
        size.height * -0.006382278,
        size.width * 0.3826029,
        size.height * 0.006791285);
    path_48.cubicTo(
        size.width * 0.4006220,
        size.height * 0.02000315,
        size.width * 0.4095598,
        size.height * 0.03876098,
        size.width * 0.4111100,
        size.height * 0.05950666);
    path_48.cubicTo(
        size.width * 0.4142129,
        size.height * 0.1010042,
        size.width * 0.3877464,
        size.height * 0.1501343,
        size.width * 0.3464330,
        size.height * 0.1779486);
    path_48.close();

    Paint paint_48_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_48_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_48, paint_48_stroke);

    Paint paint_48_fill = Paint()..style = PaintingStyle.fill;
    paint_48_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_48, paint_48_fill);

    Path path_49 = Path();
    path_49.moveTo(size.width * 0.3264426, size.height * 0.1683318);
    path_49.cubicTo(
        size.width * 0.2531077,
        size.height * 0.2177068,
        size.width * 0.1197608,
        size.height * 0.2138400,
        size.width * 0.02980766,
        size.height * 0.1819813);
    path_49.cubicTo(
        size.width * 0.007371196,
        size.height * 0.1740339,
        size.width * -0.001425522,
        size.height * 0.1667371,
        size.width * -0.001324641,
        size.height * 0.1595549);
    path_49.cubicTo(
        size.width * -0.001223098,
        size.height * 0.1523259,
        size.width * 0.007877464,
        size.height * 0.1450012,
        size.width * 0.02235419,
        size.height * 0.1369953);
    path_49.cubicTo(
        size.width * 0.03300096,
        size.height * 0.1311086,
        size.width * 0.04641244,
        size.height * 0.1249252,
        size.width * 0.06099761,
        size.height * 0.1181998);
    path_49.cubicTo(
        size.width * 0.06621914,
        size.height * 0.1157930,
        size.width * 0.07159091,
        size.height * 0.1133164,
        size.width * 0.07704019,
        size.height * 0.1107591);
    path_49.cubicTo(
        size.width * 0.09767608,
        size.height * 0.1010748,
        size.width * 0.1193502,
        size.height * 0.09026542,
        size.width * 0.1378794,
        size.height * 0.07779042);
    path_49.cubicTo(
        size.width * 0.1559615,
        size.height * 0.06561636,
        size.width * 0.1697866,
        size.height * 0.05516145,
        size.width * 0.1815584,
        size.height * 0.04625935);
    path_49.lineTo(size.width * 0.1823459, size.height * 0.04566390);
    path_49.cubicTo(
        size.width * 0.1942993,
        size.height * 0.03662523,
        size.width * 0.2041244,
        size.height * 0.02923236,
        size.width * 0.2142230,
        size.height * 0.02325829);
    path_49.cubicTo(
        size.width * 0.2243050,
        size.height * 0.01729393,
        size.width * 0.2346261,
        size.height * 0.01276495,
        size.width * 0.2475383,
        size.height * 0.009453914);
    path_49.cubicTo(
        size.width * 0.2604593,
        size.height * 0.006141157,
        size.width * 0.2760478,
        size.height * 0.004028949,
        size.width * 0.2967105,
        size.height * 0.002949731);
    path_49.cubicTo(
        size.width * 0.3129856,
        size.height * 0.002099696,
        size.width * 0.3267416,
        size.height * 0.003264977,
        size.width * 0.3382344,
        size.height * 0.006024007);
    path_49.cubicTo(
        size.width * 0.3497297,
        size.height * 0.008783528,
        size.width * 0.3590359,
        size.height * 0.01315491,
        size.width * 0.3663565,
        size.height * 0.01877208);
    path_49.cubicTo(
        size.width * 0.3810167,
        size.height * 0.03002255,
        size.width * 0.3876675,
        size.height * 0.04623610,
        size.width * 0.3879019,
        size.height * 0.06429731);
    path_49.cubicTo(
        size.width * 0.3883732,
        size.height * 0.1004197,
        size.width * 0.3631962,
        size.height * 0.1435876,
        size.width * 0.3264426,
        size.height * 0.1683318);
    path_49.close();

    Paint paint_49_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_49_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_49, paint_49_stroke);

    Paint paint_49_fill = Paint()..style = PaintingStyle.fill;
    paint_49_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_49, paint_49_fill);

    Path path_50 = Path();
    path_50.moveTo(size.width * 0.3086866, size.height * 0.1584007);
    path_50.cubicTo(
        size.width * 0.2464569,
        size.height * 0.2002967,
        size.width * 0.1370720,
        size.height * 0.1983236,
        size.width * 0.06446986,
        size.height * 0.1726098);
    path_50.cubicTo(
        size.width * 0.04637512,
        size.height * 0.1662009,
        size.width * 0.03949856,
        size.height * 0.1602255,
        size.width * 0.03986459,
        size.height * 0.1542745);
    path_50.cubicTo(
        size.width * 0.04023397,
        size.height * 0.1482640,
        size.width * 0.04797847,
        size.height * 0.1420771,
        size.width * 0.06020335,
        size.height * 0.1352535);
    path_50.cubicTo(
        size.width * 0.06918995,
        size.height * 0.1302371,
        size.width * 0.08046029,
        size.height * 0.1249498,
        size.width * 0.09272177,
        size.height * 0.1191951);
    path_50.cubicTo(
        size.width * 0.09711268,
        size.height * 0.1171355,
        size.width * 0.1016309,
        size.height * 0.1150151,
        size.width * 0.1062167,
        size.height * 0.1128265);
    path_50.cubicTo(
        size.width * 0.1235758,
        size.height * 0.1045421,
        size.width * 0.1418380,
        size.height * 0.09530584,
        size.width * 0.1575804,
        size.height * 0.08470701);
    path_50.cubicTo(
        size.width * 0.1729385,
        size.height * 0.07436694,
        size.width * 0.1847268,
        size.height * 0.06550315,
        size.width * 0.1947627,
        size.height * 0.05795689);
    path_50.lineTo(size.width * 0.1954344, size.height * 0.05745187);
    path_50.cubicTo(
        size.width * 0.2056263,
        size.height * 0.04978902,
        size.width * 0.2139971,
        size.height * 0.04352488,
        size.width * 0.2225349,
        size.height * 0.03844299);
    path_50.cubicTo(
        size.width * 0.2310577,
        size.height * 0.03337009,
        size.width * 0.2397129,
        size.height * 0.02949650,
        size.width * 0.2504450,
        size.height * 0.02661460);
    path_50.cubicTo(
        size.width * 0.2611794,
        size.height * 0.02373131,
        size.width * 0.2740598,
        size.height * 0.02182208,
        size.width * 0.2910789,
        size.height * 0.02072582);
    path_50.cubicTo(
        size.width * 0.3044641,
        size.height * 0.01986343,
        size.width * 0.3156794,
        size.height * 0.02070526,
        size.width * 0.3249665,
        size.height * 0.02288727);
    path_50.cubicTo(
        size.width * 0.3342560,
        size.height * 0.02506963,
        size.width * 0.3416986,
        size.height * 0.02861215,
        size.width * 0.3474737,
        size.height * 0.03321682);
    path_50.cubicTo(
        size.width * 0.3590502,
        size.height * 0.04244486,
        size.width * 0.3638732,
        size.height * 0.05589790,
        size.width * 0.3633469,
        size.height * 0.07097430);
    path_50.cubicTo(
        size.width * 0.3622967,
        size.height * 0.1011222,
        size.width * 0.3398804,
        size.height * 0.1373984,
        size.width * 0.3086866,
        size.height * 0.1584007);
    path_50.close();

    Paint paint_50_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_50_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_50, paint_50_stroke);

    Paint paint_50_fill = Paint()..style = PaintingStyle.fill;
    paint_50_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_50, paint_50_fill);

    Path path_51 = Path();
    path_51.moveTo(size.width * 0.2909282, size.height * 0.1484685);
    path_51.cubicTo(
        size.width * 0.2397895,
        size.height * 0.1828995,
        size.width * 0.1543598,
        size.height * 0.1827991,
        size.width * 0.09913230,
        size.height * 0.1632395);
    path_51.cubicTo(
        size.width * 0.08539043,
        size.height * 0.1583727,
        size.width * 0.08042823,
        size.height * 0.1537208,
        size.width * 0.08105287,
        size.height * 0.1489988);
    path_51.cubicTo(
        size.width * 0.08168684,
        size.height * 0.1442056,
        size.width * 0.08808086,
        size.height * 0.1391519,
        size.width * 0.09805455,
        size.height * 0.1335105);
    path_51.cubicTo(
        size.width * 0.1053821,
        size.height * 0.1293657,
        size.width * 0.1145122,
        size.height * 0.1249720,
        size.width * 0.1244507,
        size.height * 0.1201893);
    path_51.cubicTo(
        size.width * 0.1280110,
        size.height * 0.1184755,
        size.width * 0.1316749,
        size.height * 0.1167120,
        size.width * 0.1353969,
        size.height * 0.1148924);
    path_51.cubicTo(
        size.width * 0.1494787,
        size.height * 0.1080078,
        size.width * 0.1643280,
        size.height * 0.1003453,
        size.width * 0.1772821,
        size.height * 0.09162371);
    path_51.cubicTo(
        size.width * 0.1899158,
        size.height * 0.08311787,
        size.width * 0.1996667,
        size.height * 0.07584544,
        size.width * 0.2079670,
        size.height * 0.06965502);
    path_51.lineTo(size.width * 0.2085227, size.height * 0.06924054);
    path_51.cubicTo(
        size.width * 0.2169529,
        size.height * 0.06295362,
        size.width * 0.2238703,
        size.height * 0.05781741,
        size.width * 0.2308486,
        size.height * 0.05362722);
    path_51.cubicTo(
        size.width * 0.2378134,
        size.height * 0.04944486,
        size.width * 0.2448062,
        size.height * 0.04622558,
        size.width * 0.2533589,
        size.height * 0.04377231);
    path_51.cubicTo(
        size.width * 0.2619115,
        size.height * 0.04131857,
        size.width * 0.2720885,
        size.height * 0.03961297,
        size.width * 0.2854617,
        size.height * 0.03850023);
    path_51.cubicTo(
        size.width * 0.2959617,
        size.height * 0.03762675,
        size.width * 0.3046340,
        size.height * 0.03814755,
        size.width * 0.3117081,
        size.height * 0.03975187);
    path_51.cubicTo(
        size.width * 0.3187799,
        size.height * 0.04135596,
        size.width * 0.3243565,
        size.height * 0.04406612,
        size.width * 0.3285885,
        size.height * 0.04765631);
    path_51.cubicTo(
        size.width * 0.3370789,
        size.height * 0.05485970,
        size.width * 0.3400813,
        size.height * 0.06555093,
        size.width * 0.3387943,
        size.height * 0.07764451);
    path_51.cubicTo(
        size.width * 0.3362249,
        size.height * 0.1018193,
        size.width * 0.3165694,
        size.height * 0.1312068,
        size.width * 0.2909282,
        size.height * 0.1484685);
    path_51.close();

    Paint paint_51_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_51_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_51, paint_51_stroke);

    Paint paint_51_fill = Paint()..style = PaintingStyle.fill;
    paint_51_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_51, paint_51_fill);

    Path path_52 = Path();
    path_52.moveTo(size.width * 0.06920048, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.06625311,
        size.height * 0.1167401,
        size.width * 0.06345885,
        size.height * 0.1165812,
        size.width * 0.06081770,
        size.height * 0.1162634);
    path_52.cubicTo(
        size.width * 0.05817656,
        size.height * 0.1159270,
        size.width * 0.05597560,
        size.height * 0.1154690,
        size.width * 0.05421483,
        size.height * 0.1148896);
    path_52.lineTo(size.width * 0.05421483, size.height * 0.1099550);
    path_52.lineTo(size.width * 0.06569809, size.height * 0.1099550);
    path_52.lineTo(size.width * 0.06569809, size.height * 0.1102354);
    path_52.cubicTo(
        size.width * 0.06569809,
        size.height * 0.1112447,
        size.width * 0.06669330,
        size.height * 0.1117494,
        size.width * 0.06868373,
        size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.06971722,
        size.height * 0.1117494,
        size.width * 0.07048278,
        size.height * 0.1116186,
        size.width * 0.07098038,
        size.height * 0.1113569);
    path_52.cubicTo(
        size.width * 0.07151627,
        size.height * 0.1110765,
        size.width * 0.07178421,
        size.height * 0.1106466,
        size.width * 0.07178421,
        size.height * 0.1100672);
    path_52.lineTo(size.width * 0.07178421, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.06661675, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.06661675, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.09073158, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.09073158, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.08786077, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.08786077, size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.08786077,
        size.height * 0.1113008,
        size.width * 0.08621483,
        size.height * 0.1133569,
        size.width * 0.08292297,
        size.height * 0.1147214);
    path_52.cubicTo(
        size.width * 0.07963110,
        size.height * 0.1160672,
        size.width * 0.07505694,
        size.height * 0.1167401,
        size.width * 0.06920048,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.1305794, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1305794, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1148474, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1148474, size.height * 0.1141606);
    path_52.cubicTo(
        size.width * 0.1120914,
        size.height * 0.1158803,
        size.width * 0.1086464,
        size.height * 0.1167401,
        size.width * 0.1045124,
        size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.1013354,
        size.height * 0.1167401,
        size.width * 0.09894306,
        size.height * 0.1162541,
        size.width * 0.09733541,
        size.height * 0.1152821);
    path_52.cubicTo(
        size.width * 0.09576603,
        size.height * 0.1143102,
        size.width * 0.09498134,
        size.height * 0.1129737,
        size.width * 0.09498134,
        size.height * 0.1112728);
    path_52.lineTo(size.width * 0.09498134, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.09245502, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.09245502, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.1081871, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.1081871, size.height * 0.1099550);
    path_52.cubicTo(
        size.width * 0.1081871,
        size.height * 0.1105718,
        size.width * 0.1084550,
        size.height * 0.1110298,
        size.width * 0.1089909,
        size.height * 0.1113289);
    path_52.cubicTo(
        size.width * 0.1095651,
        size.height * 0.1116092,
        size.width * 0.1104072,
        size.height * 0.1117494,
        size.width * 0.1115172,
        size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.1126273,
        size.height * 0.1117494,
        size.width * 0.1134502,
        size.height * 0.1116092,
        size.width * 0.1139861,
        size.height * 0.1113289);
    path_52.cubicTo(
        size.width * 0.1145603,
        size.height * 0.1110298,
        size.width * 0.1148474,
        size.height * 0.1105718,
        size.width * 0.1148474,
        size.height * 0.1099550);
    path_52.lineTo(size.width * 0.1148474, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.1117469, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.1117469, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.1280531, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.1280531, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1305794, size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.1656347, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1656347, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1504768, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1504768, size.height * 0.1144410);
    path_52.cubicTo(
        size.width * 0.1496347,
        size.height * 0.1150391,
        size.width * 0.1484481,
        size.height * 0.1155718,
        size.width * 0.1469170,
        size.height * 0.1160391);
    path_52.cubicTo(
        size.width * 0.1454242,
        size.height * 0.1165064,
        size.width * 0.1435868,
        size.height * 0.1167401,
        size.width * 0.1414050,
        size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.1385342,
        size.height * 0.1167401,
        size.width * 0.1362758,
        size.height * 0.1163662,
        size.width * 0.1346299,
        size.height * 0.1156186);
    path_52.cubicTo(
        size.width * 0.1329840,
        size.height * 0.1148709,
        size.width * 0.1321610,
        size.height * 0.1138148,
        size.width * 0.1321610,
        size.height * 0.1124504);
    path_52.cubicTo(
        size.width * 0.1321610,
        size.height * 0.1089176,
        size.width * 0.1383045,
        size.height * 0.1071046,
        size.width * 0.1505916,
        size.height * 0.1070111);
    path_52.cubicTo(
        size.width * 0.1504768,
        size.height * 0.1063756,
        size.width * 0.1499792,
        size.height * 0.1059457,
        size.width * 0.1490988,
        size.height * 0.1057214);
    path_52.cubicTo(
        size.width * 0.1482184,
        size.height * 0.1054784,
        size.width * 0.1467256,
        size.height * 0.1053569,
        size.width * 0.1446203,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.1428978,
        size.height * 0.1053569,
        size.width * 0.1410414,
        size.height * 0.1054504,
        size.width * 0.1390510,
        size.height * 0.1056373);
    path_52.cubicTo(
        size.width * 0.1370988,
        size.height * 0.1058055,
        size.width * 0.1352998,
        size.height * 0.1060391,
        size.width * 0.1336538,
        size.height * 0.1063382);
    path_52.lineTo(size.width * 0.1336538, size.height * 0.1011793);
    path_52.cubicTo(
        size.width * 0.1356825,
        size.height * 0.1009363,
        size.width * 0.1378835,
        size.height * 0.1007401,
        size.width * 0.1402567,
        size.height * 0.1005905);
    path_52.cubicTo(
        size.width * 0.1426299,
        size.height * 0.1004410,
        size.width * 0.1449457,
        size.height * 0.1003662,
        size.width * 0.1472041,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.1529074,
        size.height * 0.1003662,
        size.width * 0.1569840,
        size.height * 0.1008709,
        size.width * 0.1594337,
        size.height * 0.1018803);
    path_52.cubicTo(
        size.width * 0.1618835,
        size.height * 0.1028896,
        size.width * 0.1631084,
        size.height * 0.1044504,
        size.width * 0.1631084,
        size.height * 0.1065625);
    path_52.lineTo(size.width * 0.1631084, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1656347, size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.1504768, size.height * 0.1097868);
    path_52.cubicTo(
        size.width * 0.1487543,
        size.height * 0.1097868,
        size.width * 0.1474146,
        size.height * 0.1098989,
        size.width * 0.1464577,
        size.height * 0.1101232);
    path_52.cubicTo(
        size.width * 0.1455390,
        size.height * 0.1103475,
        size.width * 0.1450797,
        size.height * 0.1107214,
        size.width * 0.1450797,
        size.height * 0.1112447);
    path_52.cubicTo(
        size.width * 0.1450797,
        size.height * 0.1115625,
        size.width * 0.1452711,
        size.height * 0.1118242,
        size.width * 0.1456538,
        size.height * 0.1120298);
    path_52.cubicTo(
        size.width * 0.1460749,
        size.height * 0.1122167,
        size.width * 0.1466490,
        size.height * 0.1123102,
        size.width * 0.1473763,
        size.height * 0.1123102);
    path_52.cubicTo(
        size.width * 0.1483715,
        size.height * 0.1123102,
        size.width * 0.1491371,
        size.height * 0.1121046,
        size.width * 0.1496730,
        size.height * 0.1116933);
    path_52.cubicTo(
        size.width * 0.1502089,
        size.height * 0.1112821,
        size.width * 0.1504768,
        size.height * 0.1107027,
        size.width * 0.1504768,
        size.height * 0.1099550);
    path_52.lineTo(size.width * 0.1504768, size.height * 0.1097868);
    path_52.close();
    path_52.moveTo(size.width * 0.2056098, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.2056098, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1874663, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1874663, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1898778, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1898778, size.height * 0.1071513);
    path_52.cubicTo(
        size.width * 0.1898778,
        size.height * 0.1065345,
        size.width * 0.1896098,
        size.height * 0.1060859,
        size.width * 0.1890739,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.1885380,
        size.height * 0.1055064,
        size.width * 0.1877342,
        size.height * 0.1053569,
        size.width * 0.1866624,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.1843658,
        size.height * 0.1053569,
        size.width * 0.1832175,
        size.height * 0.1059550,
        size.width * 0.1832175,
        size.height * 0.1071513);
    path_52.lineTo(size.width * 0.1832175, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1856289, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1856289, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1674854, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.1674854, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1700117, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.1700117, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.1674854, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.1674854, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.1832175, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.1832175, size.height * 0.1029457);
    path_52.cubicTo(
        size.width * 0.1859734,
        size.height * 0.1012261,
        size.width * 0.1894184,
        size.height * 0.1003662,
        size.width * 0.1935524,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.1967294,
        size.height * 0.1003662,
        size.width * 0.1991026,
        size.height * 0.1008522,
        size.width * 0.2006720,
        size.height * 0.1018242);
    path_52.cubicTo(
        size.width * 0.2022797,
        size.height * 0.1027961,
        size.width * 0.2030835,
        size.height * 0.1041326,
        size.width * 0.2030835,
        size.height * 0.1058335);
    path_52.lineTo(size.width * 0.2030835, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.2056098, size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.2553947, size.height * 0.1050204);
    path_52.cubicTo(
        size.width * 0.2575383,
        size.height * 0.1053943,
        size.width * 0.2593756,
        size.height * 0.1060204,
        size.width * 0.2609067,
        size.height * 0.1068989);
    path_52.cubicTo(
        size.width * 0.2624761,
        size.height * 0.1077588,
        size.width * 0.2632608,
        size.height * 0.1088989,
        size.width * 0.2632608,
        size.height * 0.1103195);
    path_52.cubicTo(
        size.width * 0.2632608,
        size.height * 0.1124317,
        size.width * 0.2615957,
        size.height * 0.1140298,
        size.width * 0.2582656,
        size.height * 0.1151139);
    path_52.cubicTo(
        size.width * 0.2549737,
        size.height * 0.1161980,
        size.width * 0.2501316,
        size.height * 0.1167401,
        size.width * 0.2437392,
        size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.2373474,
        size.height * 0.1167401,
        size.width * 0.2324861,
        size.height * 0.1162167,
        size.width * 0.2291560,
        size.height * 0.1151700);
    path_52.cubicTo(
        size.width * 0.2258641,
        size.height * 0.1141046,
        size.width * 0.2242182,
        size.height * 0.1125438,
        size.width * 0.2242182,
        size.height * 0.1104877);
    path_52.cubicTo(
        size.width * 0.2242182,
        size.height * 0.1090111,
        size.width * 0.2250411,
        size.height * 0.1078242,
        size.width * 0.2266871,
        size.height * 0.1069270);
    path_52.cubicTo(
        size.width * 0.2283713,
        size.height * 0.1060298,
        size.width * 0.2303617,
        size.height * 0.1053943,
        size.width * 0.2326584,
        size.height * 0.1050204);
    path_52.cubicTo(
        size.width * 0.2306297,
        size.height * 0.1046653,
        size.width * 0.2289263,
        size.height * 0.1040952,
        size.width * 0.2275483,
        size.height * 0.1033102);
    path_52.cubicTo(
        size.width * 0.2261703,
        size.height * 0.1025064,
        size.width * 0.2254813,
        size.height * 0.1014784,
        size.width * 0.2254813,
        size.height * 0.1002261);
    path_52.cubicTo(
        size.width * 0.2254813,
        size.height * 0.09822605,
        size.width * 0.2270124,
        size.height * 0.09671203,
        size.width * 0.2300746,
        size.height * 0.09568400);
    path_52.cubicTo(
        size.width * 0.2331751,
        size.height * 0.09465596,
        size.width * 0.2377301,
        size.height * 0.09414194,
        size.width * 0.2437392,
        size.height * 0.09414194);
    path_52.cubicTo(
        size.width * 0.2497105,
        size.height * 0.09414194,
        size.width * 0.2542273,
        size.height * 0.09465596,
        size.width * 0.2572895,
        size.height * 0.09568400);
    path_52.cubicTo(
        size.width * 0.2603517,
        size.height * 0.09671203,
        size.width * 0.2618828,
        size.height * 0.09822605,
        size.width * 0.2618828,
        size.height * 0.1002261);
    path_52.cubicTo(
        size.width * 0.2618828,
        size.height * 0.1014971,
        size.width * 0.2612703,
        size.height * 0.1025251,
        size.width * 0.2600455,
        size.height * 0.1033102);
    path_52.cubicTo(
        size.width * 0.2588206,
        size.height * 0.1040952,
        size.width * 0.2572703,
        size.height * 0.1046653,
        size.width * 0.2553947,
        size.height * 0.1050204);
    path_52.close();
    path_52.moveTo(size.width * 0.2437392, size.height * 0.09913259);
    path_52.cubicTo(
        size.width * 0.2411364,
        size.height * 0.09913259,
        size.width * 0.2398349,
        size.height * 0.09978680,
        size.width * 0.2398349,
        size.height * 0.1010952);
    path_52.cubicTo(
        size.width * 0.2398349,
        size.height * 0.1023289,
        size.width * 0.2411364,
        size.height * 0.1029457,
        size.width * 0.2437392,
        size.height * 0.1029457);
    path_52.cubicTo(
        size.width * 0.2463421,
        size.height * 0.1029457,
        size.width * 0.2476435,
        size.height * 0.1023289,
        size.width * 0.2476435,
        size.height * 0.1010952);
    path_52.cubicTo(
        size.width * 0.2476435,
        size.height * 0.09978680,
        size.width * 0.2463421,
        size.height * 0.09913259,
        size.width * 0.2437392,
        size.height * 0.09913259);
    path_52.close();
    path_52.moveTo(size.width * 0.2437392, size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.2467249,
        size.height * 0.1117494,
        size.width * 0.2482177,
        size.height * 0.1110018,
        size.width * 0.2482177,
        size.height * 0.1095064);
    path_52.cubicTo(
        size.width * 0.2482177,
        size.height * 0.1087588,
        size.width * 0.2478349,
        size.height * 0.1081887,
        size.width * 0.2470694,
        size.height * 0.1077961);
    path_52.cubicTo(
        size.width * 0.2463038,
        size.height * 0.1074036,
        size.width * 0.2451938,
        size.height * 0.1072074,
        size.width * 0.2437392,
        size.height * 0.1072074);
    path_52.cubicTo(
        size.width * 0.2422847,
        size.height * 0.1072074,
        size.width * 0.2411746,
        size.height * 0.1074036,
        size.width * 0.2404091,
        size.height * 0.1077961);
    path_52.cubicTo(
        size.width * 0.2396435,
        size.height * 0.1081887,
        size.width * 0.2392608,
        size.height * 0.1087588,
        size.width * 0.2392608,
        size.height * 0.1095064);
    path_52.cubicTo(
        size.width * 0.2392608,
        size.height * 0.1110018,
        size.width * 0.2407536,
        size.height * 0.1117494,
        size.width * 0.2437392,
        size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.2661435, size.height * 0.1072354);
    path_52.lineTo(size.width * 0.2661435, size.height * 0.1026373);
    path_52.lineTo(size.width * 0.2751005, size.height * 0.1026373);
    path_52.lineTo(size.width * 0.2751005, size.height * 0.1072354);
    path_52.lineTo(size.width * 0.2661435, size.height * 0.1072354);
    path_52.close();
    path_52.moveTo(size.width * 0.2661435, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.2661435, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.2751005, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.2751005, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.2661435, size.height * 0.1163475);
    path_52.close();
    path_52.moveTo(size.width * 0.3057679, size.height * 0.1052167);
    path_52.cubicTo(
        size.width * 0.3069545,
        size.height * 0.1053662,
        size.width * 0.3080837,
        size.height * 0.1056746,
        size.width * 0.3091555,
        size.height * 0.1061419);
    path_52.cubicTo(
        size.width * 0.3102656,
        size.height * 0.1065905,
        size.width * 0.3111651,
        size.height * 0.1071606,
        size.width * 0.3118541,
        size.height * 0.1078522);
    path_52.cubicTo(
        size.width * 0.3125813,
        size.height * 0.1085438,
        size.width * 0.3129450,
        size.height * 0.1093102,
        size.width * 0.3129450,
        size.height * 0.1101513);
    path_52.cubicTo(
        size.width * 0.3129450,
        size.height * 0.1122074,
        size.width * 0.3114330,
        size.height * 0.1138242,
        size.width * 0.3084091,
        size.height * 0.1150018);
    path_52.cubicTo(
        size.width * 0.3054234,
        size.height * 0.1161606,
        size.width * 0.3009833,
        size.height * 0.1167401,
        size.width * 0.2950885,
        size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.2922943,
        size.height * 0.1167401,
        size.width * 0.2895000,
        size.height * 0.1165905,
        size.width * 0.2867057,
        size.height * 0.1162915);
    path_52.cubicTo(
        size.width * 0.2839115,
        size.height * 0.1159737,
        size.width * 0.2814234,
        size.height * 0.1155905,
        size.width * 0.2792416,
        size.height * 0.1151419);
    path_52.lineTo(size.width * 0.2792416, size.height * 0.1091700);
    path_52.cubicTo(
        size.width * 0.2816148,
        size.height * 0.1096746,
        size.width * 0.2840646,
        size.height * 0.1100859,
        size.width * 0.2865909,
        size.height * 0.1104036);
    path_52.cubicTo(
        size.width * 0.2891555,
        size.height * 0.1107214,
        size.width * 0.2915861,
        size.height * 0.1108803,
        size.width * 0.2938828,
        size.height * 0.1108803);
    path_52.cubicTo(
        size.width * 0.2954904,
        size.height * 0.1108803,
        size.width * 0.2966579,
        size.height * 0.1107588,
        size.width * 0.2973852,
        size.height * 0.1105158);
    path_52.cubicTo(
        size.width * 0.2981507,
        size.height * 0.1102728,
        size.width * 0.2985335,
        size.height * 0.1098709,
        size.width * 0.2985335,
        size.height * 0.1093102);
    path_52.cubicTo(
        size.width * 0.2985335,
        size.height * 0.1082261,
        size.width * 0.2971938,
        size.height * 0.1076840,
        size.width * 0.2945144,
        size.height * 0.1076840);
    path_52.lineTo(size.width * 0.2903804, size.height * 0.1076840);
    path_52.lineTo(size.width * 0.2903804, size.height * 0.1030859);
    path_52.lineTo(size.width * 0.2935957, size.height * 0.1030859);
    path_52.cubicTo(
        size.width * 0.2961220,
        size.height * 0.1030859,
        size.width * 0.2973852,
        size.height * 0.1025625,
        size.width * 0.2973852,
        size.height * 0.1015158);
    path_52.cubicTo(
        size.width * 0.2973852,
        size.height * 0.1005064,
        size.width * 0.2961220,
        size.height * 0.1000018,
        size.width * 0.2935957,
        size.height * 0.1000018);
    path_52.cubicTo(
        size.width * 0.2917584,
        size.height * 0.1000018,
        size.width * 0.2898445,
        size.height * 0.1002167,
        size.width * 0.2878541,
        size.height * 0.1006466);
    path_52.cubicTo(
        size.width * 0.2858636,
        size.height * 0.1010578,
        size.width * 0.2839306,
        size.height * 0.1015999,
        size.width * 0.2820550,
        size.height * 0.1022728);
    path_52.lineTo(size.width * 0.2786675, size.height * 0.09630082);
    path_52.cubicTo(
        size.width * 0.2810024,
        size.height * 0.09570269,
        size.width * 0.2836627,
        size.height * 0.09519801,
        size.width * 0.2866483,
        size.height * 0.09478680);
    path_52.cubicTo(
        size.width * 0.2896340,
        size.height * 0.09435689,
        size.width * 0.2926388,
        size.height * 0.09414194,
        size.width * 0.2956627,
        size.height * 0.09414194);
    path_52.cubicTo(
        size.width * 0.3009450,
        size.height * 0.09414194,
        size.width * 0.3050024,
        size.height * 0.09468400,
        size.width * 0.3078349,
        size.height * 0.09576811);
    path_52.cubicTo(
        size.width * 0.3106675,
        size.height * 0.09685222,
        size.width * 0.3120837,
        size.height * 0.09838493,
        size.width * 0.3120837,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.3120837,
        size.height * 0.1015999,
        size.width * 0.3114904,
        size.height * 0.1026186,
        size.width * 0.3103038,
        size.height * 0.1034223);
    path_52.cubicTo(
        size.width * 0.3091172,
        size.height * 0.1042074,
        size.width * 0.3076053,
        size.height * 0.1048055,
        size.width * 0.3057679,
        size.height * 0.1052167);
    path_52.close();
    path_52.moveTo(size.width * 0.3143254, size.height * 0.1139363);
    path_52.cubicTo(
        size.width * 0.3143254,
        size.height * 0.1123289,
        size.width * 0.3148038,
        size.height * 0.1109083,
        size.width * 0.3157608,
        size.height * 0.1096746);
    path_52.cubicTo(
        size.width * 0.3167560,
        size.height * 0.1084410,
        size.width * 0.3183636,
        size.height * 0.1072821,
        size.width * 0.3205837,
        size.height * 0.1061980);
    path_52.cubicTo(
        size.width * 0.3228038,
        size.height * 0.1050952,
        size.width * 0.3258660,
        size.height * 0.1039550,
        size.width * 0.3297703,
        size.height * 0.1027775);
    path_52.cubicTo(
        size.width * 0.3309187,
        size.height * 0.1024223,
        size.width * 0.3317225,
        size.height * 0.1021232,
        size.width * 0.3321818,
        size.height * 0.1018803);
    path_52.cubicTo(
        size.width * 0.3326794,
        size.height * 0.1016186,
        size.width * 0.3329282,
        size.height * 0.1013102,
        size.width * 0.3329282,
        size.height * 0.1009550);
    path_52.cubicTo(
        size.width * 0.3329282,
        size.height * 0.1001887,
        size.width * 0.3317990,
        size.height * 0.09980549,
        size.width * 0.3295407,
        size.height * 0.09980549);
    path_52.cubicTo(
        size.width * 0.3278565,
        size.height * 0.09980549,
        size.width * 0.3259234,
        size.height * 0.1000204,
        size.width * 0.3237416,
        size.height * 0.1004504);
    path_52.cubicTo(
        size.width * 0.3215598,
        size.height * 0.1008803,
        size.width * 0.3195885,
        size.height * 0.1014223,
        size.width * 0.3178278,
        size.height * 0.1020765);
    path_52.lineTo(size.width * 0.3144402, size.height * 0.09610456);
    path_52.cubicTo(
        size.width * 0.3168900,
        size.height * 0.09550643,
        size.width * 0.3197033,
        size.height * 0.09500175,
        size.width * 0.3228804,
        size.height * 0.09459054);
    path_52.cubicTo(
        size.width * 0.3260574,
        size.height * 0.09416063,
        size.width * 0.3292536,
        size.height * 0.09394568,
        size.width * 0.3324689,
        size.height * 0.09394568);
    path_52.cubicTo(
        size.width * 0.3377512,
        size.height * 0.09394568,
        size.width * 0.3418469,
        size.height * 0.09451577,
        size.width * 0.3447560,
        size.height * 0.09565596);
    path_52.cubicTo(
        size.width * 0.3476651,
        size.height * 0.09679614,
        size.width * 0.3491196,
        size.height * 0.09841297,
        size.width * 0.3491196,
        size.height * 0.1005064);
    path_52.cubicTo(
        size.width * 0.3491196,
        size.height * 0.1016279,
        size.width * 0.3486029,
        size.height * 0.1026186,
        size.width * 0.3475694,
        size.height * 0.1034784);
    path_52.cubicTo(
        size.width * 0.3465742,
        size.height * 0.1043195,
        size.width * 0.3453493,
        size.height * 0.1050298,
        size.width * 0.3438947,
        size.height * 0.1056092);
    path_52.cubicTo(
        size.width * 0.3424785,
        size.height * 0.1061887,
        size.width * 0.3406220,
        size.height * 0.1068522,
        size.width * 0.3383254,
        size.height * 0.1075999);
    path_52.cubicTo(
        size.width * 0.3357608,
        size.height * 0.1084223,
        size.width * 0.3338660,
        size.height * 0.1091326,
        size.width * 0.3326411,
        size.height * 0.1097307);
    path_52.cubicTo(
        size.width * 0.3314545,
        size.height * 0.1103102,
        size.width * 0.3308612,
        size.height * 0.1109831,
        size.width * 0.3308612,
        size.height * 0.1117494);
    path_52.lineTo(size.width * 0.3378086, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.3378086, size.height * 0.1101513);
    path_52.lineTo(size.width * 0.3495789, size.height * 0.1101513);
    path_52.lineTo(size.width * 0.3495789, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.3143254, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.3143254, size.height * 0.1139363);
    path_52.close();
    path_52.moveTo(size.width * 0.3532201, size.height * 0.1072354);
    path_52.lineTo(size.width * 0.3532201, size.height * 0.1026373);
    path_52.lineTo(size.width * 0.3621770, size.height * 0.1026373);
    path_52.lineTo(size.width * 0.3621770, size.height * 0.1072354);
    path_52.lineTo(size.width * 0.3532201, size.height * 0.1072354);
    path_52.close();
    path_52.moveTo(size.width * 0.3532201, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.3532201, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.3621770, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.3621770, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.3532201, size.height * 0.1163475);
    path_52.close();
    path_52.moveTo(size.width * 0.3938110, size.height * 0.1009831);
    path_52.lineTo(size.width * 0.3929498, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.4011603, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.4002990, size.height * 0.1009831);
    path_52.lineTo(size.width * 0.3938110, size.height * 0.1009831);
    path_52.close();
    path_52.moveTo(size.width * 0.3844522, size.height * 0.1009831);
    path_52.lineTo(size.width * 0.3835909, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.3918014, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.3909402, size.height * 0.1009831);
    path_52.lineTo(size.width * 0.3844522, size.height * 0.1009831);
    path_52.close();
    path_52.moveTo(size.width * 0.4288612, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.4464880, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.4464880, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4441914, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4331100, size.height * 0.1088335);
    path_52.lineTo(size.width * 0.4331100, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.4359809, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.4359809, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.4141627, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.4141627, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.4170335, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.4170335, size.height * 0.1088335);
    path_52.lineTo(size.width * 0.4056077, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4033110, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4033110, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.4255311, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.4255311, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4235215, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4269091, size.height * 0.1034784);
    path_52.lineTo(size.width * 0.4274833, size.height * 0.1034784);
    path_52.lineTo(size.width * 0.4308708, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4288612, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.4288612, size.height * 0.09453446);
    path_52.close();
    path_52.moveTo(size.width * 0.4826124, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.4771388,
        size.height * 0.1167401,
        size.width * 0.4728708,
        size.height * 0.1160485,
        size.width * 0.4698086,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.4667464,
        size.height * 0.1132634,
        size.width * 0.4652153,
        size.height * 0.1112261,
        size.width * 0.4652153,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.4652153,
        size.height * 0.1058803,
        size.width * 0.4667464,
        size.height * 0.1038522,
        size.width * 0.4698086,
        size.height * 0.1024690);
    path_52.cubicTo(
        size.width * 0.4728708,
        size.height * 0.1010672,
        size.width * 0.4771196,
        size.height * 0.1003662,
        size.width * 0.4825550,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.4851962,
        size.height * 0.1003662,
        size.width * 0.4877225,
        size.height * 0.1005438,
        size.width * 0.4901340,
        size.height * 0.1008989);
    path_52.cubicTo(
        size.width * 0.4925455,
        size.height * 0.1012541,
        size.width * 0.4944211,
        size.height * 0.1016560,
        size.width * 0.4957608,
        size.height * 0.1021046);
    path_52.lineTo(size.width * 0.4957608, size.height * 0.1076560);
    path_52.lineTo(size.width * 0.4858852, size.height * 0.1076560);
    path_52.lineTo(size.width * 0.4858852, size.height * 0.1071513);
    path_52.cubicTo(
        size.width * 0.4858852,
        size.height * 0.1065345,
        size.width * 0.4856172,
        size.height * 0.1060859,
        size.width * 0.4850813,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.4845455,
        size.height * 0.1055064,
        size.width * 0.4837033,
        size.height * 0.1053569,
        size.width * 0.4825550,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.4803349,
        size.height * 0.1053569,
        size.width * 0.4792249,
        size.height * 0.1059550,
        size.width * 0.4792249,
        size.height * 0.1071513);
    path_52.lineTo(size.width * 0.4792249, size.height * 0.1095625);
    path_52.cubicTo(
        size.width * 0.4792249,
        size.height * 0.1110204,
        size.width * 0.4809282,
        size.height * 0.1117494,
        size.width * 0.4843349,
        size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.4875120,
        size.height * 0.1117494,
        size.width * 0.4912057,
        size.height * 0.1115812,
        size.width * 0.4954163,
        size.height * 0.1112447);
    path_52.lineTo(size.width * 0.4954163, size.height * 0.1156466);
    path_52.cubicTo(
        size.width * 0.4941148,
        size.height * 0.1159270,
        size.width * 0.4922775,
        size.height * 0.1161793,
        size.width * 0.4899043,
        size.height * 0.1164036);
    path_52.cubicTo(
        size.width * 0.4875694,
        size.height * 0.1166279,
        size.width * 0.4851388,
        size.height * 0.1167401,
        size.width * 0.4826124,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.5147943, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.5093589,
        size.height * 0.1167401,
        size.width * 0.5051100,
        size.height * 0.1160485,
        size.width * 0.5020478,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.4989856,
        size.height * 0.1132634,
        size.width * 0.4974545,
        size.height * 0.1112261,
        size.width * 0.4974545,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.4974545,
        size.height * 0.1058803,
        size.width * 0.4989856,
        size.height * 0.1038522,
        size.width * 0.5020478,
        size.height * 0.1024690);
    path_52.cubicTo(
        size.width * 0.5051100,
        size.height * 0.1010672,
        size.width * 0.5093589,
        size.height * 0.1003662,
        size.width * 0.5147943,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.5203062,
        size.height * 0.1003662,
        size.width * 0.5245742,
        size.height * 0.1010765,
        size.width * 0.5275981,
        size.height * 0.1024971);
    path_52.cubicTo(
        size.width * 0.5306220,
        size.height * 0.1038989,
        size.width * 0.5321340,
        size.height * 0.1059176,
        size.width * 0.5321340,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.5321340,
        size.height * 0.1112261,
        size.width * 0.5306029,
        size.height * 0.1132634,
        size.width * 0.5275407,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.5244785,
        size.height * 0.1160485,
        size.width * 0.5202297,
        size.height * 0.1167401,
        size.width * 0.5147943,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.5147943, size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.5159043,
        size.height * 0.1117494,
        size.width * 0.5167273,
        size.height * 0.1116092,
        size.width * 0.5172632,
        size.height * 0.1113289);
    path_52.cubicTo(
        size.width * 0.5178373,
        size.height * 0.1110298,
        size.width * 0.5181244,
        size.height * 0.1105718,
        size.width * 0.5181244,
        size.height * 0.1099550);
    path_52.lineTo(size.width * 0.5181244, size.height * 0.1071513);
    path_52.cubicTo(
        size.width * 0.5181244,
        size.height * 0.1065345,
        size.width * 0.5178373,
        size.height * 0.1060859,
        size.width * 0.5172632,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.5167273,
        size.height * 0.1055064,
        size.width * 0.5159043,
        size.height * 0.1053569,
        size.width * 0.5147943,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.5136842,
        size.height * 0.1053569,
        size.width * 0.5128421,
        size.height * 0.1055064,
        size.width * 0.5122679,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.5117321,
        size.height * 0.1060859,
        size.width * 0.5114641,
        size.height * 0.1065345,
        size.width * 0.5114641,
        size.height * 0.1071513);
    path_52.lineTo(size.width * 0.5114641, size.height * 0.1099550);
    path_52.cubicTo(
        size.width * 0.5114641,
        size.height * 0.1105718,
        size.width * 0.5117321,
        size.height * 0.1110298,
        size.width * 0.5122679,
        size.height * 0.1113289);
    path_52.cubicTo(
        size.width * 0.5128421,
        size.height * 0.1116092,
        size.width * 0.5136842,
        size.height * 0.1117494,
        size.width * 0.5147943,
        size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.5720861, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5720861, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.5539426, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.5539426, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5563541, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5563541, size.height * 0.1071513);
    path_52.cubicTo(
        size.width * 0.5563541,
        size.height * 0.1065345,
        size.width * 0.5560861,
        size.height * 0.1060859,
        size.width * 0.5555502,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.5550144,
        size.height * 0.1055064,
        size.width * 0.5542105,
        size.height * 0.1053569,
        size.width * 0.5531388,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.5508421,
        size.height * 0.1053569,
        size.width * 0.5496938,
        size.height * 0.1059550,
        size.width * 0.5496938,
        size.height * 0.1071513);
    path_52.lineTo(size.width * 0.5496938, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5521053, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5521053, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.5339617, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.5339617, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5364880, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5364880, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.5339617, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.5339617, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.5496938, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.5496938, size.height * 0.1029457);
    path_52.cubicTo(
        size.width * 0.5524498,
        size.height * 0.1012261,
        size.width * 0.5558947,
        size.height * 0.1003662,
        size.width * 0.5600287,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.5632057,
        size.height * 0.1003662,
        size.width * 0.5655789,
        size.height * 0.1008522,
        size.width * 0.5671483,
        size.height * 0.1018242);
    path_52.cubicTo(
        size.width * 0.5687560,
        size.height * 0.1027961,
        size.width * 0.5695598,
        size.height * 0.1041326,
        size.width * 0.5695598,
        size.height * 0.1058335);
    path_52.lineTo(size.width * 0.5695598, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.5720861, size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.5910502, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.5856148,
        size.height * 0.1167401,
        size.width * 0.5813660,
        size.height * 0.1160485,
        size.width * 0.5783038,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.5752416,
        size.height * 0.1132634,
        size.width * 0.5737105,
        size.height * 0.1112261,
        size.width * 0.5737105,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.5737105,
        size.height * 0.1058803,
        size.width * 0.5752416,
        size.height * 0.1038522,
        size.width * 0.5783038,
        size.height * 0.1024690);
    path_52.cubicTo(
        size.width * 0.5813660,
        size.height * 0.1010672,
        size.width * 0.5856148,
        size.height * 0.1003662,
        size.width * 0.5910502,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.5965622,
        size.height * 0.1003662,
        size.width * 0.6008301,
        size.height * 0.1010765,
        size.width * 0.6038541,
        size.height * 0.1024971);
    path_52.cubicTo(
        size.width * 0.6068780,
        size.height * 0.1038989,
        size.width * 0.6083900,
        size.height * 0.1059176,
        size.width * 0.6083900,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.6083900,
        size.height * 0.1112261,
        size.width * 0.6068589,
        size.height * 0.1132634,
        size.width * 0.6037967,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.6007344,
        size.height * 0.1160485,
        size.width * 0.5964856,
        size.height * 0.1167401,
        size.width * 0.5910502,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.5910502, size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.5921603,
        size.height * 0.1117494,
        size.width * 0.5929833,
        size.height * 0.1116092,
        size.width * 0.5935191,
        size.height * 0.1113289);
    path_52.cubicTo(
        size.width * 0.5940933,
        size.height * 0.1110298,
        size.width * 0.5943804,
        size.height * 0.1105718,
        size.width * 0.5943804,
        size.height * 0.1099550);
    path_52.lineTo(size.width * 0.5943804, size.height * 0.1071513);
    path_52.cubicTo(
        size.width * 0.5943804,
        size.height * 0.1065345,
        size.width * 0.5940933,
        size.height * 0.1060859,
        size.width * 0.5935191,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.5929833,
        size.height * 0.1055064,
        size.width * 0.5921603,
        size.height * 0.1053569,
        size.width * 0.5910502,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.5899402,
        size.height * 0.1053569,
        size.width * 0.5890981,
        size.height * 0.1055064,
        size.width * 0.5885239,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.5879880,
        size.height * 0.1060859,
        size.width * 0.5877201,
        size.height * 0.1065345,
        size.width * 0.5877201,
        size.height * 0.1071513);
    path_52.lineTo(size.width * 0.5877201, size.height * 0.1099550);
    path_52.cubicTo(
        size.width * 0.5877201,
        size.height * 0.1105718,
        size.width * 0.5879880,
        size.height * 0.1110298,
        size.width * 0.5885239,
        size.height * 0.1113289);
    path_52.cubicTo(
        size.width * 0.5890981,
        size.height * 0.1116092,
        size.width * 0.5899402,
        size.height * 0.1117494,
        size.width * 0.5910502,
        size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.6273852, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.6219115,
        size.height * 0.1167401,
        size.width * 0.6176435,
        size.height * 0.1160485,
        size.width * 0.6145813,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.6115191,
        size.height * 0.1132634,
        size.width * 0.6099880,
        size.height * 0.1112261,
        size.width * 0.6099880,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.6099880,
        size.height * 0.1058803,
        size.width * 0.6115191,
        size.height * 0.1038522,
        size.width * 0.6145813,
        size.height * 0.1024690);
    path_52.cubicTo(
        size.width * 0.6176435,
        size.height * 0.1010672,
        size.width * 0.6218923,
        size.height * 0.1003662,
        size.width * 0.6273278,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.6299689,
        size.height * 0.1003662,
        size.width * 0.6324952,
        size.height * 0.1005438,
        size.width * 0.6349067,
        size.height * 0.1008989);
    path_52.cubicTo(
        size.width * 0.6373182,
        size.height * 0.1012541,
        size.width * 0.6391938,
        size.height * 0.1016560,
        size.width * 0.6405335,
        size.height * 0.1021046);
    path_52.lineTo(size.width * 0.6405335, size.height * 0.1076560);
    path_52.lineTo(size.width * 0.6306579, size.height * 0.1076560);
    path_52.lineTo(size.width * 0.6306579, size.height * 0.1071513);
    path_52.cubicTo(
        size.width * 0.6306579,
        size.height * 0.1065345,
        size.width * 0.6303900,
        size.height * 0.1060859,
        size.width * 0.6298541,
        size.height * 0.1058055);
    path_52.cubicTo(
        size.width * 0.6293182,
        size.height * 0.1055064,
        size.width * 0.6284761,
        size.height * 0.1053569,
        size.width * 0.6273278,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.6251077,
        size.height * 0.1053569,
        size.width * 0.6239976,
        size.height * 0.1059550,
        size.width * 0.6239976,
        size.height * 0.1071513);
    path_52.lineTo(size.width * 0.6239976, size.height * 0.1095625);
    path_52.cubicTo(
        size.width * 0.6239976,
        size.height * 0.1110204,
        size.width * 0.6257010,
        size.height * 0.1117494,
        size.width * 0.6291077,
        size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.6322847,
        size.height * 0.1117494,
        size.width * 0.6359785,
        size.height * 0.1115812,
        size.width * 0.6401890,
        size.height * 0.1112447);
    path_52.lineTo(size.width * 0.6401890, size.height * 0.1156466);
    path_52.cubicTo(
        size.width * 0.6388876,
        size.height * 0.1159270,
        size.width * 0.6370502,
        size.height * 0.1161793,
        size.width * 0.6346770,
        size.height * 0.1164036);
    path_52.cubicTo(
        size.width * 0.6323421,
        size.height * 0.1166279,
        size.width * 0.6299115,
        size.height * 0.1167401,
        size.width * 0.6273852,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.6595694, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.6541340,
        size.height * 0.1167401,
        size.width * 0.6498852,
        size.height * 0.1160485,
        size.width * 0.6468230,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.6437608,
        size.height * 0.1132634,
        size.width * 0.6422297,
        size.height * 0.1112261,
        size.width * 0.6422297,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.6422297,
        size.height * 0.1058803,
        size.width * 0.6437608,
        size.height * 0.1038522,
        size.width * 0.6468230,
        size.height * 0.1024690);
    path_52.cubicTo(
        size.width * 0.6498852,
        size.height * 0.1010672,
        size.width * 0.6541340,
        size.height * 0.1003662,
        size.width * 0.6595694,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.6649665,
        size.height * 0.1003662,
        size.width * 0.6688517,
        size.height * 0.1010578,
        size.width * 0.6712249,
        size.height * 0.1024410);
    path_52.cubicTo(
        size.width * 0.6736364,
        size.height * 0.1038055,
        size.width * 0.6748421,
        size.height * 0.1055064,
        size.width * 0.6748421,
        size.height * 0.1075438);
    path_52.lineTo(size.width * 0.6748421, size.height * 0.1095625);
    path_52.lineTo(size.width * 0.6562392, size.height * 0.1095625);
    path_52.lineTo(size.width * 0.6562392, size.height * 0.1097307);
    path_52.cubicTo(
        size.width * 0.6562392,
        size.height * 0.1104223,
        size.width * 0.6566603,
        size.height * 0.1109363,
        size.width * 0.6575024,
        size.height * 0.1112728);
    path_52.cubicTo(
        size.width * 0.6583445,
        size.height * 0.1115905,
        size.width * 0.6597416,
        size.height * 0.1117494,
        size.width * 0.6616938,
        size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.6640287,
        size.height * 0.1117494,
        size.width * 0.6662488,
        size.height * 0.1116653,
        size.width * 0.6683541,
        size.height * 0.1114971);
    path_52.cubicTo(
        size.width * 0.6704593,
        size.height * 0.1113289,
        size.width * 0.6722967,
        size.height * 0.1111139,
        size.width * 0.6738660,
        size.height * 0.1108522);
    path_52.lineTo(size.width * 0.6738660, size.height * 0.1153382);
    path_52.cubicTo(
        size.width * 0.6725263,
        size.height * 0.1156933,
        size.width * 0.6705550,
        size.height * 0.1160204,
        size.width * 0.6679522,
        size.height * 0.1163195);
    path_52.cubicTo(
        size.width * 0.6653876,
        size.height * 0.1165999,
        size.width * 0.6625933,
        size.height * 0.1167401,
        size.width * 0.6595694,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.6628995, size.height * 0.1064784);
    path_52.lineTo(size.width * 0.6628995, size.height * 0.1061419);
    path_52.cubicTo(
        size.width * 0.6628995,
        size.height * 0.1055064,
        size.width * 0.6626124,
        size.height * 0.1050485,
        size.width * 0.6620383,
        size.height * 0.1047681);
    path_52.cubicTo(
        size.width * 0.6615024,
        size.height * 0.1044877,
        size.width * 0.6606794,
        size.height * 0.1043475,
        size.width * 0.6595694,
        size.height * 0.1043475);
    path_52.cubicTo(
        size.width * 0.6584593,
        size.height * 0.1043475,
        size.width * 0.6576172,
        size.height * 0.1044971,
        size.width * 0.6570431,
        size.height * 0.1047961);
    path_52.cubicTo(
        size.width * 0.6565072,
        size.height * 0.1050765,
        size.width * 0.6562392,
        size.height * 0.1055251,
        size.width * 0.6562392,
        size.height * 0.1061419);
    path_52.lineTo(size.width * 0.6562392, size.height * 0.1064784);
    path_52.lineTo(size.width * 0.6628995, size.height * 0.1064784);
    path_52.close();
    path_52.moveTo(size.width * 0.7010670, size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.7018325,
        size.height * 0.1003662,
        size.width * 0.7025598,
        size.height * 0.1004036,
        size.width * 0.7032488,
        size.height * 0.1004784);
    path_52.cubicTo(
        size.width * 0.7039378,
        size.height * 0.1005532,
        size.width * 0.7045120,
        size.height * 0.1006466,
        size.width * 0.7049713,
        size.height * 0.1007588);
    path_52.lineTo(size.width * 0.7049713, size.height * 0.1061139);
    path_52.cubicTo(
        size.width * 0.7034019,
        size.height * 0.1057961,
        size.width * 0.7017177,
        size.height * 0.1056373,
        size.width * 0.6999187,
        size.height * 0.1056373);
    path_52.cubicTo(
        size.width * 0.6975072,
        size.height * 0.1056373,
        size.width * 0.6956507,
        size.height * 0.1059457,
        size.width * 0.6943493,
        size.height * 0.1065625);
    path_52.cubicTo(
        size.width * 0.6930478,
        size.height * 0.1071793,
        size.width * 0.6923971,
        size.height * 0.1080952,
        size.width * 0.6923971,
        size.height * 0.1093102);
    path_52.lineTo(size.width * 0.6923971, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.6975646, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.6975646, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.6766651, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.6766651, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.6791914, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.6791914, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.6766651, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.6766651, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.6923971, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.6923971, size.height * 0.1028055);
    path_52.cubicTo(
        size.width * 0.6934689,
        size.height * 0.1020204,
        size.width * 0.6946938,
        size.height * 0.1014223,
        size.width * 0.6960718,
        size.height * 0.1010111);
    path_52.cubicTo(
        size.width * 0.6974498,
        size.height * 0.1005812,
        size.width * 0.6991148,
        size.height * 0.1003662,
        size.width * 0.7010670,
        size.height * 0.1003662);
    path_52.close();
    path_52.moveTo(size.width * 0.7239378, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.7185024,
        size.height * 0.1167401,
        size.width * 0.7142536,
        size.height * 0.1160485,
        size.width * 0.7111914,
        size.height * 0.1146653);
    path_52.cubicTo(
        size.width * 0.7081292,
        size.height * 0.1132634,
        size.width * 0.7065981,
        size.height * 0.1112261,
        size.width * 0.7065981,
        size.height * 0.1085532);
    path_52.cubicTo(
        size.width * 0.7065981,
        size.height * 0.1058803,
        size.width * 0.7081292,
        size.height * 0.1038522,
        size.width * 0.7111914,
        size.height * 0.1024690);
    path_52.cubicTo(
        size.width * 0.7142536,
        size.height * 0.1010672,
        size.width * 0.7185024,
        size.height * 0.1003662,
        size.width * 0.7239378,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.7293349,
        size.height * 0.1003662,
        size.width * 0.7332201,
        size.height * 0.1010578,
        size.width * 0.7355933,
        size.height * 0.1024410);
    path_52.cubicTo(
        size.width * 0.7380048,
        size.height * 0.1038055,
        size.width * 0.7392105,
        size.height * 0.1055064,
        size.width * 0.7392105,
        size.height * 0.1075438);
    path_52.lineTo(size.width * 0.7392105, size.height * 0.1095625);
    path_52.lineTo(size.width * 0.7206077, size.height * 0.1095625);
    path_52.lineTo(size.width * 0.7206077, size.height * 0.1097307);
    path_52.cubicTo(
        size.width * 0.7206077,
        size.height * 0.1104223,
        size.width * 0.7210287,
        size.height * 0.1109363,
        size.width * 0.7218708,
        size.height * 0.1112728);
    path_52.cubicTo(
        size.width * 0.7227129,
        size.height * 0.1115905,
        size.width * 0.7241100,
        size.height * 0.1117494,
        size.width * 0.7260622,
        size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.7283971,
        size.height * 0.1117494,
        size.width * 0.7306172,
        size.height * 0.1116653,
        size.width * 0.7327225,
        size.height * 0.1114971);
    path_52.cubicTo(
        size.width * 0.7348278,
        size.height * 0.1113289,
        size.width * 0.7366651,
        size.height * 0.1111139,
        size.width * 0.7382344,
        size.height * 0.1108522);
    path_52.lineTo(size.width * 0.7382344, size.height * 0.1153382);
    path_52.cubicTo(
        size.width * 0.7368947,
        size.height * 0.1156933,
        size.width * 0.7349234,
        size.height * 0.1160204,
        size.width * 0.7323206,
        size.height * 0.1163195);
    path_52.cubicTo(
        size.width * 0.7297560,
        size.height * 0.1165999,
        size.width * 0.7269617,
        size.height * 0.1167401,
        size.width * 0.7239378,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.7272679, size.height * 0.1064784);
    path_52.lineTo(size.width * 0.7272679, size.height * 0.1061419);
    path_52.cubicTo(
        size.width * 0.7272679,
        size.height * 0.1055064,
        size.width * 0.7269809,
        size.height * 0.1050485,
        size.width * 0.7264067,
        size.height * 0.1047681);
    path_52.cubicTo(
        size.width * 0.7258708,
        size.height * 0.1044877,
        size.width * 0.7250478,
        size.height * 0.1043475,
        size.width * 0.7239378,
        size.height * 0.1043475);
    path_52.cubicTo(
        size.width * 0.7228278,
        size.height * 0.1043475,
        size.width * 0.7219856,
        size.height * 0.1044971,
        size.width * 0.7214115,
        size.height * 0.1047961);
    path_52.cubicTo(
        size.width * 0.7208756,
        size.height * 0.1050765,
        size.width * 0.7206077,
        size.height * 0.1055251,
        size.width * 0.7206077,
        size.height * 0.1061419);
    path_52.lineTo(size.width * 0.7206077, size.height * 0.1064784);
    path_52.lineTo(size.width * 0.7272679, size.height * 0.1064784);
    path_52.close();
    path_52.moveTo(size.width * 0.7189426, size.height * 0.09907652);
    path_52.lineTo(size.width * 0.7189426, size.height * 0.09865596);
    path_52.lineTo(size.width * 0.7252010, size.height * 0.09439428);
    path_52.lineTo(size.width * 0.7374880, size.height * 0.09439428);
    path_52.lineTo(size.width * 0.7374880, size.height * 0.09515129);
    path_52.lineTo(size.width * 0.7281292, size.height * 0.09907652);
    path_52.lineTo(size.width * 0.7189426, size.height * 0.09907652);
    path_52.close();
    path_52.moveTo(size.width * 0.7436746, size.height * 0.09921671);
    path_52.lineTo(size.width * 0.7436746, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.7553876, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.7553876, size.height * 0.09921671);
    path_52.lineTo(size.width * 0.7436746, size.height * 0.09921671);
    path_52.close();
    path_52.moveTo(size.width * 0.7409187, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.7409187, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.7434450, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.7434450, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.7409187, size.height * 0.1053569);
    path_52.lineTo(size.width * 0.7409187, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.7566507, size.height * 0.1007588);
    path_52.lineTo(size.width * 0.7566507, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.7591770, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.7591770, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.7409187, size.height * 0.1163475);
    path_52.close();
    path_52.moveTo(size.width * 0.7747201, size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.7698971,
        size.height * 0.1167401,
        size.width * 0.7652464,
        size.height * 0.1163662,
        size.width * 0.7607679,
        size.height * 0.1156186);
    path_52.lineTo(size.width * 0.7607679, size.height * 0.1114690);
    path_52.lineTo(size.width * 0.7700694, size.height * 0.1114690);
    path_52.lineTo(size.width * 0.7700694, size.height * 0.1117494);
    path_52.cubicTo(
        size.width * 0.7700694,
        size.height * 0.1126466,
        size.width * 0.7712368,
        size.height * 0.1130952,
        size.width * 0.7735718,
        size.height * 0.1130952);
    path_52.cubicTo(
        size.width * 0.7756388,
        size.height * 0.1130952,
        size.width * 0.7766722,
        size.height * 0.1127494,
        size.width * 0.7766722,
        size.height * 0.1120578);
    path_52.cubicTo(
        size.width * 0.7766722,
        size.height * 0.1116840,
        size.width * 0.7763660,
        size.height * 0.1114036,
        size.width * 0.7757536,
        size.height * 0.1112167);
    path_52.cubicTo(
        size.width * 0.7751794,
        size.height * 0.1110298,
        size.width * 0.7741459,
        size.height * 0.1108709,
        size.width * 0.7726531,
        size.height * 0.1107401);
    path_52.lineTo(size.width * 0.7697823, size.height * 0.1104877);
    path_52.cubicTo(
        size.width * 0.7637727,
        size.height * 0.1099644,
        size.width * 0.7607679,
        size.height * 0.1083008,
        size.width * 0.7607679,
        size.height * 0.1054971);
    path_52.cubicTo(
        size.width * 0.7607679,
        size.height * 0.1038709,
        size.width * 0.7620311,
        size.height * 0.1026092,
        size.width * 0.7645574,
        size.height * 0.1017120);
    path_52.cubicTo(
        size.width * 0.7670837,
        size.height * 0.1008148,
        size.width * 0.7704904,
        size.height * 0.1003662,
        size.width * 0.7747775,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.7795622,
        size.height * 0.1003662,
        size.width * 0.7836005,
        size.height * 0.1007588,
        size.width * 0.7868923,
        size.height * 0.1015438);
    path_52.lineTo(size.width * 0.7868923, size.height * 0.1054410);
    path_52.lineTo(size.width * 0.7781651, size.height * 0.1054410);
    path_52.lineTo(size.width * 0.7781651, size.height * 0.1051606);
    path_52.cubicTo(
        size.width * 0.7781651,
        size.height * 0.1047868,
        size.width * 0.7778971,
        size.height * 0.1045064,
        size.width * 0.7773612,
        size.height * 0.1043195);
    path_52.cubicTo(
        size.width * 0.7768636,
        size.height * 0.1041139,
        size.width * 0.7761172,
        size.height * 0.1040111,
        size.width * 0.7751220,
        size.height * 0.1040111);
    path_52.cubicTo(
        size.width * 0.7732081,
        size.height * 0.1040111,
        size.width * 0.7722512,
        size.height * 0.1043102,
        size.width * 0.7722512,
        size.height * 0.1049083);
    path_52.cubicTo(
        size.width * 0.7722512,
        size.height * 0.1052261,
        size.width * 0.7725191,
        size.height * 0.1054690,
        size.width * 0.7730550,
        size.height * 0.1056373);
    path_52.cubicTo(
        size.width * 0.7735909,
        size.height * 0.1058055,
        size.width * 0.7745670,
        size.height * 0.1059644,
        size.width * 0.7759833,
        size.height * 0.1061139);
    path_52.lineTo(size.width * 0.7792560, size.height * 0.1064223);
    path_52.cubicTo(
        size.width * 0.7826627,
        size.height * 0.1067401,
        size.width * 0.7850933,
        size.height * 0.1073289,
        size.width * 0.7865478,
        size.height * 0.1081887);
    path_52.cubicTo(
        size.width * 0.7880024,
        size.height * 0.1090485,
        size.width * 0.7887297,
        size.height * 0.1101513,
        size.width * 0.7887297,
        size.height * 0.1114971);
    path_52.cubicTo(
        size.width * 0.7887297,
        size.height * 0.1131980,
        size.width * 0.7875048,
        size.height * 0.1144971,
        size.width * 0.7850550,
        size.height * 0.1153943);
    path_52.cubicTo(
        size.width * 0.7826435,
        size.height * 0.1162915,
        size.width * 0.7791986,
        size.height * 0.1167401,
        size.width * 0.7747201,
        size.height * 0.1167401);
    path_52.close();
    path_52.moveTo(size.width * 0.8077560, size.height * 0.1163756);
    path_52.lineTo(size.width * 0.8077560, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.8102823, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.8102823, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.8077560, size.height * 0.09913259);
    path_52.lineTo(size.width * 0.8077560, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.8234880, size.height * 0.09453446);
    path_52.lineTo(size.width * 0.8234880, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.8260144, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.8260144, size.height * 0.1163756);
    path_52.lineTo(size.width * 0.8077560, size.height * 0.1163756);
    path_52.close();
    path_52.moveTo(size.width * 0.8613014, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.8613014, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.8461435, size.height * 0.1163475);
    path_52.lineTo(size.width * 0.8461435, size.height * 0.1144410);
    path_52.cubicTo(
        size.width * 0.8453014,
        size.height * 0.1150391,
        size.width * 0.8441148,
        size.height * 0.1155718,
        size.width * 0.8425837,
        size.height * 0.1160391);
    path_52.cubicTo(
        size.width * 0.8410909,
        size.height * 0.1165064,
        size.width * 0.8392536,
        size.height * 0.1167401,
        size.width * 0.8370718,
        size.height * 0.1167401);
    path_52.cubicTo(
        size.width * 0.8342010,
        size.height * 0.1167401,
        size.width * 0.8319426,
        size.height * 0.1163662,
        size.width * 0.8302967,
        size.height * 0.1156186);
    path_52.cubicTo(
        size.width * 0.8286507,
        size.height * 0.1148709,
        size.width * 0.8278278,
        size.height * 0.1138148,
        size.width * 0.8278278,
        size.height * 0.1124504);
    path_52.cubicTo(
        size.width * 0.8278278,
        size.height * 0.1089176,
        size.width * 0.8339713,
        size.height * 0.1071046,
        size.width * 0.8462584,
        size.height * 0.1070111);
    path_52.cubicTo(
        size.width * 0.8461435,
        size.height * 0.1063756,
        size.width * 0.8456459,
        size.height * 0.1059457,
        size.width * 0.8447656,
        size.height * 0.1057214);
    path_52.cubicTo(
        size.width * 0.8438852,
        size.height * 0.1054784,
        size.width * 0.8423923,
        size.height * 0.1053569,
        size.width * 0.8402871,
        size.height * 0.1053569);
    path_52.cubicTo(
        size.width * 0.8385646,
        size.height * 0.1053569,
        size.width * 0.8367081,
        size.height * 0.1054504,
        size.width * 0.8347177,
        size.height * 0.1056373);
    path_52.cubicTo(
        size.width * 0.8327656,
        size.height * 0.1058055,
        size.width * 0.8309665,
        size.height * 0.1060391,
        size.width * 0.8293206,
        size.height * 0.1063382);
    path_52.lineTo(size.width * 0.8293206, size.height * 0.1011793);
    path_52.cubicTo(
        size.width * 0.8313493,
        size.height * 0.1009363,
        size.width * 0.8335502,
        size.height * 0.1007401,
        size.width * 0.8359234,
        size.height * 0.1005905);
    path_52.cubicTo(
        size.width * 0.8382967,
        size.height * 0.1004410,
        size.width * 0.8406124,
        size.height * 0.1003662,
        size.width * 0.8428708,
        size.height * 0.1003662);
    path_52.cubicTo(
        size.width * 0.8485742,
        size.height * 0.1003662,
        size.width * 0.8526507,
        size.height * 0.1008709,
        size.width * 0.8551005,
        size.height * 0.1018803);
    path_52.cubicTo(
        size.width * 0.8575502,
        size.height * 0.1028896,
        size.width * 0.8587751,
        size.height * 0.1044504,
        size.width * 0.8587751,
        size.height * 0.1065625);
    path_52.lineTo(size.width * 0.8587751, size.height * 0.1117494);
    path_52.lineTo(size.width * 0.8613014, size.height * 0.1117494);
    path_52.close();
    path_52.moveTo(size.width * 0.8461435, size.height * 0.1097868);
    path_52.cubicTo(
        size.width * 0.8444211,
        size.height * 0.1097868,
        size.width * 0.8430813,
        size.height * 0.1098989,
        size.width * 0.8421244,
        size.height * 0.1101232);
    path_52.cubicTo(
        size.width * 0.8412057,
        size.height * 0.1103475,
        size.width * 0.8407464,
        size.height * 0.1107214,
        size.width * 0.8407464,
        size.height * 0.1112447);
    path_52.cubicTo(
        size.width * 0.8407464,
        size.height * 0.1115625,
        size.width * 0.8409378,
        size.height * 0.1118242,
        size.width * 0.8413206,
        size.height * 0.1120298);
    path_52.cubicTo(
        size.width * 0.8417416,
        size.height * 0.1122167,
        size.width * 0.8423158,
        size.height * 0.1123102,
        size.width * 0.8430431,
        size.height * 0.1123102);
    path_52.cubicTo(
        size.width * 0.8440383,
        size.height * 0.1123102,
        size.width * 0.8448038,
        size.height * 0.1121046,
        size.width * 0.8453397,
        size.height * 0.1116933);
    path_52.cubicTo(
        size.width * 0.8458756,
        size.height * 0.1112821,
        size.width * 0.8461435,
        size.height * 0.1107027,
        size.width * 0.8461435,
        size.height * 0.1099550);
    path_52.lineTo(size.width * 0.8461435, size.height * 0.1097868);
    path_52.close();
    path_52.moveTo(size.width * 0.1350397, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.1278053, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1253938, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1253938, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.1431354, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.1431354, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1407239, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1437670, size.height * 0.1494603);
    path_52.lineTo(size.width * 0.1443411, size.height * 0.1494603);
    path_52.lineTo(size.width * 0.1473842, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1449727, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1449727, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.1616234, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.1616234, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1592120, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1521498, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.1350397, size.height * 0.1548995);
    path_52.close();
    path_52.moveTo(size.width * 0.1803622, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.1749268,
        size.height * 0.1552921,
        size.width * 0.1706780,
        size.height * 0.1546005,
        size.width * 0.1676158,
        size.height * 0.1532173);
    path_52.cubicTo(
        size.width * 0.1645536,
        size.height * 0.1518154,
        size.width * 0.1630225,
        size.height * 0.1497780,
        size.width * 0.1630225,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.1630225,
        size.height * 0.1444322,
        size.width * 0.1645536,
        size.height * 0.1424042,
        size.width * 0.1676158,
        size.height * 0.1410210);
    path_52.cubicTo(
        size.width * 0.1706780,
        size.height * 0.1396192,
        size.width * 0.1749268,
        size.height * 0.1389182,
        size.width * 0.1803622,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.1857593,
        size.height * 0.1389182,
        size.width * 0.1896445,
        size.height * 0.1396098,
        size.width * 0.1920177,
        size.height * 0.1409930);
    path_52.cubicTo(
        size.width * 0.1944292,
        size.height * 0.1423575,
        size.width * 0.1956349,
        size.height * 0.1440584,
        size.width * 0.1956349,
        size.height * 0.1460958);
    path_52.lineTo(size.width * 0.1956349, size.height * 0.1481145);
    path_52.lineTo(size.width * 0.1770321, size.height * 0.1481145);
    path_52.lineTo(size.width * 0.1770321, size.height * 0.1482827);
    path_52.cubicTo(
        size.width * 0.1770321,
        size.height * 0.1489743,
        size.width * 0.1774531,
        size.height * 0.1494883,
        size.width * 0.1782952,
        size.height * 0.1498248);
    path_52.cubicTo(
        size.width * 0.1791373,
        size.height * 0.1501425,
        size.width * 0.1805344,
        size.height * 0.1503014,
        size.width * 0.1824866,
        size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.1848215,
        size.height * 0.1503014,
        size.width * 0.1870416,
        size.height * 0.1502173,
        size.width * 0.1891469,
        size.height * 0.1500491);
    path_52.cubicTo(
        size.width * 0.1912522,
        size.height * 0.1498808,
        size.width * 0.1930895,
        size.height * 0.1496659,
        size.width * 0.1946589,
        size.height * 0.1494042);
    path_52.lineTo(size.width * 0.1946589, size.height * 0.1538902);
    path_52.cubicTo(
        size.width * 0.1933191,
        size.height * 0.1542453,
        size.width * 0.1913478,
        size.height * 0.1545724,
        size.width * 0.1887450,
        size.height * 0.1548715);
    path_52.cubicTo(
        size.width * 0.1861804,
        size.height * 0.1551519,
        size.width * 0.1833861,
        size.height * 0.1552921,
        size.width * 0.1803622,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.1836923, size.height * 0.1450304);
    path_52.lineTo(size.width * 0.1836923, size.height * 0.1446939);
    path_52.cubicTo(
        size.width * 0.1836923,
        size.height * 0.1440584,
        size.width * 0.1834053,
        size.height * 0.1436005,
        size.width * 0.1828311,
        size.height * 0.1433201);
    path_52.cubicTo(
        size.width * 0.1822952,
        size.height * 0.1430397,
        size.width * 0.1814722,
        size.height * 0.1428995,
        size.width * 0.1803622,
        size.height * 0.1428995);
    path_52.cubicTo(
        size.width * 0.1792522,
        size.height * 0.1428995,
        size.width * 0.1784100,
        size.height * 0.1430491,
        size.width * 0.1778359,
        size.height * 0.1433481);
    path_52.cubicTo(
        size.width * 0.1773000,
        size.height * 0.1436285,
        size.width * 0.1770321,
        size.height * 0.1440771,
        size.width * 0.1770321,
        size.height * 0.1446939);
    path_52.lineTo(size.width * 0.1770321, size.height * 0.1450304);
    path_52.lineTo(size.width * 0.1836923, size.height * 0.1450304);
    path_52.close();
    path_52.moveTo(size.width * 0.2218598, size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.2226254,
        size.height * 0.1389182,
        size.width * 0.2233526,
        size.height * 0.1389556,
        size.width * 0.2240416,
        size.height * 0.1390304);
    path_52.cubicTo(
        size.width * 0.2247306,
        size.height * 0.1391051,
        size.width * 0.2253048,
        size.height * 0.1391986,
        size.width * 0.2257641,
        size.height * 0.1393107);
    path_52.lineTo(size.width * 0.2257641, size.height * 0.1446659);
    path_52.cubicTo(
        size.width * 0.2241947,
        size.height * 0.1443481,
        size.width * 0.2225105,
        size.height * 0.1441893,
        size.width * 0.2207115,
        size.height * 0.1441893);
    path_52.cubicTo(
        size.width * 0.2183000,
        size.height * 0.1441893,
        size.width * 0.2164435,
        size.height * 0.1444977,
        size.width * 0.2151421,
        size.height * 0.1451145);
    path_52.cubicTo(
        size.width * 0.2138407,
        size.height * 0.1457313,
        size.width * 0.2131900,
        size.height * 0.1466472,
        size.width * 0.2131900,
        size.height * 0.1478621);
    path_52.lineTo(size.width * 0.2131900, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.2183574, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.2183574, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.1974579, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.1974579, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.1999842, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.1999842, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1974579, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.1974579, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.2131900, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.2131900, size.height * 0.1413575);
    path_52.cubicTo(
        size.width * 0.2142617,
        size.height * 0.1405724,
        size.width * 0.2154866,
        size.height * 0.1399743,
        size.width * 0.2168646,
        size.height * 0.1395631);
    path_52.cubicTo(
        size.width * 0.2182426,
        size.height * 0.1391332,
        size.width * 0.2199077,
        size.height * 0.1389182,
        size.width * 0.2218598,
        size.height * 0.1389182);
    path_52.close();
    path_52.moveTo(size.width * 0.2389321, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.2350278,
        size.height * 0.1552921,
        size.width * 0.2320804,
        size.height * 0.1545818,
        size.width * 0.2300900,
        size.height * 0.1531612);
    path_52.cubicTo(
        size.width * 0.2281378,
        size.height * 0.1517407,
        size.width * 0.2271617,
        size.height * 0.1497220,
        size.width * 0.2271617,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.2271617,
        size.height * 0.1444883,
        size.width * 0.2281378,
        size.height * 0.1424696,
        size.width * 0.2300900,
        size.height * 0.1410491);
    path_52.cubicTo(
        size.width * 0.2320804,
        size.height * 0.1396285,
        size.width * 0.2350278,
        size.height * 0.1389182,
        size.width * 0.2389321,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.2408852,
        size.height * 0.1389182,
        size.width * 0.2426077,
        size.height * 0.1391519,
        size.width * 0.2441005,
        size.height * 0.1396192);
    path_52.cubicTo(
        size.width * 0.2456316,
        size.height * 0.1400864,
        size.width * 0.2468756,
        size.height * 0.1406192,
        size.width * 0.2478325,
        size.height * 0.1412173);
    path_52.lineTo(size.width * 0.2478325, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.2444450, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.2444450, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.2610383, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.2610383, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.2635646, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.2635646, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.2478325, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.2478325, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.2468756,
        size.height * 0.1535911,
        size.width * 0.2456316,
        size.height * 0.1541238,
        size.width * 0.2441005,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.2426077,
        size.height * 0.1550584,
        size.width * 0.2408852,
        size.height * 0.1552921,
        size.width * 0.2389321,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.2445024, size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.2456124,
        size.height * 0.1503014,
        size.width * 0.2464354,
        size.height * 0.1501612,
        size.width * 0.2469713,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.2475455,
        size.height * 0.1495818,
        size.width * 0.2478325,
        size.height * 0.1491238,
        size.width * 0.2478325,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.2478325, size.height * 0.1457033);
    path_52.cubicTo(
        size.width * 0.2478325,
        size.height * 0.1450864,
        size.width * 0.2475455,
        size.height * 0.1446379,
        size.width * 0.2469713,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.2464354,
        size.height * 0.1440584,
        size.width * 0.2456124,
        size.height * 0.1439089,
        size.width * 0.2445024,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.2433923,
        size.height * 0.1439089,
        size.width * 0.2425502,
        size.height * 0.1440584,
        size.width * 0.2419761,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.2414402,
        size.height * 0.1446379,
        size.width * 0.2411722,
        size.height * 0.1450864,
        size.width * 0.2411722,
        size.height * 0.1457033);
    path_52.lineTo(size.width * 0.2411722, size.height * 0.1485070);
    path_52.cubicTo(
        size.width * 0.2411722,
        size.height * 0.1491238,
        size.width * 0.2414402,
        size.height * 0.1495818,
        size.width * 0.2419761,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.2425502,
        size.height * 0.1501612,
        size.width * 0.2433923,
        size.height * 0.1503014,
        size.width * 0.2445024,
        size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.2988852, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.2988852, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.2837273, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.2837273, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.2828852,
        size.height * 0.1535911,
        size.width * 0.2816986,
        size.height * 0.1541238,
        size.width * 0.2801675,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.2786746,
        size.height * 0.1550584,
        size.width * 0.2768373,
        size.height * 0.1552921,
        size.width * 0.2746555,
        size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.2717847,
        size.height * 0.1552921,
        size.width * 0.2695263,
        size.height * 0.1549182,
        size.width * 0.2678804,
        size.height * 0.1541706);
    path_52.cubicTo(
        size.width * 0.2662344,
        size.height * 0.1534229,
        size.width * 0.2654115,
        size.height * 0.1523668,
        size.width * 0.2654115,
        size.height * 0.1510023);
    path_52.cubicTo(
        size.width * 0.2654115,
        size.height * 0.1474696,
        size.width * 0.2715550,
        size.height * 0.1456565,
        size.width * 0.2838421,
        size.height * 0.1455631);
    path_52.cubicTo(
        size.width * 0.2837273,
        size.height * 0.1449276,
        size.width * 0.2832297,
        size.height * 0.1444977,
        size.width * 0.2823493,
        size.height * 0.1442734);
    path_52.cubicTo(
        size.width * 0.2814689,
        size.height * 0.1440304,
        size.width * 0.2799761,
        size.height * 0.1439089,
        size.width * 0.2778708,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.2761483,
        size.height * 0.1439089,
        size.width * 0.2742919,
        size.height * 0.1440023,
        size.width * 0.2723014,
        size.height * 0.1441893);
    path_52.cubicTo(
        size.width * 0.2703493,
        size.height * 0.1443575,
        size.width * 0.2685502,
        size.height * 0.1445911,
        size.width * 0.2669043,
        size.height * 0.1448902);
    path_52.lineTo(size.width * 0.2669043, size.height * 0.1397313);
    path_52.cubicTo(
        size.width * 0.2689330,
        size.height * 0.1394883,
        size.width * 0.2711340,
        size.height * 0.1392921,
        size.width * 0.2735072,
        size.height * 0.1391425);
    path_52.cubicTo(
        size.width * 0.2758804,
        size.height * 0.1389930,
        size.width * 0.2781962,
        size.height * 0.1389182,
        size.width * 0.2804545,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.2861579,
        size.height * 0.1389182,
        size.width * 0.2902344,
        size.height * 0.1394229,
        size.width * 0.2926842,
        size.height * 0.1404322);
    path_52.cubicTo(
        size.width * 0.2951340,
        size.height * 0.1414416,
        size.width * 0.2963589,
        size.height * 0.1430023,
        size.width * 0.2963589,
        size.height * 0.1451145);
    path_52.lineTo(size.width * 0.2963589, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.2988852, size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.2837273, size.height * 0.1483388);
    path_52.cubicTo(
        size.width * 0.2820048,
        size.height * 0.1483388,
        size.width * 0.2806651,
        size.height * 0.1484509,
        size.width * 0.2797081,
        size.height * 0.1486752);
    path_52.cubicTo(
        size.width * 0.2787895,
        size.height * 0.1488995,
        size.width * 0.2783301,
        size.height * 0.1492734,
        size.width * 0.2783301,
        size.height * 0.1497967);
    path_52.cubicTo(
        size.width * 0.2783301,
        size.height * 0.1501145,
        size.width * 0.2785215,
        size.height * 0.1503762,
        size.width * 0.2789043,
        size.height * 0.1505818);
    path_52.cubicTo(
        size.width * 0.2793254,
        size.height * 0.1507687,
        size.width * 0.2798995,
        size.height * 0.1508621,
        size.width * 0.2806268,
        size.height * 0.1508621);
    path_52.cubicTo(
        size.width * 0.2816220,
        size.height * 0.1508621,
        size.width * 0.2823876,
        size.height * 0.1506565,
        size.width * 0.2829234,
        size.height * 0.1502453);
    path_52.cubicTo(
        size.width * 0.2834593,
        size.height * 0.1498341,
        size.width * 0.2837273,
        size.height * 0.1492547,
        size.width * 0.2837273,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.2837273, size.height * 0.1483388);
    path_52.close();
    path_52.moveTo(size.width * 0.3120478, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.3081435,
        size.height * 0.1552921,
        size.width * 0.3051962,
        size.height * 0.1545818,
        size.width * 0.3032057,
        size.height * 0.1531612);
    path_52.cubicTo(
        size.width * 0.3012536,
        size.height * 0.1517407,
        size.width * 0.3002775,
        size.height * 0.1497220,
        size.width * 0.3002775,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.3002775,
        size.height * 0.1444883,
        size.width * 0.3012536,
        size.height * 0.1424696,
        size.width * 0.3032057,
        size.height * 0.1410491);
    path_52.cubicTo(
        size.width * 0.3051962,
        size.height * 0.1396285,
        size.width * 0.3081435,
        size.height * 0.1389182,
        size.width * 0.3120478,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.3140000,
        size.height * 0.1389182,
        size.width * 0.3157225,
        size.height * 0.1391519,
        size.width * 0.3172153,
        size.height * 0.1396192);
    path_52.cubicTo(
        size.width * 0.3187464,
        size.height * 0.1400864,
        size.width * 0.3199904,
        size.height * 0.1406192,
        size.width * 0.3209474,
        size.height * 0.1412173);
    path_52.lineTo(size.width * 0.3209474, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.3175598, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.3175598, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.3341531, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.3341531, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.3366794, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.3366794, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.3209474, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.3209474, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.3199904,
        size.height * 0.1535911,
        size.width * 0.3187464,
        size.height * 0.1541238,
        size.width * 0.3172153,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.3157225,
        size.height * 0.1550584,
        size.width * 0.3140000,
        size.height * 0.1552921,
        size.width * 0.3120478,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.3176172, size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.3187273,
        size.height * 0.1503014,
        size.width * 0.3195502,
        size.height * 0.1501612,
        size.width * 0.3200861,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.3206603,
        size.height * 0.1495818,
        size.width * 0.3209474,
        size.height * 0.1491238,
        size.width * 0.3209474,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.3209474, size.height * 0.1457033);
    path_52.cubicTo(
        size.width * 0.3209474,
        size.height * 0.1450864,
        size.width * 0.3206603,
        size.height * 0.1446379,
        size.width * 0.3200861,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.3195502,
        size.height * 0.1440584,
        size.width * 0.3187273,
        size.height * 0.1439089,
        size.width * 0.3176172,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.3165072,
        size.height * 0.1439089,
        size.width * 0.3156651,
        size.height * 0.1440584,
        size.width * 0.3150909,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.3145550,
        size.height * 0.1446379,
        size.width * 0.3142871,
        size.height * 0.1450864,
        size.width * 0.3142871,
        size.height * 0.1457033);
    path_52.lineTo(size.width * 0.3142871, size.height * 0.1485070);
    path_52.cubicTo(
        size.width * 0.3142871,
        size.height * 0.1491238,
        size.width * 0.3145550,
        size.height * 0.1495818,
        size.width * 0.3150909,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.3156651,
        size.height * 0.1501612,
        size.width * 0.3165072,
        size.height * 0.1503014,
        size.width * 0.3176172,
        size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.3397919, size.height * 0.1594136);
    path_52.lineTo(size.width * 0.3427775, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.3398493, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.3398493, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.3488062, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.3488062, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.3447297, size.height * 0.1594136);
    path_52.lineTo(size.width * 0.3397919, size.height * 0.1594136);
    path_52.close();
    path_52.moveTo(size.width * 0.4043804, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.4043804, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.4021986, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3946770, size.height * 0.1536379);
    path_52.cubicTo(
        size.width * 0.3928014,
        size.height * 0.1560864,
        size.width * 0.3906579,
        size.height * 0.1579182,
        size.width * 0.3882464,
        size.height * 0.1591332);
    path_52.cubicTo(
        size.width * 0.3858349,
        size.height * 0.1603668,
        size.width * 0.3826579,
        size.height * 0.1609836,
        size.width * 0.3787153,
        size.height * 0.1609836);
    path_52.cubicTo(
        size.width * 0.3771077,
        size.height * 0.1609836,
        size.width * 0.3754809,
        size.height * 0.1608995,
        size.width * 0.3738349,
        size.height * 0.1607313);
    path_52.cubicTo(
        size.width * 0.3721890,
        size.height * 0.1605818,
        size.width * 0.3706962,
        size.height * 0.1603668,
        size.width * 0.3693565,
        size.height * 0.1600864);
    path_52.lineTo(size.width * 0.3693565, size.height * 0.1550117);
    path_52.lineTo(size.width * 0.3772799, size.height * 0.1550117);
    path_52.lineTo(size.width * 0.3772799, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.3772799,
        size.height * 0.1557593,
        size.width * 0.3777775,
        size.height * 0.1559930,
        size.width * 0.3787727,
        size.height * 0.1559930);
    path_52.cubicTo(
        size.width * 0.3796531,
        size.height * 0.1559930,
        size.width * 0.3803230,
        size.height * 0.1557874,
        size.width * 0.3807823,
        size.height * 0.1553762);
    path_52.lineTo(size.width * 0.3717105, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3695287, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3695287, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.3865813, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.3865813, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3846292, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3876148, size.height * 0.1482827);
    path_52.lineTo(size.width * 0.3903708, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3884187, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.3884187, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.4043804, size.height * 0.1393107);
    path_52.close();
    path_52.moveTo(size.width * 0.4233062, size.height * 0.1549276);
    path_52.lineTo(size.width * 0.4233062, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.4258325, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.4258325, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.4233062, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.4233062, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.4390383, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.4390383, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.4415646, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.4415646, size.height * 0.1549276);
    path_52.lineTo(size.width * 0.4233062, size.height * 0.1549276);
    path_52.close();
    path_52.moveTo(size.width * 0.4768541, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.4768541, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.4616962, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.4616962, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.4608541,
        size.height * 0.1535911,
        size.width * 0.4596675,
        size.height * 0.1541238,
        size.width * 0.4581364,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.4566435,
        size.height * 0.1550584,
        size.width * 0.4548062,
        size.height * 0.1552921,
        size.width * 0.4526244,
        size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.4497536,
        size.height * 0.1552921,
        size.width * 0.4474952,
        size.height * 0.1549182,
        size.width * 0.4458493,
        size.height * 0.1541706);
    path_52.cubicTo(
        size.width * 0.4442033,
        size.height * 0.1534229,
        size.width * 0.4433804,
        size.height * 0.1523668,
        size.width * 0.4433804,
        size.height * 0.1510023);
    path_52.cubicTo(
        size.width * 0.4433804,
        size.height * 0.1474696,
        size.width * 0.4495239,
        size.height * 0.1456565,
        size.width * 0.4618110,
        size.height * 0.1455631);
    path_52.cubicTo(
        size.width * 0.4616962,
        size.height * 0.1449276,
        size.width * 0.4611986,
        size.height * 0.1444977,
        size.width * 0.4603182,
        size.height * 0.1442734);
    path_52.cubicTo(
        size.width * 0.4594378,
        size.height * 0.1440304,
        size.width * 0.4579450,
        size.height * 0.1439089,
        size.width * 0.4558397,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.4541172,
        size.height * 0.1439089,
        size.width * 0.4522608,
        size.height * 0.1440023,
        size.width * 0.4502703,
        size.height * 0.1441893);
    path_52.cubicTo(
        size.width * 0.4483182,
        size.height * 0.1443575,
        size.width * 0.4465191,
        size.height * 0.1445911,
        size.width * 0.4448732,
        size.height * 0.1448902);
    path_52.lineTo(size.width * 0.4448732, size.height * 0.1397313);
    path_52.cubicTo(
        size.width * 0.4469019,
        size.height * 0.1394883,
        size.width * 0.4491029,
        size.height * 0.1392921,
        size.width * 0.4514761,
        size.height * 0.1391425);
    path_52.cubicTo(
        size.width * 0.4538493,
        size.height * 0.1389930,
        size.width * 0.4561651,
        size.height * 0.1389182,
        size.width * 0.4584234,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.4641268,
        size.height * 0.1389182,
        size.width * 0.4682033,
        size.height * 0.1394229,
        size.width * 0.4706531,
        size.height * 0.1404322);
    path_52.cubicTo(
        size.width * 0.4731029,
        size.height * 0.1414416,
        size.width * 0.4743278,
        size.height * 0.1430023,
        size.width * 0.4743278,
        size.height * 0.1451145);
    path_52.lineTo(size.width * 0.4743278, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.4768541, size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.4616962, size.height * 0.1483388);
    path_52.cubicTo(
        size.width * 0.4599737,
        size.height * 0.1483388,
        size.width * 0.4586340,
        size.height * 0.1484509,
        size.width * 0.4576770,
        size.height * 0.1486752);
    path_52.cubicTo(
        size.width * 0.4567584,
        size.height * 0.1488995,
        size.width * 0.4562990,
        size.height * 0.1492734,
        size.width * 0.4562990,
        size.height * 0.1497967);
    path_52.cubicTo(
        size.width * 0.4562990,
        size.height * 0.1501145,
        size.width * 0.4564904,
        size.height * 0.1503762,
        size.width * 0.4568732,
        size.height * 0.1505818);
    path_52.cubicTo(
        size.width * 0.4572943,
        size.height * 0.1507687,
        size.width * 0.4578684,
        size.height * 0.1508621,
        size.width * 0.4585957,
        size.height * 0.1508621);
    path_52.cubicTo(
        size.width * 0.4595909,
        size.height * 0.1508621,
        size.width * 0.4603565,
        size.height * 0.1506565,
        size.width * 0.4608923,
        size.height * 0.1502453);
    path_52.cubicTo(
        size.width * 0.4614282,
        size.height * 0.1498341,
        size.width * 0.4616962,
        size.height * 0.1492547,
        size.width * 0.4616962,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.4616962, size.height * 0.1483388);
    path_52.close();
    path_52.moveTo(size.width * 0.5051053, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.4978708, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.4954593, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.4954593, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5132010, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5132010, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5107895, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5138325, size.height * 0.1494603);
    path_52.lineTo(size.width * 0.5144067, size.height * 0.1494603);
    path_52.lineTo(size.width * 0.5174498, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5150383, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5150383, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5316890, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5316890, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5292775, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5222153, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.5051053, size.height * 0.1548995);
    path_52.close();
    path_52.moveTo(size.width * 0.5504282, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.5449928,
        size.height * 0.1552921,
        size.width * 0.5407440,
        size.height * 0.1546005,
        size.width * 0.5376818,
        size.height * 0.1532173);
    path_52.cubicTo(
        size.width * 0.5346196,
        size.height * 0.1518154,
        size.width * 0.5330885,
        size.height * 0.1497780,
        size.width * 0.5330885,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.5330885,
        size.height * 0.1444322,
        size.width * 0.5346196,
        size.height * 0.1424042,
        size.width * 0.5376818,
        size.height * 0.1410210);
    path_52.cubicTo(
        size.width * 0.5407440,
        size.height * 0.1396192,
        size.width * 0.5449928,
        size.height * 0.1389182,
        size.width * 0.5504282,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.5558254,
        size.height * 0.1389182,
        size.width * 0.5597105,
        size.height * 0.1396098,
        size.width * 0.5620837,
        size.height * 0.1409930);
    path_52.cubicTo(
        size.width * 0.5644952,
        size.height * 0.1423575,
        size.width * 0.5657010,
        size.height * 0.1440584,
        size.width * 0.5657010,
        size.height * 0.1460958);
    path_52.lineTo(size.width * 0.5657010, size.height * 0.1481145);
    path_52.lineTo(size.width * 0.5470981, size.height * 0.1481145);
    path_52.lineTo(size.width * 0.5470981, size.height * 0.1482827);
    path_52.cubicTo(
        size.width * 0.5470981,
        size.height * 0.1489743,
        size.width * 0.5475191,
        size.height * 0.1494883,
        size.width * 0.5483612,
        size.height * 0.1498248);
    path_52.cubicTo(
        size.width * 0.5492033,
        size.height * 0.1501425,
        size.width * 0.5506005,
        size.height * 0.1503014,
        size.width * 0.5525526,
        size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.5548876,
        size.height * 0.1503014,
        size.width * 0.5571077,
        size.height * 0.1502173,
        size.width * 0.5592129,
        size.height * 0.1500491);
    path_52.cubicTo(
        size.width * 0.5613182,
        size.height * 0.1498808,
        size.width * 0.5631555,
        size.height * 0.1496659,
        size.width * 0.5647249,
        size.height * 0.1494042);
    path_52.lineTo(size.width * 0.5647249, size.height * 0.1538902);
    path_52.cubicTo(
        size.width * 0.5633852,
        size.height * 0.1542453,
        size.width * 0.5614139,
        size.height * 0.1545724,
        size.width * 0.5588110,
        size.height * 0.1548715);
    path_52.cubicTo(
        size.width * 0.5562464,
        size.height * 0.1551519,
        size.width * 0.5534522,
        size.height * 0.1552921,
        size.width * 0.5504282,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.5537584, size.height * 0.1450304);
    path_52.lineTo(size.width * 0.5537584, size.height * 0.1446939);
    path_52.cubicTo(
        size.width * 0.5537584,
        size.height * 0.1440584,
        size.width * 0.5534713,
        size.height * 0.1436005,
        size.width * 0.5528971,
        size.height * 0.1433201);
    path_52.cubicTo(
        size.width * 0.5523612,
        size.height * 0.1430397,
        size.width * 0.5515383,
        size.height * 0.1428995,
        size.width * 0.5504282,
        size.height * 0.1428995);
    path_52.cubicTo(
        size.width * 0.5493182,
        size.height * 0.1428995,
        size.width * 0.5484761,
        size.height * 0.1430491,
        size.width * 0.5479019,
        size.height * 0.1433481);
    path_52.cubicTo(
        size.width * 0.5473660,
        size.height * 0.1436285,
        size.width * 0.5470981,
        size.height * 0.1440771,
        size.width * 0.5470981,
        size.height * 0.1446939);
    path_52.lineTo(size.width * 0.5470981, size.height * 0.1450304);
    path_52.lineTo(size.width * 0.5537584, size.height * 0.1450304);
    path_52.close();
    path_52.moveTo(size.width * 0.5919258, size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.5926914,
        size.height * 0.1389182,
        size.width * 0.5934187,
        size.height * 0.1389556,
        size.width * 0.5941077,
        size.height * 0.1390304);
    path_52.cubicTo(
        size.width * 0.5947967,
        size.height * 0.1391051,
        size.width * 0.5953708,
        size.height * 0.1391986,
        size.width * 0.5958301,
        size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5958301, size.height * 0.1446659);
    path_52.cubicTo(
        size.width * 0.5942608,
        size.height * 0.1443481,
        size.width * 0.5925766,
        size.height * 0.1441893,
        size.width * 0.5907775,
        size.height * 0.1441893);
    path_52.cubicTo(
        size.width * 0.5883660,
        size.height * 0.1441893,
        size.width * 0.5865096,
        size.height * 0.1444977,
        size.width * 0.5852081,
        size.height * 0.1451145);
    path_52.cubicTo(
        size.width * 0.5839067,
        size.height * 0.1457313,
        size.width * 0.5832560,
        size.height * 0.1466472,
        size.width * 0.5832560,
        size.height * 0.1478621);
    path_52.lineTo(size.width * 0.5832560, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.5884234, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.5884234, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.5675239, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.5675239, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.5700502, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.5700502, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5675239, size.height * 0.1439089);
    path_52.lineTo(size.width * 0.5675239, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5832560, size.height * 0.1393107);
    path_52.lineTo(size.width * 0.5832560, size.height * 0.1413575);
    path_52.cubicTo(
        size.width * 0.5843278,
        size.height * 0.1405724,
        size.width * 0.5855526,
        size.height * 0.1399743,
        size.width * 0.5869306,
        size.height * 0.1395631);
    path_52.cubicTo(
        size.width * 0.5883086,
        size.height * 0.1391332,
        size.width * 0.5899737,
        size.height * 0.1389182,
        size.width * 0.5919258,
        size.height * 0.1389182);
    path_52.close();
    path_52.moveTo(size.width * 0.6089976, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.6050933,
        size.height * 0.1552921,
        size.width * 0.6021459,
        size.height * 0.1545818,
        size.width * 0.6001555,
        size.height * 0.1531612);
    path_52.cubicTo(
        size.width * 0.5982033,
        size.height * 0.1517407,
        size.width * 0.5972273,
        size.height * 0.1497220,
        size.width * 0.5972273,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.5972273,
        size.height * 0.1444883,
        size.width * 0.5982033,
        size.height * 0.1424696,
        size.width * 0.6001555,
        size.height * 0.1410491);
    path_52.cubicTo(
        size.width * 0.6021459,
        size.height * 0.1396285,
        size.width * 0.6050933,
        size.height * 0.1389182,
        size.width * 0.6089976,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.6109498,
        size.height * 0.1389182,
        size.width * 0.6126722,
        size.height * 0.1391519,
        size.width * 0.6141651,
        size.height * 0.1396192);
    path_52.cubicTo(
        size.width * 0.6156962,
        size.height * 0.1400864,
        size.width * 0.6169402,
        size.height * 0.1406192,
        size.width * 0.6178971,
        size.height * 0.1412173);
    path_52.lineTo(size.width * 0.6178971, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.6145096, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.6145096, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.6311029, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.6311029, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.6336292, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.6336292, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.6178971, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.6178971, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.6169402,
        size.height * 0.1535911,
        size.width * 0.6156962,
        size.height * 0.1541238,
        size.width * 0.6141651,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.6126722,
        size.height * 0.1550584,
        size.width * 0.6109498,
        size.height * 0.1552921,
        size.width * 0.6089976,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.6145670, size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.6156770,
        size.height * 0.1503014,
        size.width * 0.6165000,
        size.height * 0.1501612,
        size.width * 0.6170359,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.6176100,
        size.height * 0.1495818,
        size.width * 0.6178971,
        size.height * 0.1491238,
        size.width * 0.6178971,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.6178971, size.height * 0.1457033);
    path_52.cubicTo(
        size.width * 0.6178971,
        size.height * 0.1450864,
        size.width * 0.6176100,
        size.height * 0.1446379,
        size.width * 0.6170359,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.6165000,
        size.height * 0.1440584,
        size.width * 0.6156770,
        size.height * 0.1439089,
        size.width * 0.6145670,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.6134569,
        size.height * 0.1439089,
        size.width * 0.6126148,
        size.height * 0.1440584,
        size.width * 0.6120407,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.6115048,
        size.height * 0.1446379,
        size.width * 0.6112368,
        size.height * 0.1450864,
        size.width * 0.6112368,
        size.height * 0.1457033);
    path_52.lineTo(size.width * 0.6112368, size.height * 0.1485070);
    path_52.cubicTo(
        size.width * 0.6112368,
        size.height * 0.1491238,
        size.width * 0.6115048,
        size.height * 0.1495818,
        size.width * 0.6120407,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.6126148,
        size.height * 0.1501612,
        size.width * 0.6134569,
        size.height * 0.1503014,
        size.width * 0.6145670,
        size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.6689522, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.6689522, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.6537943, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.6537943, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.6529522,
        size.height * 0.1535911,
        size.width * 0.6517656,
        size.height * 0.1541238,
        size.width * 0.6502344,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.6487416,
        size.height * 0.1550584,
        size.width * 0.6469043,
        size.height * 0.1552921,
        size.width * 0.6447225,
        size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.6418517,
        size.height * 0.1552921,
        size.width * 0.6395933,
        size.height * 0.1549182,
        size.width * 0.6379474,
        size.height * 0.1541706);
    path_52.cubicTo(
        size.width * 0.6363014,
        size.height * 0.1534229,
        size.width * 0.6354785,
        size.height * 0.1523668,
        size.width * 0.6354785,
        size.height * 0.1510023);
    path_52.cubicTo(
        size.width * 0.6354785,
        size.height * 0.1474696,
        size.width * 0.6416220,
        size.height * 0.1456565,
        size.width * 0.6539091,
        size.height * 0.1455631);
    path_52.cubicTo(
        size.width * 0.6537943,
        size.height * 0.1449276,
        size.width * 0.6532967,
        size.height * 0.1444977,
        size.width * 0.6524163,
        size.height * 0.1442734);
    path_52.cubicTo(
        size.width * 0.6515359,
        size.height * 0.1440304,
        size.width * 0.6500431,
        size.height * 0.1439089,
        size.width * 0.6479378,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.6462153,
        size.height * 0.1439089,
        size.width * 0.6443589,
        size.height * 0.1440023,
        size.width * 0.6423684,
        size.height * 0.1441893);
    path_52.cubicTo(
        size.width * 0.6404163,
        size.height * 0.1443575,
        size.width * 0.6386172,
        size.height * 0.1445911,
        size.width * 0.6369713,
        size.height * 0.1448902);
    path_52.lineTo(size.width * 0.6369713, size.height * 0.1397313);
    path_52.cubicTo(
        size.width * 0.6390000,
        size.height * 0.1394883,
        size.width * 0.6412010,
        size.height * 0.1392921,
        size.width * 0.6435742,
        size.height * 0.1391425);
    path_52.cubicTo(
        size.width * 0.6459474,
        size.height * 0.1389930,
        size.width * 0.6482632,
        size.height * 0.1389182,
        size.width * 0.6505215,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.6562249,
        size.height * 0.1389182,
        size.width * 0.6603014,
        size.height * 0.1394229,
        size.width * 0.6627512,
        size.height * 0.1404322);
    path_52.cubicTo(
        size.width * 0.6652010,
        size.height * 0.1414416,
        size.width * 0.6664258,
        size.height * 0.1430023,
        size.width * 0.6664258,
        size.height * 0.1451145);
    path_52.lineTo(size.width * 0.6664258, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.6689522, size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.6537943, size.height * 0.1483388);
    path_52.cubicTo(
        size.width * 0.6520718,
        size.height * 0.1483388,
        size.width * 0.6507321,
        size.height * 0.1484509,
        size.width * 0.6497751,
        size.height * 0.1486752);
    path_52.cubicTo(
        size.width * 0.6488565,
        size.height * 0.1488995,
        size.width * 0.6483971,
        size.height * 0.1492734,
        size.width * 0.6483971,
        size.height * 0.1497967);
    path_52.cubicTo(
        size.width * 0.6483971,
        size.height * 0.1501145,
        size.width * 0.6485885,
        size.height * 0.1503762,
        size.width * 0.6489713,
        size.height * 0.1505818);
    path_52.cubicTo(
        size.width * 0.6493923,
        size.height * 0.1507687,
        size.width * 0.6499665,
        size.height * 0.1508621,
        size.width * 0.6506938,
        size.height * 0.1508621);
    path_52.cubicTo(
        size.width * 0.6516890,
        size.height * 0.1508621,
        size.width * 0.6524545,
        size.height * 0.1506565,
        size.width * 0.6529904,
        size.height * 0.1502453);
    path_52.cubicTo(
        size.width * 0.6535263,
        size.height * 0.1498341,
        size.width * 0.6537943,
        size.height * 0.1492547,
        size.width * 0.6537943,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.6537943, size.height * 0.1483388);
    path_52.close();
    path_52.moveTo(size.width * 0.6821148, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.6782105,
        size.height * 0.1552921,
        size.width * 0.6752632,
        size.height * 0.1545818,
        size.width * 0.6732727,
        size.height * 0.1531612);
    path_52.cubicTo(
        size.width * 0.6713206,
        size.height * 0.1517407,
        size.width * 0.6703445,
        size.height * 0.1497220,
        size.width * 0.6703445,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.6703445,
        size.height * 0.1444883,
        size.width * 0.6713206,
        size.height * 0.1424696,
        size.width * 0.6732727,
        size.height * 0.1410491);
    path_52.cubicTo(
        size.width * 0.6752632,
        size.height * 0.1396285,
        size.width * 0.6782105,
        size.height * 0.1389182,
        size.width * 0.6821148,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.6840670,
        size.height * 0.1389182,
        size.width * 0.6857895,
        size.height * 0.1391519,
        size.width * 0.6872823,
        size.height * 0.1396192);
    path_52.cubicTo(
        size.width * 0.6888134,
        size.height * 0.1400864,
        size.width * 0.6900574,
        size.height * 0.1406192,
        size.width * 0.6910144,
        size.height * 0.1412173);
    path_52.lineTo(size.width * 0.6910144, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.6876268, size.height * 0.1376846);
    path_52.lineTo(size.width * 0.6876268, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.7042201, size.height * 0.1330864);
    path_52.lineTo(size.width * 0.7042201, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.7067464, size.height * 0.1503014);
    path_52.lineTo(size.width * 0.7067464, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.6910144, size.height * 0.1548995);
    path_52.lineTo(size.width * 0.6910144, size.height * 0.1529930);
    path_52.cubicTo(
        size.width * 0.6900574,
        size.height * 0.1535911,
        size.width * 0.6888134,
        size.height * 0.1541238,
        size.width * 0.6872823,
        size.height * 0.1545911);
    path_52.cubicTo(
        size.width * 0.6857895,
        size.height * 0.1550584,
        size.width * 0.6840670,
        size.height * 0.1552921,
        size.width * 0.6821148,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.6876842, size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.6887943,
        size.height * 0.1503014,
        size.width * 0.6896172,
        size.height * 0.1501612,
        size.width * 0.6901531,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.6907273,
        size.height * 0.1495818,
        size.width * 0.6910144,
        size.height * 0.1491238,
        size.width * 0.6910144,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.6910144, size.height * 0.1457033);
    path_52.cubicTo(
        size.width * 0.6910144,
        size.height * 0.1450864,
        size.width * 0.6907273,
        size.height * 0.1446379,
        size.width * 0.6901531,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.6896172,
        size.height * 0.1440584,
        size.width * 0.6887943,
        size.height * 0.1439089,
        size.width * 0.6876842,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.6865742,
        size.height * 0.1439089,
        size.width * 0.6857321,
        size.height * 0.1440584,
        size.width * 0.6851579,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.6846220,
        size.height * 0.1446379,
        size.width * 0.6843541,
        size.height * 0.1450864,
        size.width * 0.6843541,
        size.height * 0.1457033);
    path_52.lineTo(size.width * 0.6843541, size.height * 0.1485070);
    path_52.cubicTo(
        size.width * 0.6843541,
        size.height * 0.1491238,
        size.width * 0.6846220,
        size.height * 0.1495818,
        size.width * 0.6851579,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.6857321,
        size.height * 0.1501612,
        size.width * 0.6865742,
        size.height * 0.1503014,
        size.width * 0.6876842,
        size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.7429187, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.7374833,
        size.height * 0.1552921,
        size.width * 0.7332344,
        size.height * 0.1546005,
        size.width * 0.7301722,
        size.height * 0.1532173);
    path_52.cubicTo(
        size.width * 0.7271100,
        size.height * 0.1518154,
        size.width * 0.7255789,
        size.height * 0.1497780,
        size.width * 0.7255789,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.7255789,
        size.height * 0.1444322,
        size.width * 0.7271100,
        size.height * 0.1424042,
        size.width * 0.7301722,
        size.height * 0.1410210);
    path_52.cubicTo(
        size.width * 0.7332344,
        size.height * 0.1396192,
        size.width * 0.7374833,
        size.height * 0.1389182,
        size.width * 0.7429187,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.7484306,
        size.height * 0.1389182,
        size.width * 0.7526986,
        size.height * 0.1396285,
        size.width * 0.7557225,
        size.height * 0.1410491);
    path_52.cubicTo(
        size.width * 0.7587464,
        size.height * 0.1424509,
        size.width * 0.7602584,
        size.height * 0.1444696,
        size.width * 0.7602584,
        size.height * 0.1471051);
    path_52.cubicTo(
        size.width * 0.7602584,
        size.height * 0.1497780,
        size.width * 0.7587273,
        size.height * 0.1518154,
        size.width * 0.7556651,
        size.height * 0.1532173);
    path_52.cubicTo(
        size.width * 0.7526029,
        size.height * 0.1546005,
        size.width * 0.7483541,
        size.height * 0.1552921,
        size.width * 0.7429187,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.7429187, size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.7440287,
        size.height * 0.1503014,
        size.width * 0.7448517,
        size.height * 0.1501612,
        size.width * 0.7453876,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.7459617,
        size.height * 0.1495818,
        size.width * 0.7462488,
        size.height * 0.1491238,
        size.width * 0.7462488,
        size.height * 0.1485070);
    path_52.lineTo(size.width * 0.7462488, size.height * 0.1457033);
    path_52.cubicTo(
        size.width * 0.7462488,
        size.height * 0.1450864,
        size.width * 0.7459617,
        size.height * 0.1446379,
        size.width * 0.7453876,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.7448517,
        size.height * 0.1440584,
        size.width * 0.7440287,
        size.height * 0.1439089,
        size.width * 0.7429187,
        size.height * 0.1439089);
    path_52.cubicTo(
        size.width * 0.7418086,
        size.height * 0.1439089,
        size.width * 0.7409665,
        size.height * 0.1440584,
        size.width * 0.7403923,
        size.height * 0.1443575);
    path_52.cubicTo(
        size.width * 0.7398565,
        size.height * 0.1446379,
        size.width * 0.7395885,
        size.height * 0.1450864,
        size.width * 0.7395885,
        size.height * 0.1457033);
    path_52.lineTo(size.width * 0.7395885, size.height * 0.1485070);
    path_52.cubicTo(
        size.width * 0.7395885,
        size.height * 0.1491238,
        size.width * 0.7398565,
        size.height * 0.1495818,
        size.width * 0.7403923,
        size.height * 0.1498808);
    path_52.cubicTo(
        size.width * 0.7409665,
        size.height * 0.1501612,
        size.width * 0.7418086,
        size.height * 0.1503014,
        size.width * 0.7429187,
        size.height * 0.1503014);
    path_52.close();
    path_52.moveTo(size.width * 0.7760383, size.height * 0.1552921);
    path_52.cubicTo(
        size.width * 0.7712153,
        size.height * 0.1552921,
        size.width * 0.7665646,
        size.height * 0.1549182,
        size.width * 0.7620861,
        size.height * 0.1541706);
    path_52.lineTo(size.width * 0.7620861, size.height * 0.1500210);
    path_52.lineTo(size.width * 0.7713876, size.height * 0.1500210);
    path_52.lineTo(size.width * 0.7713876, size.height * 0.1503014);
    path_52.cubicTo(
        size.width * 0.7713876,
        size.height * 0.1511986,
        size.width * 0.7725550,
        size.height * 0.1516472,
        size.width * 0.7748900,
        size.height * 0.1516472);
    path_52.cubicTo(
        size.width * 0.7769569,
        size.height * 0.1516472,
        size.width * 0.7779904,
        size.height * 0.1513014,
        size.width * 0.7779904,
        size.height * 0.1506098);
    path_52.cubicTo(
        size.width * 0.7779904,
        size.height * 0.1502360,
        size.width * 0.7776842,
        size.height * 0.1499556,
        size.width * 0.7770718,
        size.height * 0.1497687);
    path_52.cubicTo(
        size.width * 0.7764976,
        size.height * 0.1495818,
        size.width * 0.7754641,
        size.height * 0.1494229,
        size.width * 0.7739713,
        size.height * 0.1492921);
    path_52.lineTo(size.width * 0.7711005, size.height * 0.1490397);
    path_52.cubicTo(
        size.width * 0.7650909,
        size.height * 0.1485164,
        size.width * 0.7620861,
        size.height * 0.1468528,
        size.width * 0.7620861,
        size.height * 0.1440491);
    path_52.cubicTo(
        size.width * 0.7620861,
        size.height * 0.1424229,
        size.width * 0.7633493,
        size.height * 0.1411612,
        size.width * 0.7658756,
        size.height * 0.1402640);
    path_52.cubicTo(
        size.width * 0.7684019,
        size.height * 0.1393668,
        size.width * 0.7718086,
        size.height * 0.1389182,
        size.width * 0.7760957,
        size.height * 0.1389182);
    path_52.cubicTo(
        size.width * 0.7808804,
        size.height * 0.1389182,
        size.width * 0.7849187,
        size.height * 0.1393107,
        size.width * 0.7882105,
        size.height * 0.1400958);
    path_52.lineTo(size.width * 0.7882105, size.height * 0.1439930);
    path_52.lineTo(size.width * 0.7794833, size.height * 0.1439930);
    path_52.lineTo(size.width * 0.7794833, size.height * 0.1437126);
    path_52.cubicTo(
        size.width * 0.7794833,
        size.height * 0.1433388,
        size.width * 0.7792153,
        size.height * 0.1430584,
        size.width * 0.7786794,
        size.height * 0.1428715);
    path_52.cubicTo(
        size.width * 0.7781818,
        size.height * 0.1426659,
        size.width * 0.7774354,
        size.height * 0.1425631,
        size.width * 0.7764402,
        size.height * 0.1425631);
    path_52.cubicTo(
        size.width * 0.7745263,
        size.height * 0.1425631,
        size.width * 0.7735694,
        size.height * 0.1428621,
        size.width * 0.7735694,
        size.height * 0.1434603);
    path_52.cubicTo(
        size.width * 0.7735694,
        size.height * 0.1437780,
        size.width * 0.7738373,
        size.height * 0.1440210,
        size.width * 0.7743732,
        size.height * 0.1441893);
    path_52.cubicTo(
        size.width * 0.7749091,
        size.height * 0.1443575,
        size.width * 0.7758852,
        size.height * 0.1445164,
        size.width * 0.7773014,
        size.height * 0.1446659);
    path_52.lineTo(size.width * 0.7805742, size.height * 0.1449743);
    path_52.cubicTo(
        size.width * 0.7839809,
        size.height * 0.1452921,
        size.width * 0.7864115,
        size.height * 0.1458808,
        size.width * 0.7878660,
        size.height * 0.1467407);
    path_52.cubicTo(
        size.width * 0.7893206,
        size.height * 0.1476005,
        size.width * 0.7900478,
        size.height * 0.1487033,
        size.width * 0.7900478,
        size.height * 0.1500491);
    path_52.cubicTo(
        size.width * 0.7900478,
        size.height * 0.1517500,
        size.width * 0.7888230,
        size.height * 0.1530491,
        size.width * 0.7863732,
        size.height * 0.1539463);
    path_52.cubicTo(
        size.width * 0.7839617,
        size.height * 0.1548435,
        size.width * 0.7805167,
        size.height * 0.1552921,
        size.width * 0.7760383,
        size.height * 0.1552921);
    path_52.close();
    path_52.moveTo(size.width * 0.3146388, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3146388, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.2964952, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.2964952, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.2989067, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.2989067, size.height * 0.1842547);
    path_52.cubicTo(
        size.width * 0.2989067,
        size.height * 0.1836379,
        size.width * 0.2986388,
        size.height * 0.1831893,
        size.width * 0.2981029,
        size.height * 0.1829089);
    path_52.cubicTo(
        size.width * 0.2975670,
        size.height * 0.1826098,
        size.width * 0.2967632,
        size.height * 0.1824603,
        size.width * 0.2956914,
        size.height * 0.1824603);
    path_52.cubicTo(
        size.width * 0.2933947,
        size.height * 0.1824603,
        size.width * 0.2922464,
        size.height * 0.1830584,
        size.width * 0.2922464,
        size.height * 0.1842547);
    path_52.lineTo(size.width * 0.2922464, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.2946579, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.2946579, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.2765144, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.2765144, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.2790407, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.2790407, size.height * 0.1762360);
    path_52.lineTo(size.width * 0.2765144, size.height * 0.1762360);
    path_52.lineTo(size.width * 0.2765144, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.2922464, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.2922464, size.height * 0.1800491);
    path_52.cubicTo(
        size.width * 0.2936627,
        size.height * 0.1791893,
        size.width * 0.2951938,
        size.height * 0.1785444,
        size.width * 0.2968397,
        size.height * 0.1781145);
    path_52.cubicTo(
        size.width * 0.2984856,
        size.height * 0.1776846,
        size.width * 0.3003995,
        size.height * 0.1774696,
        size.width * 0.3025813,
        size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.3057584,
        size.height * 0.1774696,
        size.width * 0.3081316,
        size.height * 0.1779556,
        size.width * 0.3097010,
        size.height * 0.1789276);
    path_52.cubicTo(
        size.width * 0.3113086,
        size.height * 0.1798995,
        size.width * 0.3121124,
        size.height * 0.1812360,
        size.width * 0.3121124,
        size.height * 0.1829369);
    path_52.lineTo(size.width * 0.3121124, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3146388, size.height * 0.1888528);
    path_52.close();
    path_52.moveTo(size.width * 0.3499665, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3499665, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.3348086, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.3348086, size.height * 0.1915444);
    path_52.cubicTo(
        size.width * 0.3339665,
        size.height * 0.1921425,
        size.width * 0.3327799,
        size.height * 0.1926752,
        size.width * 0.3312488,
        size.height * 0.1931425);
    path_52.cubicTo(
        size.width * 0.3297560,
        size.height * 0.1936098,
        size.width * 0.3279187,
        size.height * 0.1938435,
        size.width * 0.3257368,
        size.height * 0.1938435);
    path_52.cubicTo(
        size.width * 0.3228660,
        size.height * 0.1938435,
        size.width * 0.3206077,
        size.height * 0.1934696,
        size.width * 0.3189617,
        size.height * 0.1927220);
    path_52.cubicTo(
        size.width * 0.3173158,
        size.height * 0.1919743,
        size.width * 0.3164928,
        size.height * 0.1909182,
        size.width * 0.3164928,
        size.height * 0.1895537);
    path_52.cubicTo(
        size.width * 0.3164928,
        size.height * 0.1860210,
        size.width * 0.3226364,
        size.height * 0.1842079,
        size.width * 0.3349234,
        size.height * 0.1841145);
    path_52.cubicTo(
        size.width * 0.3348086,
        size.height * 0.1834790,
        size.width * 0.3343110,
        size.height * 0.1830491,
        size.width * 0.3334306,
        size.height * 0.1828248);
    path_52.cubicTo(
        size.width * 0.3325502,
        size.height * 0.1825818,
        size.width * 0.3310574,
        size.height * 0.1824603,
        size.width * 0.3289522,
        size.height * 0.1824603);
    path_52.cubicTo(
        size.width * 0.3272297,
        size.height * 0.1824603,
        size.width * 0.3253732,
        size.height * 0.1825537,
        size.width * 0.3233828,
        size.height * 0.1827407);
    path_52.cubicTo(
        size.width * 0.3214306,
        size.height * 0.1829089,
        size.width * 0.3196316,
        size.height * 0.1831425,
        size.width * 0.3179856,
        size.height * 0.1834416);
    path_52.lineTo(size.width * 0.3179856, size.height * 0.1782827);
    path_52.cubicTo(
        size.width * 0.3200144,
        size.height * 0.1780397,
        size.width * 0.3222153,
        size.height * 0.1778435,
        size.width * 0.3245885,
        size.height * 0.1776939);
    path_52.cubicTo(
        size.width * 0.3269617,
        size.height * 0.1775444,
        size.width * 0.3292775,
        size.height * 0.1774696,
        size.width * 0.3315359,
        size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.3372392,
        size.height * 0.1774696,
        size.width * 0.3413158,
        size.height * 0.1779743,
        size.width * 0.3437656,
        size.height * 0.1789836);
    path_52.cubicTo(
        size.width * 0.3462153,
        size.height * 0.1799930,
        size.width * 0.3474402,
        size.height * 0.1815537,
        size.width * 0.3474402,
        size.height * 0.1836659);
    path_52.lineTo(size.width * 0.3474402, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3499665, size.height * 0.1888528);
    path_52.close();
    path_52.moveTo(size.width * 0.3348086, size.height * 0.1868902);
    path_52.cubicTo(
        size.width * 0.3330861,
        size.height * 0.1868902,
        size.width * 0.3317464,
        size.height * 0.1870023,
        size.width * 0.3307895,
        size.height * 0.1872266);
    path_52.cubicTo(
        size.width * 0.3298708,
        size.height * 0.1874509,
        size.width * 0.3294115,
        size.height * 0.1878248,
        size.width * 0.3294115,
        size.height * 0.1883481);
    path_52.cubicTo(
        size.width * 0.3294115,
        size.height * 0.1886659,
        size.width * 0.3296029,
        size.height * 0.1889276,
        size.width * 0.3299856,
        size.height * 0.1891332);
    path_52.cubicTo(
        size.width * 0.3304067,
        size.height * 0.1893201,
        size.width * 0.3309809,
        size.height * 0.1894136,
        size.width * 0.3317081,
        size.height * 0.1894136);
    path_52.cubicTo(
        size.width * 0.3327033,
        size.height * 0.1894136,
        size.width * 0.3334689,
        size.height * 0.1892079,
        size.width * 0.3340048,
        size.height * 0.1887967);
    path_52.cubicTo(
        size.width * 0.3345407,
        size.height * 0.1883855,
        size.width * 0.3348086,
        size.height * 0.1878061,
        size.width * 0.3348086,
        size.height * 0.1870584);
    path_52.lineTo(size.width * 0.3348086, size.height * 0.1868902);
    path_52.close();
    path_52.moveTo(size.width * 0.3763349, size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.3771005,
        size.height * 0.1774696,
        size.width * 0.3778278,
        size.height * 0.1775070,
        size.width * 0.3785167,
        size.height * 0.1775818);
    path_52.cubicTo(
        size.width * 0.3792057,
        size.height * 0.1776565,
        size.width * 0.3797799,
        size.height * 0.1777500,
        size.width * 0.3802392,
        size.height * 0.1778621);
    path_52.lineTo(size.width * 0.3802392, size.height * 0.1832173);
    path_52.cubicTo(
        size.width * 0.3786699,
        size.height * 0.1828995,
        size.width * 0.3769856,
        size.height * 0.1827407,
        size.width * 0.3751866,
        size.height * 0.1827407);
    path_52.cubicTo(
        size.width * 0.3727751,
        size.height * 0.1827407,
        size.width * 0.3709187,
        size.height * 0.1830491,
        size.width * 0.3696172,
        size.height * 0.1836659);
    path_52.cubicTo(
        size.width * 0.3683158,
        size.height * 0.1842827,
        size.width * 0.3676651,
        size.height * 0.1851986,
        size.width * 0.3676651,
        size.height * 0.1864136);
    path_52.lineTo(size.width * 0.3676651, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3728325, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3728325, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.3519330, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.3519330, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3544593, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.3544593, size.height * 0.1824603);
    path_52.lineTo(size.width * 0.3519330, size.height * 0.1824603);
    path_52.lineTo(size.width * 0.3519330, size.height * 0.1778621);
    path_52.lineTo(size.width * 0.3676651, size.height * 0.1778621);
    path_52.lineTo(size.width * 0.3676651, size.height * 0.1799089);
    path_52.cubicTo(
        size.width * 0.3687368,
        size.height * 0.1791238,
        size.width * 0.3699617,
        size.height * 0.1785257,
        size.width * 0.3713397,
        size.height * 0.1781145);
    path_52.cubicTo(
        size.width * 0.3727177,
        size.height * 0.1776846,
        size.width * 0.3743828,
        size.height * 0.1774696,
        size.width * 0.3763349,
        size.height * 0.1774696);
    path_52.close();
    path_52.moveTo(size.width * 0.4155694, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4155694, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.4004115, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.4004115, size.height * 0.1915444);
    path_52.cubicTo(
        size.width * 0.3995694,
        size.height * 0.1921425,
        size.width * 0.3983828,
        size.height * 0.1926752,
        size.width * 0.3968517,
        size.height * 0.1931425);
    path_52.cubicTo(
        size.width * 0.3953589,
        size.height * 0.1936098,
        size.width * 0.3935215,
        size.height * 0.1938435,
        size.width * 0.3913397,
        size.height * 0.1938435);
    path_52.cubicTo(
        size.width * 0.3884689,
        size.height * 0.1938435,
        size.width * 0.3862105,
        size.height * 0.1934696,
        size.width * 0.3845646,
        size.height * 0.1927220);
    path_52.cubicTo(
        size.width * 0.3829187,
        size.height * 0.1919743,
        size.width * 0.3820957,
        size.height * 0.1909182,
        size.width * 0.3820957,
        size.height * 0.1895537);
    path_52.cubicTo(
        size.width * 0.3820957,
        size.height * 0.1860210,
        size.width * 0.3882392,
        size.height * 0.1842079,
        size.width * 0.4005263,
        size.height * 0.1841145);
    path_52.cubicTo(
        size.width * 0.4004115,
        size.height * 0.1834790,
        size.width * 0.3999139,
        size.height * 0.1830491,
        size.width * 0.3990335,
        size.height * 0.1828248);
    path_52.cubicTo(
        size.width * 0.3981531,
        size.height * 0.1825818,
        size.width * 0.3966603,
        size.height * 0.1824603,
        size.width * 0.3945550,
        size.height * 0.1824603);
    path_52.cubicTo(
        size.width * 0.3928325,
        size.height * 0.1824603,
        size.width * 0.3909761,
        size.height * 0.1825537,
        size.width * 0.3889856,
        size.height * 0.1827407);
    path_52.cubicTo(
        size.width * 0.3870335,
        size.height * 0.1829089,
        size.width * 0.3852344,
        size.height * 0.1831425,
        size.width * 0.3835885,
        size.height * 0.1834416);
    path_52.lineTo(size.width * 0.3835885, size.height * 0.1782827);
    path_52.cubicTo(
        size.width * 0.3856172,
        size.height * 0.1780397,
        size.width * 0.3878182,
        size.height * 0.1778435,
        size.width * 0.3901914,
        size.height * 0.1776939);
    path_52.cubicTo(
        size.width * 0.3925646,
        size.height * 0.1775444,
        size.width * 0.3948804,
        size.height * 0.1774696,
        size.width * 0.3971388,
        size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.4028421,
        size.height * 0.1774696,
        size.width * 0.4069187,
        size.height * 0.1779743,
        size.width * 0.4093684,
        size.height * 0.1789836);
    path_52.cubicTo(
        size.width * 0.4118182,
        size.height * 0.1799930,
        size.width * 0.4130431,
        size.height * 0.1815537,
        size.width * 0.4130431,
        size.height * 0.1836659);
    path_52.lineTo(size.width * 0.4130431, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4155694, size.height * 0.1888528);
    path_52.close();
    path_52.moveTo(size.width * 0.4004115, size.height * 0.1868902);
    path_52.cubicTo(
        size.width * 0.3986890,
        size.height * 0.1868902,
        size.width * 0.3973493,
        size.height * 0.1870023,
        size.width * 0.3963923,
        size.height * 0.1872266);
    path_52.cubicTo(
        size.width * 0.3954737,
        size.height * 0.1874509,
        size.width * 0.3950144,
        size.height * 0.1878248,
        size.width * 0.3950144,
        size.height * 0.1883481);
    path_52.cubicTo(
        size.width * 0.3950144,
        size.height * 0.1886659,
        size.width * 0.3952057,
        size.height * 0.1889276,
        size.width * 0.3955885,
        size.height * 0.1891332);
    path_52.cubicTo(
        size.width * 0.3960096,
        size.height * 0.1893201,
        size.width * 0.3965837,
        size.height * 0.1894136,
        size.width * 0.3973110,
        size.height * 0.1894136);
    path_52.cubicTo(
        size.width * 0.3983062,
        size.height * 0.1894136,
        size.width * 0.3990718,
        size.height * 0.1892079,
        size.width * 0.3996077,
        size.height * 0.1887967);
    path_52.cubicTo(
        size.width * 0.4001435,
        size.height * 0.1883855,
        size.width * 0.4004115,
        size.height * 0.1878061,
        size.width * 0.4004115,
        size.height * 0.1870584);
    path_52.lineTo(size.width * 0.4004115, size.height * 0.1868902);
    path_52.close();
    path_52.moveTo(size.width * 0.3941531, size.height * 0.1761799);
    path_52.lineTo(size.width * 0.3941531, size.height * 0.1757593);
    path_52.lineTo(size.width * 0.4004115, size.height * 0.1714977);
    path_52.lineTo(size.width * 0.4126986, size.height * 0.1714977);
    path_52.lineTo(size.width * 0.4126986, size.height * 0.1722547);
    path_52.lineTo(size.width * 0.4033397, size.height * 0.1761799);
    path_52.lineTo(size.width * 0.3941531, size.height * 0.1761799);
    path_52.close();
    path_52.moveTo(size.width * 0.4346340, size.height * 0.1934790);
    path_52.lineTo(size.width * 0.4346340, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4371603, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4371603, size.height * 0.1762360);
    path_52.lineTo(size.width * 0.4346340, size.height * 0.1762360);
    path_52.lineTo(size.width * 0.4346340, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.4503660, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.4503660, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4528923, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4528923, size.height * 0.1934790);
    path_52.lineTo(size.width * 0.4346340, size.height * 0.1934790);
    path_52.close();
    path_52.moveTo(size.width * 0.4574617, size.height * 0.1763201);
    path_52.lineTo(size.width * 0.4574617, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.4691746, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.4691746, size.height * 0.1763201);
    path_52.lineTo(size.width * 0.4574617, size.height * 0.1763201);
    path_52.close();
    path_52.moveTo(size.width * 0.4547057, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.4547057, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4572321, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4572321, size.height * 0.1824603);
    path_52.lineTo(size.width * 0.4547057, size.height * 0.1824603);
    path_52.lineTo(size.width * 0.4547057, size.height * 0.1778621);
    path_52.lineTo(size.width * 0.4704378, size.height * 0.1778621);
    path_52.lineTo(size.width * 0.4704378, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4729641, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4729641, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.4547057, size.height * 0.1934509);
    path_52.close();
    path_52.moveTo(size.width * 0.4991866, size.height * 0.1938435);
    path_52.cubicTo(
        size.width * 0.4972344,
        size.height * 0.1938435,
        size.width * 0.4954928,
        size.height * 0.1936098,
        size.width * 0.4939617,
        size.height * 0.1931425);
    path_52.cubicTo(
        size.width * 0.4924689,
        size.height * 0.1926752,
        size.width * 0.4912440,
        size.height * 0.1921425,
        size.width * 0.4902871,
        size.height * 0.1915444);
    path_52.lineTo(size.width * 0.4902871, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.4745550, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.4745550, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4770813, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.4770813, size.height * 0.1762360);
    path_52.lineTo(size.width * 0.4745550, size.height * 0.1762360);
    path_52.lineTo(size.width * 0.4745550, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.4902871, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.4902871, size.height * 0.1797687);
    path_52.cubicTo(
        size.width * 0.4912440,
        size.height * 0.1791706,
        size.width * 0.4924689,
        size.height * 0.1786379,
        size.width * 0.4939617,
        size.height * 0.1781706);
    path_52.cubicTo(
        size.width * 0.4954928,
        size.height * 0.1777033,
        size.width * 0.4972344,
        size.height * 0.1774696,
        size.width * 0.4991866,
        size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.5030909,
        size.height * 0.1774696,
        size.width * 0.5060191,
        size.height * 0.1781799,
        size.width * 0.5079713,
        size.height * 0.1796005);
    path_52.cubicTo(
        size.width * 0.5099617,
        size.height * 0.1810210,
        size.width * 0.5109569,
        size.height * 0.1830397,
        size.width * 0.5109569,
        size.height * 0.1856565);
    path_52.cubicTo(
        size.width * 0.5109569,
        size.height * 0.1882734,
        size.width * 0.5099617,
        size.height * 0.1902921,
        size.width * 0.5079713,
        size.height * 0.1917126);
    path_52.cubicTo(
        size.width * 0.5060191,
        size.height * 0.1931332,
        size.width * 0.5030909,
        size.height * 0.1938435,
        size.width * 0.4991866,
        size.height * 0.1938435);
    path_52.close();
    path_52.moveTo(size.width * 0.4936172, size.height * 0.1888528);
    path_52.cubicTo(
        size.width * 0.4947273,
        size.height * 0.1888528,
        size.width * 0.4955502,
        size.height * 0.1887126,
        size.width * 0.4960861,
        size.height * 0.1884322);
    path_52.cubicTo(
        size.width * 0.4966603,
        size.height * 0.1881332,
        size.width * 0.4969474,
        size.height * 0.1876752,
        size.width * 0.4969474,
        size.height * 0.1870584);
    path_52.lineTo(size.width * 0.4969474, size.height * 0.1842547);
    path_52.cubicTo(
        size.width * 0.4969474,
        size.height * 0.1836379,
        size.width * 0.4966603,
        size.height * 0.1831893,
        size.width * 0.4960861,
        size.height * 0.1829089);
    path_52.cubicTo(
        size.width * 0.4955502,
        size.height * 0.1826098,
        size.width * 0.4947273,
        size.height * 0.1824603,
        size.width * 0.4936172,
        size.height * 0.1824603);
    path_52.cubicTo(
        size.width * 0.4925072,
        size.height * 0.1824603,
        size.width * 0.4916651,
        size.height * 0.1826098,
        size.width * 0.4910909,
        size.height * 0.1829089);
    path_52.cubicTo(
        size.width * 0.4905550,
        size.height * 0.1831893,
        size.width * 0.4902871,
        size.height * 0.1836379,
        size.width * 0.4902871,
        size.height * 0.1842547);
    path_52.lineTo(size.width * 0.4902871, size.height * 0.1870584);
    path_52.cubicTo(
        size.width * 0.4902871,
        size.height * 0.1876752,
        size.width * 0.4905550,
        size.height * 0.1881332,
        size.width * 0.4910909,
        size.height * 0.1884322);
    path_52.cubicTo(
        size.width * 0.4916651,
        size.height * 0.1887126,
        size.width * 0.4925072,
        size.height * 0.1888528,
        size.width * 0.4936172,
        size.height * 0.1888528);
    path_52.close();
    path_52.moveTo(size.width * 0.5370885, size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.5378541,
        size.height * 0.1774696,
        size.width * 0.5385813,
        size.height * 0.1775070,
        size.width * 0.5392703,
        size.height * 0.1775818);
    path_52.cubicTo(
        size.width * 0.5399593,
        size.height * 0.1776565,
        size.width * 0.5405335,
        size.height * 0.1777500,
        size.width * 0.5409928,
        size.height * 0.1778621);
    path_52.lineTo(size.width * 0.5409928, size.height * 0.1832173);
    path_52.cubicTo(
        size.width * 0.5394234,
        size.height * 0.1828995,
        size.width * 0.5377392,
        size.height * 0.1827407,
        size.width * 0.5359402,
        size.height * 0.1827407);
    path_52.cubicTo(
        size.width * 0.5335287,
        size.height * 0.1827407,
        size.width * 0.5316722,
        size.height * 0.1830491,
        size.width * 0.5303708,
        size.height * 0.1836659);
    path_52.cubicTo(
        size.width * 0.5290694,
        size.height * 0.1842827,
        size.width * 0.5284187,
        size.height * 0.1851986,
        size.width * 0.5284187,
        size.height * 0.1864136);
    path_52.lineTo(size.width * 0.5284187, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.5335861, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.5335861, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.5126866, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.5126866, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.5152129, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.5152129, size.height * 0.1824603);
    path_52.lineTo(size.width * 0.5126866, size.height * 0.1824603);
    path_52.lineTo(size.width * 0.5126866, size.height * 0.1778621);
    path_52.lineTo(size.width * 0.5284187, size.height * 0.1778621);
    path_52.lineTo(size.width * 0.5284187, size.height * 0.1799089);
    path_52.cubicTo(
        size.width * 0.5294904,
        size.height * 0.1791238,
        size.width * 0.5307153,
        size.height * 0.1785257,
        size.width * 0.5320933,
        size.height * 0.1781145);
    path_52.cubicTo(
        size.width * 0.5334713,
        size.height * 0.1776846,
        size.width * 0.5351364,
        size.height * 0.1774696,
        size.width * 0.5370885,
        size.height * 0.1774696);
    path_52.close();
    path_52.moveTo(size.width * 0.5599593, size.height * 0.1938435);
    path_52.cubicTo(
        size.width * 0.5545239,
        size.height * 0.1938435,
        size.width * 0.5502751,
        size.height * 0.1931519,
        size.width * 0.5472129,
        size.height * 0.1917687);
    path_52.cubicTo(
        size.width * 0.5441507,
        size.height * 0.1903668,
        size.width * 0.5426196,
        size.height * 0.1883294,
        size.width * 0.5426196,
        size.height * 0.1856565);
    path_52.cubicTo(
        size.width * 0.5426196,
        size.height * 0.1829836,
        size.width * 0.5441507,
        size.height * 0.1809556,
        size.width * 0.5472129,
        size.height * 0.1795724);
    path_52.cubicTo(
        size.width * 0.5502751,
        size.height * 0.1781706,
        size.width * 0.5545239,
        size.height * 0.1774696,
        size.width * 0.5599593,
        size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.5653565,
        size.height * 0.1774696,
        size.width * 0.5692416,
        size.height * 0.1781612,
        size.width * 0.5716148,
        size.height * 0.1795444);
    path_52.cubicTo(
        size.width * 0.5740263,
        size.height * 0.1809089,
        size.width * 0.5752321,
        size.height * 0.1826098,
        size.width * 0.5752321,
        size.height * 0.1846472);
    path_52.lineTo(size.width * 0.5752321, size.height * 0.1866659);
    path_52.lineTo(size.width * 0.5566292, size.height * 0.1866659);
    path_52.lineTo(size.width * 0.5566292, size.height * 0.1868341);
    path_52.cubicTo(
        size.width * 0.5566292,
        size.height * 0.1875257,
        size.width * 0.5570502,
        size.height * 0.1880397,
        size.width * 0.5578923,
        size.height * 0.1883762);
    path_52.cubicTo(
        size.width * 0.5587344,
        size.height * 0.1886939,
        size.width * 0.5601316,
        size.height * 0.1888528,
        size.width * 0.5620837,
        size.height * 0.1888528);
    path_52.cubicTo(
        size.width * 0.5644187,
        size.height * 0.1888528,
        size.width * 0.5666388,
        size.height * 0.1887687,
        size.width * 0.5687440,
        size.height * 0.1886005);
    path_52.cubicTo(
        size.width * 0.5708493,
        size.height * 0.1884322,
        size.width * 0.5726866,
        size.height * 0.1882173,
        size.width * 0.5742560,
        size.height * 0.1879556);
    path_52.lineTo(size.width * 0.5742560, size.height * 0.1924416);
    path_52.cubicTo(
        size.width * 0.5729163,
        size.height * 0.1927967,
        size.width * 0.5709450,
        size.height * 0.1931238,
        size.width * 0.5683421,
        size.height * 0.1934229);
    path_52.cubicTo(
        size.width * 0.5657775,
        size.height * 0.1937033,
        size.width * 0.5629833,
        size.height * 0.1938435,
        size.width * 0.5599593,
        size.height * 0.1938435);
    path_52.close();
    path_52.moveTo(size.width * 0.5632895, size.height * 0.1835818);
    path_52.lineTo(size.width * 0.5632895, size.height * 0.1832453);
    path_52.cubicTo(
        size.width * 0.5632895,
        size.height * 0.1826098,
        size.width * 0.5630024,
        size.height * 0.1821519,
        size.width * 0.5624282,
        size.height * 0.1818715);
    path_52.cubicTo(
        size.width * 0.5618923,
        size.height * 0.1815911,
        size.width * 0.5610694,
        size.height * 0.1814509,
        size.width * 0.5599593,
        size.height * 0.1814509);
    path_52.cubicTo(
        size.width * 0.5588493,
        size.height * 0.1814509,
        size.width * 0.5580072,
        size.height * 0.1816005,
        size.width * 0.5574330,
        size.height * 0.1818995);
    path_52.cubicTo(
        size.width * 0.5568971,
        size.height * 0.1821799,
        size.width * 0.5566292,
        size.height * 0.1826285,
        size.width * 0.5566292,
        size.height * 0.1832453);
    path_52.lineTo(size.width * 0.5566292, size.height * 0.1835818);
    path_52.lineTo(size.width * 0.5632895, size.height * 0.1835818);
    path_52.close();
    path_52.moveTo(size.width * 0.5908923, size.height * 0.1938435);
    path_52.cubicTo(
        size.width * 0.5860694,
        size.height * 0.1938435,
        size.width * 0.5814187,
        size.height * 0.1934696,
        size.width * 0.5769402,
        size.height * 0.1927220);
    path_52.lineTo(size.width * 0.5769402, size.height * 0.1885724);
    path_52.lineTo(size.width * 0.5862416, size.height * 0.1885724);
    path_52.lineTo(size.width * 0.5862416, size.height * 0.1888528);
    path_52.cubicTo(
        size.width * 0.5862416,
        size.height * 0.1897500,
        size.width * 0.5874091,
        size.height * 0.1901986,
        size.width * 0.5897440,
        size.height * 0.1901986);
    path_52.cubicTo(
        size.width * 0.5918110,
        size.height * 0.1901986,
        size.width * 0.5928445,
        size.height * 0.1898528,
        size.width * 0.5928445,
        size.height * 0.1891612);
    path_52.cubicTo(
        size.width * 0.5928445,
        size.height * 0.1887874,
        size.width * 0.5925383,
        size.height * 0.1885070,
        size.width * 0.5919258,
        size.height * 0.1883201);
    path_52.cubicTo(
        size.width * 0.5913517,
        size.height * 0.1881332,
        size.width * 0.5903182,
        size.height * 0.1879743,
        size.width * 0.5888254,
        size.height * 0.1878435);
    path_52.lineTo(size.width * 0.5859545, size.height * 0.1875911);
    path_52.cubicTo(
        size.width * 0.5799450,
        size.height * 0.1870678,
        size.width * 0.5769402,
        size.height * 0.1854042,
        size.width * 0.5769402,
        size.height * 0.1826005);
    path_52.cubicTo(
        size.width * 0.5769402,
        size.height * 0.1809743,
        size.width * 0.5782033,
        size.height * 0.1797126,
        size.width * 0.5807297,
        size.height * 0.1788154);
    path_52.cubicTo(
        size.width * 0.5832560,
        size.height * 0.1779182,
        size.width * 0.5866627,
        size.height * 0.1774696,
        size.width * 0.5909498,
        size.height * 0.1774696);
    path_52.cubicTo(
        size.width * 0.5957344,
        size.height * 0.1774696,
        size.width * 0.5997727,
        size.height * 0.1778621,
        size.width * 0.6030646,
        size.height * 0.1786472);
    path_52.lineTo(size.width * 0.6030646, size.height * 0.1825444);
    path_52.lineTo(size.width * 0.5943373, size.height * 0.1825444);
    path_52.lineTo(size.width * 0.5943373, size.height * 0.1822640);
    path_52.cubicTo(
        size.width * 0.5943373,
        size.height * 0.1818902,
        size.width * 0.5940694,
        size.height * 0.1816098,
        size.width * 0.5935335,
        size.height * 0.1814229);
    path_52.cubicTo(
        size.width * 0.5930359,
        size.height * 0.1812173,
        size.width * 0.5922895,
        size.height * 0.1811145,
        size.width * 0.5912943,
        size.height * 0.1811145);
    path_52.cubicTo(
        size.width * 0.5893804,
        size.height * 0.1811145,
        size.width * 0.5884234,
        size.height * 0.1814136,
        size.width * 0.5884234,
        size.height * 0.1820117);
    path_52.cubicTo(
        size.width * 0.5884234,
        size.height * 0.1823294,
        size.width * 0.5886914,
        size.height * 0.1825724,
        size.width * 0.5892273,
        size.height * 0.1827407);
    path_52.cubicTo(
        size.width * 0.5897632,
        size.height * 0.1829089,
        size.width * 0.5907392,
        size.height * 0.1830678,
        size.width * 0.5921555,
        size.height * 0.1832173);
    path_52.lineTo(size.width * 0.5954282, size.height * 0.1835257);
    path_52.cubicTo(
        size.width * 0.5988349,
        size.height * 0.1838435,
        size.width * 0.6012656,
        size.height * 0.1844322,
        size.width * 0.6027201,
        size.height * 0.1852921);
    path_52.cubicTo(
        size.width * 0.6041746,
        size.height * 0.1861519,
        size.width * 0.6049019,
        size.height * 0.1872547,
        size.width * 0.6049019,
        size.height * 0.1886005);
    path_52.cubicTo(
        size.width * 0.6049019,
        size.height * 0.1903014,
        size.width * 0.6036770,
        size.height * 0.1916005,
        size.width * 0.6012273,
        size.height * 0.1924977);
    path_52.cubicTo(
        size.width * 0.5988158,
        size.height * 0.1933949,
        size.width * 0.5953708,
        size.height * 0.1938435,
        size.width * 0.5908923,
        size.height * 0.1938435);
    path_52.close();
    path_52.moveTo(size.width * 0.6079785, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.6079785, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.6169354, size.height * 0.1888528);
    path_52.lineTo(size.width * 0.6169354, size.height * 0.1934509);
    path_52.lineTo(size.width * 0.6079785, size.height * 0.1934509);
    path_52.close();
    path_52.moveTo(size.width * 0.6313541, size.height * 0.1780864);
    path_52.lineTo(size.width * 0.6304928, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.6387033, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.6378421, size.height * 0.1780864);
    path_52.lineTo(size.width * 0.6313541, size.height * 0.1780864);
    path_52.close();
    path_52.moveTo(size.width * 0.6219952, size.height * 0.1780864);
    path_52.lineTo(size.width * 0.6211340, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.6293445, size.height * 0.1716379);
    path_52.lineTo(size.width * 0.6284833, size.height * 0.1780864);
    path_52.lineTo(size.width * 0.6219952, size.height * 0.1780864);
    path_52.close();

    Paint paint_52_fill = Paint()..style = PaintingStyle.fill;
    paint_52_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_52, paint_52_fill);

    Path path_53 = Path();
    path_53.moveTo(size.width * 0.3995335, size.height * 0.6223481);
    path_53.lineTo(size.width * 0.5848062, size.height * 0.6062418);
    path_53.lineTo(size.width * 0.6181842, size.height * 0.8200783);
    path_53.lineTo(size.width * 0.4999737, size.height * 0.8303551);
    path_53.lineTo(size.width * 0.3995335, size.height * 0.6223481);
    path_53.close();

    Paint paint_53_fill = Paint()..style = PaintingStyle.fill;
    paint_53_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4921699, size.height * 0.6142956),
        Offset(size.width * 0.5687632, size.height * 0.8243738),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_53, paint_53_fill);

    Path path_54 = Path();
    path_54.moveTo(size.width * 0.8543349, size.height * 0.6110584);
    path_54.lineTo(size.width * 0.6668086, size.height * 0.6037336);
    path_54.lineTo(size.width * 0.6746340, size.height * 0.8181717);
    path_54.lineTo(size.width * 0.7942847, size.height * 0.8228458);
    path_54.lineTo(size.width * 0.8543349, size.height * 0.6110584);
    path_54.close();

    Paint paint_54_fill = Paint()..style = PaintingStyle.fill;
    paint_54_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.7605718, size.height * 0.6073960),
        Offset(size.width * 0.7257177, size.height * 0.8201671),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_54, paint_54_fill);

    Path path_55 = Path();
    path_55.moveTo(size.width * 0.3667057, size.height * 0.6559603);
    path_55.lineTo(size.width * 0.2146543, size.height * 0.6846764);
    path_55.lineTo(size.width * 0.3534904, size.height * 0.8531507);
    path_55.lineTo(size.width * 0.4505024, size.height * 0.8348283);
    path_55.lineTo(size.width * 0.3667057, size.height * 0.6559603);
    path_55.close();

    Paint paint_55_fill = Paint()..style = PaintingStyle.fill;
    paint_55_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.2906794, size.height * 0.6703189),
        Offset(size.width * 0.4248158, size.height * 0.8396799),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_55, paint_55_fill);

    Path path_56 = Path();
    path_56.moveTo(size.width * 0.8997751, size.height * 0.6436367);
    path_56.lineTo(size.width * 1.056653, size.height * 0.6650759);
    path_56.lineTo(size.width * 0.9507895, size.height * 0.8393143);
    path_56.lineTo(size.width * 0.8506962, size.height * 0.8256355);
    path_56.lineTo(size.width * 0.8997751, size.height * 0.6436367);
    path_56.close();

    Paint paint_56_fill = Paint()..style = PaintingStyle.fill;
    paint_56_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.9782153, size.height * 0.6543563),
        Offset(size.width * 0.8779187, size.height * 0.8293551),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_56, paint_56_fill);

    Path path_57 = Path();
    path_57.moveTo(size.width * 0.2278713, size.height * 0.7393867);
    path_57.lineTo(size.width * 0.1281675, size.height * 0.7704276);
    path_57.lineTo(size.width * 0.2658828, size.height * 0.8790397);
    path_57.lineTo(size.width * 0.3294976, size.height * 0.8592348);
    path_57.lineTo(size.width * 0.2278713, size.height * 0.7393867);
    path_57.close();

    Paint paint_57_fill = Paint()..style = PaintingStyle.fill;
    paint_57_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.1780194, size.height * 0.7549077),
        Offset(size.width * 0.3186411, size.height * 0.8626133),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_57, paint_57_fill);

    Path path_58 = Path();
    path_58.moveTo(size.width * 1.076895, size.height * 0.7202150);
    path_58.lineTo(size.width * 1.182108, size.height * 0.7464287);
    path_58.lineTo(size.width * 1.065868, size.height * 0.8610222);
    path_58.lineTo(size.width * 0.9987392, size.height * 0.8442979);
    path_58.lineTo(size.width * 1.076895, size.height * 0.7202150);
    path_58.close();

    Paint paint_58_fill = Paint()..style = PaintingStyle.fill;
    paint_58_fill.shader = ui.Gradient.linear(
        Offset(size.width * 1.129502, size.height * 0.7333213),
        Offset(size.width * 1.010490, size.height * 0.8472255),
        [const Color(0xffFFDF6E).withOpacity(0), const Color(0xffFFCD1B).withOpacity(0.5)],
        [0, 1]);
    canvas.drawPath(path_58, paint_58_fill);

    Path path_59 = Path();
    path_59.moveTo(size.width * 1.037337, size.height * 0.8506612);
    path_59.cubicTo(
        size.width * 1.057280,
        size.height * 0.8292278,
        size.width * 1.067254,
        size.height * 0.8185117,
        size.width * 1.059519,
        size.height * 0.8116495);
    path_59.cubicTo(
        size.width * 1.051782,
        size.height * 0.8047874,
        size.width * 1.030313,
        size.height * 0.8031741,
        size.width * 0.9873732,
        size.height * 0.7999486);
    path_59.lineTo(size.width * 0.9436411, size.height * 0.7966647);
    path_59.cubicTo(
        size.width * 0.9147201,
        size.height * 0.7944918,
        size.width * 0.9002584,
        size.height * 0.7934054,
        size.width * 0.8902344,
        size.height * 0.7971402);
    path_59.cubicTo(
        size.width * 0.8802081,
        size.height * 0.8008762,
        size.width * 0.8785359,
        size.height * 0.8079731,
        size.width * 0.8751866,
        size.height * 0.8221682);
    path_59.lineTo(size.width * 0.8614952, size.height * 0.8802243);
    path_59.cubicTo(
        size.width * 0.8581483,
        size.height * 0.8944194,
        size.width * 0.8564737,
        size.height * 0.9015175,
        size.width * 0.8644187,
        size.height * 0.9066016);
    path_59.cubicTo(
        size.width * 0.8723636,
        size.height * 0.9116869,
        size.width * 0.8868230,
        size.height * 0.9127722,
        size.width * 0.9157440,
        size.height * 0.9149451);
    path_59.lineTo(size.width * 0.9589187, size.height * 0.9181881);
    path_59.cubicTo(
        size.width * 1.001923,
        size.height * 0.9214182,
        size.width * 1.023426,
        size.height * 0.9230327,
        size.width * 1.034067,
        size.height * 0.9175993);
    path_59.cubicTo(
        size.width * 1.044706,
        size.height * 0.9121659,
        size.width * 1.040199,
        size.height * 0.9002383,
        size.width * 1.031184,
        size.height * 0.8763832);
    path_59.cubicTo(
        size.width * 1.029045,
        size.height * 0.8707196,
        size.width * 1.028134,
        size.height * 0.8657196,
        size.width * 1.029294,
        size.height * 0.8621811);
    path_59.cubicTo(
        size.width * 1.030333,
        size.height * 0.8590164,
        size.width * 1.033270,
        size.height * 0.8550304,
        size.width * 1.037337,
        size.height * 0.8506612);
    path_59.close();

    Paint paint_59_fill = Paint()..style = PaintingStyle.fill;
    paint_59_fill.shader = ui.Gradient.linear(
        Offset(size.width * 1.007328, size.height * 0.7321624),
        Offset(size.width * 0.9629665, size.height * 0.8580023),
        [const Color(0xffFFCF25).withOpacity(1), const Color(0xffFD8C43).withOpacity(1)],
        [0, 1]);
    canvas.drawPath(path_59, paint_59_fill);

    Path path_60 = Path();
    path_60.moveTo(size.width * 0.1557321, size.height * 0.8449112);
    path_60.cubicTo(
        size.width * 0.1538955,
        size.height * 0.8235105,
        size.width * 0.1529773,
        size.height * 0.8128096,
        size.width * 0.1664469,
        size.height * 0.8041250);
    path_60.cubicTo(
        size.width * 0.1799165,
        size.height * 0.7954404,
        size.width * 0.1996615,
        size.height * 0.7931565,
        size.width * 0.2391512,
        size.height * 0.7885900);
    path_60.cubicTo(
        size.width * 0.3023684,
        size.height * 0.7812804,
        size.width * 0.3967392,
        size.height * 0.7729276,
        size.width * 0.5115670,
        size.height * 0.7705783);
    path_60.cubicTo(
        size.width * 0.6263947,
        size.height * 0.7682278,
        size.width * 0.7218684,
        size.height * 0.7726963,
        size.width * 0.7861148,
        size.height * 0.7773984);
    path_60.cubicTo(
        size.width * 0.8262488,
        size.height * 0.7803353,
        size.width * 0.8463158,
        size.height * 0.7818037,
        size.width * 0.8612249,
        size.height * 0.7899077);
    path_60.cubicTo(
        size.width * 0.8761364,
        size.height * 0.7980117,
        size.width * 0.8770526,
        size.height * 0.8087126,
        size.width * 0.8788900,
        size.height * 0.8301145);
    path_60.lineTo(size.width * 0.8838038, size.height * 0.8873890);
    path_60.cubicTo(
        size.width * 0.8865407,
        size.height * 0.9192804,
        size.width * 0.8879091,
        size.height * 0.9352255,
        size.width * 0.8682464,
        size.height * 0.9446624);
    path_60.cubicTo(
        size.width * 0.8485837,
        size.height * 0.9540993,
        size.width * 0.8155215,
        size.height * 0.9531414,
        size.width * 0.7493923,
        size.height * 0.9512266);
    path_60.cubicTo(
        size.width * 0.6733182,
        size.height * 0.9490245,
        size.width * 0.5835239,
        size.height * 0.9471308,
        size.width * 0.5268158,
        size.height * 0.9482909);
    path_60.cubicTo(
        size.width * 0.4701100,
        size.height * 0.9494509,
        size.width * 0.3809545,
        size.height * 0.9550070,
        size.width * 0.3055239,
        size.height * 0.9603096);
    path_60.cubicTo(
        size.width * 0.2399569,
        size.height * 0.9649194,
        size.width * 0.2071727,
        size.height * 0.9672231,
        size.width * 0.1859622,
        size.height * 0.9586238);
    path_60.cubicTo(
        size.width * 0.1647517,
        size.height * 0.9500234,
        size.width * 0.1633833,
        size.height * 0.9340771,
        size.width * 0.1606467,
        size.height * 0.9021857);
    path_60.lineTo(size.width * 0.1557321, size.height * 0.8449112);
    path_60.close();

    Paint paint_60_fill = Paint()..style = PaintingStyle.fill;
    paint_60_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.5029689, size.height * 0.6703785),
        Offset(size.width * 0.5203278, size.height * 0.8726682),
        [const Color(0xffFFCF25).withOpacity(1), const Color(0xffFD8C43).withOpacity(1)],
        [0, 1]);
    canvas.drawPath(path_60, paint_60_fill);

    Path path_61 = Path();
    path_61.moveTo(size.width * 0.5011029, size.height * 0.7032874);
    path_61.cubicTo(
        size.width * 0.5090885,
        size.height * 0.6874311,
        size.width * 0.5130813,
        size.height * 0.6795023,
        size.width * 0.5210191,
        size.height * 0.6780444);
    path_61.cubicTo(
        size.width * 0.5242392,
        size.height * 0.6774521,
        size.width * 0.5277656,
        size.height * 0.6773797,
        size.width * 0.5310766,
        size.height * 0.6778388);
    path_61.cubicTo(
        size.width * 0.5392344,
        size.height * 0.6789673,
        size.width * 0.5445718,
        size.height * 0.6867044,
        size.width * 0.5552464,
        size.height * 0.7021799);
    path_61.cubicTo(
        size.width * 0.5580311,
        size.height * 0.7062150,
        size.width * 0.5594234,
        size.height * 0.7082325,
        size.width * 0.5623038,
        size.height * 0.7095724);
    path_61.cubicTo(
        size.width * 0.5635431,
        size.height * 0.7101484,
        size.width * 0.5649617,
        size.height * 0.7106250,
        size.width * 0.5665072,
        size.height * 0.7109825);
    path_61.cubicTo(
        size.width * 0.5701029,
        size.height * 0.7118154,
        size.width * 0.5744593,
        size.height * 0.7117266,
        size.width * 0.5831699,
        size.height * 0.7115479);
    path_61.lineTo(size.width * 0.5844522, size.height * 0.7115222);
    path_61.cubicTo(
        size.width * 0.6166818,
        size.height * 0.7108621,
        size.width * 0.6327967,
        size.height * 0.7105327,
        size.width * 0.6377536,
        size.height * 0.7144311);
    path_61.cubicTo(
        size.width * 0.6387368,
        size.height * 0.7152033,
        size.width * 0.6394378,
        size.height * 0.7160526,
        size.width * 0.6398254,
        size.height * 0.7169428);
    path_61.cubicTo(
        size.width * 0.6417823,
        size.height * 0.7214299,
        size.width * 0.6296962,
        size.height * 0.7266460,
        size.width * 0.6055239,
        size.height * 0.7370759);
    path_61.lineTo(size.width * 0.6005502, size.height * 0.7392220);
    path_61.cubicTo(
        size.width * 0.5935670,
        size.height * 0.7422348,
        size.width * 0.5900766,
        size.height * 0.7437418,
        size.width * 0.5887105,
        size.height * 0.7457593);
    path_61.cubicTo(
        size.width * 0.5885144,
        size.height * 0.7460479,
        size.width * 0.5883541,
        size.height * 0.7463411,
        size.width * 0.5882297,
        size.height * 0.7466390);
    path_61.cubicTo(
        size.width * 0.5873517,
        size.height * 0.7487208,
        size.width * 0.5888397,
        size.height * 0.7508762,
        size.width * 0.5918134,
        size.height * 0.7551893);
    path_61.lineTo(size.width * 0.5947225, size.height * 0.7594054);
    path_61.cubicTo(
        size.width * 0.6043517,
        size.height * 0.7733645,
        size.width * 0.6091651,
        size.height * 0.7803435,
        size.width * 0.6047177,
        size.height * 0.7835643);
    path_61.cubicTo(
        size.width * 0.6025981,
        size.height * 0.7851005,
        size.width * 0.5994354,
        size.height * 0.7862208,
        size.width * 0.5957895,
        size.height * 0.7867290);
    path_61.cubicTo(
        size.width * 0.5881388,
        size.height * 0.7877956,
        size.width * 0.5760431,
        size.height * 0.7833984,
        size.width * 0.5518469,
        size.height * 0.7746028);
    path_61.cubicTo(
        size.width * 0.5446196,
        size.height * 0.7719743,
        size.width * 0.5410048,
        size.height * 0.7706612,
        size.width * 0.5369928,
        size.height * 0.7703727);
    path_61.cubicTo(
        size.width * 0.5349880,
        size.height * 0.7702278,
        size.width * 0.5329474,
        size.height * 0.7702699,
        size.width * 0.5309761,
        size.height * 0.7704953);
    path_61.cubicTo(
        size.width * 0.5270263,
        size.height * 0.7709474,
        size.width * 0.5236507,
        size.height * 0.7724042,
        size.width * 0.5168971,
        size.height * 0.7753178);
    path_61.cubicTo(
        size.width * 0.4942943,
        size.height * 0.7850713,
        size.width * 0.4829928,
        size.height * 0.7899474,
        size.width * 0.4751866,
        size.height * 0.7891974);
    path_61.cubicTo(
        size.width * 0.4714665,
        size.height * 0.7888400,
        size.width * 0.4681244,
        size.height * 0.7878516,
        size.width * 0.4657488,
        size.height * 0.7864089);
    path_61.cubicTo(
        size.width * 0.4607656,
        size.height * 0.7833797,
        size.width * 0.4643660,
        size.height * 0.7762290,
        size.width * 0.4715694,
        size.height * 0.7619252);
    path_61.lineTo(size.width * 0.4737464, size.height * 0.7576051);
    path_61.cubicTo(
        size.width * 0.4759713,
        size.height * 0.7531857,
        size.width * 0.4770837,
        size.height * 0.7509766,
        size.width * 0.4758541,
        size.height * 0.7489393);
    path_61.cubicTo(
        size.width * 0.4756770,
        size.height * 0.7486472,
        size.width * 0.4754665,
        size.height * 0.7483610,
        size.width * 0.4752225,
        size.height * 0.7480818);
    path_61.cubicTo(
        size.width * 0.4735167,
        size.height * 0.7461262,
        size.width * 0.4697799,
        size.height * 0.7447675,
        size.width * 0.4623038,
        size.height * 0.7420502);
    path_61.lineTo(size.width * 0.4569809, size.height * 0.7401145);
    path_61.cubicTo(
        size.width * 0.4311077,
        size.height * 0.7307091,
        size.width * 0.4181699,
        size.height * 0.7260058,
        size.width * 0.4193493,
        size.height * 0.7214533);
    path_61.cubicTo(
        size.width * 0.4195837,
        size.height * 0.7205514,
        size.width * 0.4201364,
        size.height * 0.7196764,
        size.width * 0.4209833,
        size.height * 0.7188657);
    path_61.cubicTo(
        size.width * 0.4252560,
        size.height * 0.7147792,
        size.width * 0.4413708,
        size.height * 0.7144498,
        size.width * 0.4736005,
        size.height * 0.7137909);
    path_61.lineTo(size.width * 0.4748828, size.height * 0.7137640);
    path_61.cubicTo(
        size.width * 0.4835933,
        size.height * 0.7135853,
        size.width * 0.4879498,
        size.height * 0.7134965,
        size.width * 0.4913900,
        size.height * 0.7125199);
    path_61.cubicTo(
        size.width * 0.4928684,
        size.height * 0.7120993,
        size.width * 0.4942010,
        size.height * 0.7115678,
        size.width * 0.4953373,
        size.height * 0.7109428);
    path_61.cubicTo(
        size.width * 0.4979785,
        size.height * 0.7094895,
        size.width * 0.4990191,
        size.height * 0.7074217,
        size.width * 0.5011029,
        size.height * 0.7032874);
    path_61.close();

    Paint paint_61_fill = Paint()..style = PaintingStyle.fill;
    paint_61_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.5262249, size.height * 0.6800140),
        Offset(size.width * 0.5340287, size.height * 0.7709533),
        [const Color(0xffFFF2C2).withOpacity(1), const Color(0xffFFCF25).withOpacity(1)],
        [0, 1]);
    canvas.drawPath(path_61, paint_61_fill);

    Path path_62 = Path();
    path_62.moveTo(size.width * 0.7275455, size.height * 0.7311834);
    path_62.cubicTo(
        size.width * 0.7350455,
        size.height * 0.7225748,
        size.width * 0.7387967,
        size.height * 0.7182710,
        size.width * 0.7433110,
        size.height * 0.7175386);
    path_62.cubicTo(
        size.width * 0.7465981,
        size.height * 0.7170058,
        size.width * 0.7502584,
        size.height * 0.7172804,
        size.width * 0.7531818,
        size.height * 0.7182804);
    path_62.cubicTo(
        size.width * 0.7572010,
        size.height * 0.7196530,
        size.width * 0.7588254,
        size.height * 0.7243610,
        size.width * 0.7620766,
        size.height * 0.7337769);
    path_62.cubicTo(
        size.width * 0.7629282,
        size.height * 0.7362488,
        size.width * 0.7633565,
        size.height * 0.7374848,
        size.width * 0.7646148,
        size.height * 0.7384556);
    path_62.cubicTo(
        size.width * 0.7655598,
        size.height * 0.7391846,
        size.width * 0.7668301,
        size.height * 0.7397991,
        size.width * 0.7683230,
        size.height * 0.7402535);
    path_62.cubicTo(
        size.width * 0.7703134,
        size.height * 0.7408575,
        size.width * 0.7728230,
        size.height * 0.7410456,
        size.width * 0.7778445,
        size.height * 0.7414229);
    path_62.lineTo(size.width * 0.7786124, size.height * 0.7414813);
    path_62.cubicTo(
        size.width * 0.7973206,
        size.height * 0.7428855,
        size.width * 0.8066746,
        size.height * 0.7435888,
        size.width * 0.8094928,
        size.height * 0.7458773);
    path_62.cubicTo(
        size.width * 0.8107919,
        size.height * 0.7469334,
        size.width * 0.8113541,
        size.height * 0.7481600,
        size.width * 0.8110909,
        size.height * 0.7493633);
    path_62.cubicTo(
        size.width * 0.8105191,
        size.height * 0.7519720,
        size.width * 0.8025574,
        size.height * 0.7543072,
        size.width * 0.7866340,
        size.height * 0.7589766);
    path_62.lineTo(size.width * 0.7832656, size.height * 0.7599638);
    path_62.cubicTo(
        size.width * 0.7786388,
        size.height * 0.7613213,
        size.width * 0.7763254,
        size.height * 0.7619988,
        size.width * 0.7749856,
        size.height * 0.7630386);
    path_62.cubicTo(
        size.width * 0.7744522,
        size.height * 0.7634521,
        size.width * 0.7740407,
        size.height * 0.7639019,
        size.width * 0.7737584,
        size.height * 0.7643750);
    path_62.cubicTo(
        size.width * 0.7730502,
        size.height * 0.7655654,
        size.width * 0.7735120,
        size.height * 0.7669030,
        size.width * 0.7744354,
        size.height * 0.7695783);
    path_62.lineTo(size.width * 0.7753612, size.height * 0.7722558);
    path_62.cubicTo(
        size.width * 0.7783014,
        size.height * 0.7807722,
        size.width * 0.7797703,
        size.height * 0.7850304,
        size.width * 0.7771938,
        size.height * 0.7868143);
    path_62.cubicTo(
        size.width * 0.7750885,
        size.height * 0.7882734,
        size.width * 0.7716053,
        size.height * 0.7890900,
        size.width * 0.7679115,
        size.height * 0.7889907);
    path_62.cubicTo(
        size.width * 0.7633923,
        size.height * 0.7888692,
        size.width * 0.7572847,
        size.height * 0.7856974,
        size.width * 0.7450694,
        size.height * 0.7793551);
    path_62.cubicTo(
        size.width * 0.7414282,
        size.height * 0.7774638,
        size.width * 0.7396077,
        size.height * 0.7765175,
        size.width * 0.7374402,
        size.height * 0.7760537);
    path_62.cubicTo(
        size.width * 0.7356268,
        size.height * 0.7756671,
        size.width * 0.7336579,
        size.height * 0.7755187,
        size.width * 0.7317297,
        size.height * 0.7756250);
    path_62.cubicTo(
        size.width * 0.7294234,
        size.height * 0.7757523,
        size.width * 0.7272273,
        size.height * 0.7763972,
        size.width * 0.7228349,
        size.height * 0.7776846);
    path_62.cubicTo(
        size.width * 0.7081053,
        size.height * 0.7820035,
        size.width * 0.7007416,
        size.height * 0.7841636,
        size.width * 0.6963230,
        size.height * 0.7836133);
    path_62.cubicTo(
        size.width * 0.6927105,
        size.height * 0.7831636,
        size.width * 0.6897273,
        size.height * 0.7818610,
        size.width * 0.6883708,
        size.height * 0.7801425);
    path_62.cubicTo(
        size.width * 0.6867105,
        size.height * 0.7780409,
        size.width * 0.6901029,
        size.height * 0.7741472,
        size.width * 0.6968900,
        size.height * 0.7663610);
    path_62.lineTo(size.width * 0.6990215, size.height * 0.7639136);
    path_62.cubicTo(
        size.width * 0.7011531,
        size.height * 0.7614673,
        size.width * 0.7022201,
        size.height * 0.7602442,
        size.width * 0.7020885,
        size.height * 0.7589907);
    path_62.cubicTo(
        size.width * 0.7020359,
        size.height * 0.7584930,
        size.width * 0.7018469,
        size.height * 0.7579988,
        size.width * 0.7015239,
        size.height * 0.7575210);
    path_62.cubicTo(
        size.width * 0.7007105,
        size.height * 0.7563189,
        size.width * 0.6987919,
        size.height * 0.7553236,
        size.width * 0.6949569,
        size.height * 0.7533306);
    path_62.lineTo(size.width * 0.6921627, size.height * 0.7518808);
    path_62.cubicTo(
        size.width * 0.6789569,
        size.height * 0.7450234,
        size.width * 0.6723565,
        size.height * 0.7415946,
        size.width * 0.6730120,
        size.height * 0.7389918);
    path_62.cubicTo(
        size.width * 0.6733158,
        size.height * 0.7377921,
        size.width * 0.6744258,
        size.height * 0.7366904,
        size.width * 0.6761699,
        size.height * 0.7358633);
    path_62.cubicTo(
        size.width * 0.6799498,
        size.height * 0.7340701,
        size.width * 0.6893038,
        size.height * 0.7347722,
        size.width * 0.7080144,
        size.height * 0.7361776);
    path_62.lineTo(size.width * 0.7087823, size.height * 0.7362360);
    path_62.cubicTo(
        size.width * 0.7138038,
        size.height * 0.7366133,
        size.width * 0.7163134,
        size.height * 0.7368014,
        size.width * 0.7185144,
        size.height * 0.7365117);
    path_62.cubicTo(
        size.width * 0.7201651,
        size.height * 0.7362944,
        size.width * 0.7216770,
        size.height * 0.7358879,
        size.width * 0.7229258,
        size.height * 0.7353236);
    path_62.cubicTo(
        size.width * 0.7245909,
        size.height * 0.7345724,
        size.width * 0.7255766,
        size.height * 0.7334428,
        size.width * 0.7275455,
        size.height * 0.7311834);
    path_62.close();

    Paint paint_62_fill = Paint()..style = PaintingStyle.fill;
    paint_62_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.7482201, size.height * 0.7180269),
        Offset(size.width * 0.7300694, size.height * 0.7756449),
        [const Color(0xffFFF2C2).withOpacity(1), const Color(0xffFFCF25).withOpacity(1)],
        [0, 1]);
    canvas.drawPath(path_62, paint_62_fill);

    Path path_63 = Path();
    path_63.moveTo(size.width * 0.3337751, size.height * 0.7383376);
    path_63.cubicTo(
        size.width * 0.3248230,
        size.height * 0.7300654,
        size.width * 0.3203493,
        size.height * 0.7259299,
        size.width * 0.3157249,
        size.height * 0.7253843);
    path_63.cubicTo(
        size.width * 0.3123589,
        size.height * 0.7249871,
        size.width * 0.3087584,
        size.height * 0.7254100,
        size.width * 0.3060167,
        size.height * 0.7265257);
    path_63.cubicTo(
        size.width * 0.3022488,
        size.height * 0.7280584,
        size.width * 0.3014354,
        size.height * 0.7328166,
        size.width * 0.2998086,
        size.height * 0.7423329);
    path_63.cubicTo(
        size.width * 0.2993828,
        size.height * 0.7448294,
        size.width * 0.2991675,
        size.height * 0.7460783,
        size.width * 0.2980789,
        size.height * 0.7470981);
    path_63.cubicTo(
        size.width * 0.2972632,
        size.height * 0.7478621,
        size.width * 0.2961029,
        size.height * 0.7485280,
        size.width * 0.2946938,
        size.height * 0.7490409);
    path_63.cubicTo(
        size.width * 0.2928134,
        size.height * 0.7497243,
        size.width * 0.2903445,
        size.height * 0.7500140,
        size.width * 0.2854043,
        size.height * 0.7505958);
    path_63.lineTo(size.width * 0.2846507, size.height * 0.7506846);
    path_63.cubicTo(
        size.width * 0.2662464,
        size.height * 0.7528493,
        size.width * 0.2570455,
        size.height * 0.7539311,
        size.width * 0.2546316,
        size.height * 0.7563271);
    path_63.cubicTo(
        size.width * 0.2535167,
        size.height * 0.7574322,
        size.width * 0.2531675,
        size.height * 0.7586787,
        size.width * 0.2536364,
        size.height * 0.7598668);
    path_63.cubicTo(
        size.width * 0.2546531,
        size.height * 0.7624428,
        size.width * 0.2629856,
        size.height * 0.7644439,
        size.width * 0.2796555,
        size.height * 0.7684463);
    path_63.lineTo(size.width * 0.2831794, size.height * 0.7692932);
    path_63.cubicTo(
        size.width * 0.2880215,
        size.height * 0.7704556,
        size.width * 0.2904426,
        size.height * 0.7710374,
        size.width * 0.2919569,
        size.height * 0.7720187);
    path_63.cubicTo(
        size.width * 0.2925598,
        size.height * 0.7724089,
        size.width * 0.2930478,
        size.height * 0.7728400,
        size.width * 0.2934091,
        size.height * 0.7732991);
    path_63.cubicTo(
        size.width * 0.2943182,
        size.height * 0.7744568,
        size.width * 0.2940861,
        size.height * 0.7758084,
        size.width * 0.2936244,
        size.height * 0.7785117);
    path_63.lineTo(size.width * 0.2931627, size.height * 0.7812185);
    path_63.cubicTo(
        size.width * 0.2916914,
        size.height * 0.7898248,
        size.width * 0.2909569,
        size.height * 0.7941285,
        size.width * 0.2938301,
        size.height * 0.7958014);
    path_63.cubicTo(
        size.width * 0.2961770,
        size.height * 0.7971682,
        size.width * 0.2997871,
        size.height * 0.7978400,
        size.width * 0.3034522,
        size.height * 0.7975900);
    path_63.cubicTo(
        size.width * 0.3079354,
        size.height * 0.7972850,
        size.width * 0.3134785,
        size.height * 0.7938750,
        size.width * 0.3245622,
        size.height * 0.7870549);
    path_63.cubicTo(
        size.width * 0.3278684,
        size.height * 0.7850222,
        size.width * 0.3295215,
        size.height * 0.7840047,
        size.width * 0.3316005,
        size.height * 0.7834544);
    path_63.cubicTo(
        size.width * 0.3333397,
        size.height * 0.7829942,
        size.width * 0.3352775,
        size.height * 0.7827664,
        size.width * 0.3372177,
        size.height * 0.7827932);
    path_63.cubicTo(
        size.width * 0.3395383,
        size.height * 0.7828271,
        size.width * 0.3418373,
        size.height * 0.7833785,
        size.width * 0.3464354,
        size.height * 0.7844825);
    path_63.cubicTo(
        size.width * 0.3618517,
        size.height * 0.7881846,
        size.width * 0.3695598,
        size.height * 0.7900362,
        size.width * 0.3738684,
        size.height * 0.7893072);
    path_63.cubicTo(
        size.width * 0.3773923,
        size.height * 0.7887114,
        size.width * 0.3801411,
        size.height * 0.7872921,
        size.width * 0.3811986,
        size.height * 0.7855245);
    path_63.cubicTo(
        size.width * 0.3824928,
        size.height * 0.7833610,
        size.width * 0.3784450,
        size.height * 0.7796203,
        size.width * 0.3703493,
        size.height * 0.7721390);
    path_63.lineTo(size.width * 0.3678038, size.height * 0.7697874);
    path_63.cubicTo(
        size.width * 0.3652608,
        size.height * 0.7674369,
        size.width * 0.3639904,
        size.height * 0.7662617,
        size.width * 0.3639067,
        size.height * 0.7650070);
    path_63.cubicTo(
        size.width * 0.3638732,
        size.height * 0.7645093,
        size.width * 0.3639761,
        size.height * 0.7640082,
        size.width * 0.3642177,
        size.height * 0.7635199);
    path_63.cubicTo(
        size.width * 0.3648206,
        size.height * 0.7622886,
        size.width * 0.3665622,
        size.height * 0.7612173,
        size.width * 0.3700431,
        size.height * 0.7590748);
    path_63.lineTo(size.width * 0.3725766, size.height * 0.7575164);
    path_63.cubicTo(
        size.width * 0.3845622,
        size.height * 0.7501437,
        size.width * 0.3905550,
        size.height * 0.7464568,
        size.width * 0.3894545,
        size.height * 0.7438902);
    path_63.cubicTo(
        size.width * 0.3889450,
        size.height * 0.7427068,
        size.width * 0.3876507,
        size.height * 0.7416554,
        size.width * 0.3857703,
        size.height * 0.7409019);
    path_63.cubicTo(
        size.width * 0.3816962,
        size.height * 0.7392687,
        size.width * 0.3724952,
        size.height * 0.7403516,
        size.width * 0.3540933,
        size.height * 0.7425164);
    path_63.lineTo(size.width * 0.3533373, size.height * 0.7426051);
    path_63.cubicTo(
        size.width * 0.3483971,
        size.height * 0.7431857,
        size.width * 0.3459282,
        size.height * 0.7434766,
        size.width * 0.3436866,
        size.height * 0.7432780);
    path_63.cubicTo(
        size.width * 0.3420048,
        size.height * 0.7431285,
        size.width * 0.3404282,
        size.height * 0.7427850,
        size.width * 0.3390861,
        size.height * 0.7422745);
    path_63.cubicTo(
        size.width * 0.3372990,
        size.height * 0.7415935,
        size.width * 0.3361244,
        size.height * 0.7405082,
        size.width * 0.3337751,
        size.height * 0.7383376);
    path_63.close();

    Paint paint_63_fill = Paint()..style = PaintingStyle.fill;
    paint_63_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.3109187, size.height * 0.7260713),
        Offset(size.width * 0.3388756, size.height * 0.7827453),
        [const Color(0xffFFF2C2).withOpacity(1), const Color(0xffFFCF25).withOpacity(1)],
        [0, 1]);
    canvas.drawPath(path_63, paint_63_fill);

    Paint paint_64_fill = Paint()..style = PaintingStyle.fill;
    paint_64_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.6854067, size.height * 0.6670561),
            width: size.width * 0.1172249,
            height: size.height * 0.05607477),
        paint_64_fill);

    Path path_65 = Path();
    path_65.moveTo(size.width * 0.7004330, size.height * 0.6655467);
    path_65.cubicTo(
        size.width * 0.7022129,
        size.height * 0.6657710,
        size.width * 0.7039067,
        size.height * 0.6662336,
        size.width * 0.7055144,
        size.height * 0.6669346);
    path_65.cubicTo(
        size.width * 0.7071794,
        size.height * 0.6676075,
        size.width * 0.7085287,
        size.height * 0.6684626,
        size.width * 0.7095622,
        size.height * 0.6695000);
    path_65.cubicTo(
        size.width * 0.7106531,
        size.height * 0.6705374,
        size.width * 0.7111986,
        size.height * 0.6716869,
        size.width * 0.7111986,
        size.height * 0.6729486);
    path_65.cubicTo(
        size.width * 0.7111986,
        size.height * 0.6760327,
        size.width * 0.7089306,
        size.height * 0.6784579,
        size.width * 0.7043947,
        size.height * 0.6802243);
    path_65.cubicTo(
        size.width * 0.6999163,
        size.height * 0.6819626,
        size.width * 0.6932560,
        size.height * 0.6828318,
        size.width * 0.6844139,
        size.height * 0.6828318);
    path_65.cubicTo(
        size.width * 0.6802225,
        size.height * 0.6828318,
        size.width * 0.6760311,
        size.height * 0.6826075,
        size.width * 0.6718397,
        size.height * 0.6821589);
    path_65.cubicTo(
        size.width * 0.6676483,
        size.height * 0.6816822,
        size.width * 0.6639163,
        size.height * 0.6811075,
        size.width * 0.6606435,
        size.height * 0.6804346);
    path_65.lineTo(size.width * 0.6606435, size.height * 0.6714766);
    path_65.cubicTo(
        size.width * 0.6642033,
        size.height * 0.6722336,
        size.width * 0.6678780,
        size.height * 0.6728505,
        size.width * 0.6716675,
        size.height * 0.6733271);
    path_65.cubicTo(
        size.width * 0.6755144,
        size.height * 0.6738037,
        size.width * 0.6791603,
        size.height * 0.6740421,
        size.width * 0.6826053,
        size.height * 0.6740421);
    path_65.cubicTo(
        size.width * 0.6850167,
        size.height * 0.6740421,
        size.width * 0.6867679,
        size.height * 0.6738598,
        size.width * 0.6878589,
        size.height * 0.6734953);
    path_65.cubicTo(
        size.width * 0.6890072,
        size.height * 0.6731308,
        size.width * 0.6895813,
        size.height * 0.6725280,
        size.width * 0.6895813,
        size.height * 0.6716869);
    path_65.cubicTo(
        size.width * 0.6895813,
        size.height * 0.6700607,
        size.width * 0.6875718,
        size.height * 0.6692477,
        size.width * 0.6835526,
        size.height * 0.6692477);
    path_65.lineTo(size.width * 0.6773517, size.height * 0.6692477);
    path_65.lineTo(size.width * 0.6773517, size.height * 0.6623505);
    path_65.lineTo(size.width * 0.6821746, size.height * 0.6623505);
    path_65.cubicTo(
        size.width * 0.6859641,
        size.height * 0.6623505,
        size.width * 0.6878589,
        size.height * 0.6615654,
        size.width * 0.6878589,
        size.height * 0.6599953);
    path_65.cubicTo(
        size.width * 0.6878589,
        size.height * 0.6584813,
        size.width * 0.6859641,
        size.height * 0.6577243,
        size.width * 0.6821746,
        size.height * 0.6577243);
    path_65.cubicTo(
        size.width * 0.6794187,
        size.height * 0.6577243,
        size.width * 0.6765478,
        size.height * 0.6580467,
        size.width * 0.6735622,
        size.height * 0.6586916);
    path_65.cubicTo(
        size.width * 0.6705766,
        size.height * 0.6593084,
        size.width * 0.6676770,
        size.height * 0.6601215,
        size.width * 0.6648636,
        size.height * 0.6611308);
    path_65.lineTo(size.width * 0.6597823, size.height * 0.6521729);
    path_65.cubicTo(
        size.width * 0.6632847,
        size.height * 0.6512757,
        size.width * 0.6672751,
        size.height * 0.6505187,
        size.width * 0.6717536,
        size.height * 0.6499019);
    path_65.cubicTo(
        size.width * 0.6762321,
        size.height * 0.6492570,
        size.width * 0.6807392,
        size.height * 0.6489346,
        size.width * 0.6852751,
        size.height * 0.6489346);
    path_65.cubicTo(
        size.width * 0.6931986,
        size.height * 0.6489346,
        size.width * 0.6992847,
        size.height * 0.6497477,
        size.width * 0.7035335,
        size.height * 0.6513738);
    path_65.cubicTo(
        size.width * 0.7077823,
        size.height * 0.6530000,
        size.width * 0.7099067,
        size.height * 0.6552991,
        size.width * 0.7099067,
        size.height * 0.6582710);
    path_65.cubicTo(
        size.width * 0.7099067,
        size.height * 0.6601215,
        size.width * 0.7090167,
        size.height * 0.6616495,
        size.width * 0.7072368,
        size.height * 0.6628551);
    path_65.cubicTo(
        size.width * 0.7054569,
        size.height * 0.6640327,
        size.width * 0.7031890,
        size.height * 0.6649299,
        size.width * 0.7004330,
        size.height * 0.6655467);
    path_65.close();

    Paint paint_65_fill = Paint()..style = PaintingStyle.fill;
    paint_65_fill.color = const Color(0xffE5D273).withOpacity(0.83);
    canvas.drawPath(path_65, paint_65_fill);

    Paint paint_66_fill = Paint()..style = PaintingStyle.fill;
    paint_66_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.8552632, size.height * 0.4509346),
            width: size.width * 0.1172249,
            height: size.height * 0.05607477),
        paint_66_fill);

    Path path_67 = Path();
    path_67.moveTo(size.width * 0.8365550, size.height * 0.4661215);
    path_67.lineTo(size.width * 0.8365550, size.height * 0.4592243);
    path_67.lineTo(size.width * 0.8448230, size.height * 0.4592243);
    path_67.lineTo(size.width * 0.8448230, size.height * 0.4402991);
    path_67.lineTo(size.width * 0.8339713, size.height * 0.4402991);
    path_67.lineTo(size.width * 0.8339713, size.height * 0.4355467);
    path_67.lineTo(size.width * 0.8530909, size.height * 0.4334019);
    path_67.lineTo(size.width * 0.8675598, size.height * 0.4334019);
    path_67.lineTo(size.width * 0.8675598, size.height * 0.4592243);
    path_67.lineTo(size.width * 0.8747943, size.height * 0.4592243);
    path_67.lineTo(size.width * 0.8747943, size.height * 0.4661215);
    path_67.lineTo(size.width * 0.8365550, size.height * 0.4661215);
    path_67.close();

    Paint paint_67_fill = Paint()..style = PaintingStyle.fill;
    paint_67_fill.color = const Color(0xffC4C4C4).withOpacity(0.83);
    canvas.drawPath(path_67, paint_67_fill);

    Paint paint_68_fill = Paint()..style = PaintingStyle.fill;
    paint_68_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.8552632, size.height * 0.4509346),
            width: size.width * 0.1172249,
            height: size.height * 0.05607477),
        paint_68_fill);

    Path path_69 = Path();
    path_69.moveTo(size.width * 0.8271364, size.height * 0.4625047);
    path_69.cubicTo(
        size.width * 0.8271364,
        size.height * 0.4600935,
        size.width * 0.8278541,
        size.height * 0.4579626,
        size.width * 0.8292895,
        size.height * 0.4561121);
    path_69.cubicTo(
        size.width * 0.8307823,
        size.height * 0.4542617,
        size.width * 0.8331938,
        size.height * 0.4525234,
        size.width * 0.8365239,
        size.height * 0.4508972);
    path_69.cubicTo(
        size.width * 0.8398541,
        size.height * 0.4492430,
        size.width * 0.8444474,
        size.height * 0.4475327,
        size.width * 0.8503038,
        size.height * 0.4457664);
    path_69.cubicTo(
        size.width * 0.8520263,
        size.height * 0.4452336,
        size.width * 0.8532321,
        size.height * 0.4447850,
        size.width * 0.8539211,
        size.height * 0.4444206);
    path_69.cubicTo(
        size.width * 0.8546675,
        size.height * 0.4440280,
        size.width * 0.8550407,
        size.height * 0.4435654,
        size.width * 0.8550407,
        size.height * 0.4430327);
    path_69.cubicTo(
        size.width * 0.8550407,
        size.height * 0.4418832,
        size.width * 0.8533469,
        size.height * 0.4413084,
        size.width * 0.8499593,
        size.height * 0.4413084);
    path_69.cubicTo(
        size.width * 0.8474330,
        size.height * 0.4413084,
        size.width * 0.8445335,
        size.height * 0.4416308,
        size.width * 0.8412608,
        size.height * 0.4422757);
    path_69.cubicTo(
        size.width * 0.8379880,
        size.height * 0.4429206,
        size.width * 0.8350311,
        size.height * 0.4437336,
        size.width * 0.8323900,
        size.height * 0.4447150);
    path_69.lineTo(size.width * 0.8273086, size.height * 0.4357570);
    path_69.cubicTo(
        size.width * 0.8309833,
        size.height * 0.4348598,
        size.width * 0.8352033,
        size.height * 0.4341028,
        size.width * 0.8399689,
        size.height * 0.4334860);
    path_69.cubicTo(
        size.width * 0.8447344,
        size.height * 0.4328411,
        size.width * 0.8495287,
        size.height * 0.4325187,
        size.width * 0.8543517,
        size.height * 0.4325187);
    path_69.cubicTo(
        size.width * 0.8622751,
        size.height * 0.4325187,
        size.width * 0.8684187,
        size.height * 0.4333738,
        size.width * 0.8727823,
        size.height * 0.4350841);
    path_69.cubicTo(
        size.width * 0.8771459,
        size.height * 0.4367944,
        size.width * 0.8793278,
        size.height * 0.4392196,
        size.width * 0.8793278,
        size.height * 0.4423598);
    path_69.cubicTo(
        size.width * 0.8793278,
        size.height * 0.4440421,
        size.width * 0.8785526,
        size.height * 0.4455280,
        size.width * 0.8770024,
        size.height * 0.4468178);
    path_69.cubicTo(
        size.width * 0.8755096,
        size.height * 0.4480794,
        size.width * 0.8736722,
        size.height * 0.4491449,
        size.width * 0.8714904,
        size.height * 0.4500140);
    path_69.cubicTo(
        size.width * 0.8693660,
        size.height * 0.4508832,
        size.width * 0.8665813,
        size.height * 0.4518785,
        size.width * 0.8631364,
        size.height * 0.4530000);
    path_69.cubicTo(
        size.width * 0.8592895,
        size.height * 0.4542336,
        size.width * 0.8564474,
        size.height * 0.4552991,
        size.width * 0.8546100,
        size.height * 0.4561963);
    path_69.cubicTo(
        size.width * 0.8528301,
        size.height * 0.4570654,
        size.width * 0.8519402,
        size.height * 0.4580748,
        size.width * 0.8519402,
        size.height * 0.4592243);
    path_69.lineTo(size.width * 0.8623612, size.height * 0.4592243);
    path_69.lineTo(size.width * 0.8623612, size.height * 0.4568271);
    path_69.lineTo(size.width * 0.8800167, size.height * 0.4568271);
    path_69.lineTo(size.width * 0.8800167, size.height * 0.4661215);
    path_69.lineTo(size.width * 0.8271364, size.height * 0.4661215);
    path_69.lineTo(size.width * 0.8271364, size.height * 0.4625047);
    path_69.close();

    Paint paint_69_fill = Paint()..style = PaintingStyle.fill;
    paint_69_fill.color = const Color(0xff886D6D).withOpacity(0.93);
    canvas.drawPath(path_69, paint_69_fill);

    Path path_70 = Path();
    path_70.moveTo(size.width * 0.2139409, size.height * 0.3276916);
    path_70.cubicTo(
        size.width * 0.2084289,
        size.height * 0.3276916,
        size.width * 0.2032041,
        size.height * 0.3274673,
        size.width * 0.1982663,
        size.height * 0.3270187);
    path_70.cubicTo(
        size.width * 0.1933859,
        size.height * 0.3265421,
        size.width * 0.1896251,
        size.height * 0.3260093,
        size.width * 0.1869840,
        size.height * 0.3254206);
    path_70.lineTo(size.width * 0.1869840, size.height * 0.3170935);
    path_70.lineTo(size.width * 0.2059313, size.height * 0.3170935);
    path_70.cubicTo(
        size.width * 0.2059313,
        size.height * 0.3179626,
        size.width * 0.2063333,
        size.height * 0.3185935,
        size.width * 0.2071371,
        size.height * 0.3189860);
    path_70.cubicTo(
        size.width * 0.2079409,
        size.height * 0.3193785,
        size.width * 0.2094050,
        size.height * 0.3195748,
        size.width * 0.2115294,
        size.height * 0.3195748);
    path_70.cubicTo(
        size.width * 0.2133093,
        size.height * 0.3195748,
        size.width * 0.2145725,
        size.height * 0.3194486,
        size.width * 0.2153189,
        size.height * 0.3191963);
    path_70.cubicTo(
        size.width * 0.2161227,
        size.height * 0.3189159,
        size.width * 0.2165246,
        size.height * 0.3185093,
        size.width * 0.2165246,
        size.height * 0.3179766);
    path_70.cubicTo(
        size.width * 0.2165246,
        size.height * 0.3175280,
        size.width * 0.2161514,
        size.height * 0.3171495,
        size.width * 0.2154050,
        size.height * 0.3168411);
    path_70.cubicTo(
        size.width * 0.2146586,
        size.height * 0.3165047,
        size.width * 0.2133667,
        size.height * 0.3161682,
        size.width * 0.2115294,
        size.height * 0.3158318);
    path_70.lineTo(size.width * 0.2041227, size.height * 0.3145701);
    path_70.cubicTo(
        size.width * 0.1977495,
        size.height * 0.3133925,
        size.width * 0.1931562,
        size.height * 0.3120047,
        size.width * 0.1903428,
        size.height * 0.3104065);
    path_70.cubicTo(
        size.width * 0.1875868,
        size.height * 0.3088084,
        size.width * 0.1862089,
        size.height * 0.3066495,
        size.width * 0.1862089,
        size.height * 0.3039299);
    path_70.cubicTo(
        size.width * 0.1862089,
        size.height * 0.3006215,
        size.width * 0.1884194,
        size.height * 0.2981121,
        size.width * 0.1928404,
        size.height * 0.2964019);
    path_70.cubicTo(
        size.width * 0.1973189,
        size.height * 0.2946636,
        size.width * 0.2047543,
        size.height * 0.2937944,
        size.width * 0.2151467,
        size.height * 0.2937944);
    path_70.cubicTo(
        size.width * 0.2201419,
        size.height * 0.2937944,
        size.width * 0.2248213,
        size.height * 0.2940467,
        size.width * 0.2291849,
        size.height * 0.2945514);
    path_70.cubicTo(
        size.width * 0.2336060,
        size.height * 0.2950280,
        size.width * 0.2371658,
        size.height * 0.2956729,
        size.width * 0.2398636,
        size.height * 0.2964860);
    path_70.lineTo(size.width * 0.2398636, size.height * 0.3040140);
    path_70.lineTo(size.width * 0.2226395, size.height * 0.3040140);
    path_70.cubicTo(
        size.width * 0.2226395,
        size.height * 0.3026121,
        size.width * 0.2208596,
        size.height * 0.3019112,
        size.width * 0.2172998,
        size.height * 0.3019112);
    path_70.cubicTo(
        size.width * 0.2155773,
        size.height * 0.3019112,
        size.width * 0.2143428,
        size.height * 0.3020234,
        size.width * 0.2135964,
        size.height * 0.3022477);
    path_70.cubicTo(
        size.width * 0.2129074,
        size.height * 0.3024439,
        size.width * 0.2125629,
        size.height * 0.3028084,
        size.width * 0.2125629,
        size.height * 0.3033411);
    path_70.cubicTo(
        size.width * 0.2125629,
        size.height * 0.3038178,
        size.width * 0.2129648,
        size.height * 0.3041963,
        size.width * 0.2137687,
        size.height * 0.3044766);
    path_70.cubicTo(
        size.width * 0.2146299,
        size.height * 0.3047570,
        size.width * 0.2160079,
        size.height * 0.3050514,
        size.width * 0.2179026,
        size.height * 0.3053598);
    path_70.lineTo(size.width * 0.2253955, size.height * 0.3066215);
    path_70.cubicTo(
        size.width * 0.2314816,
        size.height * 0.3076308,
        size.width * 0.2359026,
        size.height * 0.3089486,
        size.width * 0.2386586,
        size.height * 0.3105748);
    path_70.cubicTo(
        size.width * 0.2414713,
        size.height * 0.3121729,
        size.width * 0.2428780,
        size.height * 0.3142757,
        size.width * 0.2428780,
        size.height * 0.3168832);
    path_70.cubicTo(
        size.width * 0.2428780,
        size.height * 0.3204439,
        size.width * 0.2404091,
        size.height * 0.3231355,
        size.width * 0.2354720,
        size.height * 0.3249579);
    path_70.cubicTo(
        size.width * 0.2305916,
        size.height * 0.3267804,
        size.width * 0.2234146,
        size.height * 0.3276916,
        size.width * 0.2139409,
        size.height * 0.3276916);
    path_70.close();
    path_70.moveTo(size.width * 0.2544043, size.height * 0.3014065);
    path_70.lineTo(size.width * 0.2544043, size.height * 0.2943832);
    path_70.lineTo(size.width * 0.2719737, size.height * 0.2943832);
    path_70.lineTo(size.width * 0.2719737, size.height * 0.3014065);
    path_70.lineTo(size.width * 0.2544043, size.height * 0.3014065);
    path_70.close();
    path_70.moveTo(size.width * 0.2502703, size.height * 0.3271028);
    path_70.lineTo(size.width * 0.2502703, size.height * 0.3202056);
    path_70.lineTo(size.width * 0.2540598, size.height * 0.3202056);
    path_70.lineTo(size.width * 0.2540598, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.2502703, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.2502703, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.2738684, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.2738684, size.height * 0.3202056);
    path_70.lineTo(size.width * 0.2776579, size.height * 0.3202056);
    path_70.lineTo(size.width * 0.2776579, size.height * 0.3271028);
    path_70.lineTo(size.width * 0.2502703, size.height * 0.3271028);
    path_70.close();
    path_70.moveTo(size.width * 0.3104450, size.height * 0.3370280);
    path_70.cubicTo(
        size.width * 0.3063110,
        size.height * 0.3370280,
        size.width * 0.3023493,
        size.height * 0.3368879,
        size.width * 0.2985598,
        size.height * 0.3366075);
    path_70.cubicTo(
        size.width * 0.2948278,
        size.height * 0.3363271,
        size.width * 0.2919282,
        size.height * 0.3360047,
        size.width * 0.2898612,
        size.height * 0.3356402);
    path_70.lineTo(size.width * 0.2898612, size.height * 0.3287430);
    path_70.cubicTo(
        size.width * 0.2959474,
        size.height * 0.3292757,
        size.width * 0.3014019,
        size.height * 0.3295421,
        size.width * 0.3062249,
        size.height * 0.3295421);
    path_70.cubicTo(
        size.width * 0.3094976,
        size.height * 0.3295421,
        size.width * 0.3118517,
        size.height * 0.3292897,
        size.width * 0.3132871,
        size.height * 0.3287850);
    path_70.cubicTo(
        size.width * 0.3147799,
        size.height * 0.3283084,
        size.width * 0.3155263,
        size.height * 0.3273972,
        size.width * 0.3155263,
        size.height * 0.3260514);
    path_70.lineTo(size.width * 0.3155263, size.height * 0.3242430);
    path_70.cubicTo(
        size.width * 0.3140909,
        size.height * 0.3251402,
        size.width * 0.3122249,
        size.height * 0.3259393,
        size.width * 0.3099282,
        size.height * 0.3266402);
    path_70.cubicTo(
        size.width * 0.3076890,
        size.height * 0.3273411,
        size.width * 0.3051053,
        size.height * 0.3276916,
        size.width * 0.3021770,
        size.height * 0.3276916);
    path_70.cubicTo(
        size.width * 0.2963206,
        size.height * 0.3276916,
        size.width * 0.2918995,
        size.height * 0.3266262,
        size.width * 0.2889139,
        size.height * 0.3244953);
    path_70.cubicTo(
        size.width * 0.2859856,
        size.height * 0.3223645,
        size.width * 0.2845215,
        size.height * 0.3193364,
        size.width * 0.2845215,
        size.height * 0.3154112);
    path_70.cubicTo(
        size.width * 0.2845215,
        size.height * 0.3114860,
        size.width * 0.2859856,
        size.height * 0.3084579,
        size.width * 0.2889139,
        size.height * 0.3063271);
    path_70.cubicTo(
        size.width * 0.2918995,
        size.height * 0.3041963,
        size.width * 0.2963206,
        size.height * 0.3031308,
        size.width * 0.3021770,
        size.height * 0.3031308);
    path_70.cubicTo(
        size.width * 0.3051053,
        size.height * 0.3031308,
        size.width * 0.3076890,
        size.height * 0.3034813,
        size.width * 0.3099282,
        size.height * 0.3041822);
    path_70.cubicTo(
        size.width * 0.3122249,
        size.height * 0.3048832,
        size.width * 0.3140909,
        size.height * 0.3056822,
        size.width * 0.3155263,
        size.height * 0.3065794);
    path_70.lineTo(size.width * 0.3155263, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.3391244, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.3391244, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.3353349, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.3353349, size.height * 0.3254206);
    path_70.cubicTo(
        size.width * 0.3353349,
        size.height * 0.3294860,
        size.width * 0.3332679,
        size.height * 0.3324299,
        size.width * 0.3291340,
        size.height * 0.3342523);
    path_70.cubicTo(
        size.width * 0.3250000,
        size.height * 0.3361028,
        size.width * 0.3187703,
        size.height * 0.3370280,
        size.width * 0.3104450,
        size.height * 0.3370280);
    path_70.close();
    path_70.moveTo(size.width * 0.3105311, size.height * 0.3202056);
    path_70.cubicTo(
        size.width * 0.3121962,
        size.height * 0.3202056,
        size.width * 0.3134306,
        size.height * 0.3199953,
        size.width * 0.3142344,
        size.height * 0.3195748);
    path_70.cubicTo(
        size.width * 0.3150957,
        size.height * 0.3191262,
        size.width * 0.3155263,
        size.height * 0.3184393,
        size.width * 0.3155263,
        size.height * 0.3175140);
    path_70.lineTo(size.width * 0.3155263, size.height * 0.3133084);
    path_70.cubicTo(
        size.width * 0.3155263,
        size.height * 0.3123832,
        size.width * 0.3150957,
        size.height * 0.3117103,
        size.width * 0.3142344,
        size.height * 0.3112897);
    path_70.cubicTo(
        size.width * 0.3134306,
        size.height * 0.3108411,
        size.width * 0.3121962,
        size.height * 0.3106168,
        size.width * 0.3105311,
        size.height * 0.3106168);
    path_70.cubicTo(
        size.width * 0.3088660,
        size.height * 0.3106168,
        size.width * 0.3076029,
        size.height * 0.3108411,
        size.width * 0.3067416,
        size.height * 0.3112897);
    path_70.cubicTo(
        size.width * 0.3059378,
        size.height * 0.3117103,
        size.width * 0.3055359,
        size.height * 0.3123832,
        size.width * 0.3055359,
        size.height * 0.3133084);
    path_70.lineTo(size.width * 0.3055359, size.height * 0.3175140);
    path_70.cubicTo(
        size.width * 0.3055359,
        size.height * 0.3184393,
        size.width * 0.3059378,
        size.height * 0.3191262,
        size.width * 0.3067416,
        size.height * 0.3195748);
    path_70.cubicTo(
        size.width * 0.3076029,
        size.height * 0.3199953,
        size.width * 0.3088660,
        size.height * 0.3202056,
        size.width * 0.3105311,
        size.height * 0.3202056);
    path_70.close();
    path_70.moveTo(size.width * 0.4033995, size.height * 0.3202056);
    path_70.lineTo(size.width * 0.4033995, size.height * 0.3271028);
    path_70.lineTo(size.width * 0.3798014, size.height * 0.3271028);
    path_70.lineTo(size.width * 0.3798014, size.height * 0.3238224);
    path_70.cubicTo(
        size.width * 0.3756675,
        size.height * 0.3264019,
        size.width * 0.3705000,
        size.height * 0.3276916,
        size.width * 0.3642990,
        size.height * 0.3276916);
    path_70.cubicTo(
        size.width * 0.3595335,
        size.height * 0.3276916,
        size.width * 0.3559450,
        size.height * 0.3269626,
        size.width * 0.3535335,
        size.height * 0.3255047);
    path_70.cubicTo(
        size.width * 0.3511794,
        size.height * 0.3240467,
        size.width * 0.3500024,
        size.height * 0.3220421,
        size.width * 0.3500024,
        size.height * 0.3194907);
    path_70.lineTo(size.width * 0.3500024, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.3462129, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.3462129, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.3698110, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.3698110, size.height * 0.3175140);
    path_70.cubicTo(
        size.width * 0.3698110,
        size.height * 0.3184393,
        size.width * 0.3702129,
        size.height * 0.3191262,
        size.width * 0.3710167,
        size.height * 0.3195748);
    path_70.cubicTo(
        size.width * 0.3718780,
        size.height * 0.3199953,
        size.width * 0.3731411,
        size.height * 0.3202056,
        size.width * 0.3748062,
        size.height * 0.3202056);
    path_70.cubicTo(
        size.width * 0.3764713,
        size.height * 0.3202056,
        size.width * 0.3777057,
        size.height * 0.3199953,
        size.width * 0.3785096,
        size.height * 0.3195748);
    path_70.cubicTo(
        size.width * 0.3793708,
        size.height * 0.3191262,
        size.width * 0.3798014,
        size.height * 0.3184393,
        size.width * 0.3798014,
        size.height * 0.3175140);
    path_70.lineTo(size.width * 0.3798014, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.3751507, size.height * 0.3106168);
    path_70.lineTo(size.width * 0.3751507, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.3996100, size.height * 0.3037196);
    path_70.lineTo(size.width * 0.3996100, size.height * 0.3202056);
    path_70.lineTo(size.width * 0.4033995, size.height * 0.3202056);
    path_70.close();
    path_70.moveTo(size.width * 0.4366053, size.height * 0.3276916);
    path_70.cubicTo(
        size.width * 0.4284522,
        size.height * 0.3276916,
        size.width * 0.4220789,
        size.height * 0.3266542,
        size.width * 0.4174856,
        size.height * 0.3245794);
    path_70.cubicTo(
        size.width * 0.4128923,
        size.height * 0.3224766,
        size.width * 0.4105957,
        size.height * 0.3194206,
        size.width * 0.4105957,
        size.height * 0.3154112);
    path_70.cubicTo(
        size.width * 0.4105957,
        size.height * 0.3114019,
        size.width * 0.4128923,
        size.height * 0.3083598,
        size.width * 0.4174856,
        size.height * 0.3062850);
    path_70.cubicTo(
        size.width * 0.4220789,
        size.height * 0.3041822,
        size.width * 0.4284522,
        size.height * 0.3031308,
        size.width * 0.4366053,
        size.height * 0.3031308);
    path_70.cubicTo(
        size.width * 0.4447010,
        size.height * 0.3031308,
        size.width * 0.4505287,
        size.height * 0.3041682,
        size.width * 0.4540885,
        size.height * 0.3062430);
    path_70.cubicTo(
        size.width * 0.4577057,
        size.height * 0.3082897,
        size.width * 0.4595144,
        size.height * 0.3108411,
        size.width * 0.4595144,
        size.height * 0.3138972);
    path_70.lineTo(size.width * 0.4595144, size.height * 0.3169252);
    path_70.lineTo(size.width * 0.4316100, size.height * 0.3169252);
    path_70.lineTo(size.width * 0.4316100, size.height * 0.3171776);
    path_70.cubicTo(
        size.width * 0.4316100,
        size.height * 0.3182150,
        size.width * 0.4322416,
        size.height * 0.3189860,
        size.width * 0.4335048,
        size.height * 0.3194907);
    path_70.cubicTo(
        size.width * 0.4347679,
        size.height * 0.3199673,
        size.width * 0.4368636,
        size.height * 0.3202056,
        size.width * 0.4397919,
        size.height * 0.3202056);
    path_70.cubicTo(
        size.width * 0.4432943,
        size.height * 0.3202056,
        size.width * 0.4466244,
        size.height * 0.3200794,
        size.width * 0.4497823,
        size.height * 0.3198271);
    path_70.cubicTo(
        size.width * 0.4529402,
        size.height * 0.3195748,
        size.width * 0.4556962,
        size.height * 0.3192523,
        size.width * 0.4580502,
        size.height * 0.3188598);
    path_70.lineTo(size.width * 0.4580502, size.height * 0.3255888);
    path_70.cubicTo(
        size.width * 0.4560407,
        size.height * 0.3261215,
        size.width * 0.4530837,
        size.height * 0.3266121,
        size.width * 0.4491794,
        size.height * 0.3270607);
    path_70.cubicTo(
        size.width * 0.4453325,
        size.height * 0.3274813,
        size.width * 0.4411411,
        size.height * 0.3276916,
        size.width * 0.4366053,
        size.height * 0.3276916);
    path_70.close();
    path_70.moveTo(size.width * 0.4416005, size.height * 0.3122991);
    path_70.lineTo(size.width * 0.4416005, size.height * 0.3117944);
    path_70.cubicTo(
        size.width * 0.4416005,
        size.height * 0.3108411,
        size.width * 0.4411699,
        size.height * 0.3101542,
        size.width * 0.4403086,
        size.height * 0.3097336);
    path_70.cubicTo(
        size.width * 0.4395048,
        size.height * 0.3093131,
        size.width * 0.4382703,
        size.height * 0.3091028,
        size.width * 0.4366053,
        size.height * 0.3091028);
    path_70.cubicTo(
        size.width * 0.4349402,
        size.height * 0.3091028,
        size.width * 0.4336770,
        size.height * 0.3093271,
        size.width * 0.4328158,
        size.height * 0.3097757);
    path_70.cubicTo(
        size.width * 0.4320120,
        size.height * 0.3101963,
        size.width * 0.4316100,
        size.height * 0.3108692,
        size.width * 0.4316100,
        size.height * 0.3117944);
    path_70.lineTo(size.width * 0.4316100, size.height * 0.3122991);
    path_70.lineTo(size.width * 0.4416005, size.height * 0.3122991);
    path_70.close();
    path_70.moveTo(size.width * 0.2959354, size.height * 0.3843879);
    path_70.lineTo(size.width * 0.2959354, size.height * 0.3774486);
    path_70.lineTo(size.width * 0.2997249, size.height * 0.3774486);
    path_70.lineTo(size.width * 0.2997249, size.height * 0.3585234);
    path_70.lineTo(size.width * 0.2959354, size.height * 0.3585234);
    path_70.lineTo(size.width * 0.2959354, size.height * 0.3516262);
    path_70.lineTo(size.width * 0.3195335, size.height * 0.3516262);
    path_70.lineTo(size.width * 0.3195335, size.height * 0.3774486);
    path_70.lineTo(size.width * 0.3233230, size.height * 0.3774486);
    path_70.lineTo(size.width * 0.3233230, size.height * 0.3843879);
    path_70.lineTo(size.width * 0.2959354, size.height * 0.3843879);
    path_70.close();
    path_70.moveTo(size.width * 0.3814234, size.height * 0.3774486);
    path_70.lineTo(size.width * 0.3814234, size.height * 0.3843458);
    path_70.lineTo(size.width * 0.3586866, size.height * 0.3843458);
    path_70.lineTo(size.width * 0.3586866, size.height * 0.3814860);
    path_70.cubicTo(
        size.width * 0.3574234,
        size.height * 0.3823832,
        size.width * 0.3556435,
        size.height * 0.3831822,
        size.width * 0.3533469,
        size.height * 0.3838832);
    path_70.cubicTo(
        size.width * 0.3511077,
        size.height * 0.3845841,
        size.width * 0.3483517,
        size.height * 0.3849346,
        size.width * 0.3450789,
        size.height * 0.3849346);
    path_70.cubicTo(
        size.width * 0.3407727,
        size.height * 0.3849346,
        size.width * 0.3373852,
        size.height * 0.3843738,
        size.width * 0.3349163,
        size.height * 0.3832523);
    path_70.cubicTo(
        size.width * 0.3324474,
        size.height * 0.3821308,
        size.width * 0.3312129,
        size.height * 0.3805467,
        size.width * 0.3312129,
        size.height * 0.3785000);
    path_70.cubicTo(
        size.width * 0.3312129,
        size.height * 0.3732009,
        size.width * 0.3404282,
        size.height * 0.3704813,
        size.width * 0.3588589,
        size.height * 0.3703411);
    path_70.cubicTo(
        size.width * 0.3586866,
        size.height * 0.3693879,
        size.width * 0.3579402,
        size.height * 0.3687430,
        size.width * 0.3566196,
        size.height * 0.3684065);
    path_70.cubicTo(
        size.width * 0.3552990,
        size.height * 0.3680421,
        size.width * 0.3530598,
        size.height * 0.3678598,
        size.width * 0.3499019,
        size.height * 0.3678598);
    path_70.cubicTo(
        size.width * 0.3473182,
        size.height * 0.3678598,
        size.width * 0.3445335,
        size.height * 0.3680000,
        size.width * 0.3415478,
        size.height * 0.3682804);
    path_70.cubicTo(
        size.width * 0.3386196,
        size.height * 0.3685327,
        size.width * 0.3359211,
        size.height * 0.3688832,
        size.width * 0.3334522,
        size.height * 0.3693318);
    path_70.lineTo(size.width * 0.3334522, size.height * 0.3615935);
    path_70.cubicTo(
        size.width * 0.3364952,
        size.height * 0.3612290,
        size.width * 0.3397967,
        size.height * 0.3609346,
        size.width * 0.3433565,
        size.height * 0.3607103);
    path_70.cubicTo(
        size.width * 0.3469163,
        size.height * 0.3604860,
        size.width * 0.3503900,
        size.height * 0.3603738,
        size.width * 0.3537775,
        size.height * 0.3603738);
    path_70.cubicTo(
        size.width * 0.3623325,
        size.height * 0.3603738,
        size.width * 0.3684474,
        size.height * 0.3611308,
        size.width * 0.3721220,
        size.height * 0.3626449);
    path_70.cubicTo(
        size.width * 0.3757967,
        size.height * 0.3641589,
        size.width * 0.3776340,
        size.height * 0.3665000,
        size.width * 0.3776340,
        size.height * 0.3696682);
    path_70.lineTo(size.width * 0.3776340, size.height * 0.3774486);
    path_70.lineTo(size.width * 0.3814234, size.height * 0.3774486);
    path_70.close();
    path_70.moveTo(size.width * 0.3586866, size.height * 0.3745047);
    path_70.cubicTo(
        size.width * 0.3561029,
        size.height * 0.3745047,
        size.width * 0.3540933,
        size.height * 0.3746729,
        size.width * 0.3526579,
        size.height * 0.3750093);
    path_70.cubicTo(
        size.width * 0.3512799,
        size.height * 0.3753458,
        size.width * 0.3505909,
        size.height * 0.3759065,
        size.width * 0.3505909,
        size.height * 0.3766916);
    path_70.cubicTo(
        size.width * 0.3505909,
        size.height * 0.3771682,
        size.width * 0.3508780,
        size.height * 0.3775607,
        size.width * 0.3514522,
        size.height * 0.3778692);
    path_70.cubicTo(
        size.width * 0.3520837,
        size.height * 0.3781495,
        size.width * 0.3529450,
        size.height * 0.3782897,
        size.width * 0.3540359,
        size.height * 0.3782897);
    path_70.cubicTo(
        size.width * 0.3555287,
        size.height * 0.3782897,
        size.width * 0.3566770,
        size.height * 0.3779813,
        size.width * 0.3574809,
        size.height * 0.3773645);
    path_70.cubicTo(
        size.width * 0.3582847,
        size.height * 0.3767477,
        size.width * 0.3586866,
        size.height * 0.3758785,
        size.width * 0.3586866,
        size.height * 0.3747570);
    path_70.lineTo(size.width * 0.3586866, size.height * 0.3745047);
    path_70.close();
    path_70.moveTo(size.width * 0.2864330, size.height * 0.4176168);
    path_70.cubicTo(
        size.width * 0.2875813,
        size.height * 0.4176168,
        size.width * 0.2886722,
        size.height * 0.4176729,
        size.width * 0.2897057,
        size.height * 0.4177850);
    path_70.cubicTo(
        size.width * 0.2907392,
        size.height * 0.4178972,
        size.width * 0.2916005,
        size.height * 0.4180374,
        size.width * 0.2922895,
        size.height * 0.4182056);
    path_70.lineTo(size.width * 0.2922895, size.height * 0.4262383);
    path_70.cubicTo(
        size.width * 0.2899354,
        size.height * 0.4257617,
        size.width * 0.2874091,
        size.height * 0.4255234,
        size.width * 0.2847105,
        size.height * 0.4255234);
    path_70.cubicTo(
        size.width * 0.2810933,
        size.height * 0.4255234,
        size.width * 0.2783086,
        size.height * 0.4259860,
        size.width * 0.2763565,
        size.height * 0.4269112);
    path_70.cubicTo(
        size.width * 0.2744043,
        size.height * 0.4278364,
        size.width * 0.2734282,
        size.height * 0.4292103,
        size.width * 0.2734282,
        size.height * 0.4310327);
    path_70.lineTo(size.width * 0.2734282, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.2811794, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.2811794, size.height * 0.4415888);
    path_70.lineTo(size.width * 0.2498301, size.height * 0.4415888);
    path_70.lineTo(size.width * 0.2498301, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.2536196, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.2536196, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.2498301, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.2498301, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.2734282, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.2734282, size.height * 0.4212757);
    path_70.cubicTo(
        size.width * 0.2750359,
        size.height * 0.4200981,
        size.width * 0.2768732,
        size.height * 0.4192009,
        size.width * 0.2789402,
        size.height * 0.4185841);
    path_70.cubicTo(
        size.width * 0.2810072,
        size.height * 0.4179393,
        size.width * 0.2835048,
        size.height * 0.4176168,
        size.width * 0.2864330,
        size.height * 0.4176168);
    path_70.close();
    path_70.moveTo(size.width * 0.3569139, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.3569139, size.height * 0.4415888);
    path_70.lineTo(size.width * 0.3333158, size.height * 0.4415888);
    path_70.lineTo(size.width * 0.3333158, size.height * 0.4383084);
    path_70.cubicTo(
        size.width * 0.3291818,
        size.height * 0.4408879,
        size.width * 0.3240144,
        size.height * 0.4421776,
        size.width * 0.3178134,
        size.height * 0.4421776);
    path_70.cubicTo(
        size.width * 0.3130478,
        size.height * 0.4421776,
        size.width * 0.3094593,
        size.height * 0.4414486,
        size.width * 0.3070478,
        size.height * 0.4399907);
    path_70.cubicTo(
        size.width * 0.3046938,
        size.height * 0.4385327,
        size.width * 0.3035167,
        size.height * 0.4365280,
        size.width * 0.3035167,
        size.height * 0.4339766);
    path_70.lineTo(size.width * 0.3035167, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.2997273, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.2997273, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.3233254, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.3233254, size.height * 0.4320000);
    path_70.cubicTo(
        size.width * 0.3233254,
        size.height * 0.4329252,
        size.width * 0.3237273,
        size.height * 0.4336121,
        size.width * 0.3245311,
        size.height * 0.4340607);
    path_70.cubicTo(
        size.width * 0.3253923,
        size.height * 0.4344813,
        size.width * 0.3266555,
        size.height * 0.4346916,
        size.width * 0.3283206,
        size.height * 0.4346916);
    path_70.cubicTo(
        size.width * 0.3299856,
        size.height * 0.4346916,
        size.width * 0.3312201,
        size.height * 0.4344813,
        size.width * 0.3320239,
        size.height * 0.4340607);
    path_70.cubicTo(
        size.width * 0.3328852,
        size.height * 0.4336121,
        size.width * 0.3333158,
        size.height * 0.4329252,
        size.width * 0.3333158,
        size.height * 0.4320000);
    path_70.lineTo(size.width * 0.3333158, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.3286651, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.3286651, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.3531244, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.3531244, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.3569139, size.height * 0.4346916);
    path_70.close();
    path_70.moveTo(size.width * 0.3857249, size.height * 0.4421776);
    path_70.cubicTo(
        size.width * 0.3796388,
        size.height * 0.4421776,
        size.width * 0.3750455,
        size.height * 0.4414626,
        size.width * 0.3719450,
        size.height * 0.4400327);
    path_70.cubicTo(
        size.width * 0.3689019,
        size.height * 0.4385748,
        size.width * 0.3673804,
        size.height * 0.4361355,
        size.width * 0.3673804,
        size.height * 0.4327150);
    path_70.lineTo(size.width * 0.3673804, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.3635909, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.3635909, size.height * 0.4182056);
    path_70.cubicTo(
        size.width * 0.3657727,
        size.height * 0.4182056,
        size.width * 0.3674091,
        size.height * 0.4179393,
        size.width * 0.3685000,
        size.height * 0.4174065);
    path_70.cubicTo(
        size.width * 0.3695909,
        size.height * 0.4168458,
        size.width * 0.3701364,
        size.height * 0.4160888,
        size.width * 0.3701364,
        size.height * 0.4151355);
    path_70.lineTo(size.width * 0.3701364, size.height * 0.4132430);
    path_70.lineTo(size.width * 0.3883947, size.height * 0.4132430);
    path_70.lineTo(size.width * 0.3883947, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.4000215, size.height * 0.4182056);
    path_70.lineTo(size.width * 0.4000215, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.3883947, size.height * 0.4251028);
    path_70.lineTo(size.width * 0.3883947, size.height * 0.4320000);
    path_70.cubicTo(
        size.width * 0.3883947,
        size.height * 0.4329252,
        size.width * 0.3887967,
        size.height * 0.4336121,
        size.width * 0.3896005,
        size.height * 0.4340607);
    path_70.cubicTo(
        size.width * 0.3904617,
        size.height * 0.4344813,
        size.width * 0.3917249,
        size.height * 0.4346916,
        size.width * 0.3933900,
        size.height * 0.4346916);
    path_70.cubicTo(
        size.width * 0.3955718,
        size.height * 0.4346916,
        size.width * 0.3979545,
        size.height * 0.4345654,
        size.width * 0.4005383,
        size.height * 0.4343131);
    path_70.lineTo(size.width * 0.4005383, size.height * 0.4409159);
    path_70.cubicTo(
        size.width * 0.3989306,
        size.height * 0.4412243,
        size.width * 0.3967488,
        size.height * 0.4415047,
        size.width * 0.3939928,
        size.height * 0.4417570);
    path_70.cubicTo(
        size.width * 0.3912943,
        size.height * 0.4420374,
        size.width * 0.3885383,
        size.height * 0.4421776,
        size.width * 0.3857249,
        size.height * 0.4421776);
    path_70.close();
    path_70.moveTo(size.width * 0.4586866, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.4586866, size.height * 0.4415888);
    path_70.lineTo(size.width * 0.4359498, size.height * 0.4415888);
    path_70.lineTo(size.width * 0.4359498, size.height * 0.4387290);
    path_70.cubicTo(
        size.width * 0.4346866,
        size.height * 0.4396262,
        size.width * 0.4329067,
        size.height * 0.4404252,
        size.width * 0.4306100,
        size.height * 0.4411262);
    path_70.cubicTo(
        size.width * 0.4283708,
        size.height * 0.4418271,
        size.width * 0.4256148,
        size.height * 0.4421776,
        size.width * 0.4223421,
        size.height * 0.4421776);
    path_70.cubicTo(
        size.width * 0.4180359,
        size.height * 0.4421776,
        size.width * 0.4146483,
        size.height * 0.4416168,
        size.width * 0.4121794,
        size.height * 0.4404953);
    path_70.cubicTo(
        size.width * 0.4097105,
        size.height * 0.4393738,
        size.width * 0.4084761,
        size.height * 0.4377897,
        size.width * 0.4084761,
        size.height * 0.4357430);
    path_70.cubicTo(
        size.width * 0.4084761,
        size.height * 0.4304439,
        size.width * 0.4176914,
        size.height * 0.4277243,
        size.width * 0.4361220,
        size.height * 0.4275841);
    path_70.cubicTo(
        size.width * 0.4359498,
        size.height * 0.4266308,
        size.width * 0.4352033,
        size.height * 0.4259860,
        size.width * 0.4338828,
        size.height * 0.4256495);
    path_70.cubicTo(
        size.width * 0.4325622,
        size.height * 0.4252850,
        size.width * 0.4303230,
        size.height * 0.4251028,
        size.width * 0.4271651,
        size.height * 0.4251028);
    path_70.cubicTo(
        size.width * 0.4245813,
        size.height * 0.4251028,
        size.width * 0.4217967,
        size.height * 0.4252430,
        size.width * 0.4188110,
        size.height * 0.4255234);
    path_70.cubicTo(
        size.width * 0.4158828,
        size.height * 0.4257757,
        size.width * 0.4131842,
        size.height * 0.4261262,
        size.width * 0.4107153,
        size.height * 0.4265748);
    path_70.lineTo(size.width * 0.4107153, size.height * 0.4188364);
    path_70.cubicTo(
        size.width * 0.4137584,
        size.height * 0.4184720,
        size.width * 0.4170598,
        size.height * 0.4181776,
        size.width * 0.4206196,
        size.height * 0.4179533);
    path_70.cubicTo(
        size.width * 0.4241794,
        size.height * 0.4177290,
        size.width * 0.4276531,
        size.height * 0.4176168,
        size.width * 0.4310407,
        size.height * 0.4176168);
    path_70.cubicTo(
        size.width * 0.4395957,
        size.height * 0.4176168,
        size.width * 0.4457105,
        size.height * 0.4183738,
        size.width * 0.4493852,
        size.height * 0.4198879);
    path_70.cubicTo(
        size.width * 0.4530598,
        size.height * 0.4214019,
        size.width * 0.4548971,
        size.height * 0.4237430,
        size.width * 0.4548971,
        size.height * 0.4269112);
    path_70.lineTo(size.width * 0.4548971, size.height * 0.4346916);
    path_70.lineTo(size.width * 0.4586866, size.height * 0.4346916);
    path_70.close();
    path_70.moveTo(size.width * 0.4359498, size.height * 0.4317477);
    path_70.cubicTo(
        size.width * 0.4333660,
        size.height * 0.4317477,
        size.width * 0.4313565,
        size.height * 0.4319159,
        size.width * 0.4299211,
        size.height * 0.4322523);
    path_70.cubicTo(
        size.width * 0.4285431,
        size.height * 0.4325888,
        size.width * 0.4278541,
        size.height * 0.4331495,
        size.width * 0.4278541,
        size.height * 0.4339346);
    path_70.cubicTo(
        size.width * 0.4278541,
        size.height * 0.4344112,
        size.width * 0.4281411,
        size.height * 0.4348037,
        size.width * 0.4287153,
        size.height * 0.4351121);
    path_70.cubicTo(
        size.width * 0.4293469,
        size.height * 0.4353925,
        size.width * 0.4302081,
        size.height * 0.4355327,
        size.width * 0.4312990,
        size.height * 0.4355327);
    path_70.cubicTo(
        size.width * 0.4327919,
        size.height * 0.4355327,
        size.width * 0.4339402,
        size.height * 0.4352243,
        size.width * 0.4347440,
        size.height * 0.4346075);
    path_70.cubicTo(
        size.width * 0.4355478,
        size.height * 0.4339907,
        size.width * 0.4359498,
        size.height * 0.4331215,
        size.width * 0.4359498,
        size.height * 0.4320000);
    path_70.lineTo(size.width * 0.4359498, size.height * 0.4317477);
    path_70.close();
    path_70.moveTo(size.width * 0.2383282, size.height * 0.4994206);
    path_70.cubicTo(
        size.width * 0.2324718,
        size.height * 0.4994206,
        size.width * 0.2280507,
        size.height * 0.4983551,
        size.width * 0.2250651,
        size.height * 0.4962243);
    path_70.cubicTo(
        size.width * 0.2221368,
        size.height * 0.4940935,
        size.width * 0.2206727,
        size.height * 0.4910654,
        size.width * 0.2206727,
        size.height * 0.4871402);
    path_70.cubicTo(
        size.width * 0.2206727,
        size.height * 0.4832150,
        size.width * 0.2221368,
        size.height * 0.4801869,
        size.width * 0.2250651,
        size.height * 0.4780561);
    path_70.cubicTo(
        size.width * 0.2280507,
        size.height * 0.4759252,
        size.width * 0.2324718,
        size.height * 0.4748598,
        size.width * 0.2383282,
        size.height * 0.4748598);
    path_70.cubicTo(
        size.width * 0.2412560,
        size.height * 0.4748598,
        size.width * 0.2438397,
        size.height * 0.4752103,
        size.width * 0.2460789,
        size.height * 0.4759112);
    path_70.cubicTo(
        size.width * 0.2483756,
        size.height * 0.4766121,
        size.width * 0.2502416,
        size.height * 0.4774112,
        size.width * 0.2516770,
        size.height * 0.4783084);
    path_70.lineTo(size.width * 0.2516770, size.height * 0.4730093);
    path_70.lineTo(size.width * 0.2465957, size.height * 0.4730093);
    path_70.lineTo(size.width * 0.2465957, size.height * 0.4661121);
    path_70.lineTo(size.width * 0.2714856, size.height * 0.4661121);
    path_70.lineTo(size.width * 0.2714856, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.2752751, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.2752751, size.height * 0.4988318);
    path_70.lineTo(size.width * 0.2516770, size.height * 0.4988318);
    path_70.lineTo(size.width * 0.2516770, size.height * 0.4959720);
    path_70.cubicTo(
        size.width * 0.2502416,
        size.height * 0.4968692,
        size.width * 0.2483756,
        size.height * 0.4976682,
        size.width * 0.2460789,
        size.height * 0.4983692);
    path_70.cubicTo(
        size.width * 0.2438397,
        size.height * 0.4990701,
        size.width * 0.2412560,
        size.height * 0.4994206,
        size.width * 0.2383282,
        size.height * 0.4994206);
    path_70.close();
    path_70.moveTo(size.width * 0.2466818, size.height * 0.4919346);
    path_70.cubicTo(
        size.width * 0.2483469,
        size.height * 0.4919346,
        size.width * 0.2495813,
        size.height * 0.4917243,
        size.width * 0.2503852,
        size.height * 0.4913037);
    path_70.cubicTo(
        size.width * 0.2512464,
        size.height * 0.4908551,
        size.width * 0.2516770,
        size.height * 0.4901682,
        size.width * 0.2516770,
        size.height * 0.4892430);
    path_70.lineTo(size.width * 0.2516770, size.height * 0.4850374);
    path_70.cubicTo(
        size.width * 0.2516770,
        size.height * 0.4841121,
        size.width * 0.2512464,
        size.height * 0.4834393,
        size.width * 0.2503852,
        size.height * 0.4830187);
    path_70.cubicTo(
        size.width * 0.2495813,
        size.height * 0.4825701,
        size.width * 0.2483469,
        size.height * 0.4823458,
        size.width * 0.2466818,
        size.height * 0.4823458);
    path_70.cubicTo(
        size.width * 0.2450167,
        size.height * 0.4823458,
        size.width * 0.2437536,
        size.height * 0.4825701,
        size.width * 0.2428923,
        size.height * 0.4830187);
    path_70.cubicTo(
        size.width * 0.2420885,
        size.height * 0.4834393,
        size.width * 0.2416866,
        size.height * 0.4841121,
        size.width * 0.2416866,
        size.height * 0.4850374);
    path_70.lineTo(size.width * 0.2416866, size.height * 0.4892430);
    path_70.cubicTo(
        size.width * 0.2416866,
        size.height * 0.4901682,
        size.width * 0.2420885,
        size.height * 0.4908551,
        size.width * 0.2428923,
        size.height * 0.4913037);
    path_70.cubicTo(
        size.width * 0.2437536,
        size.height * 0.4917243,
        size.width * 0.2450167,
        size.height * 0.4919346,
        size.width * 0.2466818,
        size.height * 0.4919346);
    path_70.close();
    path_70.moveTo(size.width * 0.3088804, size.height * 0.4994206);
    path_70.cubicTo(
        size.width * 0.3007273,
        size.height * 0.4994206,
        size.width * 0.2943541,
        size.height * 0.4983832,
        size.width * 0.2897608,
        size.height * 0.4963084);
    path_70.cubicTo(
        size.width * 0.2851675,
        size.height * 0.4942056,
        size.width * 0.2828708,
        size.height * 0.4911495,
        size.width * 0.2828708,
        size.height * 0.4871402);
    path_70.cubicTo(
        size.width * 0.2828708,
        size.height * 0.4831308,
        size.width * 0.2851675,
        size.height * 0.4800888,
        size.width * 0.2897608,
        size.height * 0.4780140);
    path_70.cubicTo(
        size.width * 0.2943541,
        size.height * 0.4759112,
        size.width * 0.3007273,
        size.height * 0.4748598,
        size.width * 0.3088804,
        size.height * 0.4748598);
    path_70.cubicTo(
        size.width * 0.3169761,
        size.height * 0.4748598,
        size.width * 0.3228038,
        size.height * 0.4758972,
        size.width * 0.3263636,
        size.height * 0.4779720);
    path_70.cubicTo(
        size.width * 0.3299809,
        size.height * 0.4800187,
        size.width * 0.3317895,
        size.height * 0.4825701,
        size.width * 0.3317895,
        size.height * 0.4856262);
    path_70.lineTo(size.width * 0.3317895, size.height * 0.4886542);
    path_70.lineTo(size.width * 0.3038852, size.height * 0.4886542);
    path_70.lineTo(size.width * 0.3038852, size.height * 0.4889065);
    path_70.cubicTo(
        size.width * 0.3038852,
        size.height * 0.4899439,
        size.width * 0.3045167,
        size.height * 0.4907150,
        size.width * 0.3057799,
        size.height * 0.4912196);
    path_70.cubicTo(
        size.width * 0.3070431,
        size.height * 0.4916963,
        size.width * 0.3091388,
        size.height * 0.4919346,
        size.width * 0.3120670,
        size.height * 0.4919346);
    path_70.cubicTo(
        size.width * 0.3155694,
        size.height * 0.4919346,
        size.width * 0.3188995,
        size.height * 0.4918084,
        size.width * 0.3220574,
        size.height * 0.4915561);
    path_70.cubicTo(
        size.width * 0.3252153,
        size.height * 0.4913037,
        size.width * 0.3279713,
        size.height * 0.4909813,
        size.width * 0.3303254,
        size.height * 0.4905888);
    path_70.lineTo(size.width * 0.3303254, size.height * 0.4973178);
    path_70.cubicTo(
        size.width * 0.3283158,
        size.height * 0.4978505,
        size.width * 0.3253589,
        size.height * 0.4983411,
        size.width * 0.3214545,
        size.height * 0.4987897);
    path_70.cubicTo(
        size.width * 0.3176077,
        size.height * 0.4992103,
        size.width * 0.3134163,
        size.height * 0.4994206,
        size.width * 0.3088804,
        size.height * 0.4994206);
    path_70.close();
    path_70.moveTo(size.width * 0.3138756, size.height * 0.4840280);
    path_70.lineTo(size.width * 0.3138756, size.height * 0.4835234);
    path_70.cubicTo(
        size.width * 0.3138756,
        size.height * 0.4825701,
        size.width * 0.3134450,
        size.height * 0.4818832,
        size.width * 0.3125837,
        size.height * 0.4814626);
    path_70.cubicTo(
        size.width * 0.3117799,
        size.height * 0.4810421,
        size.width * 0.3105455,
        size.height * 0.4808318,
        size.width * 0.3088804,
        size.height * 0.4808318);
    path_70.cubicTo(
        size.width * 0.3072153,
        size.height * 0.4808318,
        size.width * 0.3059522,
        size.height * 0.4810561,
        size.width * 0.3050909,
        size.height * 0.4815047);
    path_70.cubicTo(
        size.width * 0.3042871,
        size.height * 0.4819252,
        size.width * 0.3038852,
        size.height * 0.4825981,
        size.width * 0.3038852,
        size.height * 0.4835234);
    path_70.lineTo(size.width * 0.3038852, size.height * 0.4840280);
    path_70.lineTo(size.width * 0.3138756, size.height * 0.4840280);
    path_70.close();
    path_70.moveTo(size.width * 0.3705072, size.height * 0.4988738);
    path_70.lineTo(size.width * 0.3705072, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.3742967, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.3742967, size.height * 0.4730093);
    path_70.lineTo(size.width * 0.3705072, size.height * 0.4730093);
    path_70.lineTo(size.width * 0.3705072, size.height * 0.4661121);
    path_70.lineTo(size.width * 0.3941053, size.height * 0.4661121);
    path_70.lineTo(size.width * 0.3941053, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.3978947, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.3978947, size.height * 0.4988738);
    path_70.lineTo(size.width * 0.3705072, size.height * 0.4988738);
    path_70.close();
    path_70.moveTo(size.width * 0.4559952, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.4559952, size.height * 0.4988318);
    path_70.lineTo(size.width * 0.4332584, size.height * 0.4988318);
    path_70.lineTo(size.width * 0.4332584, size.height * 0.4959720);
    path_70.cubicTo(
        size.width * 0.4319952,
        size.height * 0.4968692,
        size.width * 0.4302153,
        size.height * 0.4976682,
        size.width * 0.4279187,
        size.height * 0.4983692);
    path_70.cubicTo(
        size.width * 0.4256794,
        size.height * 0.4990701,
        size.width * 0.4229234,
        size.height * 0.4994206,
        size.width * 0.4196507,
        size.height * 0.4994206);
    path_70.cubicTo(
        size.width * 0.4153445,
        size.height * 0.4994206,
        size.width * 0.4119569,
        size.height * 0.4988598,
        size.width * 0.4094880,
        size.height * 0.4977383);
    path_70.cubicTo(
        size.width * 0.4070191,
        size.height * 0.4966168,
        size.width * 0.4057847,
        size.height * 0.4950327,
        size.width * 0.4057847,
        size.height * 0.4929860);
    path_70.cubicTo(
        size.width * 0.4057847,
        size.height * 0.4876869,
        size.width * 0.4150000,
        size.height * 0.4849673,
        size.width * 0.4334306,
        size.height * 0.4848271);
    path_70.cubicTo(
        size.width * 0.4332584,
        size.height * 0.4838738,
        size.width * 0.4325120,
        size.height * 0.4832290,
        size.width * 0.4311914,
        size.height * 0.4828925);
    path_70.cubicTo(
        size.width * 0.4298708,
        size.height * 0.4825280,
        size.width * 0.4276316,
        size.height * 0.4823458,
        size.width * 0.4244737,
        size.height * 0.4823458);
    path_70.cubicTo(
        size.width * 0.4218900,
        size.height * 0.4823458,
        size.width * 0.4191053,
        size.height * 0.4824860,
        size.width * 0.4161196,
        size.height * 0.4827664);
    path_70.cubicTo(
        size.width * 0.4131914,
        size.height * 0.4830187,
        size.width * 0.4104928,
        size.height * 0.4833692,
        size.width * 0.4080239,
        size.height * 0.4838178);
    path_70.lineTo(size.width * 0.4080239, size.height * 0.4760794);
    path_70.cubicTo(
        size.width * 0.4110670,
        size.height * 0.4757150,
        size.width * 0.4143684,
        size.height * 0.4754206,
        size.width * 0.4179282,
        size.height * 0.4751963);
    path_70.cubicTo(
        size.width * 0.4214880,
        size.height * 0.4749720,
        size.width * 0.4249617,
        size.height * 0.4748598,
        size.width * 0.4283493,
        size.height * 0.4748598);
    path_70.cubicTo(
        size.width * 0.4369043,
        size.height * 0.4748598,
        size.width * 0.4430191,
        size.height * 0.4756168,
        size.width * 0.4466938,
        size.height * 0.4771308);
    path_70.cubicTo(
        size.width * 0.4503684,
        size.height * 0.4786449,
        size.width * 0.4522057,
        size.height * 0.4809860,
        size.width * 0.4522057,
        size.height * 0.4841542);
    path_70.lineTo(size.width * 0.4522057, size.height * 0.4919346);
    path_70.lineTo(size.width * 0.4559952, size.height * 0.4919346);
    path_70.close();
    path_70.moveTo(size.width * 0.4332584, size.height * 0.4889907);
    path_70.cubicTo(
        size.width * 0.4306746,
        size.height * 0.4889907,
        size.width * 0.4286651,
        size.height * 0.4891589,
        size.width * 0.4272297,
        size.height * 0.4894953);
    path_70.cubicTo(
        size.width * 0.4258517,
        size.height * 0.4898318,
        size.width * 0.4251627,
        size.height * 0.4903925,
        size.width * 0.4251627,
        size.height * 0.4911776);
    path_70.cubicTo(
        size.width * 0.4251627,
        size.height * 0.4916542,
        size.width * 0.4254498,
        size.height * 0.4920467,
        size.width * 0.4260239,
        size.height * 0.4923551);
    path_70.cubicTo(
        size.width * 0.4266555,
        size.height * 0.4926355,
        size.width * 0.4275167,
        size.height * 0.4927757,
        size.width * 0.4286077,
        size.height * 0.4927757);
    path_70.cubicTo(
        size.width * 0.4301005,
        size.height * 0.4927757,
        size.width * 0.4312488,
        size.height * 0.4924673,
        size.width * 0.4320526,
        size.height * 0.4918505);
    path_70.cubicTo(
        size.width * 0.4328565,
        size.height * 0.4912336,
        size.width * 0.4332584,
        size.height * 0.4903645,
        size.width * 0.4332584,
        size.height * 0.4892430);
    path_70.lineTo(size.width * 0.4332584, size.height * 0.4889907);
    path_70.close();
    path_70.moveTo(size.width * 0.1563940, size.height * 0.5566636);
    path_70.cubicTo(
        size.width * 0.1508821,
        size.height * 0.5566636,
        size.width * 0.1456572,
        size.height * 0.5564393,
        size.width * 0.1407194,
        size.height * 0.5559907);
    path_70.cubicTo(
        size.width * 0.1358390,
        size.height * 0.5555140,
        size.width * 0.1320782,
        size.height * 0.5549813,
        size.width * 0.1294371,
        size.height * 0.5543925);
    path_70.lineTo(size.width * 0.1294371, size.height * 0.5460654);
    path_70.lineTo(size.width * 0.1483844, size.height * 0.5460654);
    path_70.cubicTo(
        size.width * 0.1483844,
        size.height * 0.5469346,
        size.width * 0.1487864,
        size.height * 0.5475654,
        size.width * 0.1495902,
        size.height * 0.5479579);
    path_70.cubicTo(
        size.width * 0.1503940,
        size.height * 0.5483505,
        size.width * 0.1518581,
        size.height * 0.5485467,
        size.width * 0.1539825,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.1557624,
        size.height * 0.5485467,
        size.width * 0.1570256,
        size.height * 0.5484206,
        size.width * 0.1577720,
        size.height * 0.5481682);
    path_70.cubicTo(
        size.width * 0.1585758,
        size.height * 0.5478879,
        size.width * 0.1589778,
        size.height * 0.5474813,
        size.width * 0.1589778,
        size.height * 0.5469486);
    path_70.cubicTo(
        size.width * 0.1589778,
        size.height * 0.5465000,
        size.width * 0.1586045,
        size.height * 0.5461215,
        size.width * 0.1578581,
        size.height * 0.5458131);
    path_70.cubicTo(
        size.width * 0.1571117,
        size.height * 0.5454766,
        size.width * 0.1558199,
        size.height * 0.5451402,
        size.width * 0.1539825,
        size.height * 0.5448037);
    path_70.lineTo(size.width * 0.1465758, size.height * 0.5435421);
    path_70.cubicTo(
        size.width * 0.1402026,
        size.height * 0.5423645,
        size.width * 0.1356093,
        size.height * 0.5409766,
        size.width * 0.1327959,
        size.height * 0.5393785);
    path_70.cubicTo(
        size.width * 0.1300400,
        size.height * 0.5377804,
        size.width * 0.1286620,
        size.height * 0.5356215,
        size.width * 0.1286620,
        size.height * 0.5329019);
    path_70.cubicTo(
        size.width * 0.1286620,
        size.height * 0.5295935,
        size.width * 0.1308725,
        size.height * 0.5270841,
        size.width * 0.1352935,
        size.height * 0.5253738);
    path_70.cubicTo(
        size.width * 0.1397720,
        size.height * 0.5236355,
        size.width * 0.1472074,
        size.height * 0.5227664,
        size.width * 0.1575998,
        size.height * 0.5227664);
    path_70.cubicTo(
        size.width * 0.1625950,
        size.height * 0.5227664,
        size.width * 0.1672744,
        size.height * 0.5230187,
        size.width * 0.1716380,
        size.height * 0.5235234);
    path_70.cubicTo(
        size.width * 0.1760591,
        size.height * 0.5240000,
        size.width * 0.1796189,
        size.height * 0.5246449,
        size.width * 0.1823175,
        size.height * 0.5254579);
    path_70.lineTo(size.width * 0.1823175, size.height * 0.5329860);
    path_70.lineTo(size.width * 0.1650926, size.height * 0.5329860);
    path_70.cubicTo(
        size.width * 0.1650926,
        size.height * 0.5315841,
        size.width * 0.1633127,
        size.height * 0.5308832,
        size.width * 0.1597529,
        size.height * 0.5308832);
    path_70.cubicTo(
        size.width * 0.1580304,
        size.height * 0.5308832,
        size.width * 0.1567959,
        size.height * 0.5309953,
        size.width * 0.1560495,
        size.height * 0.5312196);
    path_70.cubicTo(
        size.width * 0.1553605,
        size.height * 0.5314159,
        size.width * 0.1550160,
        size.height * 0.5317804,
        size.width * 0.1550160,
        size.height * 0.5323131);
    path_70.cubicTo(
        size.width * 0.1550160,
        size.height * 0.5327897,
        size.width * 0.1554179,
        size.height * 0.5331682,
        size.width * 0.1562218,
        size.height * 0.5334486);
    path_70.cubicTo(
        size.width * 0.1570830,
        size.height * 0.5337290,
        size.width * 0.1584610,
        size.height * 0.5340234,
        size.width * 0.1603557,
        size.height * 0.5343318);
    path_70.lineTo(size.width * 0.1678486, size.height * 0.5355935);
    path_70.cubicTo(
        size.width * 0.1739347,
        size.height * 0.5366028,
        size.width * 0.1783557,
        size.height * 0.5379206,
        size.width * 0.1811117,
        size.height * 0.5395467);
    path_70.cubicTo(
        size.width * 0.1839251,
        size.height * 0.5411449,
        size.width * 0.1853318,
        size.height * 0.5432477,
        size.width * 0.1853318,
        size.height * 0.5458551);
    path_70.cubicTo(
        size.width * 0.1853318,
        size.height * 0.5494159,
        size.width * 0.1828629,
        size.height * 0.5521075,
        size.width * 0.1779251,
        size.height * 0.5539299);
    path_70.cubicTo(
        size.width * 0.1730447,
        size.height * 0.5557523,
        size.width * 0.1658677,
        size.height * 0.5566636,
        size.width * 0.1563940,
        size.height * 0.5566636);
    path_70.close();
    path_70.moveTo(size.width * 0.2429330, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.2429330, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.2201974, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.2201974, size.height * 0.5532150);
    path_70.cubicTo(
        size.width * 0.2189342,
        size.height * 0.5541121,
        size.width * 0.2171543,
        size.height * 0.5549112,
        size.width * 0.2148577,
        size.height * 0.5556121);
    path_70.cubicTo(
        size.width * 0.2126184,
        size.height * 0.5563131,
        size.width * 0.2098624,
        size.height * 0.5566636,
        size.width * 0.2065897,
        size.height * 0.5566636);
    path_70.cubicTo(
        size.width * 0.2022835,
        size.height * 0.5566636,
        size.width * 0.1988959,
        size.height * 0.5561028,
        size.width * 0.1964270,
        size.height * 0.5549813);
    path_70.cubicTo(
        size.width * 0.1939581,
        size.height * 0.5538598,
        size.width * 0.1927237,
        size.height * 0.5522757,
        size.width * 0.1927237,
        size.height * 0.5502290);
    path_70.cubicTo(
        size.width * 0.1927237,
        size.height * 0.5449299,
        size.width * 0.2019390,
        size.height * 0.5422103,
        size.width * 0.2203696,
        size.height * 0.5420701);
    path_70.cubicTo(
        size.width * 0.2201974,
        size.height * 0.5411168,
        size.width * 0.2194510,
        size.height * 0.5404720,
        size.width * 0.2181304,
        size.height * 0.5401355);
    path_70.cubicTo(
        size.width * 0.2168098,
        size.height * 0.5397710,
        size.width * 0.2145706,
        size.height * 0.5395888,
        size.width * 0.2114127,
        size.height * 0.5395888);
    path_70.cubicTo(
        size.width * 0.2088289,
        size.height * 0.5395888,
        size.width * 0.2060443,
        size.height * 0.5397290,
        size.width * 0.2030586,
        size.height * 0.5400093);
    path_70.cubicTo(
        size.width * 0.2001304,
        size.height * 0.5402617,
        size.width * 0.1974318,
        size.height * 0.5406121,
        size.width * 0.1949629,
        size.height * 0.5410607);
    path_70.lineTo(size.width * 0.1949629, size.height * 0.5333224);
    path_70.cubicTo(
        size.width * 0.1980060,
        size.height * 0.5329579,
        size.width * 0.2013074,
        size.height * 0.5326636,
        size.width * 0.2048672,
        size.height * 0.5324393);
    path_70.cubicTo(
        size.width * 0.2084270,
        size.height * 0.5322150,
        size.width * 0.2119007,
        size.height * 0.5321028,
        size.width * 0.2152883,
        size.height * 0.5321028);
    path_70.cubicTo(
        size.width * 0.2238433,
        size.height * 0.5321028,
        size.width * 0.2299581,
        size.height * 0.5328598,
        size.width * 0.2336328,
        size.height * 0.5343738);
    path_70.cubicTo(
        size.width * 0.2373074,
        size.height * 0.5358879,
        size.width * 0.2391447,
        size.height * 0.5382290,
        size.width * 0.2391447,
        size.height * 0.5413972);
    path_70.lineTo(size.width * 0.2391447, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.2429330, size.height * 0.5491776);
    path_70.close();
    path_70.moveTo(size.width * 0.2201974, size.height * 0.5462336);
    path_70.cubicTo(
        size.width * 0.2176136,
        size.height * 0.5462336,
        size.width * 0.2156041,
        size.height * 0.5464019,
        size.width * 0.2141687,
        size.height * 0.5467383);
    path_70.cubicTo(
        size.width * 0.2127907,
        size.height * 0.5470748,
        size.width * 0.2121017,
        size.height * 0.5476355,
        size.width * 0.2121017,
        size.height * 0.5484206);
    path_70.cubicTo(
        size.width * 0.2121017,
        size.height * 0.5488972,
        size.width * 0.2123888,
        size.height * 0.5492897,
        size.width * 0.2129629,
        size.height * 0.5495981);
    path_70.cubicTo(
        size.width * 0.2135945,
        size.height * 0.5498785,
        size.width * 0.2144557,
        size.height * 0.5500187,
        size.width * 0.2155467,
        size.height * 0.5500187);
    path_70.cubicTo(
        size.width * 0.2170395,
        size.height * 0.5500187,
        size.width * 0.2181878,
        size.height * 0.5497103,
        size.width * 0.2189916,
        size.height * 0.5490935);
    path_70.cubicTo(
        size.width * 0.2197955,
        size.height * 0.5484766,
        size.width * 0.2201974,
        size.height * 0.5476075,
        size.width * 0.2201974,
        size.height * 0.5464860);
    path_70.lineTo(size.width * 0.2201974, size.height * 0.5462336);
    path_70.close();
    path_70.moveTo(size.width * 0.2878254, size.height * 0.5566636);
    path_70.cubicTo(
        size.width * 0.2848971,
        size.height * 0.5566636,
        size.width * 0.2822847,
        size.height * 0.5563131,
        size.width * 0.2799880,
        size.height * 0.5556121);
    path_70.cubicTo(
        size.width * 0.2777488,
        size.height * 0.5549112,
        size.width * 0.2759115,
        size.height * 0.5541121,
        size.width * 0.2744761,
        size.height * 0.5532150);
    path_70.lineTo(size.width * 0.2744761, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.2508780, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.2508780, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.2546675, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.2546675, size.height * 0.5302523);
    path_70.lineTo(size.width * 0.2508780, size.height * 0.5302523);
    path_70.lineTo(size.width * 0.2508780, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.2744761, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.2744761, size.height * 0.5355514);
    path_70.cubicTo(
        size.width * 0.2759115,
        size.height * 0.5346542,
        size.width * 0.2777488,
        size.height * 0.5338551,
        size.width * 0.2799880,
        size.height * 0.5331542);
    path_70.cubicTo(
        size.width * 0.2822847,
        size.height * 0.5324533,
        size.width * 0.2848971,
        size.height * 0.5321028,
        size.width * 0.2878254,
        size.height * 0.5321028);
    path_70.cubicTo(
        size.width * 0.2936818,
        size.height * 0.5321028,
        size.width * 0.2980742,
        size.height * 0.5331682,
        size.width * 0.3010024,
        size.height * 0.5352991);
    path_70.cubicTo(
        size.width * 0.3039880,
        size.height * 0.5374299,
        size.width * 0.3054809,
        size.height * 0.5404579,
        size.width * 0.3054809,
        size.height * 0.5443832);
    path_70.cubicTo(
        size.width * 0.3054809,
        size.height * 0.5483084,
        size.width * 0.3039880,
        size.height * 0.5513364,
        size.width * 0.3010024,
        size.height * 0.5534673);
    path_70.cubicTo(
        size.width * 0.2980742,
        size.height * 0.5555981,
        size.width * 0.2936818,
        size.height * 0.5566636,
        size.width * 0.2878254,
        size.height * 0.5566636);
    path_70.close();
    path_70.moveTo(size.width * 0.2794713, size.height * 0.5491776);
    path_70.cubicTo(
        size.width * 0.2811364,
        size.height * 0.5491776,
        size.width * 0.2823708,
        size.height * 0.5489673,
        size.width * 0.2831746,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.2840359,
        size.height * 0.5480981,
        size.width * 0.2844665,
        size.height * 0.5474112,
        size.width * 0.2844665,
        size.height * 0.5464860);
    path_70.lineTo(size.width * 0.2844665, size.height * 0.5422804);
    path_70.cubicTo(
        size.width * 0.2844665,
        size.height * 0.5413551,
        size.width * 0.2840359,
        size.height * 0.5406822,
        size.width * 0.2831746,
        size.height * 0.5402617);
    path_70.cubicTo(
        size.width * 0.2823708,
        size.height * 0.5398131,
        size.width * 0.2811364,
        size.height * 0.5395888,
        size.width * 0.2794713,
        size.height * 0.5395888);
    path_70.cubicTo(
        size.width * 0.2778062,
        size.height * 0.5395888,
        size.width * 0.2765431,
        size.height * 0.5398131,
        size.width * 0.2756818,
        size.height * 0.5402617);
    path_70.cubicTo(
        size.width * 0.2748780,
        size.height * 0.5406822,
        size.width * 0.2744761,
        size.height * 0.5413551,
        size.width * 0.2744761,
        size.height * 0.5422804);
    path_70.lineTo(size.width * 0.2744761, size.height * 0.5464860);
    path_70.cubicTo(
        size.width * 0.2744761,
        size.height * 0.5474112,
        size.width * 0.2748780,
        size.height * 0.5480981,
        size.width * 0.2756818,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.2765431,
        size.height * 0.5489673,
        size.width * 0.2778062,
        size.height * 0.5491776,
        size.width * 0.2794713,
        size.height * 0.5491776);
    path_70.close();
    path_70.moveTo(size.width * 0.3172033, size.height * 0.5303785);
    path_70.lineTo(size.width * 0.3172033, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.3347727, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.3347727, size.height * 0.5303785);
    path_70.lineTo(size.width * 0.3172033, size.height * 0.5303785);
    path_70.close();
    path_70.moveTo(size.width * 0.3130694, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.3130694, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.3168589, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.3168589, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.3130694, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.3130694, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.3366675, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.3366675, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.3404569, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.3404569, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.3130694, size.height * 0.5560748);
    path_70.close();
    path_70.moveTo(size.width * 0.3649761, size.height * 0.5566636);
    path_70.cubicTo(
        size.width * 0.3591196,
        size.height * 0.5566636,
        size.width * 0.3546986,
        size.height * 0.5555981,
        size.width * 0.3517129,
        size.height * 0.5534673);
    path_70.cubicTo(
        size.width * 0.3487847,
        size.height * 0.5513364,
        size.width * 0.3473206,
        size.height * 0.5483084,
        size.width * 0.3473206,
        size.height * 0.5443832);
    path_70.cubicTo(
        size.width * 0.3473206,
        size.height * 0.5404579,
        size.width * 0.3487847,
        size.height * 0.5374299,
        size.width * 0.3517129,
        size.height * 0.5352991);
    path_70.cubicTo(
        size.width * 0.3546986,
        size.height * 0.5331682,
        size.width * 0.3591196,
        size.height * 0.5321028,
        size.width * 0.3649761,
        size.height * 0.5321028);
    path_70.cubicTo(
        size.width * 0.3679043,
        size.height * 0.5321028,
        size.width * 0.3704880,
        size.height * 0.5324533,
        size.width * 0.3727273,
        size.height * 0.5331542);
    path_70.cubicTo(
        size.width * 0.3750239,
        size.height * 0.5338551,
        size.width * 0.3768900,
        size.height * 0.5346542,
        size.width * 0.3783254,
        size.height * 0.5355514);
    path_70.lineTo(size.width * 0.3783254, size.height * 0.5302523);
    path_70.lineTo(size.width * 0.3732440, size.height * 0.5302523);
    path_70.lineTo(size.width * 0.3732440, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.3981340, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.3981340, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.4019234, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.4019234, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.3783254, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.3783254, size.height * 0.5532150);
    path_70.cubicTo(
        size.width * 0.3768900,
        size.height * 0.5541121,
        size.width * 0.3750239,
        size.height * 0.5549112,
        size.width * 0.3727273,
        size.height * 0.5556121);
    path_70.cubicTo(
        size.width * 0.3704880,
        size.height * 0.5563131,
        size.width * 0.3679043,
        size.height * 0.5566636,
        size.width * 0.3649761,
        size.height * 0.5566636);
    path_70.close();
    path_70.moveTo(size.width * 0.3733301, size.height * 0.5491776);
    path_70.cubicTo(
        size.width * 0.3749952,
        size.height * 0.5491776,
        size.width * 0.3762297,
        size.height * 0.5489673,
        size.width * 0.3770335,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.3778947,
        size.height * 0.5480981,
        size.width * 0.3783254,
        size.height * 0.5474112,
        size.width * 0.3783254,
        size.height * 0.5464860);
    path_70.lineTo(size.width * 0.3783254, size.height * 0.5422804);
    path_70.cubicTo(
        size.width * 0.3783254,
        size.height * 0.5413551,
        size.width * 0.3778947,
        size.height * 0.5406822,
        size.width * 0.3770335,
        size.height * 0.5402617);
    path_70.cubicTo(
        size.width * 0.3762297,
        size.height * 0.5398131,
        size.width * 0.3749952,
        size.height * 0.5395888,
        size.width * 0.3733301,
        size.height * 0.5395888);
    path_70.cubicTo(
        size.width * 0.3716651,
        size.height * 0.5395888,
        size.width * 0.3704019,
        size.height * 0.5398131,
        size.width * 0.3695407,
        size.height * 0.5402617);
    path_70.cubicTo(
        size.width * 0.3687368,
        size.height * 0.5406822,
        size.width * 0.3683349,
        size.height * 0.5413551,
        size.width * 0.3683349,
        size.height * 0.5422804);
    path_70.lineTo(size.width * 0.3683349, size.height * 0.5464860);
    path_70.cubicTo(
        size.width * 0.3683349,
        size.height * 0.5474112,
        size.width * 0.3687368,
        size.height * 0.5480981,
        size.width * 0.3695407,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.3704019,
        size.height * 0.5489673,
        size.width * 0.3716651,
        size.height * 0.5491776,
        size.width * 0.3733301,
        size.height * 0.5491776);
    path_70.close();
    path_70.moveTo(size.width * 0.4665335, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.4665335, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.4429354, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.4429354, size.height * 0.5527944);
    path_70.cubicTo(
        size.width * 0.4388014,
        size.height * 0.5553738,
        size.width * 0.4336340,
        size.height * 0.5566636,
        size.width * 0.4274330,
        size.height * 0.5566636);
    path_70.cubicTo(
        size.width * 0.4226675,
        size.height * 0.5566636,
        size.width * 0.4190789,
        size.height * 0.5559346,
        size.width * 0.4166675,
        size.height * 0.5544766);
    path_70.cubicTo(
        size.width * 0.4143134,
        size.height * 0.5530187,
        size.width * 0.4131364,
        size.height * 0.5510140,
        size.width * 0.4131364,
        size.height * 0.5484626);
    path_70.lineTo(size.width * 0.4131364, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.4093469, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.4093469, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.4329450, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.4329450, size.height * 0.5464860);
    path_70.cubicTo(
        size.width * 0.4329450,
        size.height * 0.5474112,
        size.width * 0.4333469,
        size.height * 0.5480981,
        size.width * 0.4341507,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.4350120,
        size.height * 0.5489673,
        size.width * 0.4362751,
        size.height * 0.5491776,
        size.width * 0.4379402,
        size.height * 0.5491776);
    path_70.cubicTo(
        size.width * 0.4396053,
        size.height * 0.5491776,
        size.width * 0.4408397,
        size.height * 0.5489673,
        size.width * 0.4416435,
        size.height * 0.5485467);
    path_70.cubicTo(
        size.width * 0.4425048,
        size.height * 0.5480981,
        size.width * 0.4429354,
        size.height * 0.5474112,
        size.width * 0.4429354,
        size.height * 0.5464860);
    path_70.lineTo(size.width * 0.4429354, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.4382847, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.4382847, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.4627440, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.4627440, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.4665335, size.height * 0.5491776);
    path_70.close();
    path_70.moveTo(size.width * 0.5108493, size.height * 0.5321028);
    path_70.cubicTo(
        size.width * 0.5119976,
        size.height * 0.5321028,
        size.width * 0.5130885,
        size.height * 0.5321589,
        size.width * 0.5141220,
        size.height * 0.5322710);
    path_70.cubicTo(
        size.width * 0.5151555,
        size.height * 0.5323832,
        size.width * 0.5160167,
        size.height * 0.5325234,
        size.width * 0.5167057,
        size.height * 0.5326916);
    path_70.lineTo(size.width * 0.5167057, size.height * 0.5407243);
    path_70.cubicTo(
        size.width * 0.5143517,
        size.height * 0.5402477,
        size.width * 0.5118254,
        size.height * 0.5400093,
        size.width * 0.5091268,
        size.height * 0.5400093);
    path_70.cubicTo(
        size.width * 0.5055096,
        size.height * 0.5400093,
        size.width * 0.5027249,
        size.height * 0.5404720,
        size.width * 0.5007727,
        size.height * 0.5413972);
    path_70.cubicTo(
        size.width * 0.4988206,
        size.height * 0.5423224,
        size.width * 0.4978445,
        size.height * 0.5436963,
        size.width * 0.4978445,
        size.height * 0.5455187);
    path_70.lineTo(size.width * 0.4978445, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.5055957, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.5055957, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.4742464, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.4742464, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.4780359, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.4780359, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.4742464, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.4742464, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.4978445, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.4978445, size.height * 0.5357617);
    path_70.cubicTo(
        size.width * 0.4994522,
        size.height * 0.5345841,
        size.width * 0.5012895,
        size.height * 0.5336869,
        size.width * 0.5033565,
        size.height * 0.5330701);
    path_70.cubicTo(
        size.width * 0.5054234,
        size.height * 0.5324252,
        size.width * 0.5079211,
        size.height * 0.5321028,
        size.width * 0.5108493,
        size.height * 0.5321028);
    path_70.close();
    path_70.moveTo(size.width * 0.5287943, size.height * 0.5303785);
    path_70.lineTo(size.width * 0.5287943, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.5463636, size.height * 0.5233551);
    path_70.lineTo(size.width * 0.5463636, size.height * 0.5303785);
    path_70.lineTo(size.width * 0.5287943, size.height * 0.5303785);
    path_70.close();
    path_70.moveTo(size.width * 0.5246603, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.5246603, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.5284498, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.5284498, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.5246603, size.height * 0.5395888);
    path_70.lineTo(size.width * 0.5246603, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.5482584, size.height * 0.5326916);
    path_70.lineTo(size.width * 0.5482584, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.5520478, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.5520478, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.5246603, size.height * 0.5560748);
    path_70.close();
    path_70.moveTo(size.width * 0.6098110, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.6098110, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.5870742, size.height * 0.5560748);
    path_70.lineTo(size.width * 0.5870742, size.height * 0.5532150);
    path_70.cubicTo(
        size.width * 0.5858110,
        size.height * 0.5541121,
        size.width * 0.5840311,
        size.height * 0.5549112,
        size.width * 0.5817344,
        size.height * 0.5556121);
    path_70.cubicTo(
        size.width * 0.5794952,
        size.height * 0.5563131,
        size.width * 0.5767392,
        size.height * 0.5566636,
        size.width * 0.5734665,
        size.height * 0.5566636);
    path_70.cubicTo(
        size.width * 0.5691603,
        size.height * 0.5566636,
        size.width * 0.5657727,
        size.height * 0.5561028,
        size.width * 0.5633038,
        size.height * 0.5549813);
    path_70.cubicTo(
        size.width * 0.5608349,
        size.height * 0.5538598,
        size.width * 0.5596005,
        size.height * 0.5522757,
        size.width * 0.5596005,
        size.height * 0.5502290);
    path_70.cubicTo(
        size.width * 0.5596005,
        size.height * 0.5449299,
        size.width * 0.5688158,
        size.height * 0.5422103,
        size.width * 0.5872464,
        size.height * 0.5420701);
    path_70.cubicTo(
        size.width * 0.5870742,
        size.height * 0.5411168,
        size.width * 0.5863278,
        size.height * 0.5404720,
        size.width * 0.5850072,
        size.height * 0.5401355);
    path_70.cubicTo(
        size.width * 0.5836866,
        size.height * 0.5397710,
        size.width * 0.5814474,
        size.height * 0.5395888,
        size.width * 0.5782895,
        size.height * 0.5395888);
    path_70.cubicTo(
        size.width * 0.5757057,
        size.height * 0.5395888,
        size.width * 0.5729211,
        size.height * 0.5397290,
        size.width * 0.5699354,
        size.height * 0.5400093);
    path_70.cubicTo(
        size.width * 0.5670072,
        size.height * 0.5402617,
        size.width * 0.5643086,
        size.height * 0.5406121,
        size.width * 0.5618397,
        size.height * 0.5410607);
    path_70.lineTo(size.width * 0.5618397, size.height * 0.5333224);
    path_70.cubicTo(
        size.width * 0.5648828,
        size.height * 0.5329579,
        size.width * 0.5681842,
        size.height * 0.5326636,
        size.width * 0.5717440,
        size.height * 0.5324393);
    path_70.cubicTo(
        size.width * 0.5753038,
        size.height * 0.5322150,
        size.width * 0.5787775,
        size.height * 0.5321028,
        size.width * 0.5821651,
        size.height * 0.5321028);
    path_70.cubicTo(
        size.width * 0.5907201,
        size.height * 0.5321028,
        size.width * 0.5968349,
        size.height * 0.5328598,
        size.width * 0.6005096,
        size.height * 0.5343738);
    path_70.cubicTo(
        size.width * 0.6041842,
        size.height * 0.5358879,
        size.width * 0.6060215,
        size.height * 0.5382290,
        size.width * 0.6060215,
        size.height * 0.5413972);
    path_70.lineTo(size.width * 0.6060215, size.height * 0.5491776);
    path_70.lineTo(size.width * 0.6098110, size.height * 0.5491776);
    path_70.close();
    path_70.moveTo(size.width * 0.5870742, size.height * 0.5462336);
    path_70.cubicTo(
        size.width * 0.5844904,
        size.height * 0.5462336,
        size.width * 0.5824809,
        size.height * 0.5464019,
        size.width * 0.5810455,
        size.height * 0.5467383);
    path_70.cubicTo(
        size.width * 0.5796675,
        size.height * 0.5470748,
        size.width * 0.5789785,
        size.height * 0.5476355,
        size.width * 0.5789785,
        size.height * 0.5484206);
    path_70.cubicTo(
        size.width * 0.5789785,
        size.height * 0.5488972,
        size.width * 0.5792656,
        size.height * 0.5492897,
        size.width * 0.5798397,
        size.height * 0.5495981);
    path_70.cubicTo(
        size.width * 0.5804713,
        size.height * 0.5498785,
        size.width * 0.5813325,
        size.height * 0.5500187,
        size.width * 0.5824234,
        size.height * 0.5500187);
    path_70.cubicTo(
        size.width * 0.5839163,
        size.height * 0.5500187,
        size.width * 0.5850646,
        size.height * 0.5497103,
        size.width * 0.5858684,
        size.height * 0.5490935);
    path_70.cubicTo(
        size.width * 0.5866722,
        size.height * 0.5484766,
        size.width * 0.5870742,
        size.height * 0.5476075,
        size.width * 0.5870742,
        size.height * 0.5464860);
    path_70.lineTo(size.width * 0.5870742, size.height * 0.5462336);
    path_70.close();

    Paint paint_70_fill = Paint()..style = PaintingStyle.fill;
    paint_70_fill.color = const Color(0xffFD943D).withOpacity(1.0);
    canvas.drawPath(path_70, paint_70_fill);

    Path path_71 = Path();
    path_71.moveTo(size.width * 0.3246722, size.height * 0.4321589);
    path_71.cubicTo(
        size.width * 0.3550000,
        size.height * 0.3745339,
        size.width * 0.4354809,
        size.height * 0.3362944,
        size.width * 0.5363014,
        size.height * 0.3159474);
    path_71.cubicTo(
        size.width * 0.6371507,
        size.height * 0.2955946,
        size.width * 0.7583349,
        size.height * 0.2931507,
        size.width * 0.8698995,
        size.height * 0.3071530);
    path_71.cubicTo(
        size.width * 0.9256555,
        size.height * 0.3141495,
        size.width * 0.9546603,
        size.height * 0.3246098,
        size.width * 0.9662392,
        size.height * 0.3380164);
    path_71.cubicTo(
        size.width * 0.9778421,
        size.height * 0.3514533,
        size.width * 0.9721316,
        size.height * 0.3680491,
        size.width * 0.9573900,
        size.height * 0.3875491);
    path_71.cubicTo(
        size.width * 0.9465407,
        size.height * 0.4019054,
        size.width * 0.9308780,
        size.height * 0.4177395,
        size.width * 0.9138732,
        size.height * 0.4349311);
    path_71.cubicTo(
        size.width * 0.9077919,
        size.height * 0.4410794,
        size.width * 0.9015383,
        size.height * 0.4474007,
        size.width * 0.8952727,
        size.height * 0.4538902);
    path_71.cubicTo(
        size.width * 0.8715048,
        size.height * 0.4785070,
        size.width * 0.8475885,
        size.height * 0.5055023,
        size.width * 0.8323421,
        size.height * 0.5344708);
    path_71.cubicTo(
        size.width * 0.8173780,
        size.height * 0.5629042,
        size.width * 0.8078469,
        size.height * 0.5867325,
        size.width * 0.7997297,
        size.height * 0.6070199);
    path_71.lineTo(size.width * 0.7993038, size.height * 0.6080853);
    path_71.cubicTo(
        size.width * 0.7910909,
        size.height * 0.6286145,
        size.width * 0.7842823,
        size.height * 0.6454626,
        size.width * 0.7746435,
        size.height * 0.6598096);
    path_71.cubicTo(
        size.width * 0.7650144,
        size.height * 0.6741437,
        size.width * 0.7525718,
        size.height * 0.6859556,
        size.width * 0.7331244,
        size.height * 0.6964042);
    path_71.cubicTo(
        size.width * 0.7136675,
        size.height * 0.7068575,
        size.width * 0.6871411,
        size.height * 0.7159790,
        size.width * 0.6492488,
        size.height * 0.7248879);
    path_71.cubicTo(
        size.width * 0.5895144,
        size.height * 0.7389311,
        size.width * 0.5357057,
        size.height * 0.7349217,
        size.width * 0.4894211,
        size.height * 0.7192161);
    path_71.cubicTo(
        size.width * 0.4430598,
        size.height * 0.7034836,
        size.width * 0.4042010,
        size.height * 0.6759942,
        size.width * 0.3746938,
        size.height * 0.6430607);
    path_71.cubicTo(
        size.width * 0.3156746,
        size.height * 0.5771881,
        size.width * 0.2943158,
        size.height * 0.4898341,
        size.width * 0.3246722,
        size.height * 0.4321589);
    path_71.close();

    Paint paint_71_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_71_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_71, paint_71_stroke);

    Paint paint_71_fill = Paint()..style = PaintingStyle.fill;
    paint_71_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_71, paint_71_fill);

    Path path_72 = Path();
    path_72.moveTo(size.width * 0.4347512, size.height * 0.4519042);
    path_72.cubicTo(
        size.width * 0.4805407,
        size.height * 0.3649030,
        size.width * 0.6596890,
        size.height * 0.3341016,
        size.width * 0.8102656,
        size.height * 0.3529988);
    path_72.cubicTo(
        size.width * 0.8478445,
        size.height * 0.3577150,
        size.width * 0.8670144,
        size.height * 0.3652593,
        size.width * 0.8743062,
        size.height * 0.3751390);
    path_72.cubicTo(
        size.width * 0.8816388,
        size.height * 0.3850736,
        size.width * 0.8771220,
        size.height * 0.3975572,
        size.width * 0.8663182,
        size.height * 0.4123364);
    path_72.cubicTo(
        size.width * 0.8583708,
        size.height * 0.4232126,
        size.width * 0.8470909,
        size.height * 0.4352418,
        size.width * 0.8348397,
        size.height * 0.4483084);
    path_72.cubicTo(
        size.width * 0.8304569,
        size.height * 0.4529813,
        size.width * 0.8259498,
        size.height * 0.4577886,
        size.width * 0.8214282,
        size.height * 0.4627220);
    path_72.cubicTo(
        size.width * 0.8042775,
        size.height * 0.4814276,
        size.width * 0.7869306,
        size.height * 0.5019264,
        size.width * 0.7754043,
        size.height * 0.5238248);
    path_72.cubicTo(
        size.width * 0.7641483,
        size.height * 0.5452138,
        size.width * 0.7567129,
        size.height * 0.5631215,
        size.width * 0.7503804,
        size.height * 0.5783762);
    path_72.lineTo(size.width * 0.7499569, size.height * 0.5793949);
    path_72.cubicTo(
        size.width * 0.7435263,
        size.height * 0.5948785,
        size.width * 0.7381962,
        size.height * 0.6075783,
        size.width * 0.7310502,
        size.height * 0.6184299);
    path_72.cubicTo(
        size.width * 0.7239115,
        size.height * 0.6292699,
        size.width * 0.7149785,
        size.height * 0.6382395,
        size.width * 0.7013708,
        size.height * 0.6462582);
    path_72.cubicTo(
        size.width * 0.6877584,
        size.height * 0.6542780,
        size.width * 0.6694234,
        size.height * 0.6613750,
        size.width * 0.6434019,
        size.height * 0.6684346);
    path_72.cubicTo(
        size.width * 0.6228612,
        size.height * 0.6740070,
        size.width * 0.6035550,
        size.height * 0.6761565,
        size.width * 0.5855789,
        size.height * 0.6755187);
    path_72.cubicTo(
        size.width * 0.5676005,
        size.height * 0.6748808,
        size.width * 0.5508612,
        size.height * 0.6714521,
        size.width * 0.5354689,
        size.height * 0.6657944);
    path_72.cubicTo(
        size.width * 0.5046507,
        size.height * 0.6544661,
        size.width * 0.4793182,
        size.height * 0.6342278,
        size.width * 0.4605335,
        size.height * 0.6097769);
    path_72.cubicTo(
        size.width * 0.4229641,
        size.height * 0.5608773,
        size.width * 0.4118230,
        size.height * 0.4954685,
        size.width * 0.4347512,
        size.height * 0.4519042);
    path_72.close();

    Paint paint_72_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_72_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_72, paint_72_stroke);

    Paint paint_72_fill = Paint()..style = PaintingStyle.fill;
    paint_72_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_72, paint_72_fill);

    Path path_73 = Path();
    path_73.moveTo(size.width * 0.4762392, size.height * 0.4623773);
    path_73.cubicTo(
        size.width * 0.5138828,
        size.height * 0.3908540,
        size.width * 0.6520024,
        size.height * 0.3644334,
        size.width * 0.7666842,
        size.height * 0.3788259);
    path_73.cubicTo(
        size.width * 0.7952751,
        size.height * 0.3824136,
        size.width * 0.8096411,
        size.height * 0.3884276,
        size.width * 0.8149067,
        size.height * 0.3964124);
    path_73.cubicTo(
        size.width * 0.8202153,
        size.height * 0.4044661,
        size.width * 0.8164043,
        size.height * 0.4146986,
        size.width * 0.8076890,
        size.height * 0.4268773);
    path_73.cubicTo(
        size.width * 0.8012751,
        size.height * 0.4358353,
        size.width * 0.7922799,
        size.height * 0.4457605,
        size.width * 0.7825048,
        size.height * 0.4565444);
    path_73.cubicTo(
        size.width * 0.7790072,
        size.height * 0.4604019,
        size.width * 0.7754091,
        size.height * 0.4643692,
        size.width * 0.7717967,
        size.height * 0.4684428);
    path_73.cubicTo(
        size.width * 0.7580981,
        size.height * 0.4838808,
        size.width * 0.7441938,
        size.height * 0.5007897,
        size.width * 0.7347105,
        size.height * 0.5188061);
    path_73.cubicTo(
        size.width * 0.7254522,
        size.height * 0.5363995,
        size.width * 0.7192249,
        size.height * 0.5511168,
        size.width * 0.7139211,
        size.height * 0.5636507);
    path_73.lineTo(size.width * 0.7135670, size.height * 0.5644883);
    path_73.cubicTo(
        size.width * 0.7081818,
        size.height * 0.5772126,
        size.width * 0.7037225,
        size.height * 0.5876449,
        size.width * 0.6979282,
        size.height * 0.5965759);
    path_73.cubicTo(
        size.width * 0.6921411,
        size.height * 0.6054965,
        size.width * 0.6850335,
        size.height * 0.6128949,
        size.width * 0.6743828,
        size.height * 0.6195456);
    path_73.cubicTo(
        size.width * 0.6637297,
        size.height * 0.6261974,
        size.width * 0.6494856,
        size.height * 0.6321297,
        size.width * 0.6293493,
        size.height * 0.6380864);
    path_73.cubicTo(
        size.width * 0.6134737,
        size.height * 0.6427839,
        size.width * 0.5986699,
        size.height * 0.6446671,
        size.width * 0.5849928,
        size.height * 0.6442734);
    path_73.cubicTo(
        size.width * 0.5713134,
        size.height * 0.6438797,
        size.width * 0.5586483,
        size.height * 0.6412068,
        size.width * 0.5470598,
        size.height * 0.6366986);
    path_73.cubicTo(
        size.width * 0.5238349,
        size.height * 0.6276647,
        size.width * 0.5050311,
        size.height * 0.6113014,
        size.width * 0.4913517,
        size.height * 0.5914159);
    path_73.cubicTo(
        size.width * 0.4640024,
        size.height * 0.5516577,
        size.width * 0.4573876,
        size.height * 0.4981951,
        size.width * 0.4762392,
        size.height * 0.4623773);
    path_73.close();

    Paint paint_73_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_73_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_73, paint_73_stroke);

    Paint paint_73_fill = Paint()..style = PaintingStyle.fill;
    paint_73_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_73, paint_73_fill);

    Path path_74 = Path();
    path_74.moveTo(size.width * 0.9053541, size.height * 0.9251530);
    path_74.cubicTo(
        size.width * 0.9313182,
        size.height * 0.8968843,
        size.width * 0.9227847,
        size.height * 0.8682862,
        size.width * 0.8934330,
        size.height * 0.8435958);
    path_74.cubicTo(
        size.width * 0.8640646,
        size.height * 0.8188925,
        size.width * 0.8138684,
        size.height * 0.7981192,
        size.width * 0.7566388,
        size.height * 0.7855841);
    path_74.cubicTo(
        size.width * 0.7280407,
        size.height * 0.7793201,
        size.width * 0.7087129,
        size.height * 0.7788668,
        size.width * 0.6948900,
        size.height * 0.7823633);
    path_74.cubicTo(
        size.width * 0.6810263,
        size.height * 0.7858703,
        size.width * 0.6722871,
        size.height * 0.7934474,
        size.width * 0.6653971,
        size.height * 0.8037675);
    path_74.cubicTo(
        size.width * 0.6603278,
        size.height * 0.8113586,
        size.width * 0.6563182,
        size.height * 0.8203306,
        size.width * 0.6519569,
        size.height * 0.8300900);
    path_74.cubicTo(
        size.width * 0.6503947,
        size.height * 0.8335853,
        size.width * 0.6487871,
        size.height * 0.8371811,
        size.width * 0.6470718,
        size.height * 0.8408505);
    path_74.cubicTo(
        size.width * 0.6405718,
        size.height * 0.8547418,
        size.width * 0.6325144,
        size.height * 0.8696425,
        size.width * 0.6193900,
        size.height * 0.8839299);
    path_74.cubicTo(
        size.width * 0.6065239,
        size.height * 0.8979369,
        size.width * 0.5944522,
        size.height * 0.9091822,
        size.width * 0.5841794,
        size.height * 0.9187523);
    path_74.lineTo(size.width * 0.5836388, size.height * 0.9192558);
    path_74.cubicTo(
        size.width * 0.5732416,
        size.height * 0.9289428,
        size.width * 0.5647584,
        size.height * 0.9368832,
        size.width * 0.5591818,
        size.height * 0.9442664);
    path_74.cubicTo(
        size.width * 0.5536172,
        size.height * 0.9516367,
        size.width * 0.5509641,
        size.height * 0.9584264,
        size.width * 0.5522105,
        size.height * 0.9657991);
    path_74.cubicTo(
        size.width * 0.5534569,
        size.height * 0.9731787,
        size.width * 0.5586124,
        size.height * 0.9811869,
        size.width * 0.5687967,
        size.height * 0.9909825);
    path_74.cubicTo(
        size.width * 0.5847919,
        size.height * 1.006367,
        size.width * 0.6104067,
        size.height * 1.013489,
        size.width * 0.6407249,
        size.height * 1.014669);
    path_74.cubicTo(
        size.width * 0.6711268,
        size.height * 1.015853,
        size.width * 0.7063110,
        size.height * 1.011060,
        size.width * 0.7412321,
        size.height * 1.002516);
    path_74.cubicTo(
        size.width * 0.8110933,
        size.height * 0.9854264,
        size.width * 0.8793421,
        size.height * 0.9534708,
        size.width * 0.9053541,
        size.height * 0.9251530);
    path_74.close();

    Paint paint_74_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_74_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_74, paint_74_stroke);

    Paint paint_74_fill = Paint()..style = PaintingStyle.fill;
    paint_74_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_74, paint_74_fill);

    Path path_75 = Path();
    path_75.moveTo(size.width * 0.8799211, size.height * 0.9216157);
    path_75.cubicTo(
        size.width * 0.9030191,
        size.height * 0.8964685,
        size.width * 0.8969904,
        size.height * 0.8713820,
        size.width * 0.8732440,
        size.height * 0.8499486);
    path_75.cubicTo(
        size.width * 0.8494833,
        size.height * 0.8285012,
        size.width * 0.8079809,
        size.height * 0.8107185,
        size.width * 0.7602033,
        size.height * 0.8002535);
    path_75.cubicTo(
        size.width * 0.7363445,
        size.height * 0.7950280,
        size.width * 0.7201196,
        size.height * 0.7948306,
        size.width * 0.7083684,
        size.height * 0.7980269);
    path_75.cubicTo(
        size.width * 0.6965502,
        size.height * 0.8012418,
        size.width * 0.6888589,
        size.height * 0.8079895,
        size.width * 0.6826100,
        size.height * 0.8171484);
    path_75.cubicTo(
        size.width * 0.6780144,
        size.height * 0.8238832,
        size.width * 0.6742560,
        size.height * 0.8318224,
        size.width * 0.6701675,
        size.height * 0.8404614);
    path_75.cubicTo(
        size.width * 0.6687033,
        size.height * 0.8435549,
        size.width * 0.6671962,
        size.height * 0.8467383,
        size.width * 0.6655933,
        size.height * 0.8499883);
    path_75.cubicTo(
        size.width * 0.6595287,
        size.height * 0.8622897,
        size.width * 0.6521029,
        size.height * 0.8754942,
        size.width * 0.6404211,
        size.height * 0.8882114);
    path_75.cubicTo(
        size.width * 0.6290263,
        size.height * 0.9006180,
        size.width * 0.6184234,
        size.height * 0.9106086,
        size.width * 0.6093971,
        size.height * 0.9191145);
    path_75.lineTo(size.width * 0.6087919, size.height * 0.9196846);
    path_75.cubicTo(
        size.width * 0.5996268,
        size.height * 0.9283224,
        size.width * 0.5921579,
        size.height * 0.9354007,
        size.width * 0.5871603,
        size.height * 0.9419591);
    path_75.cubicTo(
        size.width * 0.5821699,
        size.height * 0.9485047,
        size.width * 0.5796603,
        size.height * 0.9545070,
        size.width * 0.5803923,
        size.height * 0.9609790);
    path_75.cubicTo(
        size.width * 0.5811268,
        size.height * 0.9674568,
        size.width * 0.5851148,
        size.height * 0.9744463,
        size.width * 0.5932392,
        size.height * 0.9829591);
    path_75.cubicTo(
        size.width * 0.6060024,
        size.height * 0.9963271,
        size.width * 0.6272225,
        size.height * 1.002325,
        size.width * 0.6526794,
        size.height * 1.003064);
    path_75.cubicTo(
        size.width * 0.6782392,
        size.height * 1.003807,
        size.width * 0.7081316,
        size.height * 0.9992453,
        size.width * 0.7379976,
        size.height * 0.9913750);
    path_75.cubicTo(
        size.width * 0.7977392,
        size.height * 0.9756320,
        size.width * 0.8567823,
        size.height * 0.9468084,
        size.width * 0.8799211,
        size.height * 0.9216157);
    path_75.close();

    Paint paint_75_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_75_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_75, paint_75_stroke);

    Paint paint_75_fill = Paint()..style = PaintingStyle.fill;
    paint_75_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_75, paint_75_fill);

    Path path_76 = Path();
    path_76.moveTo(size.width * 0.8550407, size.height * 0.9190876);
    path_76.cubicTo(
        size.width * 0.8941986,
        size.height * 0.8764556,
        size.width * 0.8385909,
        size.height * 0.8347839,
        size.width * 0.7613804,
        size.height * 0.8178727);
    path_76.cubicTo(
        size.width * 0.7421364,
        size.height * 0.8136577,
        size.width * 0.7290120,
        size.height * 0.8136250,
        size.width * 0.7194163,
        size.height * 0.8163808);
    path_76.cubicTo(
        size.width * 0.7097344,
        size.height * 0.8191624,
        size.width * 0.7032656,
        size.height * 0.8248808,
        size.width * 0.6978852,
        size.height * 0.8326425);
    path_76.cubicTo(
        size.width * 0.6939306,
        size.height * 0.8383481,
        size.width * 0.6906220,
        size.height * 0.8450596,
        size.width * 0.6870191,
        size.height * 0.8523668);
    path_76.cubicTo(
        size.width * 0.6857273,
        size.height * 0.8549836,
        size.width * 0.6843995,
        size.height * 0.8576776,
        size.width * 0.6829904,
        size.height * 0.8604287);
    path_76.cubicTo(
        size.width * 0.6776603,
        size.height * 0.8708376,
        size.width * 0.6711914,
        size.height * 0.8820210,
        size.width * 0.6612656,
        size.height * 0.8928271);
    path_76.cubicTo(
        size.width * 0.6515885,
        size.height * 0.9033645,
        size.width * 0.6426316,
        size.height * 0.9118610,
        size.width * 0.6350072,
        size.height * 0.9190935);
    path_76.lineTo(size.width * 0.6344952, size.height * 0.9195783);
    path_76.cubicTo(
        size.width * 0.6267536,
        size.height * 0.9269241,
        size.width * 0.6204474,
        size.height * 0.9329393,
        size.width * 0.6161699,
        size.height * 0.9384965);
    path_76.cubicTo(
        size.width * 0.6119019,
        size.height * 0.9440432,
        size.width * 0.6096722,
        size.height * 0.9491086,
        size.width * 0.6100670,
        size.height * 0.9545432);
    path_76.cubicTo(
        size.width * 0.6104617,
        size.height * 0.9599813,
        size.width * 0.6134856,
        size.height * 0.9658271,
        size.width * 0.6198373,
        size.height * 0.9729299);
    path_76.cubicTo(
        size.width * 0.6248278,
        size.height * 0.9785117,
        size.width * 0.6315861,
        size.height * 0.9825000,
        size.width * 0.6396292,
        size.height * 0.9851495);
    path_76.cubicTo(
        size.width * 0.6476770,
        size.height * 0.9878002,
        size.width * 0.6570789,
        size.height * 0.9891332,
        size.width * 0.6674330,
        size.height * 0.9893493);
    path_76.cubicTo(
        size.width * 0.6881770,
        size.height * 0.9897827,
        size.width * 0.7126435,
        size.height * 0.9857290,
        size.width * 0.7372273,
        size.height * 0.9788785);
    path_76.cubicTo(
        size.width * 0.7863923,
        size.height * 0.9651787,
        size.width * 0.8354019,
        size.height * 0.9404685,
        size.width * 0.8550407,
        size.height * 0.9190876);
    path_76.close();

    Paint paint_76_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_76_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_76, paint_76_stroke);

    Paint paint_76_fill = Paint()..style = PaintingStyle.fill;
    paint_76_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_76, paint_76_fill);

    Path path_77 = Path();
    path_77.moveTo(size.width * 0.8301579, size.height * 0.9165596);
    path_77.cubicTo(
        size.width * 0.8623325,
        size.height * 0.8815315,
        size.width * 0.8212895,
        size.height * 0.8483540,
        size.width * 0.7625574,
        size.height * 0.8354907);
    path_77.cubicTo(
        size.width * 0.7479402,
        size.height * 0.8322886,
        size.width * 0.7379163,
        size.height * 0.8324171,
        size.width * 0.7304761,
        size.height * 0.8347301);
    path_77.cubicTo(
        size.width * 0.7229211,
        size.height * 0.8370783,
        size.width * 0.7176722,
        size.height * 0.8417722,
        size.width * 0.7131603,
        size.height * 0.8481379);
    path_77.cubicTo(
        size.width * 0.7098445,
        size.height * 0.8528131,
        size.width * 0.7069833,
        size.height * 0.8582991,
        size.width * 0.7038660,
        size.height * 0.8642734);
    path_77.cubicTo(
        size.width * 0.7027488,
        size.height * 0.8664147,
        size.width * 0.7016005,
        size.height * 0.8686192,
        size.width * 0.7003852,
        size.height * 0.8708715);
    path_77.cubicTo(
        size.width * 0.6957895,
        size.height * 0.8793879,
        size.width * 0.6902799,
        size.height * 0.8885491,
        size.width * 0.6821124,
        size.height * 0.8974416);
    path_77.cubicTo(
        size.width * 0.6741483,
        size.height * 0.9061098,
        size.width * 0.6668373,
        size.height * 0.9131121,
        size.width * 0.6606148,
        size.height * 0.9190713);
    path_77.lineTo(size.width * 0.6601986, size.height * 0.9194708);
    path_77.cubicTo(
        size.width * 0.6538780,
        size.height * 0.9255245,
        size.width * 0.6487344,
        size.height * 0.9304766,
        size.width * 0.6451794,
        size.height * 0.9350350);
    path_77.cubicTo(
        size.width * 0.6416316,
        size.height * 0.9395829,
        size.width * 0.6396842,
        size.height * 0.9437138,
        size.width * 0.6397416,
        size.height * 0.9481121);
    path_77.cubicTo(
        size.width * 0.6397967,
        size.height * 0.9525117,
        size.width * 0.6418612,
        size.height * 0.9572161,
        size.width * 0.6464378,
        size.height * 0.9629065);
    path_77.cubicTo(
        size.width * 0.6500263,
        size.height * 0.9673692,
        size.width * 0.6550359,
        size.height * 0.9705105,
        size.width * 0.6610646,
        size.height * 0.9725526);
    path_77.cubicTo(
        size.width * 0.6670957,
        size.height * 0.9745958,
        size.width * 0.6742321,
        size.height * 0.9755701,
        size.width * 0.6821722,
        size.height * 0.9756332);
    path_77.cubicTo(
        size.width * 0.6980981,
        size.height * 0.9757582,
        size.width * 0.7171411,
        size.height * 0.9722161,
        size.width * 0.7364450,
        size.height * 0.9663855);
    path_77.cubicTo(
        size.width * 0.7750359,
        size.height * 0.9547290,
        size.width * 0.8140191,
        size.height * 0.9341308,
        size.width * 0.8301579,
        size.height * 0.9165596);
    path_77.close();

    Paint paint_77_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_77_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_77, paint_77_stroke);

    Paint paint_77_fill = Paint()..style = PaintingStyle.fill;
    paint_77_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_77, paint_77_fill);

    Path path_78 = Path();
    path_78.moveTo(size.width * 0.3957847, size.height * 0.9251530);
    path_78.cubicTo(
        size.width * 0.4217488,
        size.height * 0.8968843,
        size.width * 0.4132153,
        size.height * 0.8682862,
        size.width * 0.3838636,
        size.height * 0.8435958);
    path_78.cubicTo(
        size.width * 0.3544952,
        size.height * 0.8188925,
        size.width * 0.3042990,
        size.height * 0.7981192,
        size.width * 0.2470694,
        size.height * 0.7855841);
    path_78.cubicTo(
        size.width * 0.2184722,
        size.height * 0.7793201,
        size.width * 0.1991445,
        size.height * 0.7788668,
        size.width * 0.1853215,
        size.height * 0.7823633);
    path_78.cubicTo(
        size.width * 0.1714562,
        size.height * 0.7858703,
        size.width * 0.1627184,
        size.height * 0.7934474,
        size.width * 0.1558273,
        size.height * 0.8037675);
    path_78.cubicTo(
        size.width * 0.1507577,
        size.height * 0.8113586,
        size.width * 0.1467486,
        size.height * 0.8203306,
        size.width * 0.1423871,
        size.height * 0.8300900);
    path_78.cubicTo(
        size.width * 0.1408256,
        size.height * 0.8335853,
        size.width * 0.1392187,
        size.height * 0.8371811,
        size.width * 0.1375019,
        size.height * 0.8408505);
    path_78.cubicTo(
        size.width * 0.1310026,
        size.height * 0.8547418,
        size.width * 0.1229452,
        size.height * 0.8696425,
        size.width * 0.1098208,
        size.height * 0.8839299);
    path_78.cubicTo(
        size.width * 0.09695550,
        size.height * 0.8979369,
        size.width * 0.08488325,
        size.height * 0.9091822,
        size.width * 0.07461100,
        size.height * 0.9187523);
    path_78.lineTo(size.width * 0.07407010, size.height * 0.9192558);
    path_78.cubicTo(
        size.width * 0.06367129,
        size.height * 0.9289428,
        size.width * 0.05518995,
        size.height * 0.9368832,
        size.width * 0.04961316,
        size.height * 0.9442664);
    path_78.cubicTo(
        size.width * 0.04404689,
        size.height * 0.9516367,
        size.width * 0.04139545,
        size.height * 0.9584264,
        size.width * 0.04264043,
        size.height * 0.9657991);
    path_78.cubicTo(
        size.width * 0.04388660,
        size.height * 0.9731787,
        size.width * 0.04904354,
        size.height * 0.9811869,
        size.width * 0.05922799,
        size.height * 0.9909825);
    path_78.cubicTo(
        size.width * 0.07522225,
        size.height * 1.006367,
        size.width * 0.1008361,
        size.height * 1.013489,
        size.width * 0.1311562,
        size.height * 1.014669);
    path_78.cubicTo(
        size.width * 0.1615581,
        size.height * 1.015853,
        size.width * 0.1967423,
        size.height * 1.011060,
        size.width * 0.2316634,
        size.height * 1.002516);
    path_78.cubicTo(
        size.width * 0.3015239,
        size.height * 0.9854264,
        size.width * 0.3697727,
        size.height * 0.9534708,
        size.width * 0.3957847,
        size.height * 0.9251530);
    path_78.close();

    Paint paint_78_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_78_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_78, paint_78_stroke);

    Paint paint_78_fill = Paint()..style = PaintingStyle.fill;
    paint_78_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_78, paint_78_fill);

    Path path_79 = Path();
    path_79.moveTo(size.width * 0.3703517, size.height * 0.9216157);
    path_79.cubicTo(
        size.width * 0.3934498,
        size.height * 0.8964685,
        size.width * 0.3874211,
        size.height * 0.8713820,
        size.width * 0.3636746,
        size.height * 0.8499486);
    path_79.cubicTo(
        size.width * 0.3399139,
        size.height * 0.8285012,
        size.width * 0.2984115,
        size.height * 0.8107185,
        size.width * 0.2506340,
        size.height * 0.8002535);
    path_79.cubicTo(
        size.width * 0.2267751,
        size.height * 0.7950280,
        size.width * 0.2105502,
        size.height * 0.7948306,
        size.width * 0.1987993,
        size.height * 0.7980269);
    path_79.cubicTo(
        size.width * 0.1869799,
        size.height * 0.8012418,
        size.width * 0.1792897,
        size.height * 0.8079895,
        size.width * 0.1730400,
        size.height * 0.8171484);
    path_79.cubicTo(
        size.width * 0.1684440,
        size.height * 0.8238832,
        size.width * 0.1646866,
        size.height * 0.8318224,
        size.width * 0.1605981,
        size.height * 0.8404614);
    path_79.cubicTo(
        size.width * 0.1591340,
        size.height * 0.8435549,
        size.width * 0.1576275,
        size.height * 0.8467383,
        size.width * 0.1560246,
        size.height * 0.8499883);
    path_79.cubicTo(
        size.width * 0.1499584,
        size.height * 0.8622897,
        size.width * 0.1425335,
        size.height * 0.8754942,
        size.width * 0.1308522,
        size.height * 0.8882114);
    path_79.cubicTo(
        size.width * 0.1194569,
        size.height * 0.9006180,
        size.width * 0.1088538,
        size.height * 0.9106086,
        size.width * 0.09982727,
        size.height * 0.9191145);
    path_79.lineTo(size.width * 0.09922321, size.height * 0.9196846);
    path_79.cubicTo(
        size.width * 0.09005718,
        size.height * 0.9283224,
        size.width * 0.08258947,
        size.height * 0.9354007,
        size.width * 0.07758995,
        size.height * 0.9419591);
    path_79.cubicTo(
        size.width * 0.07260024,
        size.height * 0.9485047,
        size.width * 0.07009019,
        size.height * 0.9545070,
        size.width * 0.07082368,
        size.height * 0.9609790);
    path_79.cubicTo(
        size.width * 0.07155766,
        size.height * 0.9674568,
        size.width * 0.07554450,
        size.height * 0.9744463,
        size.width * 0.08367105,
        size.height * 0.9829591);
    path_79.cubicTo(
        size.width * 0.09643254,
        size.height * 0.9963271,
        size.width * 0.1176533,
        size.height * 1.002325,
        size.width * 0.1431105,
        size.height * 1.003064);
    path_79.cubicTo(
        size.width * 0.1686689,
        size.height * 1.003807,
        size.width * 0.1985622,
        size.height * 0.9992453,
        size.width * 0.2284287,
        size.height * 0.9913750);
    path_79.cubicTo(
        size.width * 0.2881699,
        size.height * 0.9756320,
        size.width * 0.3472129,
        size.height * 0.9468084,
        size.width * 0.3703517,
        size.height * 0.9216157);
    path_79.close();

    Paint paint_79_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_79_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_79, paint_79_stroke);

    Paint paint_79_fill = Paint()..style = PaintingStyle.fill;
    paint_79_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_79, paint_79_fill);

    Path path_80 = Path();
    path_80.moveTo(size.width * 0.3454713, size.height * 0.9190876);
    path_80.cubicTo(
        size.width * 0.3846292,
        size.height * 0.8764556,
        size.width * 0.3290215,
        size.height * 0.8347839,
        size.width * 0.2518110,
        size.height * 0.8178727);
    path_80.cubicTo(
        size.width * 0.2325675,
        size.height * 0.8136577,
        size.width * 0.2194416,
        size.height * 0.8136250,
        size.width * 0.2098471,
        size.height * 0.8163808);
    path_80.cubicTo(
        size.width * 0.2001653,
        size.height * 0.8191624,
        size.width * 0.1936971,
        size.height * 0.8248808,
        size.width * 0.1883160,
        size.height * 0.8326425);
    path_80.cubicTo(
        size.width * 0.1843608,
        size.height * 0.8383481,
        size.width * 0.1810514,
        size.height * 0.8450596,
        size.width * 0.1774490,
        size.height * 0.8523668);
    path_80.cubicTo(
        size.width * 0.1761584,
        size.height * 0.8549836,
        size.width * 0.1748301,
        size.height * 0.8576776,
        size.width * 0.1734211,
        size.height * 0.8604287);
    path_80.cubicTo(
        size.width * 0.1680904,
        size.height * 0.8708376,
        size.width * 0.1616225,
        size.height * 0.8820210,
        size.width * 0.1516974,
        size.height * 0.8928271);
    path_80.cubicTo(
        size.width * 0.1420184,
        size.height * 0.9033645,
        size.width * 0.1330612,
        size.height * 0.9118610,
        size.width * 0.1254366,
        size.height * 0.9190935);
    path_80.lineTo(size.width * 0.1249261, size.height * 0.9195783);
    path_80.cubicTo(
        size.width * 0.1171830,
        size.height * 0.9269241,
        size.width * 0.1108780,
        size.height * 0.9329393,
        size.width * 0.1066002,
        size.height * 0.9384965);
    path_80.cubicTo(
        size.width * 0.1023318,
        size.height * 0.9440432,
        size.width * 0.1001036,
        size.height * 0.9491086,
        size.width * 0.1004981,
        size.height * 0.9545432);
    path_80.cubicTo(
        size.width * 0.1008928,
        size.height * 0.9599813,
        size.width * 0.1039165,
        size.height * 0.9658271,
        size.width * 0.1102672,
        size.height * 0.9729299);
    path_80.cubicTo(
        size.width * 0.1152586,
        size.height * 0.9785117,
        size.width * 0.1220163,
        size.height * 0.9825000,
        size.width * 0.1300610,
        size.height * 0.9851495);
    path_80.cubicTo(
        size.width * 0.1381077,
        size.height * 0.9878002,
        size.width * 0.1475105,
        size.height * 0.9891332,
        size.width * 0.1578627,
        size.height * 0.9893493);
    path_80.cubicTo(
        size.width * 0.1786069,
        size.height * 0.9897827,
        size.width * 0.2030749,
        size.height * 0.9857290,
        size.width * 0.2276577,
        size.height * 0.9788785);
    path_80.cubicTo(
        size.width * 0.2768230,
        size.height * 0.9651787,
        size.width * 0.3258325,
        size.height * 0.9404685,
        size.width * 0.3454713,
        size.height * 0.9190876);
    path_80.close();

    Paint paint_80_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_80_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_80, paint_80_stroke);

    Paint paint_80_fill = Paint()..style = PaintingStyle.fill;
    paint_80_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_80, paint_80_fill);

    Path path_81 = Path();
    path_81.moveTo(size.width * 0.3205885, size.height * 0.9165596);
    path_81.cubicTo(
        size.width * 0.3527632,
        size.height * 0.8815315,
        size.width * 0.3117201,
        size.height * 0.8483540,
        size.width * 0.2529880,
        size.height * 0.8354907);
    path_81.cubicTo(
        size.width * 0.2383711,
        size.height * 0.8322886,
        size.width * 0.2283478,
        size.height * 0.8324171,
        size.width * 0.2209057,
        size.height * 0.8347301);
    path_81.cubicTo(
        size.width * 0.2133517,
        size.height * 0.8370783,
        size.width * 0.2081036,
        size.height * 0.8417722,
        size.width * 0.2035907,
        size.height * 0.8481379);
    path_81.cubicTo(
        size.width * 0.2002758,
        size.height * 0.8528131,
        size.width * 0.1974144,
        size.height * 0.8582991,
        size.width * 0.1942976,
        size.height * 0.8642734);
    path_81.cubicTo(
        size.width * 0.1931806,
        size.height * 0.8664147,
        size.width * 0.1920306,
        size.height * 0.8686192,
        size.width * 0.1908156,
        size.height * 0.8708715);
    path_81.cubicTo(
        size.width * 0.1862206,
        size.height * 0.8793879,
        size.width * 0.1807098,
        size.height * 0.8885491,
        size.width * 0.1725419,
        size.height * 0.8974416);
    path_81.cubicTo(
        size.width * 0.1645799,
        size.height * 0.9061098,
        size.width * 0.1572684,
        size.height * 0.9131121,
        size.width * 0.1510462,
        size.height * 0.9190713);
    path_81.lineTo(size.width * 0.1506292, size.height * 0.9194708);
    path_81.cubicTo(
        size.width * 0.1443091,
        size.height * 0.9255245,
        size.width * 0.1391656,
        size.height * 0.9304766,
        size.width * 0.1356096,
        size.height * 0.9350350);
    path_81.cubicTo(
        size.width * 0.1320612,
        size.height * 0.9395829,
        size.width * 0.1301144,
        size.height * 0.9437138,
        size.width * 0.1301713,
        size.height * 0.9481121);
    path_81.cubicTo(
        size.width * 0.1302285,
        size.height * 0.9525117,
        size.width * 0.1322919,
        size.height * 0.9572161,
        size.width * 0.1368679,
        size.height * 0.9629065);
    path_81.cubicTo(
        size.width * 0.1404567,
        size.height * 0.9673692,
        size.width * 0.1454653,
        size.height * 0.9705105,
        size.width * 0.1514962,
        size.height * 0.9725526);
    path_81.cubicTo(
        size.width * 0.1575275,
        size.height * 0.9745958,
        size.width * 0.1646636,
        size.height * 0.9755701,
        size.width * 0.1726024,
        size.height * 0.9756332);
    path_81.cubicTo(
        size.width * 0.1885289,
        size.height * 0.9757582,
        size.width * 0.2075715,
        size.height * 0.9722161,
        size.width * 0.2268746,
        size.height * 0.9663855);
    path_81.cubicTo(
        size.width * 0.2654665,
        size.height * 0.9547290,
        size.width * 0.3044498,
        size.height * 0.9341308,
        size.width * 0.3205885,
        size.height * 0.9165596);
    path_81.close();

    Paint paint_81_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_81_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_81, paint_81_stroke);

    Paint paint_81_fill = Paint()..style = PaintingStyle.fill;
    paint_81_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_81, paint_81_fill);

    Path path_82 = Path();
    path_82.moveTo(size.width * 0.6749211, size.height * 0.2565678);
    path_82.cubicTo(
        size.width * 0.7458493,
        size.height * 0.2858773,
        size.width * 0.8304593,
        size.height * 0.2923248,
        size.width * 0.9115694,
        size.height * 0.2832570);
    path_82.cubicTo(
        size.width * 0.9927081,
        size.height * 0.2741869,
        size.width * 1.070328,
        size.height * 0.2495900,
        size.width * 1.127100,
        size.height * 0.2168283);
    path_82.cubicTo(
        size.width * 1.155469,
        size.height * 0.2004579,
        size.width * 1.164000,
        size.height * 0.1877325,
        size.width * 1.159112,
        size.height * 0.1769509);
    path_82.cubicTo(
        size.width * 1.154211,
        size.height * 0.1661355,
        size.width * 1.135725,
        size.height * 0.1570596,
        size.width * 1.108916,
        size.height * 0.1480993);
    path_82.cubicTo(
        size.width * 1.089187,
        size.height * 0.1415035,
        size.width * 1.065132,
        size.height * 0.1350269,
        size.width * 1.038995,
        size.height * 0.1279907);
    path_82.cubicTo(
        size.width * 1.029646,
        size.height * 0.1254731,
        size.width * 1.020031,
        size.height * 0.1228843,
        size.width * 1.010251,
        size.height * 0.1201928);
    path_82.cubicTo(
        size.width * 0.9731818,
        size.height * 0.1099901,
        size.width * 0.9338541,
        size.height * 0.09833306,
        size.width * 0.8981364,
        size.height * 0.08357442);
    path_82.cubicTo(
        size.width * 0.8630933,
        size.height * 0.06909428,
        size.width * 0.8356005,
        size.height * 0.05631005,
        size.width * 0.8121962,
        size.height * 0.04542745);
    path_82.lineTo(size.width * 0.8109665, size.height * 0.04485549);
    path_82.cubicTo(
        size.width * 0.7872799,
        size.height * 0.03384241,
        size.width * 0.7678158,
        size.height * 0.02482617,
        size.width * 0.7488517,
        size.height * 0.01797722);
    path_82.cubicTo(
        size.width * 0.7299139,
        size.height * 0.01113671,
        size.width * 0.7115191,
        size.height * 0.006475502,
        size.width * 0.6900072,
        size.height * 0.004168762);
    path_82.cubicTo(
        size.width * 0.6684833,
        size.height * 0.001860864,
        size.width * 0.6437536,
        size.height * 0.001900783,
        size.width * 0.6121220,
        size.height * 0.004524404);
    path_82.cubicTo(
        size.width * 0.5623301,
        size.height * 0.008654334,
        size.width * 0.5325311,
        size.height * 0.02272033,
        size.width * 0.5179498,
        size.height * 0.04243914);
    path_82.cubicTo(
        size.width * 0.5033349,
        size.height * 0.06220129,
        size.width * 0.5039928,
        size.height * 0.08767068,
        size.width * 0.5154019,
        size.height * 0.1145298);
    path_82.cubicTo(
        size.width * 0.5382249,
        size.height * 0.1682535,
        size.width * 0.6039115,
        size.height * 0.2272255,
        size.width * 0.6749211,
        size.height * 0.2565678);
    path_82.close();

    Paint paint_82_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_82_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_82, paint_82_stroke);

    Paint paint_82_fill = Paint()..style = PaintingStyle.fill;
    paint_82_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_82, paint_82_fill);
  //fin de la mascara
    Path path_83 = Path();
    path_83.moveTo(size.width * 0.6943493, size.height * 0.2411600);
    path_83.cubicTo(
        size.width * 0.8204833,
        size.height * 0.2932804,
        size.width * 0.9892273,
        size.height * 0.2677313,
        size.width * 1.084100,
        size.height * 0.2129836);
    path_83.cubicTo(
        size.width * 1.107778,
        size.height * 0.1993201,
        size.width * 1.114438,
        size.height * 0.1885467,
        size.width * 1.109627,
        size.height * 0.1792664);
    path_83.cubicTo(
        size.width * 1.104794,
        size.height * 0.1699404,
        size.width * 1.088289,
        size.height * 0.1619159,
        size.width * 1.064548,
        size.height * 0.1538738);
    path_83.cubicTo(
        size.width * 1.047079,
        size.height * 0.1479568,
        size.width * 1.025866,
        size.height * 0.1420853,
        size.width * 1.002816,
        size.height * 0.1357056);
    path_83.cubicTo(
        size.width * 0.9945694,
        size.height * 0.1334229,
        size.width * 0.9860885,
        size.height * 0.1310748,
        size.width * 0.9774569,
        size.height * 0.1286367);
    path_83.cubicTo(
        size.width * 0.9447488,
        size.height * 0.1193960,
        size.width * 0.9100024,
        size.height * 0.1088766,
        size.width * 0.8782129,
        size.height * 0.09574171);
    path_83.cubicTo(
        size.width * 0.8471770,
        size.height * 0.08291636,
        size.width * 0.8227057,
        size.height * 0.07163995,
        size.width * 0.8018636,
        size.height * 0.06203586);
    path_83.lineTo(size.width * 0.8004689, size.height * 0.06139404);
    path_83.cubicTo(
        size.width * 0.7793110,
        size.height * 0.05164486,
        size.width * 0.7619234,
        size.height * 0.04366834,
        size.width * 0.7450957,
        size.height * 0.03755386);
    path_83.cubicTo(
        size.width * 0.7282871,
        size.height * 0.03144673,
        size.width * 0.7120837,
        size.height * 0.02721379,
        size.width * 0.6933230,
        size.height * 0.02494766);
    path_83.cubicTo(
        size.width * 0.6745550,
        size.height * 0.02268072,
        size.width * 0.6531531,
        size.height * 0.02237266,
        size.width * 0.6259258,
        size.height * 0.02417126);
    path_83.cubicTo(
        size.width * 0.6044426,
        size.height * 0.02559030,
        size.width * 0.5874880,
        size.height * 0.02921379,
        size.width * 0.5744665,
        size.height * 0.03454673);
    path_83.cubicTo(
        size.width * 0.5614426,
        size.height * 0.03988049,
        size.width * 0.5522943,
        size.height * 0.04694965,
        size.width * 0.5465144,
        size.height * 0.05530666);
    path_83.cubicTo(
        size.width * 0.5349402,
        size.height * 0.07203867,
        size.width * 0.5368971,
        size.height * 0.09389428,
        size.width * 0.5482584,
        size.height * 0.1171075);
    path_83.cubicTo(
        size.width * 0.5709856,
        size.height * 0.1635327,
        size.width * 0.6311722,
        size.height * 0.2150537,
        size.width * 0.6943493,
        size.height * 0.2411600);
    path_83.close();

    Paint paint_83_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_83_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_83, paint_83_stroke);

    Paint paint_83_fill = Paint()..style = PaintingStyle.fill;
    paint_83_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_83, paint_83_fill);

    Path path_84 = Path();
    path_84.moveTo(size.width * 0.7322416, size.height * 0.2256904);
    path_84.cubicTo(
        size.width * 0.8392943,
        size.height * 0.2699252,
        size.width * 0.9785311,
        size.height * 0.2505058,
        size.width * 1.055132,
        size.height * 0.2063014);
    path_84.cubicTo(
        size.width * 1.074239,
        size.height * 0.1952769,
        size.width * 1.079287,
        size.height * 0.1864918,
        size.width * 1.074928,
        size.height * 0.1788294);
    path_84.cubicTo(
        size.width * 1.070536,
        size.height * 0.1711121,
        size.width * 1.056507,
        size.height * 0.1643364,
        size.width * 1.036419,
        size.height * 0.1574650);
    path_84.cubicTo(
        size.width * 1.021641,
        size.height * 0.1524112,
        size.width * 1.003754,
        size.height * 0.1473575,
        size.width * 0.9843110,
        size.height * 0.1418657);
    path_84.cubicTo(
        size.width * 0.9773517,
        size.height * 0.1398995,
        size.width * 0.9701962,
        size.height * 0.1378785,
        size.width * 0.9629115,
        size.height * 0.1357792);
    path_84.cubicTo(
        size.width * 0.9353086,
        size.height * 0.1278294,
        size.width * 0.9059498,
        size.height * 0.1188026,
        size.width * 0.8789450,
        size.height * 0.1076437);
    path_84.cubicTo(
        size.width * 0.8525837,
        size.height * 0.09675070,
        size.width * 0.8317512,
        size.height * 0.08720117,
        size.width * 0.8140096,
        size.height * 0.07906857);
    path_84.lineTo(size.width * 0.8128254, size.height * 0.07852488);
    path_84.cubicTo(
        size.width * 0.7948134,
        size.height * 0.07026881,
        size.width * 0.7800191,
        size.height * 0.06351624,
        size.width * 0.7657679,
        size.height * 0.05830596);
    path_84.cubicTo(
        size.width * 0.7515383,
        size.height * 0.05310269,
        size.width * 0.7378947,
        size.height * 0.04945409,
        size.width * 0.7222129,
        size.height * 0.04740199);
    path_84.cubicTo(
        size.width * 0.7065263,
        size.height * 0.04534930,
        size.width * 0.6887273,
        size.height * 0.04488411,
        size.width * 0.6661627,
        size.height * 0.04609942);
    path_84.cubicTo(
        size.width * 0.6483780,
        size.height * 0.04705724,
        size.width * 0.6344641,
        size.height * 0.04987442,
        size.width * 0.6238971,
        size.height * 0.05412886);
    path_84.cubicTo(
        size.width * 0.6133278,
        size.height * 0.05838376,
        size.width * 0.6060335,
        size.height * 0.06410502,
        size.width * 0.6015789,
        size.height * 0.07092710);
    path_84.cubicTo(
        size.width * 0.5926603,
        size.height * 0.08459206,
        size.width * 0.5951770,
        size.height * 0.1026272,
        size.width * 0.6055909,
        size.height * 0.1218949);
    path_84.cubicTo(
        size.width * 0.6264139,
        size.height * 0.1604241,
        size.width * 0.6786124,
        size.height * 0.2035292,
        size.width * 0.7322416,
        size.height * 0.2256904);
    path_84.close();

    Paint paint_84_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_84_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_84, paint_84_stroke);

    Paint paint_84_fill = Paint()..style = PaintingStyle.fill;
    paint_84_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_84, paint_84_fill);

    Path path_85 = Path();
    path_85.moveTo(size.width * 0.7486029, size.height * 0.2102208);
    path_85.cubicTo(
        size.width * 0.8365957,
        size.height * 0.2465806,
        size.width * 0.9463230,
        size.height * 0.2332687,
        size.width * 1.004634,
        size.height * 0.1996203);
    path_85.cubicTo(
        size.width * 1.019158,
        size.height * 0.1912383,
        size.width * 1.022603,
        size.height * 0.1844439,
        size.width * 1.018699,
        size.height * 0.1783984);
    path_85.cubicTo(
        size.width * 1.014751,
        size.height * 0.1722850,
        size.width * 1.003194,
        size.height * 0.1667582,
        size.width * 0.9867560,
        size.height * 0.1610561);
    path_85.cubicTo(
        size.width * 0.9746699,
        size.height * 0.1568645,
        size.width * 0.9601053,
        size.height * 0.1526297,
        size.width * 0.9442679,
        size.height * 0.1480245);
    path_85.cubicTo(
        size.width * 0.9386005,
        size.height * 0.1463750,
        size.width * 0.9327679,
        size.height * 0.1446799,
        size.width * 0.9268278,
        size.height * 0.1429217);
    path_85.cubicTo(
        size.width * 0.9043301,
        size.height * 0.1362617,
        size.width * 0.8803636,
        size.height * 0.1287266,
        size.width * 0.8581435,
        size.height * 0.1195456);
    path_85.cubicTo(
        size.width * 0.8364593,
        size.height * 0.1105856,
        size.width * 0.8192679,
        size.height * 0.1027630,
        size.width * 0.8046268,
        size.height * 0.09610187);
    path_85.lineTo(size.width * 0.8036483, size.height * 0.09565643);
    path_85.cubicTo(
        size.width * 0.7887823,
        size.height * 0.08889357,
        size.width * 0.7765813,
        size.height * 0.08336449,
        size.width * 0.7649091,
        size.height * 0.07905806);
    path_85.cubicTo(
        size.width * 0.7532536,
        size.height * 0.07475771,
        size.width * 0.7421675,
        size.height * 0.07169299,
        size.width * 0.7295598,
        size.height * 0.06985491);
    path_85.cubicTo(
        size.width * 0.7169522,
        size.height * 0.06801659,
        size.width * 0.7027536,
        size.height * 0.06739533,
        size.width * 0.6848517,
        size.height * 0.06802804);
    path_85.cubicTo(
        size.width * 0.6707608,
        size.height * 0.06852605,
        size.width * 0.6598995,
        size.height * 0.07053879,
        size.width * 0.6517895,
        size.height * 0.07371320);
    path_85.cubicTo(
        size.width * 0.6436818,
        size.height * 0.07688738,
        size.width * 0.6382416,
        size.height * 0.08125701,
        size.width * 0.6351172,
        size.height * 0.08654206);
    path_85.cubicTo(
        size.width * 0.6288493,
        size.height * 0.09713785,
        size.width * 0.6319234,
        size.height * 0.1113522,
        size.width * 0.6413852,
        size.height * 0.1266752);
    path_85.cubicTo(
        size.width * 0.6603014,
        size.height * 0.1573107,
        size.width * 0.7045144,
        size.height * 0.1920035,
        size.width * 0.7486029,
        size.height * 0.2102208);
    path_85.close();

    Paint paint_85_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_85_stroke.color = const Color(0xffFFFEFF).withOpacity(0.16);
    canvas.drawPath(path_85, paint_85_stroke);

    Paint paint_85_fill = Paint()..style = PaintingStyle.fill;
    paint_85_fill.color = const Color(0xff000000).withOpacity(0);
    canvas.drawPath(path_85, paint_85_fill);

    Paint paint_86_fill = Paint()..style = PaintingStyle.fill;
    paint_86_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.7380383, size.height * 0.2348131),
            width: size.width * 0.1172249,
            height: size.height * 0.05607477),
        paint_86_fill);

    Path path_87 = Path();
    path_87.moveTo(size.width * 0.7193301, size.height * 0.2500000);
    path_87.lineTo(size.width * 0.7193301, size.height * 0.2431028);
    path_87.lineTo(size.width * 0.7275981, size.height * 0.2431028);
    path_87.lineTo(size.width * 0.7275981, size.height * 0.2241776);
    path_87.lineTo(size.width * 0.7167464, size.height * 0.2241776);
    path_87.lineTo(size.width * 0.7167464, size.height * 0.2194252);
    path_87.lineTo(size.width * 0.7358660, size.height * 0.2172804);
    path_87.lineTo(size.width * 0.7503349, size.height * 0.2172804);
    path_87.lineTo(size.width * 0.7503349, size.height * 0.2431028);
    path_87.lineTo(size.width * 0.7575694, size.height * 0.2431028);
    path_87.lineTo(size.width * 0.7575694, size.height * 0.2500000);
    path_87.lineTo(size.width * 0.7193301, size.height * 0.2500000);
    path_87.close();

    Paint paint_87_fill = Paint()..style = PaintingStyle.fill;
    paint_87_fill.color = const Color(0xffC4C4C4).withOpacity(0.83);
    canvas.drawPath(path_87, paint_87_fill);

    Path path_88 = Path();
    path_88.moveTo(size.width * 0.2916053, size.height * 0.8657009);
    path_88.lineTo(size.width * 0.2908876, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.2977297, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.2970120, size.height * 0.8657009);
    path_88.lineTo(size.width * 0.2916053, size.height * 0.8657009);
    path_88.close();
    path_88.moveTo(size.width * 0.2838062, size.height * 0.8657009);
    path_88.lineTo(size.width * 0.2830885, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.2899306, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.2892129, size.height * 0.8657009);
    path_88.lineTo(size.width * 0.2838062, size.height * 0.8657009);
    path_88.close();
    path_88.moveTo(size.width * 0.3236842, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.3383732, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.3383732, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3364593, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3272249, size.height * 0.8722430);
    path_88.lineTo(size.width * 0.3272249, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.3296172, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.3296172, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.3114354, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.3114354, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.3138278, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.3138278, size.height * 0.8722430);
    path_88.lineTo(size.width * 0.3043062, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3023923, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3023923, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.3209091, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.3209091, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3192344, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3220574, size.height * 0.8677804);
    path_88.lineTo(size.width * 0.3225359, size.height * 0.8677804);
    path_88.lineTo(size.width * 0.3253589, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3236842, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3236842, size.height * 0.8603271);
    path_88.close();
    path_88.moveTo(size.width * 0.3516746, size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.3471459,
        size.height * 0.8788318,
        size.width * 0.3436053,
        size.height * 0.8782558,
        size.width * 0.3410526,
        size.height * 0.8771028);
    path_88.cubicTo(
        size.width * 0.3385000,
        size.height * 0.8759346,
        size.width * 0.3372249,
        size.height * 0.8742371,
        size.width * 0.3372249,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.3372249,
        size.height * 0.8697815,
        size.width * 0.3385000,
        size.height * 0.8680923,
        size.width * 0.3410526,
        size.height * 0.8669393);
    path_88.cubicTo(
        size.width * 0.3436053,
        size.height * 0.8657710,
        size.width * 0.3471459,
        size.height * 0.8651869,
        size.width * 0.3516746,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.3562679,
        size.height * 0.8651869,
        size.width * 0.3598254,
        size.height * 0.8657792,
        size.width * 0.3623445,
        size.height * 0.8669626);
    path_88.cubicTo(
        size.width * 0.3648636,
        size.height * 0.8681308,
        size.width * 0.3661244,
        size.height * 0.8698131,
        size.width * 0.3661244,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.3661244,
        size.height * 0.8742371,
        size.width * 0.3648493,
        size.height * 0.8759346,
        size.width * 0.3622967,
        size.height * 0.8771028);
    path_88.cubicTo(
        size.width * 0.3597440,
        size.height * 0.8782558,
        size.width * 0.3562033,
        size.height * 0.8788318,
        size.width * 0.3516746,
        size.height * 0.8788318);
    path_88.close();
    path_88.moveTo(size.width * 0.3516746, size.height * 0.8746729);
    path_88.cubicTo(
        size.width * 0.3526005,
        size.height * 0.8746729,
        size.width * 0.3532847,
        size.height * 0.8745561,
        size.width * 0.3537321,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.3542105,
        size.height * 0.8740736,
        size.width * 0.3544498,
        size.height * 0.8736916,
        size.width * 0.3544498,
        size.height * 0.8731776);
    path_88.lineTo(size.width * 0.3544498, size.height * 0.8708411);
    path_88.cubicTo(
        size.width * 0.3544498,
        size.height * 0.8703271,
        size.width * 0.3542105,
        size.height * 0.8699533,
        size.width * 0.3537321,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.3532847,
        size.height * 0.8694708,
        size.width * 0.3526005,
        size.height * 0.8693458,
        size.width * 0.3516746,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.3507488,
        size.height * 0.8693458,
        size.width * 0.3500478,
        size.height * 0.8694708,
        size.width * 0.3495694,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.3491220,
        size.height * 0.8699533,
        size.width * 0.3488995,
        size.height * 0.8703271,
        size.width * 0.3488995,
        size.height * 0.8708411);
    path_88.lineTo(size.width * 0.3488995, size.height * 0.8731776);
    path_88.cubicTo(
        size.width * 0.3488995,
        size.height * 0.8736916,
        size.width * 0.3491220,
        size.height * 0.8740736,
        size.width * 0.3495694,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.3500478,
        size.height * 0.8745561,
        size.width * 0.3507488,
        size.height * 0.8746729,
        size.width * 0.3516746,
        size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.4195048, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.4195048, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.4043852, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.4043852, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.4063947, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.4063947, size.height * 0.8708411);
    path_88.cubicTo(
        size.width * 0.4063947,
        size.height * 0.8703271,
        size.width * 0.4061722,
        size.height * 0.8699533,
        size.width * 0.4057249,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.4052775,
        size.height * 0.8694708,
        size.width * 0.4046077,
        size.height * 0.8693458,
        size.width * 0.4037153,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.4018014,
        size.height * 0.8693458,
        size.width * 0.4008445,
        size.height * 0.8698446,
        size.width * 0.4008445,
        size.height * 0.8708411);
    path_88.lineTo(size.width * 0.4008445, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.4028541, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.4028541, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.3877344, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.3877344, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.3898397, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.3898397, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3877344, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.3877344, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.4008445, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.4008445, size.height * 0.8673364);
    path_88.cubicTo(
        size.width * 0.4020239,
        size.height * 0.8666203,
        size.width * 0.4033014,
        size.height * 0.8660829,
        size.width * 0.4046722,
        size.height * 0.8657243);
    path_88.cubicTo(
        size.width * 0.4060431,
        size.height * 0.8653657,
        size.width * 0.4076388,
        size.height * 0.8651869,
        size.width * 0.4094569,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.4121053,
        size.height * 0.8651869,
        size.width * 0.4140813,
        size.height * 0.8655923,
        size.width * 0.4153900,
        size.height * 0.8664019);
    path_88.cubicTo(
        size.width * 0.4167297,
        size.height * 0.8672114,
        size.width * 0.4173995,
        size.height * 0.8683259,
        size.width * 0.4173995,
        size.height * 0.8697430);
    path_88.lineTo(size.width * 0.4173995, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.4195048, size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.4381794, size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.4336483,
        size.height * 0.8788318,
        size.width * 0.4301077,
        size.height * 0.8782558,
        size.width * 0.4275574,
        size.height * 0.8771028);
    path_88.cubicTo(
        size.width * 0.4250048,
        size.height * 0.8759346,
        size.width * 0.4237297,
        size.height * 0.8742371,
        size.width * 0.4237297,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.4237297,
        size.height * 0.8697815,
        size.width * 0.4250048,
        size.height * 0.8680923,
        size.width * 0.4275574,
        size.height * 0.8669393);
    path_88.cubicTo(
        size.width * 0.4301077,
        size.height * 0.8657710,
        size.width * 0.4336483,
        size.height * 0.8651869,
        size.width * 0.4381794,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.4426770,
        size.height * 0.8651869,
        size.width * 0.4459139,
        size.height * 0.8657629,
        size.width * 0.4478923,
        size.height * 0.8669159);
    path_88.cubicTo(
        size.width * 0.4499019,
        size.height * 0.8680526,
        size.width * 0.4509067,
        size.height * 0.8694708,
        size.width * 0.4509067,
        size.height * 0.8711682);
    path_88.lineTo(size.width * 0.4509067, size.height * 0.8728505);
    path_88.lineTo(size.width * 0.4354043, size.height * 0.8728505);
    path_88.lineTo(size.width * 0.4354043, size.height * 0.8729907);
    path_88.cubicTo(
        size.width * 0.4354043,
        size.height * 0.8735666,
        size.width * 0.4357536,
        size.height * 0.8739953,
        size.width * 0.4364569,
        size.height * 0.8742757);
    path_88.cubicTo(
        size.width * 0.4371579,
        size.height * 0.8745409,
        size.width * 0.4383230,
        size.height * 0.8746729,
        size.width * 0.4399498,
        size.height * 0.8746729);
    path_88.cubicTo(
        size.width * 0.4418947,
        size.height * 0.8746729,
        size.width * 0.4437440,
        size.height * 0.8746028,
        size.width * 0.4455000,
        size.height * 0.8744626);
    path_88.cubicTo(
        size.width * 0.4472536,
        size.height * 0.8743224,
        size.width * 0.4487847,
        size.height * 0.8741437,
        size.width * 0.4500933,
        size.height * 0.8739252);
    path_88.lineTo(size.width * 0.4500933, size.height * 0.8776636);
    path_88.cubicTo(
        size.width * 0.4489761,
        size.height * 0.8779591,
        size.width * 0.4473325,
        size.height * 0.8782325,
        size.width * 0.4451651,
        size.height * 0.8784813);
    path_88.cubicTo(
        size.width * 0.4430263,
        size.height * 0.8787150,
        size.width * 0.4406986,
        size.height * 0.8788318,
        size.width * 0.4381794,
        size.height * 0.8788318);
    path_88.close();
    path_88.moveTo(size.width * 0.4409545, size.height * 0.8702804);
    path_88.lineTo(size.width * 0.4409545, size.height * 0.8700000);
    path_88.cubicTo(
        size.width * 0.4409545,
        size.height * 0.8694708,
        size.width * 0.4407153,
        size.height * 0.8690888,
        size.width * 0.4402368,
        size.height * 0.8688551);
    path_88.cubicTo(
        size.width * 0.4397895,
        size.height * 0.8686215,
        size.width * 0.4391029,
        size.height * 0.8685047,
        size.width * 0.4381794,
        size.height * 0.8685047);
    path_88.cubicTo(
        size.width * 0.4372536,
        size.height * 0.8685047,
        size.width * 0.4365526,
        size.height * 0.8686297,
        size.width * 0.4360742,
        size.height * 0.8688785);
    path_88.cubicTo(
        size.width * 0.4356268,
        size.height * 0.8691121,
        size.width * 0.4354043,
        size.height * 0.8694860,
        size.width * 0.4354043,
        size.height * 0.8700000);
    path_88.lineTo(size.width * 0.4354043, size.height * 0.8702804);
    path_88.lineTo(size.width * 0.4409545, size.height * 0.8702804);
    path_88.close();
    path_88.moveTo(size.width * 0.4800718, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.4740431, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4720335, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4720335, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.4868182, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.4868182, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4848086, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4873445, size.height * 0.8739720);
    path_88.lineTo(size.width * 0.4878230, size.height * 0.8739720);
    path_88.lineTo(size.width * 0.4903589, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4883493, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4883493, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.5022249, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.5022249, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.5002153, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.4943301, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.4800718, size.height * 0.8785047);
    path_88.close();
    path_88.moveTo(size.width * 0.5207105, size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.5161818,
        size.height * 0.8788318,
        size.width * 0.5126411,
        size.height * 0.8782558,
        size.width * 0.5100885,
        size.height * 0.8771028);
    path_88.cubicTo(
        size.width * 0.5075359,
        size.height * 0.8759346,
        size.width * 0.5062608,
        size.height * 0.8742371,
        size.width * 0.5062608,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.5062608,
        size.height * 0.8697815,
        size.width * 0.5075359,
        size.height * 0.8680923,
        size.width * 0.5100885,
        size.height * 0.8669393);
    path_88.cubicTo(
        size.width * 0.5126411,
        size.height * 0.8657710,
        size.width * 0.5161818,
        size.height * 0.8651869,
        size.width * 0.5207105,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.5252081,
        size.height * 0.8651869,
        size.width * 0.5284450,
        size.height * 0.8657629,
        size.width * 0.5304234,
        size.height * 0.8669159);
    path_88.cubicTo(
        size.width * 0.5324330,
        size.height * 0.8680526,
        size.width * 0.5334378,
        size.height * 0.8694708,
        size.width * 0.5334378,
        size.height * 0.8711682);
    path_88.lineTo(size.width * 0.5334378, size.height * 0.8728505);
    path_88.lineTo(size.width * 0.5179354, size.height * 0.8728505);
    path_88.lineTo(size.width * 0.5179354, size.height * 0.8729907);
    path_88.cubicTo(
        size.width * 0.5179354,
        size.height * 0.8735666,
        size.width * 0.5182871,
        size.height * 0.8739953,
        size.width * 0.5189880,
        size.height * 0.8742757);
    path_88.cubicTo(
        size.width * 0.5196890,
        size.height * 0.8745409,
        size.width * 0.5208541,
        size.height * 0.8746729,
        size.width * 0.5224809,
        size.height * 0.8746729);
    path_88.cubicTo(
        size.width * 0.5244258,
        size.height * 0.8746729,
        size.width * 0.5262775,
        size.height * 0.8746028,
        size.width * 0.5280311,
        size.height * 0.8744626);
    path_88.cubicTo(
        size.width * 0.5297847,
        size.height * 0.8743224,
        size.width * 0.5313158,
        size.height * 0.8741437,
        size.width * 0.5326244,
        size.height * 0.8739252);
    path_88.lineTo(size.width * 0.5326244, size.height * 0.8776636);
    path_88.cubicTo(
        size.width * 0.5315072,
        size.height * 0.8779591,
        size.width * 0.5298660,
        size.height * 0.8782325,
        size.width * 0.5276962,
        size.height * 0.8784813);
    path_88.cubicTo(
        size.width * 0.5255598,
        size.height * 0.8787150,
        size.width * 0.5232297,
        size.height * 0.8788318,
        size.width * 0.5207105,
        size.height * 0.8788318);
    path_88.close();
    path_88.moveTo(size.width * 0.5234856, size.height * 0.8702804);
    path_88.lineTo(size.width * 0.5234856, size.height * 0.8700000);
    path_88.cubicTo(
        size.width * 0.5234856,
        size.height * 0.8694708,
        size.width * 0.5232464,
        size.height * 0.8690888,
        size.width * 0.5227679,
        size.height * 0.8688551);
    path_88.cubicTo(
        size.width * 0.5223206,
        size.height * 0.8686215,
        size.width * 0.5216364,
        size.height * 0.8685047,
        size.width * 0.5207105,
        size.height * 0.8685047);
    path_88.cubicTo(
        size.width * 0.5197847,
        size.height * 0.8685047,
        size.width * 0.5190837,
        size.height * 0.8686297,
        size.width * 0.5186053,
        size.height * 0.8688785);
    path_88.cubicTo(
        size.width * 0.5181579,
        size.height * 0.8691121,
        size.width * 0.5179354,
        size.height * 0.8694860,
        size.width * 0.5179354,
        size.height * 0.8700000);
    path_88.lineTo(size.width * 0.5179354, size.height * 0.8702804);
    path_88.lineTo(size.width * 0.5234856, size.height * 0.8702804);
    path_88.close();
    path_88.moveTo(size.width * 0.5695024, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5695024, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.5543828, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.5543828, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5563923, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5563923, size.height * 0.8708411);
    path_88.cubicTo(
        size.width * 0.5563923,
        size.height * 0.8703271,
        size.width * 0.5561699,
        size.height * 0.8699533,
        size.width * 0.5557225,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.5552751,
        size.height * 0.8694708,
        size.width * 0.5546053,
        size.height * 0.8693458,
        size.width * 0.5537129,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.5517990,
        size.height * 0.8693458,
        size.width * 0.5508421,
        size.height * 0.8698446,
        size.width * 0.5508421,
        size.height * 0.8708411);
    path_88.lineTo(size.width * 0.5508421, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5528517, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5528517, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.5377321, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.5377321, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5398373, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5398373, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.5377321, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.5377321, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.5508421, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.5508421, size.height * 0.8673364);
    path_88.cubicTo(
        size.width * 0.5531388,
        size.height * 0.8659030,
        size.width * 0.5560096,
        size.height * 0.8651869,
        size.width * 0.5594545,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.5621029,
        size.height * 0.8651869,
        size.width * 0.5640789,
        size.height * 0.8655923,
        size.width * 0.5653876,
        size.height * 0.8664019);
    path_88.cubicTo(
        size.width * 0.5667273,
        size.height * 0.8672114,
        size.width * 0.5673971,
        size.height * 0.8683259,
        size.width * 0.5673971,
        size.height * 0.8697430);
    path_88.lineTo(size.width * 0.5673971, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5695024, size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.5762153, size.height * 0.8642290);
    path_88.lineTo(size.width * 0.5762153, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.5859761, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.5859761, size.height * 0.8642290);
    path_88.lineTo(size.width * 0.5762153, size.height * 0.8642290);
    path_88.close();
    path_88.moveTo(size.width * 0.5739187, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.5739187, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5760239, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5760239, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.5739187, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.5739187, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.5870287, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.5870287, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5891340, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.5891340, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.5739187, size.height * 0.8785047);
    path_88.close();
    path_88.moveTo(size.width * 0.6027560, size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.5995024,
        size.height * 0.8788318,
        size.width * 0.5970455,
        size.height * 0.8782395,
        size.width * 0.5953876,
        size.height * 0.8770561);
    path_88.cubicTo(
        size.width * 0.5937608,
        size.height * 0.8758727,
        size.width * 0.5929474,
        size.height * 0.8741904,
        size.width * 0.5929474,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.5929474,
        size.height * 0.8698283,
        size.width * 0.5937608,
        size.height * 0.8681460,
        size.width * 0.5953876,
        size.height * 0.8669626);
    path_88.cubicTo(
        size.width * 0.5970455,
        size.height * 0.8657792,
        size.width * 0.5995024,
        size.height * 0.8651869,
        size.width * 0.6027560,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.6043828,
        size.height * 0.8651869,
        size.width * 0.6058182,
        size.height * 0.8653820,
        size.width * 0.6070622,
        size.height * 0.8657710);
    path_88.cubicTo(
        size.width * 0.6083373,
        size.height * 0.8661600,
        size.width * 0.6093756,
        size.height * 0.8666040,
        size.width * 0.6101722,
        size.height * 0.8671028);
    path_88.lineTo(size.width * 0.6101722, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.6073493, size.height * 0.8641589);
    path_88.lineTo(size.width * 0.6073493, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.6211770, size.height * 0.8603271);
    path_88.lineTo(size.width * 0.6211770, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.6232823, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.6232823, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.6101722, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.6101722, size.height * 0.8769159);
    path_88.cubicTo(
        size.width * 0.6093756,
        size.height * 0.8774147,
        size.width * 0.6083373,
        size.height * 0.8778586,
        size.width * 0.6070622,
        size.height * 0.8782477);
    path_88.cubicTo(
        size.width * 0.6058182,
        size.height * 0.8786367,
        size.width * 0.6043828,
        size.height * 0.8788318,
        size.width * 0.6027560,
        size.height * 0.8788318);
    path_88.close();
    path_88.moveTo(size.width * 0.6073971, size.height * 0.8746729);
    path_88.cubicTo(
        size.width * 0.6083230,
        size.height * 0.8746729,
        size.width * 0.6090072,
        size.height * 0.8745561,
        size.width * 0.6094545,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.6099330,
        size.height * 0.8740736,
        size.width * 0.6101722,
        size.height * 0.8736916,
        size.width * 0.6101722,
        size.height * 0.8731776);
    path_88.lineTo(size.width * 0.6101722, size.height * 0.8708411);
    path_88.cubicTo(
        size.width * 0.6101722,
        size.height * 0.8703271,
        size.width * 0.6099330,
        size.height * 0.8699533,
        size.width * 0.6094545,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.6090072,
        size.height * 0.8694708,
        size.width * 0.6083230,
        size.height * 0.8693458,
        size.width * 0.6073971,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.6064713,
        size.height * 0.8693458,
        size.width * 0.6057703,
        size.height * 0.8694708,
        size.width * 0.6052919,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.6048445,
        size.height * 0.8699533,
        size.width * 0.6046220,
        size.height * 0.8703271,
        size.width * 0.6046220,
        size.height * 0.8708411);
    path_88.lineTo(size.width * 0.6046220, size.height * 0.8731776);
    path_88.cubicTo(
        size.width * 0.6046220,
        size.height * 0.8736916,
        size.width * 0.6048445,
        size.height * 0.8740736,
        size.width * 0.6052919,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.6057703,
        size.height * 0.8745561,
        size.width * 0.6064713,
        size.height * 0.8746729,
        size.width * 0.6073971,
        size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.6419522, size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.6374234,
        size.height * 0.8788318,
        size.width * 0.6338828,
        size.height * 0.8782558,
        size.width * 0.6313301,
        size.height * 0.8771028);
    path_88.cubicTo(
        size.width * 0.6287775,
        size.height * 0.8759346,
        size.width * 0.6275024,
        size.height * 0.8742371,
        size.width * 0.6275024,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.6275024,
        size.height * 0.8697815,
        size.width * 0.6287775,
        size.height * 0.8680923,
        size.width * 0.6313301,
        size.height * 0.8669393);
    path_88.cubicTo(
        size.width * 0.6338828,
        size.height * 0.8657710,
        size.width * 0.6374234,
        size.height * 0.8651869,
        size.width * 0.6419522,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.6465455,
        size.height * 0.8651869,
        size.width * 0.6501029,
        size.height * 0.8657792,
        size.width * 0.6526220,
        size.height * 0.8669626);
    path_88.cubicTo(
        size.width * 0.6551411,
        size.height * 0.8681308,
        size.width * 0.6564019,
        size.height * 0.8698131,
        size.width * 0.6564019,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.6564019,
        size.height * 0.8742371,
        size.width * 0.6551268,
        size.height * 0.8759346,
        size.width * 0.6525742,
        size.height * 0.8771028);
    path_88.cubicTo(
        size.width * 0.6500215,
        size.height * 0.8782558,
        size.width * 0.6464809,
        size.height * 0.8788318,
        size.width * 0.6419522,
        size.height * 0.8788318);
    path_88.close();
    path_88.moveTo(size.width * 0.6419522, size.height * 0.8746729);
    path_88.cubicTo(
        size.width * 0.6428780,
        size.height * 0.8746729,
        size.width * 0.6435622,
        size.height * 0.8745561,
        size.width * 0.6440096,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.6444880,
        size.height * 0.8740736,
        size.width * 0.6447273,
        size.height * 0.8736916,
        size.width * 0.6447273,
        size.height * 0.8731776);
    path_88.lineTo(size.width * 0.6447273, size.height * 0.8708411);
    path_88.cubicTo(
        size.width * 0.6447273,
        size.height * 0.8703271,
        size.width * 0.6444880,
        size.height * 0.8699533,
        size.width * 0.6440096,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.6435622,
        size.height * 0.8694708,
        size.width * 0.6428780,
        size.height * 0.8693458,
        size.width * 0.6419522,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.6410263,
        size.height * 0.8693458,
        size.width * 0.6403254,
        size.height * 0.8694708,
        size.width * 0.6398469,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.6393995,
        size.height * 0.8699533,
        size.width * 0.6391770,
        size.height * 0.8703271,
        size.width * 0.6391770,
        size.height * 0.8708411);
    path_88.lineTo(size.width * 0.6391770, size.height * 0.8731776);
    path_88.cubicTo(
        size.width * 0.6391770,
        size.height * 0.8736916,
        size.width * 0.6393995,
        size.height * 0.8740736,
        size.width * 0.6398469,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.6403254,
        size.height * 0.8745561,
        size.width * 0.6410263,
        size.height * 0.8746729,
        size.width * 0.6419522,
        size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.6778206, size.height * 0.8798598);
    path_88.lineTo(size.width * 0.6799258, size.height * 0.8798598);
    path_88.lineTo(size.width * 0.6799258, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.6778206, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.6778206, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.6909306, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.6909306, size.height * 0.8671028);
    path_88.cubicTo(
        size.width * 0.6917273,
        size.height * 0.8666040,
        size.width * 0.6927488,
        size.height * 0.8661600,
        size.width * 0.6939928,
        size.height * 0.8657710);
    path_88.cubicTo(
        size.width * 0.6952679,
        size.height * 0.8653820,
        size.width * 0.6967201,
        size.height * 0.8651869,
        size.width * 0.6983469,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.7016005,
        size.height * 0.8651869,
        size.width * 0.7040407,
        size.height * 0.8657792,
        size.width * 0.7056675,
        size.height * 0.8669626);
    path_88.cubicTo(
        size.width * 0.7073254,
        size.height * 0.8681460,
        size.width * 0.7081555,
        size.height * 0.8698283,
        size.width * 0.7081555,
        size.height * 0.8720093);
    path_88.cubicTo(
        size.width * 0.7081555,
        size.height * 0.8741904,
        size.width * 0.7073254,
        size.height * 0.8758727,
        size.width * 0.7056675,
        size.height * 0.8770561);
    path_88.cubicTo(
        size.width * 0.7040407,
        size.height * 0.8782395,
        size.width * 0.7016005,
        size.height * 0.8788318,
        size.width * 0.6983469,
        size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.6967201,
        size.height * 0.8788318,
        size.width * 0.6952679,
        size.height * 0.8786367,
        size.width * 0.6939928,
        size.height * 0.8782477);
    path_88.cubicTo(
        size.width * 0.6927488,
        size.height * 0.8778586,
        size.width * 0.6917273,
        size.height * 0.8774147,
        size.width * 0.6909306,
        size.height * 0.8769159);
    path_88.lineTo(size.width * 0.6909306, size.height * 0.8798598);
    path_88.lineTo(size.width * 0.6942321, size.height * 0.8798598);
    path_88.lineTo(size.width * 0.6942321, size.height * 0.8836916);
    path_88.lineTo(size.width * 0.6778206, size.height * 0.8836916);
    path_88.lineTo(size.width * 0.6778206, size.height * 0.8798598);
    path_88.close();
    path_88.moveTo(size.width * 0.6937057, size.height * 0.8746729);
    path_88.cubicTo(
        size.width * 0.6946292,
        size.height * 0.8746729,
        size.width * 0.6953158,
        size.height * 0.8745561,
        size.width * 0.6957632,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.6962416,
        size.height * 0.8740736,
        size.width * 0.6964809,
        size.height * 0.8736916,
        size.width * 0.6964809,
        size.height * 0.8731776);
    path_88.lineTo(size.width * 0.6964809, size.height * 0.8708411);
    path_88.cubicTo(
        size.width * 0.6964809,
        size.height * 0.8703271,
        size.width * 0.6962416,
        size.height * 0.8699533,
        size.width * 0.6957632,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.6953158,
        size.height * 0.8694708,
        size.width * 0.6946292,
        size.height * 0.8693458,
        size.width * 0.6937057,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.6927799,
        size.height * 0.8693458,
        size.width * 0.6920789,
        size.height * 0.8694708,
        size.width * 0.6916005,
        size.height * 0.8697196);
    path_88.cubicTo(
        size.width * 0.6911531,
        size.height * 0.8699533,
        size.width * 0.6909306,
        size.height * 0.8703271,
        size.width * 0.6909306,
        size.height * 0.8708411);
    path_88.lineTo(size.width * 0.6909306, size.height * 0.8731776);
    path_88.cubicTo(
        size.width * 0.6909306,
        size.height * 0.8736916,
        size.width * 0.6911531,
        size.height * 0.8740736,
        size.width * 0.6916005,
        size.height * 0.8743224);
    path_88.cubicTo(
        size.width * 0.6920789,
        size.height * 0.8745561,
        size.width * 0.6927799,
        size.height * 0.8746729,
        size.width * 0.6937057,
        size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.7402703, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.7402703, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.7276388, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.7276388, size.height * 0.8769159);
    path_88.cubicTo(
        size.width * 0.7269378,
        size.height * 0.8774147,
        size.width * 0.7259474,
        size.height * 0.8778586,
        size.width * 0.7246722,
        size.height * 0.8782477);
    path_88.cubicTo(
        size.width * 0.7234282,
        size.height * 0.8786367,
        size.width * 0.7218971,
        size.height * 0.8788318,
        size.width * 0.7200789,
        size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.7176866,
        size.height * 0.8788318,
        size.width * 0.7158038,
        size.height * 0.8785199,
        size.width * 0.7144330,
        size.height * 0.8778972);
    path_88.cubicTo(
        size.width * 0.7130622,
        size.height * 0.8772745,
        size.width * 0.7123756,
        size.height * 0.8763937,
        size.width * 0.7123756,
        size.height * 0.8752570);
    path_88.cubicTo(
        size.width * 0.7123756,
        size.height * 0.8723131,
        size.width * 0.7174952,
        size.height * 0.8708026,
        size.width * 0.7277344,
        size.height * 0.8707243);
    path_88.cubicTo(
        size.width * 0.7276388,
        size.height * 0.8701951,
        size.width * 0.7272249,
        size.height * 0.8698364,
        size.width * 0.7264904,
        size.height * 0.8696495);
    path_88.cubicTo(
        size.width * 0.7257560,
        size.height * 0.8694474,
        size.width * 0.7245120,
        size.height * 0.8693458,
        size.width * 0.7227584,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.7213230,
        size.height * 0.8693458,
        size.width * 0.7197751,
        size.height * 0.8694241,
        size.width * 0.7181172,
        size.height * 0.8695794);
    path_88.cubicTo(
        size.width * 0.7164904,
        size.height * 0.8697196,
        size.width * 0.7149904,
        size.height * 0.8699147,
        size.width * 0.7136196,
        size.height * 0.8701636);
    path_88.lineTo(size.width * 0.7136196, size.height * 0.8658645);
    path_88.cubicTo(
        size.width * 0.7153110,
        size.height * 0.8656624,
        size.width * 0.7171435,
        size.height * 0.8654988,
        size.width * 0.7191220,
        size.height * 0.8653738);
    path_88.cubicTo(
        size.width * 0.7211005,
        size.height * 0.8652488,
        size.width * 0.7230287,
        size.height * 0.8651869,
        size.width * 0.7249115,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.7296651,
        size.height * 0.8651869,
        size.width * 0.7330622,
        size.height * 0.8656075,
        size.width * 0.7351029,
        size.height * 0.8664486);
    path_88.cubicTo(
        size.width * 0.7371435,
        size.height * 0.8672897,
        size.width * 0.7381651,
        size.height * 0.8685900,
        size.width * 0.7381651,
        size.height * 0.8703505);
    path_88.lineTo(size.width * 0.7381651, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.7402703, size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.7276388, size.height * 0.8730374);
    path_88.cubicTo(
        size.width * 0.7262033,
        size.height * 0.8730374,
        size.width * 0.7250861,
        size.height * 0.8731308,
        size.width * 0.7242895,
        size.height * 0.8733178);
    path_88.cubicTo(
        size.width * 0.7235239,
        size.height * 0.8735047,
        size.width * 0.7231411,
        size.height * 0.8738166,
        size.width * 0.7231411,
        size.height * 0.8742523);
    path_88.cubicTo(
        size.width * 0.7231411,
        size.height * 0.8745175,
        size.width * 0.7233014,
        size.height * 0.8747348,
        size.width * 0.7236196,
        size.height * 0.8749065);
    path_88.cubicTo(
        size.width * 0.7239713,
        size.height * 0.8750619,
        size.width * 0.7244498,
        size.height * 0.8751402,
        size.width * 0.7250550,
        size.height * 0.8751402);
    path_88.cubicTo(
        size.width * 0.7258852,
        size.height * 0.8751402,
        size.width * 0.7265215,
        size.height * 0.8749685,
        size.width * 0.7269689,
        size.height * 0.8746262);
    path_88.cubicTo(
        size.width * 0.7274163,
        size.height * 0.8742839,
        size.width * 0.7276388,
        size.height * 0.8738002,
        size.width * 0.7276388,
        size.height * 0.8731776);
    path_88.lineTo(size.width * 0.7276388, size.height * 0.8730374);
    path_88.close();
    path_88.moveTo(size.width * 0.7651148, size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.7657512,
        size.height * 0.8651869,
        size.width * 0.7663589,
        size.height * 0.8652185,
        size.width * 0.7669330,
        size.height * 0.8652804);
    path_88.cubicTo(
        size.width * 0.7675072,
        size.height * 0.8653423,
        size.width * 0.7679856,
        size.height * 0.8654206,
        size.width * 0.7683684,
        size.height * 0.8655140);
    path_88.lineTo(size.width * 0.7683684, size.height * 0.8699766);
    path_88.cubicTo(
        size.width * 0.7670598,
        size.height * 0.8697114,
        size.width * 0.7656555,
        size.height * 0.8695794,
        size.width * 0.7641579,
        size.height * 0.8695794);
    path_88.cubicTo(
        size.width * 0.7621483,
        size.height * 0.8695794,
        size.width * 0.7606005,
        size.height * 0.8698364,
        size.width * 0.7595167,
        size.height * 0.8703505);
    path_88.cubicTo(
        size.width * 0.7584306,
        size.height * 0.8708645,
        size.width * 0.7578900,
        size.height * 0.8716273,
        size.width * 0.7578900,
        size.height * 0.8726402);
    path_88.lineTo(size.width * 0.7578900, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.7621962, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.7621962, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.7447799, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.7447799, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.7468852, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.7468852, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.7447799, size.height * 0.8693458);
    path_88.lineTo(size.width * 0.7447799, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.7578900, size.height * 0.8655140);
    path_88.lineTo(size.width * 0.7578900, size.height * 0.8672196);
    path_88.cubicTo(
        size.width * 0.7587823,
        size.height * 0.8665654,
        size.width * 0.7598038,
        size.height * 0.8660666,
        size.width * 0.7609522,
        size.height * 0.8657243);
    path_88.cubicTo(
        size.width * 0.7621005,
        size.height * 0.8653657,
        size.width * 0.7634880,
        size.height * 0.8651869,
        size.width * 0.7651148,
        size.height * 0.8651869);
    path_88.close();
    path_88.moveTo(size.width * 0.8006794, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.8006794, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.7880478, size.height * 0.8785047);
    path_88.lineTo(size.width * 0.7880478, size.height * 0.8769159);
    path_88.cubicTo(
        size.width * 0.7873469,
        size.height * 0.8774147,
        size.width * 0.7863589,
        size.height * 0.8778586,
        size.width * 0.7850813,
        size.height * 0.8782477);
    path_88.cubicTo(
        size.width * 0.7838373,
        size.height * 0.8786367,
        size.width * 0.7823062,
        size.height * 0.8788318,
        size.width * 0.7804880,
        size.height * 0.8788318);
    path_88.cubicTo(
        size.width * 0.7780957,
        size.height * 0.8788318,
        size.width * 0.7762153,
        size.height * 0.8785199,
        size.width * 0.7748421,
        size.height * 0.8778972);
    path_88.cubicTo(
        size.width * 0.7734713,
        size.height * 0.8772745,
        size.width * 0.7727847,
        size.height * 0.8763937,
        size.width * 0.7727847,
        size.height * 0.8752570);
    path_88.cubicTo(
        size.width * 0.7727847,
        size.height * 0.8723131,
        size.width * 0.7779043,
        size.height * 0.8708026,
        size.width * 0.7881435,
        size.height * 0.8707243);
    path_88.cubicTo(
        size.width * 0.7880478,
        size.height * 0.8701951,
        size.width * 0.7876340,
        size.height * 0.8698364,
        size.width * 0.7868995,
        size.height * 0.8696495);
    path_88.cubicTo(
        size.width * 0.7861675,
        size.height * 0.8694474,
        size.width * 0.7849234,
        size.height * 0.8693458,
        size.width * 0.7831675,
        size.height * 0.8693458);
    path_88.cubicTo(
        size.width * 0.7817321,
        size.height * 0.8693458,
        size.width * 0.7801866,
        size.height * 0.8694241,
        size.width * 0.7785263,
        size.height * 0.8695794);
    path_88.cubicTo(
        size.width * 0.7768995,
        size.height * 0.8697196,
        size.width * 0.7754019,
        size.height * 0.8699147,
        size.width * 0.7740287,
        size.height * 0.8701636);
    path_88.lineTo(size.width * 0.7740287, size.height * 0.8658645);
    path_88.cubicTo(
        size.width * 0.7757201,
        size.height * 0.8656624,
        size.width * 0.7775550,
        size.height * 0.8654988,
        size.width * 0.7795311,
        size.height * 0.8653738);
    path_88.cubicTo(
        size.width * 0.7815096,
        size.height * 0.8652488,
        size.width * 0.7834402,
        size.height * 0.8651869,
        size.width * 0.7853206,
        size.height * 0.8651869);
    path_88.cubicTo(
        size.width * 0.7900742,
        size.height * 0.8651869,
        size.width * 0.7934713,
        size.height * 0.8656075,
        size.width * 0.7955120,
        size.height * 0.8664486);
    path_88.cubicTo(
        size.width * 0.7975550,
        size.height * 0.8672897,
        size.width * 0.7985742,
        size.height * 0.8685900,
        size.width * 0.7985742,
        size.height * 0.8703505);
    path_88.lineTo(size.width * 0.7985742, size.height * 0.8746729);
    path_88.lineTo(size.width * 0.8006794, size.height * 0.8746729);
    path_88.close();
    path_88.moveTo(size.width * 0.7880478, size.height * 0.8730374);
    path_88.cubicTo(
        size.width * 0.7866124,
        size.height * 0.8730374,
        size.width * 0.7854976,
        size.height * 0.8731308,
        size.width * 0.7846986,
        size.height * 0.8733178);
    path_88.cubicTo(
        size.width * 0.7839330,
        size.height * 0.8735047,
        size.width * 0.7835502,
        size.height * 0.8738166,
        size.width * 0.7835502,
        size.height * 0.8742523);
    path_88.cubicTo(
        size.width * 0.7835502,
        size.height * 0.8745175,
        size.width * 0.7837105,
        size.height * 0.8747348,
        size.width * 0.7840287,
        size.height * 0.8749065);
    path_88.cubicTo(
        size.width * 0.7843804,
        size.height * 0.8750619,
        size.width * 0.7848589,
        size.height * 0.8751402,
        size.width * 0.7854641,
        size.height * 0.8751402);
    path_88.cubicTo(
        size.width * 0.7862943,
        size.height * 0.8751402,
        size.width * 0.7869330,
        size.height * 0.8749685,
        size.width * 0.7873780,
        size.height * 0.8746262);
    path_88.cubicTo(
        size.width * 0.7878254,
        size.height * 0.8742839,
        size.width * 0.7880478,
        size.height * 0.8738002,
        size.width * 0.7880478,
        size.height * 0.8731776);
    path_88.lineTo(size.width * 0.7880478, size.height * 0.8730374);
    path_88.close();
    path_88.moveTo(size.width * 0.3231459, size.height * 0.9114019);
    path_88.lineTo(size.width * 0.3264474, size.height * 0.9114019);
    path_88.lineTo(size.width * 0.3264474, size.height * 0.9084579);
    path_88.cubicTo(
        size.width * 0.3256483,
        size.height * 0.9089568,
        size.width * 0.3246124,
        size.height * 0.9094007,
        size.width * 0.3233373,
        size.height * 0.9097897);
    path_88.cubicTo(
        size.width * 0.3220933,
        size.height * 0.9101787,
        size.width * 0.3206579,
        size.height * 0.9103738,
        size.width * 0.3190311,
        size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.3157775,
        size.height * 0.9103738,
        size.width * 0.3133206,
        size.height * 0.9097815,
        size.width * 0.3116627,
        size.height * 0.9085981);
    path_88.cubicTo(
        size.width * 0.3100359,
        size.height * 0.9074147,
        size.width * 0.3092225,
        size.height * 0.9057325,
        size.width * 0.3092225,
        size.height * 0.9035514);
    path_88.cubicTo(
        size.width * 0.3092225,
        size.height * 0.9013703,
        size.width * 0.3100359,
        size.height * 0.8996881,
        size.width * 0.3116627,
        size.height * 0.8985047);
    path_88.cubicTo(
        size.width * 0.3133206,
        size.height * 0.8973213,
        size.width * 0.3157775,
        size.height * 0.8967290,
        size.width * 0.3190311,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.3206579,
        size.height * 0.8967290,
        size.width * 0.3220933,
        size.height * 0.8969241,
        size.width * 0.3233373,
        size.height * 0.8973131);
    path_88.cubicTo(
        size.width * 0.3246124,
        size.height * 0.8977021,
        size.width * 0.3256483,
        size.height * 0.8981460,
        size.width * 0.3264474,
        size.height * 0.8986449);
    path_88.lineTo(size.width * 0.3264474, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.3395574, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.3395574, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.3374522, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.3374522, size.height * 0.9152336);
    path_88.lineTo(size.width * 0.3231459, size.height * 0.9152336);
    path_88.lineTo(size.width * 0.3231459, size.height * 0.9114019);
    path_88.close();
    path_88.moveTo(size.width * 0.3236722, size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.3245957,
        size.height * 0.9062150,
        size.width * 0.3252823,
        size.height * 0.9060981,
        size.width * 0.3257297,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.3262081,
        size.height * 0.9056157,
        size.width * 0.3264474,
        size.height * 0.9052336,
        size.width * 0.3264474,
        size.height * 0.9047196);
    path_88.lineTo(size.width * 0.3264474, size.height * 0.9023832);
    path_88.cubicTo(
        size.width * 0.3264474,
        size.height * 0.9018692,
        size.width * 0.3262081,
        size.height * 0.9014953,
        size.width * 0.3257297,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.3252823,
        size.height * 0.9010129,
        size.width * 0.3245957,
        size.height * 0.9008879,
        size.width * 0.3236722,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.3227464,
        size.height * 0.9008879,
        size.width * 0.3220455,
        size.height * 0.9010129,
        size.width * 0.3215670,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.3211196,
        size.height * 0.9014953,
        size.width * 0.3208971,
        size.height * 0.9018692,
        size.width * 0.3208971,
        size.height * 0.9023832);
    path_88.lineTo(size.width * 0.3208971, size.height * 0.9047196);
    path_88.cubicTo(
        size.width * 0.3208971,
        size.height * 0.9052336,
        size.width * 0.3211196,
        size.height * 0.9056157,
        size.width * 0.3215670,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.3220455,
        size.height * 0.9060981,
        size.width * 0.3227464,
        size.height * 0.9062150,
        size.width * 0.3236722,
        size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.3751722, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.3751722, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.3620622, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.3620622, size.height * 0.9082243);
    path_88.cubicTo(
        size.width * 0.3597656,
        size.height * 0.9096577,
        size.width * 0.3568947,
        size.height * 0.9103738,
        size.width * 0.3534498,
        size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.3508014,
        size.height * 0.9103738,
        size.width * 0.3488086,
        size.height * 0.9099685,
        size.width * 0.3474689,
        size.height * 0.9091589);
    path_88.cubicTo(
        size.width * 0.3461603,
        size.height * 0.9083493,
        size.width * 0.3455072,
        size.height * 0.9072348,
        size.width * 0.3455072,
        size.height * 0.9058178);
    path_88.lineTo(size.width * 0.3455072, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.3434019, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.3434019, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.3565120, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.3565120, size.height * 0.9047196);
    path_88.cubicTo(
        size.width * 0.3565120,
        size.height * 0.9052336,
        size.width * 0.3567344,
        size.height * 0.9056157,
        size.width * 0.3571818,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.3576603,
        size.height * 0.9060981,
        size.width * 0.3583612,
        size.height * 0.9062150,
        size.width * 0.3592871,
        size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.3602105,
        size.height * 0.9062150,
        size.width * 0.3608971,
        size.height * 0.9060981,
        size.width * 0.3613445,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.3618230,
        size.height * 0.9056157,
        size.width * 0.3620622,
        size.height * 0.9052336,
        size.width * 0.3620622,
        size.height * 0.9047196);
    path_88.lineTo(size.width * 0.3620622, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.3594785, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.3594785, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.3730670, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.3730670, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.3751722, size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.3936196, size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.3890885,
        size.height * 0.9103738,
        size.width * 0.3855478,
        size.height * 0.9097979,
        size.width * 0.3829976,
        size.height * 0.9086449);
    path_88.cubicTo(
        size.width * 0.3804450,
        size.height * 0.9074766,
        size.width * 0.3791699,
        size.height * 0.9057792,
        size.width * 0.3791699,
        size.height * 0.9035514);
    path_88.cubicTo(
        size.width * 0.3791699,
        size.height * 0.9013236,
        size.width * 0.3804450,
        size.height * 0.8996343,
        size.width * 0.3829976,
        size.height * 0.8984813);
    path_88.cubicTo(
        size.width * 0.3855478,
        size.height * 0.8973131,
        size.width * 0.3890885,
        size.height * 0.8967290,
        size.width * 0.3936196,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.3981172,
        size.height * 0.8967290,
        size.width * 0.4013541,
        size.height * 0.8973049,
        size.width * 0.4033325,
        size.height * 0.8984579);
    path_88.cubicTo(
        size.width * 0.4053421,
        size.height * 0.8995946,
        size.width * 0.4063469,
        size.height * 0.9010129,
        size.width * 0.4063469,
        size.height * 0.9027103);
    path_88.lineTo(size.width * 0.4063469, size.height * 0.9043925);
    path_88.lineTo(size.width * 0.3908445, size.height * 0.9043925);
    path_88.lineTo(size.width * 0.3908445, size.height * 0.9045327);
    path_88.cubicTo(
        size.width * 0.3908445,
        size.height * 0.9051086,
        size.width * 0.3911938,
        size.height * 0.9055374,
        size.width * 0.3918971,
        size.height * 0.9058178);
    path_88.cubicTo(
        size.width * 0.3925981,
        size.height * 0.9060829,
        size.width * 0.3937632,
        size.height * 0.9062150,
        size.width * 0.3953900,
        size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.3973349,
        size.height * 0.9062150,
        size.width * 0.3991842,
        size.height * 0.9061449,
        size.width * 0.4009402,
        size.height * 0.9060047);
    path_88.cubicTo(
        size.width * 0.4026938,
        size.height * 0.9058645,
        size.width * 0.4042249,
        size.height * 0.9056857,
        size.width * 0.4055335,
        size.height * 0.9054673);
    path_88.lineTo(size.width * 0.4055335, size.height * 0.9092056);
    path_88.cubicTo(
        size.width * 0.4044163,
        size.height * 0.9095012,
        size.width * 0.4027727,
        size.height * 0.9097745,
        size.width * 0.4006053,
        size.height * 0.9100234);
    path_88.cubicTo(
        size.width * 0.3984665,
        size.height * 0.9102570,
        size.width * 0.3961388,
        size.height * 0.9103738,
        size.width * 0.3936196,
        size.height * 0.9103738);
    path_88.close();
    path_88.moveTo(size.width * 0.3963947, size.height * 0.9018224);
    path_88.lineTo(size.width * 0.3963947, size.height * 0.9015421);
    path_88.cubicTo(
        size.width * 0.3963947,
        size.height * 0.9010129,
        size.width * 0.3961555,
        size.height * 0.9006308,
        size.width * 0.3956770,
        size.height * 0.9003972);
    path_88.cubicTo(
        size.width * 0.3952297,
        size.height * 0.9001636,
        size.width * 0.3945431,
        size.height * 0.9000467,
        size.width * 0.3936196,
        size.height * 0.9000467);
    path_88.cubicTo(
        size.width * 0.3926938,
        size.height * 0.9000467,
        size.width * 0.3919928,
        size.height * 0.9001717,
        size.width * 0.3915144,
        size.height * 0.9004206);
    path_88.cubicTo(
        size.width * 0.3910670,
        size.height * 0.9006542,
        size.width * 0.3908445,
        size.height * 0.9010280,
        size.width * 0.3908445,
        size.height * 0.9015421);
    path_88.lineTo(size.width * 0.3908445, size.height * 0.9018224);
    path_88.lineTo(size.width * 0.3963947, size.height * 0.9018224);
    path_88.close();
    path_88.moveTo(size.width * 0.4396746, size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.4362919,
        size.height * 0.9103738,
        size.width * 0.4337416,
        size.height * 0.9099766,
        size.width * 0.4320191,
        size.height * 0.9091822);
    path_88.cubicTo(
        size.width * 0.4303278,
        size.height * 0.9083727,
        size.width * 0.4294833,
        size.height * 0.9070175,
        size.width * 0.4294833,
        size.height * 0.9051168);
    path_88.lineTo(size.width * 0.4294833, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.4273780, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.4273780, size.height * 0.8970561);
    path_88.cubicTo(
        size.width * 0.4285885,
        size.height * 0.8970561,
        size.width * 0.4294976,
        size.height * 0.8969077,
        size.width * 0.4301053,
        size.height * 0.8966121);
    path_88.cubicTo(
        size.width * 0.4307105,
        size.height * 0.8963002,
        size.width * 0.4310144,
        size.height * 0.8958797,
        size.width * 0.4310144,
        size.height * 0.8953505);
    path_88.lineTo(size.width * 0.4310144, size.height * 0.8942991);
    path_88.lineTo(size.width * 0.4411579, size.height * 0.8942991);
    path_88.lineTo(size.width * 0.4411579, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.4476172, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.4476172, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.4411579, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.4411579, size.height * 0.9047196);
    path_88.cubicTo(
        size.width * 0.4411579,
        size.height * 0.9052336,
        size.width * 0.4413804,
        size.height * 0.9056157,
        size.width * 0.4418278,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.4423062,
        size.height * 0.9060981,
        size.width * 0.4430072,
        size.height * 0.9062150,
        size.width * 0.4439330,
        size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.4451435,
        size.height * 0.9062150,
        size.width * 0.4464689,
        size.height * 0.9061449,
        size.width * 0.4479043,
        size.height * 0.9060047);
    path_88.lineTo(size.width * 0.4479043, size.height * 0.9096729);
    path_88.cubicTo(
        size.width * 0.4470096,
        size.height * 0.9098446,
        size.width * 0.4457990,
        size.height * 0.9100000,
        size.width * 0.4442679,
        size.height * 0.9101402);
    path_88.cubicTo(
        size.width * 0.4427679,
        size.height * 0.9102956,
        size.width * 0.4412368,
        size.height * 0.9103738,
        size.width * 0.4396746,
        size.height * 0.9103738);
    path_88.close();
    path_88.moveTo(size.width * 0.4665718, size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.4620431,
        size.height * 0.9103738,
        size.width * 0.4585024,
        size.height * 0.9097979,
        size.width * 0.4559498,
        size.height * 0.9086449);
    path_88.cubicTo(
        size.width * 0.4533971,
        size.height * 0.9074766,
        size.width * 0.4521220,
        size.height * 0.9057792,
        size.width * 0.4521220,
        size.height * 0.9035514);
    path_88.cubicTo(
        size.width * 0.4521220,
        size.height * 0.9013236,
        size.width * 0.4533971,
        size.height * 0.8996343,
        size.width * 0.4559498,
        size.height * 0.8984813);
    path_88.cubicTo(
        size.width * 0.4585024,
        size.height * 0.8973131,
        size.width * 0.4620431,
        size.height * 0.8967290,
        size.width * 0.4665718,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.4710694,
        size.height * 0.8967290,
        size.width * 0.4743062,
        size.height * 0.8973049,
        size.width * 0.4762847,
        size.height * 0.8984579);
    path_88.cubicTo(
        size.width * 0.4782943,
        size.height * 0.8995946,
        size.width * 0.4792990,
        size.height * 0.9010129,
        size.width * 0.4792990,
        size.height * 0.9027103);
    path_88.lineTo(size.width * 0.4792990, size.height * 0.9043925);
    path_88.lineTo(size.width * 0.4637967, size.height * 0.9043925);
    path_88.lineTo(size.width * 0.4637967, size.height * 0.9045327);
    path_88.cubicTo(
        size.width * 0.4637967,
        size.height * 0.9051086,
        size.width * 0.4641483,
        size.height * 0.9055374,
        size.width * 0.4648493,
        size.height * 0.9058178);
    path_88.cubicTo(
        size.width * 0.4655502,
        size.height * 0.9060829,
        size.width * 0.4667153,
        size.height * 0.9062150,
        size.width * 0.4683421,
        size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.4702871,
        size.height * 0.9062150,
        size.width * 0.4721388,
        size.height * 0.9061449,
        size.width * 0.4738923,
        size.height * 0.9060047);
    path_88.cubicTo(
        size.width * 0.4756459,
        size.height * 0.9058645,
        size.width * 0.4771770,
        size.height * 0.9056857,
        size.width * 0.4784856,
        size.height * 0.9054673);
    path_88.lineTo(size.width * 0.4784856, size.height * 0.9092056);
    path_88.cubicTo(
        size.width * 0.4773684,
        size.height * 0.9095012,
        size.width * 0.4757273,
        size.height * 0.9097745,
        size.width * 0.4735574,
        size.height * 0.9100234);
    path_88.cubicTo(
        size.width * 0.4714211,
        size.height * 0.9102570,
        size.width * 0.4690909,
        size.height * 0.9103738,
        size.width * 0.4665718,
        size.height * 0.9103738);
    path_88.close();
    path_88.moveTo(size.width * 0.4693469, size.height * 0.9018224);
    path_88.lineTo(size.width * 0.4693469, size.height * 0.9015421);
    path_88.cubicTo(
        size.width * 0.4693469,
        size.height * 0.9010129,
        size.width * 0.4691077,
        size.height * 0.9006308,
        size.width * 0.4686292,
        size.height * 0.9003972);
    path_88.cubicTo(
        size.width * 0.4681818,
        size.height * 0.9001636,
        size.width * 0.4674976,
        size.height * 0.9000467,
        size.width * 0.4665718,
        size.height * 0.9000467);
    path_88.cubicTo(
        size.width * 0.4656459,
        size.height * 0.9000467,
        size.width * 0.4649450,
        size.height * 0.9001717,
        size.width * 0.4644665,
        size.height * 0.9004206);
    path_88.cubicTo(
        size.width * 0.4640191,
        size.height * 0.9006542,
        size.width * 0.4637967,
        size.height * 0.9010280,
        size.width * 0.4637967,
        size.height * 0.9015421);
    path_88.lineTo(size.width * 0.4637967, size.height * 0.9018224);
    path_88.lineTo(size.width * 0.4693469, size.height * 0.9018224);
    path_88.close();
    path_88.moveTo(size.width * 0.5153636, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5153636, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.5002440, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.5002440, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5022536, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5022536, size.height * 0.9023832);
    path_88.cubicTo(
        size.width * 0.5022536,
        size.height * 0.9018692,
        size.width * 0.5020311,
        size.height * 0.9014953,
        size.width * 0.5015837,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.5011364,
        size.height * 0.9010129,
        size.width * 0.5004665,
        size.height * 0.9008879,
        size.width * 0.4995742,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.4976603,
        size.height * 0.9008879,
        size.width * 0.4967033,
        size.height * 0.9013867,
        size.width * 0.4967033,
        size.height * 0.9023832);
    path_88.lineTo(size.width * 0.4967033, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.4987129, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.4987129, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.4835933, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.4835933, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.4856986, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.4856986, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.4835933, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.4835933, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.4967033, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.4967033, size.height * 0.8988785);
    path_88.cubicTo(
        size.width * 0.4990000,
        size.height * 0.8974451,
        size.width * 0.5018708,
        size.height * 0.8967290,
        size.width * 0.5053158,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.5079641,
        size.height * 0.8967290,
        size.width * 0.5099402,
        size.height * 0.8971343,
        size.width * 0.5112488,
        size.height * 0.8979439);
    path_88.cubicTo(
        size.width * 0.5125885,
        size.height * 0.8987535,
        size.width * 0.5132584,
        size.height * 0.8998680,
        size.width * 0.5132584,
        size.height * 0.9012850);
    path_88.lineTo(size.width * 0.5132584, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5153636, size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.5337990, size.height * 0.9155607);
    path_88.cubicTo(
        size.width * 0.5315024,
        size.height * 0.9155607,
        size.width * 0.5293014,
        size.height * 0.9154825,
        size.width * 0.5271962,
        size.height * 0.9153271);
    path_88.cubicTo(
        size.width * 0.5251220,
        size.height * 0.9151717,
        size.width * 0.5235120,
        size.height * 0.9149918,
        size.width * 0.5223636,
        size.height * 0.9147897);
    path_88.lineTo(size.width * 0.5223636, size.height * 0.9109579);
    path_88.cubicTo(
        size.width * 0.5257440,
        size.height * 0.9112535,
        size.width * 0.5287751,
        size.height * 0.9114019,
        size.width * 0.5314545,
        size.height * 0.9114019);
    path_88.cubicTo(
        size.width * 0.5332727,
        size.height * 0.9114019,
        size.width * 0.5345789,
        size.height * 0.9112617,
        size.width * 0.5353780,
        size.height * 0.9109813);
    path_88.cubicTo(
        size.width * 0.5362057,
        size.height * 0.9107161,
        size.width * 0.5366220,
        size.height * 0.9102103,
        size.width * 0.5366220,
        size.height * 0.9094626);
    path_88.lineTo(size.width * 0.5366220, size.height * 0.9084579);
    path_88.cubicTo(
        size.width * 0.5358230,
        size.height * 0.9089568,
        size.width * 0.5347871,
        size.height * 0.9094007,
        size.width * 0.5335120,
        size.height * 0.9097897);
    path_88.cubicTo(
        size.width * 0.5322679,
        size.height * 0.9101787,
        size.width * 0.5308325,
        size.height * 0.9103738,
        size.width * 0.5292057,
        size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.5259522,
        size.height * 0.9103738,
        size.width * 0.5234952,
        size.height * 0.9097815,
        size.width * 0.5218373,
        size.height * 0.9085981);
    path_88.cubicTo(
        size.width * 0.5202105,
        size.height * 0.9074147,
        size.width * 0.5193971,
        size.height * 0.9057325,
        size.width * 0.5193971,
        size.height * 0.9035514);
    path_88.cubicTo(
        size.width * 0.5193971,
        size.height * 0.9013703,
        size.width * 0.5202105,
        size.height * 0.8996881,
        size.width * 0.5218373,
        size.height * 0.8985047);
    path_88.cubicTo(
        size.width * 0.5234952,
        size.height * 0.8973213,
        size.width * 0.5259522,
        size.height * 0.8967290,
        size.width * 0.5292057,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.5308325,
        size.height * 0.8967290,
        size.width * 0.5322679,
        size.height * 0.8969241,
        size.width * 0.5335120,
        size.height * 0.8973131);
    path_88.cubicTo(
        size.width * 0.5347871,
        size.height * 0.8977021,
        size.width * 0.5358230,
        size.height * 0.8981460,
        size.width * 0.5366220,
        size.height * 0.8986449);
    path_88.lineTo(size.width * 0.5366220, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.5497321, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.5497321, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.5476268, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.5476268, size.height * 0.9091121);
    path_88.cubicTo(
        size.width * 0.5476268,
        size.height * 0.9113703,
        size.width * 0.5464785,
        size.height * 0.9130058,
        size.width * 0.5441818,
        size.height * 0.9140187);
    path_88.cubicTo(
        size.width * 0.5418852,
        size.height * 0.9150467,
        size.width * 0.5384234,
        size.height * 0.9155607,
        size.width * 0.5337990,
        size.height * 0.9155607);
    path_88.close();
    path_88.moveTo(size.width * 0.5338469, size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.5347703,
        size.height * 0.9062150,
        size.width * 0.5354569,
        size.height * 0.9060981,
        size.width * 0.5359043,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.5363828,
        size.height * 0.9056157,
        size.width * 0.5366220,
        size.height * 0.9052336,
        size.width * 0.5366220,
        size.height * 0.9047196);
    path_88.lineTo(size.width * 0.5366220, size.height * 0.9023832);
    path_88.cubicTo(
        size.width * 0.5366220,
        size.height * 0.9018692,
        size.width * 0.5363828,
        size.height * 0.9014953,
        size.width * 0.5359043,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.5354569,
        size.height * 0.9010129,
        size.width * 0.5347703,
        size.height * 0.9008879,
        size.width * 0.5338469,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.5329211,
        size.height * 0.9008879,
        size.width * 0.5322201,
        size.height * 0.9010129,
        size.width * 0.5317416,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.5312943,
        size.height * 0.9014953,
        size.width * 0.5310718,
        size.height * 0.9018692,
        size.width * 0.5310718,
        size.height * 0.9023832);
    path_88.lineTo(size.width * 0.5310718, size.height * 0.9047196);
    path_88.cubicTo(
        size.width * 0.5310718,
        size.height * 0.9052336,
        size.width * 0.5312943,
        size.height * 0.9056157,
        size.width * 0.5317416,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.5322201,
        size.height * 0.9060981,
        size.width * 0.5329211,
        size.height * 0.9062150,
        size.width * 0.5338469,
        size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.5818517, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5818517, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.5692201, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.5692201, size.height * 0.9084579);
    path_88.cubicTo(
        size.width * 0.5685167,
        size.height * 0.9089568,
        size.width * 0.5675287,
        size.height * 0.9094007,
        size.width * 0.5662536,
        size.height * 0.9097897);
    path_88.cubicTo(
        size.width * 0.5650096,
        size.height * 0.9101787,
        size.width * 0.5634785,
        size.height * 0.9103738,
        size.width * 0.5616603,
        size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.5592679,
        size.height * 0.9103738,
        size.width * 0.5573852,
        size.height * 0.9100619,
        size.width * 0.5560144,
        size.height * 0.9094393);
    path_88.cubicTo(
        size.width * 0.5546411,
        size.height * 0.9088166,
        size.width * 0.5539569,
        size.height * 0.9079357,
        size.width * 0.5539569,
        size.height * 0.9067991);
    path_88.cubicTo(
        size.width * 0.5539569,
        size.height * 0.9038551,
        size.width * 0.5590766,
        size.height * 0.9023446,
        size.width * 0.5693158,
        size.height * 0.9022664);
    path_88.cubicTo(
        size.width * 0.5692201,
        size.height * 0.9017371,
        size.width * 0.5688038,
        size.height * 0.9013785,
        size.width * 0.5680718,
        size.height * 0.9011916);
    path_88.cubicTo(
        size.width * 0.5673373,
        size.height * 0.9009895,
        size.width * 0.5660933,
        size.height * 0.9008879,
        size.width * 0.5643397,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.5629043,
        size.height * 0.9008879,
        size.width * 0.5613565,
        size.height * 0.9009661,
        size.width * 0.5596986,
        size.height * 0.9011215);
    path_88.cubicTo(
        size.width * 0.5580718,
        size.height * 0.9012617,
        size.width * 0.5565718,
        size.height * 0.9014568,
        size.width * 0.5552010,
        size.height * 0.9017056);
    path_88.lineTo(size.width * 0.5552010, size.height * 0.8974065);
    path_88.cubicTo(
        size.width * 0.5568900,
        size.height * 0.8972044,
        size.width * 0.5587249,
        size.height * 0.8970409,
        size.width * 0.5607033,
        size.height * 0.8969159);
    path_88.cubicTo(
        size.width * 0.5626794,
        size.height * 0.8967909,
        size.width * 0.5646100,
        size.height * 0.8967290,
        size.width * 0.5664928,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.5712440,
        size.height * 0.8967290,
        size.width * 0.5746411,
        size.height * 0.8971495,
        size.width * 0.5766842,
        size.height * 0.8979907);
    path_88.cubicTo(
        size.width * 0.5787249,
        size.height * 0.8988318,
        size.width * 0.5797464,
        size.height * 0.9001320,
        size.width * 0.5797464,
        size.height * 0.9018925);
    path_88.lineTo(size.width * 0.5797464, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5818517, size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.5692201, size.height * 0.9045794);
    path_88.cubicTo(
        size.width * 0.5677847,
        size.height * 0.9045794,
        size.width * 0.5666675,
        size.height * 0.9046729,
        size.width * 0.5658708,
        size.height * 0.9048598);
    path_88.cubicTo(
        size.width * 0.5651053,
        size.height * 0.9050467,
        size.width * 0.5647225,
        size.height * 0.9053586,
        size.width * 0.5647225,
        size.height * 0.9057944);
    path_88.cubicTo(
        size.width * 0.5647225,
        size.height * 0.9060596,
        size.width * 0.5648804,
        size.height * 0.9062769,
        size.width * 0.5652010,
        size.height * 0.9064486);
    path_88.cubicTo(
        size.width * 0.5655502,
        size.height * 0.9066040,
        size.width * 0.5660287,
        size.height * 0.9066822,
        size.width * 0.5666364,
        size.height * 0.9066822);
    path_88.cubicTo(
        size.width * 0.5674641,
        size.height * 0.9066822,
        size.width * 0.5681029,
        size.height * 0.9065105,
        size.width * 0.5685502,
        size.height * 0.9061682);
    path_88.cubicTo(
        size.width * 0.5689952,
        size.height * 0.9058259,
        size.width * 0.5692201,
        size.height * 0.9053423,
        size.width * 0.5692201,
        size.height * 0.9047196);
    path_88.lineTo(size.width * 0.5692201, size.height * 0.9045794);
    path_88.close();
    path_88.moveTo(size.width * 0.6180335, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6180335, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.6029139, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.6029139, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6049234, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6049234, size.height * 0.9023832);
    path_88.cubicTo(
        size.width * 0.6049234,
        size.height * 0.9018692,
        size.width * 0.6047010,
        size.height * 0.9014953,
        size.width * 0.6042536,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.6038086,
        size.height * 0.9010129,
        size.width * 0.6031388,
        size.height * 0.9008879,
        size.width * 0.6022440,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.6003301,
        size.height * 0.9008879,
        size.width * 0.5993732,
        size.height * 0.9013867,
        size.width * 0.5993732,
        size.height * 0.9023832);
    path_88.lineTo(size.width * 0.5993732, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6013828, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6013828, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.5862632, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.5862632, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5883684, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.5883684, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.5862632, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.5862632, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.5993732, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.5993732, size.height * 0.8988785);
    path_88.cubicTo(
        size.width * 0.6016699,
        size.height * 0.8974451,
        size.width * 0.6045407,
        size.height * 0.8967290,
        size.width * 0.6079856,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.6106340,
        size.height * 0.8967290,
        size.width * 0.6126124,
        size.height * 0.8971343,
        size.width * 0.6139187,
        size.height * 0.8979439);
    path_88.cubicTo(
        size.width * 0.6152584,
        size.height * 0.8987535,
        size.width * 0.6159282,
        size.height * 0.8998680,
        size.width * 0.6159282,
        size.height * 0.9012850);
    path_88.lineTo(size.width * 0.6159282, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6180335, size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.6473206, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.6412919, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6392823, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6392823, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.6540670, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.6540670, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6520574, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6545933, size.height * 0.9055140);
    path_88.lineTo(size.width * 0.6550718, size.height * 0.9055140);
    path_88.lineTo(size.width * 0.6576077, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6555981, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6555981, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.6694737, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.6694737, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6674641, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6615789, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.6473206, size.height * 0.9100467);
    path_88.close();
    path_88.moveTo(size.width * 0.6760000, size.height * 0.8957710);
    path_88.lineTo(size.width * 0.6760000, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.6857608, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.6857608, size.height * 0.8957710);
    path_88.lineTo(size.width * 0.6760000, size.height * 0.8957710);
    path_88.close();
    path_88.moveTo(size.width * 0.6737033, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.6737033, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6758086, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6758086, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6737033, size.height * 0.9008879);
    path_88.lineTo(size.width * 0.6737033, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.6868134, size.height * 0.8970561);
    path_88.lineTo(size.width * 0.6868134, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6889187, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.6889187, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.6737033, size.height * 0.9100467);
    path_88.close();
    path_88.moveTo(size.width * 0.7025407, size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.6992871,
        size.height * 0.9103738,
        size.width * 0.6968301,
        size.height * 0.9097815,
        size.width * 0.6951722,
        size.height * 0.9085981);
    path_88.cubicTo(
        size.width * 0.6935455,
        size.height * 0.9074147,
        size.width * 0.6927321,
        size.height * 0.9057325,
        size.width * 0.6927321,
        size.height * 0.9035514);
    path_88.cubicTo(
        size.width * 0.6927321,
        size.height * 0.9013703,
        size.width * 0.6935455,
        size.height * 0.8996881,
        size.width * 0.6951722,
        size.height * 0.8985047);
    path_88.cubicTo(
        size.width * 0.6968301,
        size.height * 0.8973213,
        size.width * 0.6992871,
        size.height * 0.8967290,
        size.width * 0.7025407,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.7041675,
        size.height * 0.8967290,
        size.width * 0.7056029,
        size.height * 0.8969241,
        size.width * 0.7068469,
        size.height * 0.8973131);
    path_88.cubicTo(
        size.width * 0.7081220,
        size.height * 0.8977021,
        size.width * 0.7091579,
        size.height * 0.8981460,
        size.width * 0.7099569,
        size.height * 0.8986449);
    path_88.lineTo(size.width * 0.7099569, size.height * 0.8957009);
    path_88.lineTo(size.width * 0.7071340, size.height * 0.8957009);
    path_88.lineTo(size.width * 0.7071340, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.7209617, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.7209617, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.7230670, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.7230670, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.7099569, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.7099569, size.height * 0.9084579);
    path_88.cubicTo(
        size.width * 0.7091579,
        size.height * 0.9089568,
        size.width * 0.7081220,
        size.height * 0.9094007,
        size.width * 0.7068469,
        size.height * 0.9097897);
    path_88.cubicTo(
        size.width * 0.7056029,
        size.height * 0.9101787,
        size.width * 0.7041675,
        size.height * 0.9103738,
        size.width * 0.7025407,
        size.height * 0.9103738);
    path_88.close();
    path_88.moveTo(size.width * 0.7071818, size.height * 0.9062150);
    path_88.cubicTo(
        size.width * 0.7081053,
        size.height * 0.9062150,
        size.width * 0.7087919,
        size.height * 0.9060981,
        size.width * 0.7092392,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.7097177,
        size.height * 0.9056157,
        size.width * 0.7099569,
        size.height * 0.9052336,
        size.width * 0.7099569,
        size.height * 0.9047196);
    path_88.lineTo(size.width * 0.7099569, size.height * 0.9023832);
    path_88.cubicTo(
        size.width * 0.7099569,
        size.height * 0.9018692,
        size.width * 0.7097177,
        size.height * 0.9014953,
        size.width * 0.7092392,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.7087919,
        size.height * 0.9010129,
        size.width * 0.7081053,
        size.height * 0.9008879,
        size.width * 0.7071818,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.7062560,
        size.height * 0.9008879,
        size.width * 0.7055550,
        size.height * 0.9010129,
        size.width * 0.7050766,
        size.height * 0.9012617);
    path_88.cubicTo(
        size.width * 0.7046292,
        size.height * 0.9014953,
        size.width * 0.7044067,
        size.height * 0.9018692,
        size.width * 0.7044067,
        size.height * 0.9023832);
    path_88.lineTo(size.width * 0.7044067, size.height * 0.9047196);
    path_88.cubicTo(
        size.width * 0.7044067,
        size.height * 0.9052336,
        size.width * 0.7046292,
        size.height * 0.9056157,
        size.width * 0.7050766,
        size.height * 0.9058645);
    path_88.cubicTo(
        size.width * 0.7055550,
        size.height * 0.9060981,
        size.width * 0.7062560,
        size.height * 0.9062150,
        size.width * 0.7071818,
        size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.7553732, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.7553732, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.7427416, size.height * 0.9100467);
    path_88.lineTo(size.width * 0.7427416, size.height * 0.9084579);
    path_88.cubicTo(
        size.width * 0.7420383,
        size.height * 0.9089568,
        size.width * 0.7410502,
        size.height * 0.9094007,
        size.width * 0.7397751,
        size.height * 0.9097897);
    path_88.cubicTo(
        size.width * 0.7385311,
        size.height * 0.9101787,
        size.width * 0.7370000,
        size.height * 0.9103738,
        size.width * 0.7351818,
        size.height * 0.9103738);
    path_88.cubicTo(
        size.width * 0.7327895,
        size.height * 0.9103738,
        size.width * 0.7309067,
        size.height * 0.9100619,
        size.width * 0.7295359,
        size.height * 0.9094393);
    path_88.cubicTo(
        size.width * 0.7281627,
        size.height * 0.9088166,
        size.width * 0.7274785,
        size.height * 0.9079357,
        size.width * 0.7274785,
        size.height * 0.9067991);
    path_88.cubicTo(
        size.width * 0.7274785,
        size.height * 0.9038551,
        size.width * 0.7325981,
        size.height * 0.9023446,
        size.width * 0.7428373,
        size.height * 0.9022664);
    path_88.cubicTo(
        size.width * 0.7427416,
        size.height * 0.9017371,
        size.width * 0.7423254,
        size.height * 0.9013785,
        size.width * 0.7415933,
        size.height * 0.9011916);
    path_88.cubicTo(
        size.width * 0.7408589,
        size.height * 0.9009895,
        size.width * 0.7396148,
        size.height * 0.9008879,
        size.width * 0.7378612,
        size.height * 0.9008879);
    path_88.cubicTo(
        size.width * 0.7364258,
        size.height * 0.9008879,
        size.width * 0.7348780,
        size.height * 0.9009661,
        size.width * 0.7332201,
        size.height * 0.9011215);
    path_88.cubicTo(
        size.width * 0.7315933,
        size.height * 0.9012617,
        size.width * 0.7300933,
        size.height * 0.9014568,
        size.width * 0.7287225,
        size.height * 0.9017056);
    path_88.lineTo(size.width * 0.7287225, size.height * 0.8974065);
    path_88.cubicTo(
        size.width * 0.7304115,
        size.height * 0.8972044,
        size.width * 0.7322464,
        size.height * 0.8970409,
        size.width * 0.7342249,
        size.height * 0.8969159);
    path_88.cubicTo(
        size.width * 0.7362010,
        size.height * 0.8967909,
        size.width * 0.7381316,
        size.height * 0.8967290,
        size.width * 0.7400144,
        size.height * 0.8967290);
    path_88.cubicTo(
        size.width * 0.7447656,
        size.height * 0.8967290,
        size.width * 0.7481627,
        size.height * 0.8971495,
        size.width * 0.7502057,
        size.height * 0.8979907);
    path_88.cubicTo(
        size.width * 0.7522464,
        size.height * 0.8988318,
        size.width * 0.7532679,
        size.height * 0.9001320,
        size.width * 0.7532679,
        size.height * 0.9018925);
    path_88.lineTo(size.width * 0.7532679, size.height * 0.9062150);
    path_88.lineTo(size.width * 0.7553732, size.height * 0.9062150);
    path_88.close();
    path_88.moveTo(size.width * 0.7427416, size.height * 0.9045794);
    path_88.cubicTo(
        size.width * 0.7413062,
        size.height * 0.9045794,
        size.width * 0.7401890,
        size.height * 0.9046729,
        size.width * 0.7393923,
        size.height * 0.9048598);
    path_88.cubicTo(
        size.width * 0.7386268,
        size.height * 0.9050467,
        size.width * 0.7382440,
        size.height * 0.9053586,
        size.width * 0.7382440,
        size.height * 0.9057944);
    path_88.cubicTo(
        size.width * 0.7382440,
        size.height * 0.9060596,
        size.width * 0.7384019,
        size.height * 0.9062769,
        size.width * 0.7387225,
        size.height * 0.9064486);
    path_88.cubicTo(
        size.width * 0.7390718,
        size.height * 0.9066040,
        size.width * 0.7395502,
        size.height * 0.9066822,
        size.width * 0.7401579,
        size.height * 0.9066822);
    path_88.cubicTo(
        size.width * 0.7409856,
        size.height * 0.9066822,
        size.width * 0.7416244,
        size.height * 0.9065105,
        size.width * 0.7420718,
        size.height * 0.9061682);
    path_88.cubicTo(
        size.width * 0.7425167,
        size.height * 0.9058259,
        size.width * 0.7427416,
        size.height * 0.9053423,
        size.width * 0.7427416,
        size.height * 0.9047196);
    path_88.lineTo(size.width * 0.7427416, size.height * 0.9045794);
    path_88.close();
    path_88.moveTo(size.width * 0.7606459, size.height * 0.8972430);
    path_88.lineTo(size.width * 0.7627033, size.height * 0.8948598);
    path_88.lineTo(size.width * 0.7603589, size.height * 0.8948598);
    path_88.lineTo(size.width * 0.7603589, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.7670574, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.7670574, size.height * 0.8948598);
    path_88.lineTo(size.width * 0.7638517, size.height * 0.8972430);
    path_88.lineTo(size.width * 0.7606459, size.height * 0.8972430);
    path_88.close();
    path_88.moveTo(size.width * 0.7690670, size.height * 0.8972430);
    path_88.lineTo(size.width * 0.7711244, size.height * 0.8948598);
    path_88.lineTo(size.width * 0.7687799, size.height * 0.8948598);
    path_88.lineTo(size.width * 0.7687799, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.7754785, size.height * 0.8918692);
    path_88.lineTo(size.width * 0.7754785, size.height * 0.8948598);
    path_88.lineTo(size.width * 0.7722727, size.height * 0.8972430);
    path_88.lineTo(size.width * 0.7690670, size.height * 0.8972430);
    path_88.close();

    Paint paint_88_fill = Paint()..style = PaintingStyle.fill;
    paint_88_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_88, paint_88_fill);

    Path path_89 = Path();
    path_89.moveTo(size.width * 0.4014928, size.height * 0.8347009);
    path_89.cubicTo(
        size.width * 0.3970718,
        size.height * 0.8347009,
        size.width * 0.3928804,
        size.height * 0.8344626,
        size.width * 0.3889187,
        size.height * 0.8339860);
    path_89.cubicTo(
        size.width * 0.3849569,
        size.height * 0.8334813,
        size.width * 0.3816555,
        size.height * 0.8327944,
        size.width * 0.3790144,
        size.height * 0.8319252);
    path_89.lineTo(size.width * 0.3790144, size.height * 0.8245234);
    path_89.lineTo(size.width * 0.3962392, size.height * 0.8245234);
    path_89.lineTo(size.width * 0.3962392, size.height * 0.8249439);
    path_89.cubicTo(
        size.width * 0.3962392,
        size.height * 0.8264579,
        size.width * 0.3977321,
        size.height * 0.8272150,
        size.width * 0.4007177,
        size.height * 0.8272150);
    path_89.cubicTo(
        size.width * 0.4022679,
        size.height * 0.8272150,
        size.width * 0.4034163,
        size.height * 0.8270187,
        size.width * 0.4041627,
        size.height * 0.8266262);
    path_89.cubicTo(
        size.width * 0.4049665,
        size.height * 0.8262056,
        size.width * 0.4053684,
        size.height * 0.8255607,
        size.width * 0.4053684,
        size.height * 0.8246916);
    path_89.lineTo(size.width * 0.4053684, size.height * 0.8082897);
    path_89.lineTo(size.width * 0.3976172, size.height * 0.8082897);
    path_89.lineTo(size.width * 0.3976172, size.height * 0.8013925);
    path_89.lineTo(size.width * 0.4337895, size.height * 0.8013925);
    path_89.lineTo(size.width * 0.4337895, size.height * 0.8082897);
    path_89.lineTo(size.width * 0.4294833, size.height * 0.8082897);
    path_89.lineTo(size.width * 0.4294833, size.height * 0.8224206);
    path_89.cubicTo(
        size.width * 0.4294833,
        size.height * 0.8265421,
        size.width * 0.4270144,
        size.height * 0.8296262,
        size.width * 0.4220766,
        size.height * 0.8316729);
    path_89.cubicTo(
        size.width * 0.4171388,
        size.height * 0.8336916,
        size.width * 0.4102775,
        size.height * 0.8347009,
        size.width * 0.4014928,
        size.height * 0.8347009);
    path_89.close();
    path_89.moveTo(size.width * 0.4677249, size.height * 0.8347009);
    path_89.cubicTo(
        size.width * 0.4595718,
        size.height * 0.8347009,
        size.width * 0.4531986,
        size.height * 0.8336636,
        size.width * 0.4486053,
        size.height * 0.8315888);
    path_89.cubicTo(
        size.width * 0.4440120,
        size.height * 0.8294860,
        size.width * 0.4417153,
        size.height * 0.8264299,
        size.width * 0.4417153,
        size.height * 0.8224206);
    path_89.cubicTo(
        size.width * 0.4417153,
        size.height * 0.8184112,
        size.width * 0.4440120,
        size.height * 0.8153692,
        size.width * 0.4486053,
        size.height * 0.8132944);
    path_89.cubicTo(
        size.width * 0.4531986,
        size.height * 0.8111916,
        size.width * 0.4595718,
        size.height * 0.8101402,
        size.width * 0.4677249,
        size.height * 0.8101402);
    path_89.cubicTo(
        size.width * 0.4758206,
        size.height * 0.8101402,
        size.width * 0.4816483,
        size.height * 0.8111776,
        size.width * 0.4852081,
        size.height * 0.8132523);
    path_89.cubicTo(
        size.width * 0.4888254,
        size.height * 0.8152991,
        size.width * 0.4906340,
        size.height * 0.8178505,
        size.width * 0.4906340,
        size.height * 0.8209065);
    path_89.lineTo(size.width * 0.4906340, size.height * 0.8239346);
    path_89.lineTo(size.width * 0.4627297, size.height * 0.8239346);
    path_89.lineTo(size.width * 0.4627297, size.height * 0.8241869);
    path_89.cubicTo(
        size.width * 0.4627297,
        size.height * 0.8252243,
        size.width * 0.4633612,
        size.height * 0.8259953,
        size.width * 0.4646244,
        size.height * 0.8265000);
    path_89.cubicTo(
        size.width * 0.4658876,
        size.height * 0.8269766,
        size.width * 0.4679833,
        size.height * 0.8272150,
        size.width * 0.4709115,
        size.height * 0.8272150);
    path_89.cubicTo(
        size.width * 0.4744139,
        size.height * 0.8272150,
        size.width * 0.4777440,
        size.height * 0.8270888,
        size.width * 0.4809019,
        size.height * 0.8268364);
    path_89.cubicTo(
        size.width * 0.4840598,
        size.height * 0.8265841,
        size.width * 0.4868158,
        size.height * 0.8262617,
        size.width * 0.4891699,
        size.height * 0.8258692);
    path_89.lineTo(size.width * 0.4891699, size.height * 0.8325981);
    path_89.cubicTo(
        size.width * 0.4871603,
        size.height * 0.8331308,
        size.width * 0.4842033,
        size.height * 0.8336215,
        size.width * 0.4802990,
        size.height * 0.8340701);
    path_89.cubicTo(
        size.width * 0.4764522,
        size.height * 0.8344907,
        size.width * 0.4722608,
        size.height * 0.8347009,
        size.width * 0.4677249,
        size.height * 0.8347009);
    path_89.close();
    path_89.moveTo(size.width * 0.4727201, size.height * 0.8193084);
    path_89.lineTo(size.width * 0.4727201, size.height * 0.8188037);
    path_89.cubicTo(
        size.width * 0.4727201,
        size.height * 0.8178505,
        size.width * 0.4722895,
        size.height * 0.8171636,
        size.width * 0.4714282,
        size.height * 0.8167430);
    path_89.cubicTo(
        size.width * 0.4706244,
        size.height * 0.8163224,
        size.width * 0.4693900,
        size.height * 0.8161121,
        size.width * 0.4677249,
        size.height * 0.8161121);
    path_89.cubicTo(
        size.width * 0.4660598,
        size.height * 0.8161121,
        size.width * 0.4647967,
        size.height * 0.8163364,
        size.width * 0.4639354,
        size.height * 0.8167850);
    path_89.cubicTo(
        size.width * 0.4631316,
        size.height * 0.8172056,
        size.width * 0.4627297,
        size.height * 0.8178785,
        size.width * 0.4627297,
        size.height * 0.8188037);
    path_89.lineTo(size.width * 0.4627297, size.height * 0.8193084);
    path_89.lineTo(size.width * 0.4727201, size.height * 0.8193084);
    path_89.close();
    path_89.moveTo(size.width * 0.5192919, size.height * 0.8347009);
    path_89.cubicTo(
        size.width * 0.5120574,
        size.height * 0.8347009,
        size.width * 0.5050813,
        size.height * 0.8341402,
        size.width * 0.4983636,
        size.height * 0.8330187);
    path_89.lineTo(size.width * 0.4983636, size.height * 0.8267944);
    path_89.lineTo(size.width * 0.5123158, size.height * 0.8267944);
    path_89.lineTo(size.width * 0.5123158, size.height * 0.8272150);
    path_89.cubicTo(
        size.width * 0.5123158,
        size.height * 0.8285607,
        size.width * 0.5140670,
        size.height * 0.8292336,
        size.width * 0.5175694,
        size.height * 0.8292336);
    path_89.cubicTo(
        size.width * 0.5206699,
        size.height * 0.8292336,
        size.width * 0.5222201,
        size.height * 0.8287150,
        size.width * 0.5222201,
        size.height * 0.8276776);
    path_89.cubicTo(
        size.width * 0.5222201,
        size.height * 0.8271168,
        size.width * 0.5217608,
        size.height * 0.8266963,
        size.width * 0.5208421,
        size.height * 0.8264159);
    path_89.cubicTo(
        size.width * 0.5199809,
        size.height * 0.8261355,
        size.width * 0.5184306,
        size.height * 0.8258972,
        size.width * 0.5161914,
        size.height * 0.8257009);
    path_89.lineTo(size.width * 0.5118852, size.height * 0.8253224);
    path_89.cubicTo(
        size.width * 0.5028708,
        size.height * 0.8245374,
        size.width * 0.4983636,
        size.height * 0.8220421,
        size.width * 0.4983636,
        size.height * 0.8178364);
    path_89.cubicTo(
        size.width * 0.4983636,
        size.height * 0.8153972,
        size.width * 0.5002584,
        size.height * 0.8135047,
        size.width * 0.5040478,
        size.height * 0.8121589);
    path_89.cubicTo(
        size.width * 0.5078373,
        size.height * 0.8108131,
        size.width * 0.5129474,
        size.height * 0.8101402,
        size.width * 0.5193780,
        size.height * 0.8101402);
    path_89.cubicTo(
        size.width * 0.5265550,
        size.height * 0.8101402,
        size.width * 0.5326124,
        size.height * 0.8107290,
        size.width * 0.5375502,
        size.height * 0.8119065);
    path_89.lineTo(size.width * 0.5375502, size.height * 0.8177523);
    path_89.lineTo(size.width * 0.5244593, size.height * 0.8177523);
    path_89.lineTo(size.width * 0.5244593, size.height * 0.8173318);
    path_89.cubicTo(
        size.width * 0.5244593,
        size.height * 0.8167710,
        size.width * 0.5240574,
        size.height * 0.8163505,
        size.width * 0.5232536,
        size.height * 0.8160701);
    path_89.cubicTo(
        size.width * 0.5225072,
        size.height * 0.8157617,
        size.width * 0.5213876,
        size.height * 0.8156075,
        size.width * 0.5198947,
        size.height * 0.8156075);
    path_89.cubicTo(
        size.width * 0.5170239,
        size.height * 0.8156075,
        size.width * 0.5155885,
        size.height * 0.8160561,
        size.width * 0.5155885,
        size.height * 0.8169533);
    path_89.cubicTo(
        size.width * 0.5155885,
        size.height * 0.8174299,
        size.width * 0.5159904,
        size.height * 0.8177944,
        size.width * 0.5167943,
        size.height * 0.8180467);
    path_89.cubicTo(
        size.width * 0.5175981,
        size.height * 0.8182991,
        size.width * 0.5190622,
        size.height * 0.8185374,
        size.width * 0.5211866,
        size.height * 0.8187617);
    path_89.lineTo(size.width * 0.5260957, size.height * 0.8192243);
    path_89.cubicTo(
        size.width * 0.5312057,
        size.height * 0.8197009,
        size.width * 0.5348517,
        size.height * 0.8205841,
        size.width * 0.5370335,
        size.height * 0.8218738);
    path_89.cubicTo(
        size.width * 0.5392153,
        size.height * 0.8231636,
        size.width * 0.5403062,
        size.height * 0.8248178,
        size.width * 0.5403062,
        size.height * 0.8268364);
    path_89.cubicTo(
        size.width * 0.5403062,
        size.height * 0.8293879,
        size.width * 0.5384689,
        size.height * 0.8313364,
        size.width * 0.5347943,
        size.height * 0.8326822);
    path_89.cubicTo(
        size.width * 0.5311770,
        size.height * 0.8340280,
        size.width * 0.5260096,
        size.height * 0.8347009,
        size.width * 0.5192919,
        size.height * 0.8347009);
    path_89.close();
    path_89.moveTo(size.width * 0.6048612, size.height * 0.8272150);
    path_89.lineTo(size.width * 0.6048612, size.height * 0.8341121);
    path_89.lineTo(size.width * 0.5812632, size.height * 0.8341121);
    path_89.lineTo(size.width * 0.5812632, size.height * 0.8308318);
    path_89.cubicTo(
        size.width * 0.5771292,
        size.height * 0.8334112,
        size.width * 0.5719617,
        size.height * 0.8347009,
        size.width * 0.5657608,
        size.height * 0.8347009);
    path_89.cubicTo(
        size.width * 0.5609952,
        size.height * 0.8347009,
        size.width * 0.5574067,
        size.height * 0.8339720,
        size.width * 0.5549952,
        size.height * 0.8325140);
    path_89.cubicTo(
        size.width * 0.5526411,
        size.height * 0.8310561,
        size.width * 0.5514641,
        size.height * 0.8290514,
        size.width * 0.5514641,
        size.height * 0.8265000);
    path_89.lineTo(size.width * 0.5514641, size.height * 0.8176262);
    path_89.lineTo(size.width * 0.5476746, size.height * 0.8176262);
    path_89.lineTo(size.width * 0.5476746, size.height * 0.8107290);
    path_89.lineTo(size.width * 0.5712727, size.height * 0.8107290);
    path_89.lineTo(size.width * 0.5712727, size.height * 0.8245234);
    path_89.cubicTo(
        size.width * 0.5712727,
        size.height * 0.8254486,
        size.width * 0.5716746,
        size.height * 0.8261355,
        size.width * 0.5724785,
        size.height * 0.8265841);
    path_89.cubicTo(
        size.width * 0.5733397,
        size.height * 0.8270047,
        size.width * 0.5746029,
        size.height * 0.8272150,
        size.width * 0.5762679,
        size.height * 0.8272150);
    path_89.cubicTo(
        size.width * 0.5779330,
        size.height * 0.8272150,
        size.width * 0.5791675,
        size.height * 0.8270047,
        size.width * 0.5799713,
        size.height * 0.8265841);
    path_89.cubicTo(
        size.width * 0.5808325,
        size.height * 0.8261355,
        size.width * 0.5812632,
        size.height * 0.8254486,
        size.width * 0.5812632,
        size.height * 0.8245234);
    path_89.lineTo(size.width * 0.5812632, size.height * 0.8176262);
    path_89.lineTo(size.width * 0.5766124, size.height * 0.8176262);
    path_89.lineTo(size.width * 0.5766124, size.height * 0.8107290);
    path_89.lineTo(size.width * 0.6010718, size.height * 0.8107290);
    path_89.lineTo(size.width * 0.6010718, size.height * 0.8272150);
    path_89.lineTo(size.width * 0.6048612, size.height * 0.8272150);
    path_89.close();
    path_89.moveTo(size.width * 0.6333301, size.height * 0.8347009);
    path_89.cubicTo(
        size.width * 0.6260957,
        size.height * 0.8347009,
        size.width * 0.6191196,
        size.height * 0.8341402,
        size.width * 0.6124019,
        size.height * 0.8330187);
    path_89.lineTo(size.width * 0.6124019, size.height * 0.8267944);
    path_89.lineTo(size.width * 0.6263541, size.height * 0.8267944);
    path_89.lineTo(size.width * 0.6263541, size.height * 0.8272150);
    path_89.cubicTo(
        size.width * 0.6263541,
        size.height * 0.8285607,
        size.width * 0.6281053,
        size.height * 0.8292336,
        size.width * 0.6316077,
        size.height * 0.8292336);
    path_89.cubicTo(
        size.width * 0.6347081,
        size.height * 0.8292336,
        size.width * 0.6362584,
        size.height * 0.8287150,
        size.width * 0.6362584,
        size.height * 0.8276776);
    path_89.cubicTo(
        size.width * 0.6362584,
        size.height * 0.8271168,
        size.width * 0.6357990,
        size.height * 0.8266963,
        size.width * 0.6348804,
        size.height * 0.8264159);
    path_89.cubicTo(
        size.width * 0.6340191,
        size.height * 0.8261355,
        size.width * 0.6324689,
        size.height * 0.8258972,
        size.width * 0.6302297,
        size.height * 0.8257009);
    path_89.lineTo(size.width * 0.6259234, size.height * 0.8253224);
    path_89.cubicTo(
        size.width * 0.6169091,
        size.height * 0.8245374,
        size.width * 0.6124019,
        size.height * 0.8220421,
        size.width * 0.6124019,
        size.height * 0.8178364);
    path_89.cubicTo(
        size.width * 0.6124019,
        size.height * 0.8153972,
        size.width * 0.6142967,
        size.height * 0.8135047,
        size.width * 0.6180861,
        size.height * 0.8121589);
    path_89.cubicTo(
        size.width * 0.6218756,
        size.height * 0.8108131,
        size.width * 0.6269856,
        size.height * 0.8101402,
        size.width * 0.6334163,
        size.height * 0.8101402);
    path_89.cubicTo(
        size.width * 0.6405933,
        size.height * 0.8101402,
        size.width * 0.6466507,
        size.height * 0.8107290,
        size.width * 0.6515885,
        size.height * 0.8119065);
    path_89.lineTo(size.width * 0.6515885, size.height * 0.8177523);
    path_89.lineTo(size.width * 0.6384976, size.height * 0.8177523);
    path_89.lineTo(size.width * 0.6384976, size.height * 0.8173318);
    path_89.cubicTo(
        size.width * 0.6384976,
        size.height * 0.8167710,
        size.width * 0.6380957,
        size.height * 0.8163505,
        size.width * 0.6372919,
        size.height * 0.8160701);
    path_89.cubicTo(
        size.width * 0.6365455,
        size.height * 0.8157617,
        size.width * 0.6354258,
        size.height * 0.8156075,
        size.width * 0.6339330,
        size.height * 0.8156075);
    path_89.cubicTo(
        size.width * 0.6310622,
        size.height * 0.8156075,
        size.width * 0.6296268,
        size.height * 0.8160561,
        size.width * 0.6296268,
        size.height * 0.8169533);
    path_89.cubicTo(
        size.width * 0.6296268,
        size.height * 0.8174299,
        size.width * 0.6300287,
        size.height * 0.8177944,
        size.width * 0.6308325,
        size.height * 0.8180467);
    path_89.cubicTo(
        size.width * 0.6316364,
        size.height * 0.8182991,
        size.width * 0.6331005,
        size.height * 0.8185374,
        size.width * 0.6352249,
        size.height * 0.8187617);
    path_89.lineTo(size.width * 0.6401340, size.height * 0.8192243);
    path_89.cubicTo(
        size.width * 0.6452440,
        size.height * 0.8197009,
        size.width * 0.6488900,
        size.height * 0.8205841,
        size.width * 0.6510718,
        size.height * 0.8218738);
    path_89.cubicTo(
        size.width * 0.6532536,
        size.height * 0.8231636,
        size.width * 0.6543445,
        size.height * 0.8248178,
        size.width * 0.6543445,
        size.height * 0.8268364);
    path_89.cubicTo(
        size.width * 0.6543445,
        size.height * 0.8293879,
        size.width * 0.6525072,
        size.height * 0.8313364,
        size.width * 0.6488325,
        size.height * 0.8326822);
    path_89.cubicTo(
        size.width * 0.6452153,
        size.height * 0.8340280,
        size.width * 0.6400478,
        size.height * 0.8347009,
        size.width * 0.6333301,
        size.height * 0.8347009);
    path_89.close();

    Paint paint_89_fill = Paint()..style = PaintingStyle.fill;
    paint_89_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_89, paint_89_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
