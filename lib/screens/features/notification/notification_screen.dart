import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/models/notification_model.dart';
import 'package:biblia_palabra_de_vida_app/providers/socket_client_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  Map<String, List<NotificationModel>> groupedNotifications = {};
  List<String> sortedDateKeys = []; // ✅ Cambiado a List<String>
  String error = '';
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        title: Text("Notificaciones"),
        titleTextStyle: StylesApp(context)
            .textStyleBody20
            .copyWith(color: StyleColor.white),
        backgroundColor: StyleColor.turquoise,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          displacement: 40,
          onRefresh: () => loadAllNotifications(),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: TextButton(
                  // style: StylesApp(context).btnWidgetSmall,
                  onPressed: () async {
                    String userId = await PreferencesManager().getUserId();
                    setState(() => loading = true);
                    final ResponseData responseMarkedAllRead =
                        await markAllAsReadNotifications(userId);
                    if (responseMarkedAllRead.error != null) {
                      setState(() => loading = false);
                      await showCustomDialog(context,
                          message: responseMarkedAllRead.error!,
                          dialogType: DialogType.error);
                      return;
                    }
                    await loadAllNotifications();
                  },
                  child: Row(
                    spacing: 4.0,
                    children: [
                      Text("Leer Todas"),
                      Icon(
                        Icons.checklist_outlined,
                        color: StyleColor.turquoise,
                      )
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: loading
                        ? Center(child: LoadingIndicator())
                        : error.isNotEmpty
                            ? Center(
                                child: BuildErrorWidget(
                                  errorMessage: error,
                                  onRetry: () async => loadAllNotifications(),
                                  onBack: () => Navigator.pop(context),
                                ),
                              )
                            : notifications.isEmpty
                                ? Center(
                                    child: Text(
                                      "No tienes notificaciones.",
                                      style: StylesApp(context)
                                          .textStyleBody7
                                          .copyWith(color: StyleColor.black),
                                    ),
                                  )
                                : _buildNotificationList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      itemCount: sortedDateKeys.length,
      separatorBuilder: (_, index) => SizedBox(height: 24.0),
      itemBuilder: (context, sectionIndex) {
        final dateKey = sortedDateKeys[sectionIndex];
        final dateNotifications = groupedNotifications[dateKey] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de fecha
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                dateKey,
                style: StylesApp(context).textStyleBody14.copyWith(
                      fontWeight: FontWeight.bold,
                      color: StyleColor.blueDark,
                    ),
              ),
            ),

            // Lista de notificaciones de esta fecha
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dateNotifications.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                final notification = dateNotifications[index];
                return _buildNotificationItem(notification);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    final DateTime notificationDate =
        _parseNotificationDate(notification.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: StyleColor.black.withAlpha(90),
            offset: Offset(0, 4),
            spreadRadius: 4.0,
            blurRadius: 4.0,
          )
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          Icons.notifications,
          color: notification.isRead
              ? StyleColor.grayMedium
              : StyleColor.turquoise,
        ),
        title: Text(
          notification.title,
          style: StylesApp(context).textStyleBody14.copyWith(
                color: notification.isRead
                    ? StyleColor.grayMedium
                    : StyleColor.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: StylesApp(context).textStyleBody10.copyWith(
                        color: notification.isRead
                            ? StyleColor.grayMedium
                            : StyleColor.black,
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTime(notificationDate),
                  style: StylesApp(context).textStyleBody10.copyWith(
                        color: notification.isRead
                            ? StyleColor.grayMedium
                            : StyleColor.black,
                      ),
                ),
                if (notification.actionLabel.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final responseMarkReadNotification =
                            await markAsReadOneNotification(notification.id!);

                        if (responseMarkReadNotification.error != null) {
                          await showCustomDialogWithAction(
                            context,
                            dialogType: DialogTypeAction.error,
                            message: responseMarkReadNotification.error!,
                            actionCallback: () {
                              Navigator.pop(context);
                            },
                            buttonOk: "Ok",
                          );
                          return;
                        } else {
                          if (responseMarkReadNotification.data != null) {
                            if (!responseMarkReadNotification.data['success']) {
                              await showCustomDialog(
                                context,
                                dialogType: DialogType.error,
                                message: responseMarkReadNotification
                                    .data['message'],
                              );
                              return;
                            }
                          }
                        }
                        // Tu lógica de navegación aquí
                        if (getRouterScreen(notification.model.toLowerCase(),
                                    notification.variables)
                                .arguments !=
                            null) {
                          Navigator.pushNamed(
                              context,
                              getRouterScreen(notification.model,
                                      notification.variables)
                                  .routeName,
                              arguments: getRouterScreen(notification.model,
                                      notification.variables)
                                  .arguments);
                        } else {
                          Navigator.pushNamed(
                              context,
                              getRouterScreen(notification.model, null)
                                  .routeName);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: StyleColor.blueDark,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(notification.actionLabel),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future loadAllNotifications() async {
    setState(() {
      error = '';
      if (!loading) loading = true;
    });

    Provider.of<SocketClientProvider>(context, listen: false)
        .cleanNotification();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useData = userProvider.currentUser;

    try {
      final responseNotification = await getAllNotification(
          1, null, useData != null ? useData.userId : '');

      if (responseNotification.error != null) {
        setState(() => loading = false);
        await showCustomDialog(context,
            message: responseNotification.error!, dialogType: DialogType.error);
        return;
      }

      setState(() {
        notifications = responseNotification.data['data']
            .map<NotificationModel>(
                (notify) => NotificationModel.fromJson(notify))
            .toList();

        // Agrupar y ordenar notificaciones
        groupedNotifications = groupNotificationsByDate(notifications);
        sortedDateKeys = _sortDateKeys(groupedNotifications);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error al leer las notificaciones: ${e.toString()}";
        loading = false;
      });
      await showCustomDialog(context,
          message: error, dialogType: DialogType.error);
    }
  }

  // Función para agrupar notificaciones por fecha
  Map<String, List<NotificationModel>> groupNotificationsByDate(
      List<NotificationModel> notifications) {
    Map<String, List<NotificationModel>> groupedNotifications = {};

    for (var notification in notifications) {
      final DateTime notificationDate =
          _parseNotificationDate(notification.createdAt);
      String dateKey = _getDateKey(notificationDate);

      if (!groupedNotifications.containsKey(dateKey)) {
        groupedNotifications[dateKey] = [];
      }

      groupedNotifications[dateKey]!.add(notification);
    }

    return groupedNotifications;
  }

  DateTime _parseNotificationDate(dynamic dateInput) {
    try {
      DateTime result;

      if (dateInput is DateTime) {
        result = dateInput;
      } else if (dateInput is String) {
        // Intentar parseo ISO primero
        result = DateTime.tryParse(dateInput) ??
            _parseCustomFormat(dateInput) ??
            (throw FormatException('Formato no válido'));
      } else {
        throw ArgumentError('Tipo no soportado: ${dateInput.runtimeType}');
      }

      return DateTime(
        result.year,
        result.month,
        result.day,
        result.hour,
        result.minute,
      );
    } catch (e) {
      print('Error parsing date: $dateInput - Error: $e');
      return DateTime.now();
    }
  }

  DateTime? _parseCustomFormat(String dateString) {
    try {
      final parts = dateString.split(' ');
      if (parts.length != 2) return null;

      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');

      if (dateParts.length != 3 || timeParts.length < 2) return null;

      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  // Función para obtener la clave de fecha
  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Hoy';
    } else if (notificationDate == yesterday) {
      return 'Ayer';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Función para ordenar las fechas
  List<String> _sortDateKeys(
      Map<String, List<NotificationModel>> groupedNotifications) {
    final keys = groupedNotifications.keys.toList();

    keys.sort((a, b) {
      if (a == 'Hoy') return -1;
      if (b == 'Hoy') return 1;
      if (a == 'Ayer') return -1;
      if (b == 'Ayer') return 1;

      // Para otras fechas, ordenar de más reciente a más antigua
      final dateA = _parseDateKey(a);
      final dateB = _parseDateKey(b);

      return dateB.compareTo(dateA);
    });

    return keys;
  }

  DateTime _parseDateKey(String key) {
    if (key == 'Hoy') return DateTime.now();
    if (key == 'Ayer') return DateTime.now().subtract(Duration(days: 1));

    final parts = key.split('/');
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }
}
