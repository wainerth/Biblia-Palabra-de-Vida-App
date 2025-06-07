import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class BibleHeaderWidget extends StatelessWidget {
  final String title;
  final String versionName;
  final String chapter;
  final VoidCallback? onBack;
  final VoidCallback? onVersionTap;
  final VoidCallback? onAudioTap;

  const BibleHeaderWidget({
    Key? key,
    required this.title,
    required this.versionName,
    required this.chapter,
    this.onBack,
    this.onVersionTap,
    this.onAudioTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/elipsisTopColor.png"),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
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
                color: Color(0XFFFD8C43),
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: IconButton(
                constraints: BoxConstraints(maxHeight: 35.0),
                padding: EdgeInsets.all(0),
                iconSize: 35.0,
                color: Colors.white,
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
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: onVersionTap,
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: StylesApp(context)
                      .textStyleTitleWithe
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  chapter,
                  textAlign: TextAlign.center,
                  style: StylesApp(context)
                      .textStyleTitleWithe
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
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
                  color: Colors.white,
                  onPressed: onAudioTap,
                  icon: Icon(
                    Icons.volume_up_outlined,
                    size: 35.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
