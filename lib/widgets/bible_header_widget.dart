import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BibleHeaderWidget extends StatelessWidget {
  final String title;
  final String versionName;
  final String chapter;
  final bool showIconVideo;
  final bool showButton;
  final double? widthButton;
  final double? topPosition;
  final double? bottomPosition;
  final double spacingBottom;
  final Function()? onSearchBible;
  final VoidCallback? onBack;
  final VoidCallback? onVersionTap;
  final VoidCallback? onVideoCollection;

  const BibleHeaderWidget({
    super.key,
    required this.title,
    required this.versionName,
    required this.chapter,
    this.showIconVideo = false,
    this.showButton = true,
    this.widthButton,
    this.topPosition = 0,
    this.bottomPosition = 0,
    this.spacingBottom = 50,
    this.onBack,
    this.onSearchBible,
    this.onVersionTap,
    this.onVideoCollection,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    final currentTheme = themeProvider.themeData;
    return SafeArea(
      child: Stack(children: [
        Positioned.fill(
          child: SvgPicture.asset(
            "assets/elipsisTopColor.svg",
            colorFilter: ColorFilter.mode(currentTheme.appBarColor,
                BlendMode.color), // currentTheme.appBarColor, // Color dinámico
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: spacingBottom),
          width: double.infinity,
          decoration: BoxDecoration(),
          child: Stack(
            children: [
              if (showButton)
                Positioned(
                  top: 10,
                  left: 15,
                  child: Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                      color: currentTheme.name != 'Claro'
                          ? currentTheme.buttonColor
                          : Color(0XFFFD8C43),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: IconButton(
                        constraints: BoxConstraints(maxHeight: 35.0),
                        padding: EdgeInsets.all(0),
                        iconSize: 35.0,
                        color: currentTheme.name != 'Claro'
                            ? currentTheme.buttonTextColor
                            : currentTheme.backgroundColor,
                        onPressed: onBack ?? () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.0),
                  Center(
                    child: ButtonThemeWidget(
                      width: widthButton,
                      height: 27.0,
                      text: versionName,
                      buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                            backgroundColor: currentTheme.name != 'Claro'
                                ? WidgetStatePropertyAll(
                                    currentTheme.buttonColor)
                                : WidgetStatePropertyAll(Color(0XFFFD8C43)),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                currentTheme.buttonTextColor),
                          ),
                      onPressed: onVersionTap,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: GestureDetector(
                      onTap: onSearchBible,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: StylesApp(context).textStyleTitleWithe.copyWith(
                            color: currentTheme.name != 'Claro'
                                ? currentTheme.textColor
                                : currentTheme.backgroundColor,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: onSearchBible,
                    child: Center(
                      child: Text(
                        chapter,
                        textAlign: TextAlign.center,
                        style: StylesApp(context).textStyleTitleWithe.copyWith(
                            color: currentTheme.name != 'Claro'
                                ? currentTheme.textColor
                                : currentTheme.backgroundColor,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
              if (showIconVideo)
                Positioned(
                  top: topPosition,
                  bottom: bottomPosition,
                  right: 15,
                  child: Column(
                    children: [
                      IconButton(
                        constraints: BoxConstraints(maxHeight: 35.0),
                        padding: EdgeInsets.all(0),
                        iconSize: 35.0,
                        color: currentTheme.buttonTextColor,
                        onPressed: onVideoCollection,
                        icon: Icon(
                          Icons.video_collection,
                          size: 35.0,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
