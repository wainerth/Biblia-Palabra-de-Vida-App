import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).height - kBottomNavigationBarHeight,
        decoration: BoxDecoration(color: StyleColor.turquoise),
        child: Column(
          spacing: 10.0,
          children: [
            HeadScreenNotAvatar(
              title: "Configuración",
              onRoute: () {
                Navigator.pushNamed(context, "/layoutPage");
              },
            ),
            // ListTile(
            //   title: Text(
            //     'Notificaciones',
            //     style: StylesApp(context).textStyleBody12,
            //   ),
            //   trailing: Switch(
            //     value: showNotification,
            //     onChanged: (bool value) {
            //       setState(() {
            //         showNotification = value;
            //       });
            //     },
            //   ),
            // ),
            // Divider(
            //   height: 2,
            //   thickness: 5,
            //   color: Colors.white.withValues(alpha: 0.50),
            //   endIndent: 10,
            //   indent: 10,
            // ),
            ListTile(
              title: Text(
                'Idioma',
                style: StylesApp(context).textStyleBody12,
              ),
              trailing: Text(
                'Español',
                style: StylesApp(context).textStyleBody12,
              ), 
              onTap: () {
                
              },
            ),
            Divider(
              height: 2,
              thickness: 5,
              color: Colors.white.withValues(alpha: 0.50),
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text(
                'Acerca de',
                style: StylesApp(context).textStyleBody12,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/aboutScreen");
              },
            ),
            Divider(
              height: 2,
              thickness: 5,
              color: Colors.white.withValues(alpha: 0.50),
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text(
                'Cerrar  Sesión',
                style: StylesApp(context).textStyleBody12,
              ),
              onTap: () {
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    return Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: 40,),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: StyleColor.redLight,
                                ),
                                Text(
                                  "La sesión se cerrara",
                                  style: StylesApp(context)
                                      .textStyleBody18
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            spacing: 15,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ButtonThemeWidget(
                                width: 150.0,
                                height: 27.0,
                                text: "Cancelar",
                                buttonStyle: StylesApp(context).btnWidgetSmall,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ButtonThemeWidget(
                                width: 150.0,
                                height: 27.0,
                                text: "Aceptar",
                                buttonStyle: StylesApp(context).btnWidgetSmall,
                                onPressed: () async {
                                  LoadingService().showLoading(context);
                                  final authentication =
                                      Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false);
                                  await authentication.logoutUser(context);
                                  LoadingService().hideLoading();
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 2,
              thickness: 5,
              color: Colors.white.withValues(alpha: 0.50),
              endIndent: 10,
              indent: 10,
            ),
          ],
        ),
      ),
    ));
  }
}
