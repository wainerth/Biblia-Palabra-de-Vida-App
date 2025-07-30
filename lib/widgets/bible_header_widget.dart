import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BibleHeaderWidget extends StatelessWidget {
  final String title;
  final String versionName;
  final String chapter;
  final bool showIconVideo;
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
            color: currentTheme.appBarColor, // Color dinámico
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 50.0),
          width: double.infinity,
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: const AssetImage("assets/elipsisTopColor1.svg"),
              //   fit: BoxFit.cover,
              //   alignment: Alignment.bottomCenter,
              // ),
              ),
          child: Stack(
            children: [
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.0),
                  Center(
                    child: ButtonThemeWidget(
                      // width: 150.0,
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
                  top: 0,
                  bottom: 0,
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
