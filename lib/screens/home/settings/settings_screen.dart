import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
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

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height:
              MediaQuery.sizeOf(context).height - kBottomNavigationBarHeight,
          decoration: BoxDecoration(color: StyleColor.turquoise),
          child: Column(
            children: [
              HeadScreenNotAvatar(
                title: "Configuración",
                onRoute: () {
                  Navigator.pushNamed(context, "/layoutPage");
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                      _buildSettingsItem(
                        context,
                        title: 'Idioma',
                        trailingText: 'Español',
                        onTap: () {
                          // Acción para cambiar idioma
                        },
                      ),
                      _buildSettingsItem(
                        context,
                        title: 'Acerca de',
                        onTap: () {
                          Navigator.pushNamed(context, "/aboutScreen");
                        },
                      ),
                      _buildSettingsItem(
                        context,
                        title: 'Preguntas frecuentes',
                        onTap: () {
                          Navigator.pushNamed(context, "/faqScreen");
                        },
                      ),
                      _buildSettingsItem(
                        context,
                        title: 'Cerrar Sesión',
                        isLogout: true,
                        onTap: () {
                          _showLogoutConfirmation(context);
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Columna izquierda: Información general y título
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: StyleColor.turquoise,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    HeadScreenNotAvatar(
                      title: "Configuración",
                      onRoute: () {
                        Navigator.pushNamed(context, "/layoutPage");
                      },
                    ),
                    SizedBox(height: 40),

                    // Información de la app
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.settings,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Ajustes de la App',
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Biblia Palabra de Vida',
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Versión 2.0.0',
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        fontSize: 14,
                                      ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '© 2024 Todos los derechos reservados',
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.6),
                                        fontSize: 12,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // Información adicional
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Personaliza tu experiencia de estudio bíblico',
                        style: StylesApp(context).textStyleBody14.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Columna derecha: Opciones de configuración - SOLUCIÓN: Usar SingleChildScrollView
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  // <-- Añadido SingleChildScrollView
                  child: Column(
                    children: [
                      // Header para tablet
                      Container(
                        height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Opciones de Configuración',
                              style:
                                  StylesApp(context).textStyleBody18.copyWith(
                                        color: StyleColor.turquoise,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: StyleColor.turquoise,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/layoutPage");
                              },
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sección: Preferencias de App
                            _buildSectionTitle('Preferencias de la App'),
                            SizedBox(height: 20),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.language,
                              title: 'Idioma',
                              subtitle: 'Español',
                              onTap: () {
                                // Acción para cambiar idioma
                              },
                            ),

                            SizedBox(height: 30), // Aumentado el espacio

                            // Sección: Información
                            _buildSectionTitle('Información'),
                            SizedBox(height: 20),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.info_outline,
                              title: 'Acerca de',
                              subtitle: 'Conoce más sobre la app',
                              onTap: () {
                                Navigator.pushNamed(context, "/aboutScreen");
                              },
                            ),

                            SizedBox(height: 15),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.help_outline,
                              title: 'Ayuda y Soporte',
                              subtitle: 'Preguntas frecuentes y contacto',
                              onTap: () {
                                Navigator.pushNamed(context, "/faqScreen");
                              },
                            ),

                            SizedBox(height: 40), // Aumentado el espacio

                            // Sección: Cuenta
                            _buildSectionTitle('Cuenta'),
                            SizedBox(height: 20),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.logout,
                              title: 'Cerrar Sesión',
                              subtitle: 'Salir de tu cuenta actual',
                              isLogout: true,
                              onTap: () {
                                _showLogoutConfirmation(context);
                              },
                            ),

                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: StylesApp(context).textStyleBody18.copyWith(
            color: StyleColor.turquoise,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    String? trailingText,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: StylesApp(context).textStyleBody12.copyWith(
                  color: isLogout ? StyleColor.redLight : Colors.white,
                  fontWeight: isLogout ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
          trailing: trailingText != null
              ? Text(
                  trailingText,
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                )
              : null,
          onTap: onTap,
        ),
        Divider(
          height: 2,
          thickness: 5,
          color: Colors.white.withValues(alpha: 0.50),
          endIndent: 10,
          indent: 10,
        ),
      ],
    );
  }

  Widget _buildTabletSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isLogout
                ? StyleColor.redLight.withValues(alpha: 0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLogout ? StyleColor.redLight : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isLogout
                      ? StyleColor.redLight.withValues(alpha: 0.2)
                      : StyleColor.turquoise.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isLogout ? StyleColor.redLight : StyleColor.turquoise,
                  size: 24,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color:
                                isLogout ? StyleColor.redLight : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: isLogout
                                ? StyleColor.redLight.withValues(alpha: 0.8)
                                : Colors.grey[600],
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isLogout ? StyleColor.redLight : Colors.grey[400],
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          // constraints: BoxConstraints(maxHeight: 220),
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: StyleColor.redLight.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.warning_amber,
                  color: StyleColor.redLight,
                  size: 36,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "¿Estás seguro de cerrar sesión?",
                style: StylesApp(context).textStyleBody18.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Se cerrará tu sesión actual y deberás iniciar sesión nuevamente",
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ButtonThemeWidget(
                      width: double.infinity,
                      height: 45,
                      text: "Cancelar",
                      buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.grey[300],
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.black87,
                            ),
                          ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ButtonThemeWidget(
                      width: double.infinity,
                      height: 45,
                      text: "Cerrar Sesión",
                      buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              StyleColor.redLight,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                          ),
                      onPressed: () async {
                        Navigator.pop(context);
                        LoadingService().showLoading(context);
                        final authentication =
                            Provider.of<AuthenticationProvider>(context,
                                listen: false);
                        await authentication.logoutUser(context);
                        LoadingService().hideLoading();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isTablet(context)
        ? _buildTabletLayout(context)
        : _buildMobileLayout(context);
  }
}
