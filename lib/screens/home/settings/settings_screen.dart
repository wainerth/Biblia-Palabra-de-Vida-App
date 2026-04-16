import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/models/whats_app_response.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/whatsAppScheduleDialog.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:biblia_palabra_de_vida_app/widgets/translated_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showNotification = false;

  int _refreshKey = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context));
  }

  Widget _buildMobileLayout(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          height:
              MediaQuery.sizeOf(context).height - kBottomNavigationBarHeight,
          decoration: BoxDecoration(color: StyleColor.turquoise),
          child: Column(
            children: [
              HeadScreenNotAvatar(
                title: 'settings.settings',
                onRoute: () {
                  Navigator.pushNamed(context, "/layoutPage");
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildWhatsAppSettingsItem(context),
                      _buildSettingsItem(
                        context,
                        path: 'settings.language',
                        trailingText: translationProvider.currentLanguageName,
                        onTap: () => GraphQLConfig.development
                            ? () => _showLanguageDialog(context)
                            : () {},
                      ),
                      _buildSettingsItem(
                        context,
                        path: 'settings.about',
                        onTap: () {
                          Navigator.pushNamed(context, "/aboutScreen");
                        },
                      ),
                      _buildSettingsItem(
                        context,
                        path: 'settings.faq_contact',
                        onTap: () {
                          Navigator.pushNamed(context, "/faqScreen");
                        },
                      ),
                      _buildSettingsItem(
                        context,
                        path: 'settings.logout_button',
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
    final translationProvider = Provider.of<AppTranslationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Columna izquierda: Información general y título
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: StyleColor.turquoise,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeadScreenNotAvatar(
                        title: translationProvider.tr('settings.settings'),
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
                            TranslatedText(
                              path: 'settings.app_settings',
                              style:
                                  StylesApp(context).textStyleBody18.copyWith(
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
                                  TranslatedText(
                                    path: 'settings.bible_word_of_life',
                                    style: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                  ),
                                  SizedBox(height: 10),
                                  TranslatedText(
                                    path: 'settings.version_2_0_0',
                                    style: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          fontSize: 14,
                                        ),
                                  ),
                                  SizedBox(height: 5),
                                  TranslatedText(
                                    path: 'settings.all_rights_reserved',
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.6),
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

                      SizedBox(height: 40),

                      // Información adicional
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TranslatedText(
                          path: 'settings.personalize_experience',
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // Columna derecha: Opciones de configuración
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
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
                            TranslatedText(
                              path: 'settings.configuration_options',
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

                            _buildSectionTitle('settings.app_preferences'),
                            SizedBox(height: 20),
                            _buildTabletWhatsAppSettingsItem(context),
                            SizedBox(height: 20),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.language,
                              path: 'settings.language',
                              subtitle: translationProvider.currentLanguageName,
                              onTap: GraphQLConfig.development
                                  ? () => _showLanguageDialog(context)
                                  : () {},
                            ),

                            SizedBox(height: 30),

                            // Sección: Información
                            _buildSectionTitle('settings.information'),
                            SizedBox(height: 20),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.info_outline,
                              path: 'settings.about',
                              subtitlePath: 'settings.learn_more_app',
                              onTap: () {
                                Navigator.pushNamed(context, "/aboutScreen");
                              },
                            ),

                            SizedBox(height: 15),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.help_outline,
                              path: 'settings.help_support',
                              subtitlePath: 'settings.faq_contact',
                              onTap: () {
                                Navigator.pushNamed(context, "/faqScreen");
                              },
                            ),

                            SizedBox(height: 40),

                            // Sección: Cuenta
                            _buildSectionTitle('settings.account'),
                            SizedBox(height: 20),

                            _buildTabletSettingsItem(
                              context,
                              icon: Icons.logout,
                              path: 'settings.logout_button',
                              subtitlePath: 'settings.logout_current_account',
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

  // Widget para tablet (similar al mobile pero con estilo tablet)
  Widget _buildTabletWhatsAppSettingsItem(BuildContext context) {
    const IconData whatsappIcon = IconData(
      0xf232, // Código Unicode de WhatsApp (FontAwesome)
      fontFamily: 'MaterialIcons',
    );

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userId = userProvider.currentUser?.userId;

        if (userId == null) {
          return _buildTabletSettingsItem(
            context,
            icon: whatsappIcon,
            path: 'settings.whatsapp_notifications',
            subtitle: 'Inicia sesión para configurar',
            onTap: () {},
          );
        }

        return FutureBuilder<UserPreference?>(
          key: ValueKey(_refreshKey),
          future: _getUserWhatsAppPreferences(userId.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildTabletSettingsItem(
                context,
                icon: whatsappIcon,
                path: 'settings.whatsapp_notifications',
                subtitle: 'Cargando...',
                onTap: () {},
              );
            }

            if (snapshot.hasError || snapshot.data == null) {
              return _buildTabletSettingsItem(
                context,
                icon: whatsappIcon,
                path: 'settings.whatsapp_notifications',
                subtitle: 'Error al cargar',
                onTap: () {},
              );
            }

            final preferences = snapshot.data!;
            final isActive = preferences.is_active_send_whatsapp;
            final schedules = preferences.user_schedules ?? [];
            final hasSchedules = schedules.isNotEmpty;

            String subtitle = '';
            if (isActive && hasSchedules) {
              final times = schedules.map((s) => s.schedule.time).toList();
              times.sort();
              subtitle = 'Horas: ${times.join(', ')}';
            } else if (isActive && !hasSchedules) {
              subtitle = 'Selecciona horarios';
            } else {
              subtitle = 'Desactivado';
            }

            return _buildTabletSettingsItem(
              context,
              icon: whatsappIcon,
              path: 'settings.whatsapp_notifications',
              subtitle: subtitle,
              onTap: () => _openWhatsAppDialog(
                context,
                userId.toString(),
                isActive,
                schedules,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String path) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return Text(
          provider.tr(path),
          style: StylesApp(context).textStyleBody18.copyWith(
                color: StyleColor.turquoise,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        );
      },
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String path,
    String? trailingText,
    Widget? trailing, // 👈 Agregar para Widget personalizado
    String? subtitle, // 👈 Agregar para subtítulo
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            ListTile(
              title: Text(
                provider.tr(path),
                style: StylesApp(context).textStyleBody12.copyWith(
                      color: isLogout ? StyleColor.redLight : Colors.white,
                      fontWeight:
                          isLogout ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
              subtitle: subtitle != null
                  ? Text(
                      subtitle,
                      style: StylesApp(context).textStyleBody10.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                    )
                  : null,
              trailing: trailing ??
                  (trailingText != null
                      ? Text(
                          trailingText,
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                        )
                      : null),
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
      },
    );
  }

  Widget _buildTabletSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String path,
    String? subtitle,
    String? subtitlePath,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        final subtitleText =
            subtitlePath != null ? provider.tr(subtitlePath) : subtitle ?? '';

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
                      color:
                          isLogout ? StyleColor.redLight : StyleColor.turquoise,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.tr(path),
                          style: StylesApp(context).textStyleBody16.copyWith(
                                color: isLogout
                                    ? StyleColor.redLight
                                    : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitleText,
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
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    Provider.of<AppTranslationProvider>(context, listen: false);

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true, // Importante para controlar el tamaño
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          // 👈 Envolver con SafeArea
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ... tu contenido existente
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
                TranslatedText(
                  path: 'settings.logout_confirmation',
                  style: StylesApp(context).textStyleBody18.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TranslatedText(
                  path: 'settings.logout_warning',
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
                      child: TranslatedButton(
                        path: 'settings.cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: StylesApp(context).btnWidgetSmall.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.grey[300],
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                Colors.black87,
                              ),
                            ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TranslatedButton(
                        path: 'settings.logout_button',
                        onPressed: () async {
                          Navigator.pop(context);
                          LoadingService().showLoading(context);
                          final authentication =
                              Provider.of<AuthenticationProvider>(context,
                                  listen: false);
                          await authentication.logoutUser(context);
                          LoadingService().hideLoading();
                        },
                        style: StylesApp(context).btnWidgetSmall.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                StyleColor.redLight,
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TranslatedText(path: 'languages.select_language'),
          content: Consumer<AppTranslationProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: provider.supportedLanguages.map((language) {
                  return ListTile(
                    leading: Text(language['flag']!),
                    title: Text(language['name']!),
                    trailing: language['code'] == provider.currentLanguage
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      provider.setLanguage(language['code']!);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TranslatedButton(
              style: StylesApp(context).btnWidgetSmall,
              path: 'common.close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // Widget de configuración de WhatsApp (para usar en ambas vistas)
  Widget _buildWhatsAppSettingsItem(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userId = userProvider.currentUser?.userId;

        if (userId == null) {
          return _buildSettingsItem(
            context,
            path: 'settings.whatsapp_notifications',
            subtitle: 'Inicia sesión para configurar',
            onTap: () {},
          );
        }

        return FutureBuilder<UserPreference?>(
          key: ValueKey(_refreshKey),
          future: _getUserWhatsAppPreferences(userId.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSettingsItem(
                context,
                path: 'settings.whatsapp_notifications',
                trailing: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                onTap: () {},
              );
            }

            if (snapshot.hasError || snapshot.data == null) {
              return _buildSettingsItem(
                context,
                path: 'settings.whatsapp_notifications',
                subtitle: 'Error al cargar',
                onTap: () {},
              );
            }

            final preferences = snapshot.data!;
            final isActive = preferences.is_active_send_whatsapp;
            final schedules = preferences.user_schedules ?? [];
            final hasSchedules = schedules.isNotEmpty;

            // Formatear horas para mostrar
            String subtitle = '';
            if (isActive && hasSchedules) {
              final times = schedules.map((s) => s.schedule.time).toList();
              times.sort();
              subtitle = 'Horas: ${times.join(', ')}';
            } else if (isActive && !hasSchedules) {
              subtitle = 'Selecciona horarios';
            } else {
              subtitle = 'Desactivado';
            }

            return _buildSettingsItem(
              context,
              path: 'settings.whatsapp_notifications',
              subtitle: subtitle,
              trailing: Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () => _openWhatsAppDialog(
                context,
                userId.toString(),
                isActive,
                schedules,
              ),
            );
          },
        );
      },
    );
  }

// Abrir el diálogo de WhatsApp
  Future<void> _openWhatsAppDialog(
    BuildContext context,
    String userId,
    bool currentIsActive,
    List<UserSchedules> currentSchedules,
  ) async {
    // Convertir los horarios actuales a List<ScheduleModel> para el diálogo
    final currentHours = currentSchedules.map((us) => us.schedule).toList();

    final result = await WhatsAppScheduleDialogExtension.show(
      context: context,
      initialEnabled: currentIsActive,
      initialHours: currentHours,
      onSave: (enabled, selectedHours) async {
        // Guardar en el backend
        await _saveWhatsAppPreferences(
          context,
          userId,
          enabled,
          selectedHours,
        );

        if (mounted) {
          setState(() {
            _refreshKey++;
          });
        }
      },
    );

    // Si el usuario guardó, refrescar la pantalla
    // if (result == true) {
    //   await Future.delayed(Duration(milliseconds: 1500));

    //   if (mounted) {
    //     setState(() {
    //       _refreshKey++;
    //     });
    //   }
    // }
  }

  // Obtener preferencias del usuario
  Future<UserPreference?> _getUserWhatsAppPreferences(String userId) async {
    final response = await getUserWhatsAppPreferences(userId);
    if (response.error != null || response.data == null) {
      return null;
    }
    return UserPreference.fromJson(response.data);
  }

  // Helper para SnackBar
  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Guardar preferencias de WhatsApp
  Future<void> _saveWhatsAppPreferences(
    BuildContext context,
    String userId,
    bool enabled,
    List<ScheduleModel> selectedHours,
  ) async {
    try {
      LoadingService().showLoading(context);

      // Extraer los IDs de los horarios seleccionados
      final scheduleIds = selectedHours.map((h) => h.id.toString()).toList();

      // Llamar a tu mutation
      await saveWhatsAppConfig(
        userId,
        enabled,
        scheduleIds,
      );

      LoadingService().hideLoading();
      _showSnackBar(
          context,
          enabled
              ? 'Notificaciones de WhatsApp activadas'
              : 'Notificaciones de WhatsApp desactivadas');
    } catch (e) {
      LoadingService().hideLoading();
      _showSnackBar(context, 'Error: ${e.toString()}', isError: true);
    }
  }
}
