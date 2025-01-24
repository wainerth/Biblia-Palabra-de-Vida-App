import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class HeaderNotDetailsStageWidget extends StatefulWidget {
  final String title;
  final String stage;
  final String subtitle;
  final dynamic details;
  final void Function()? onPressed;
  const HeaderNotDetailsStageWidget({
    super.key,
    this.onPressed,
    required this.title,
    required this.stage,
    required this.subtitle,
    this.details,
  });

  @override
  State<HeaderNotDetailsStageWidget> createState() =>
      _HeaderNotDetailsStageWidgetState();
}

class _HeaderNotDetailsStageWidgetState
    extends State<HeaderNotDetailsStageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0XFF739EC7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.0,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: 25.0,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/layoutPage1');
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: 25.0,
                  ),
                  color: Colors.white,
                ),
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  widget.title,
                  style: StylesApp(context).textStyleBody4.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: 50,
          ),
          decoration: BoxDecoration(
            color: Color(0XFF7688C2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Etapa ${widget.stage}',
                      style: StylesApp(context).textStyleBody4.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 25.0,
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        // iconSize: 20.0,
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CustomModalWidget(
                                title: widget.details!.sectionName,
                                content: widget.details.introduction,
                                buttonText: 'Aceptar',
                                id: widget.details.id,
                                itemCount: widget.details.levelCount,
                                itemsCompleted: widget.details.levelCompleted,
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.info_outline_rounded),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.subtitle,
                      style: StylesApp(context).textStyleBody4.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}