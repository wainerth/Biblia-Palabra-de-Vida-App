import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  Map<String, List<NotificationModel>> groupedNotifications = {};
  List<String> sortedDateKeys = [];
  String error = '';
  bool loading = false;
  NotificationModel? selectedNotification;

  // variable que contiene las traducciones
  final _translationProvider = AppTranslationProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllNotifications();
    });
    super.initState();
  }

  // MÉTODO MEJORADO PARA MARCAR COMO LEÍDA
  Future<void> _markAsRead(NotificationModel notification) async {
    // Si ya está leída, no hacer nada
    if (notification.isRead) return;

    LoadingService().showLoading(context);

    try {
      final responseMarkReadNotification =
          await markAsReadOneNotification(notification.id!);

      if (responseMarkReadNotification.error != null) {
        if (mounted) {
          await showCustomDialogWithAction(
            context,
            dialogType: DialogTypeAction.error,
            message: responseMarkReadNotification.error!,
            actionCallback: () => Navigator.pop(context),
            buttonOk: "Ok",
          );
        }
        return;
      }

      if (responseMarkReadNotification.data != null &&
          !responseMarkReadNotification.data['success']) {
        if (mounted) {
          await showCustomDialog(
            context,
            dialogType: DialogType.error,
            message: responseMarkReadNotification.data['message'],
          );
        }
        return;
      }

      final socketProvider =
          Provider.of<SocketClientProvider>(context, listen: false);
      socketProvider.markNotificationAsRead(notification.id!);
      // ACTUALIZAR ESTADO COMPLETO
      _updateNotificationStatus(notification.id!, true);
    } catch (e) {
      if (mounted) {
        await showCustomDialog(
          context,
          dialogType: DialogType.error,
          message: _translationProvider
              .trParams("notification_screen.messages.error", {
            "error": e.toString(),
          }),
        );
      }
    } finally {
      LoadingService().hideLoading();
    }
  }

  // MÉTODO PARA ACTUALIZAR EL ESTADO DE UNA NOTIFICACIÓN
  void _updateNotificationStatus(String notificationId, bool isRead) {
    if (!mounted) return;

    setState(() {
      // 1. Actualizar en la lista principal
      for (int i = 0; i < notifications.length; i++) {
        if (notifications[i].id == notificationId) {
          notifications[i] = notifications[i].copyWith(isRead: isRead);
          break;
        }
      }

      // 2. Actualizar en groupedNotifications
      for (final key in groupedNotifications.keys) {
        for (int i = 0; i < groupedNotifications[key]!.length; i++) {
          if (groupedNotifications[key]![i].id == notificationId) {
            groupedNotifications[key]![i] =
                groupedNotifications[key]![i].copyWith(isRead: isRead);
            break;
          }
        }
      }

      // 3. Actualizar selectedNotification si es la misma
      if (selectedNotification?.id == notificationId) {
        selectedNotification = selectedNotification!.copyWith(isRead: isRead);
      }

      // 4. Reordenar las fechas si es necesario
      _reorganizeNotificationGroups();
    });
  }

  // REORGANIZAR GRUPOS DESPUÉS DE ACTUALIZAR
  void _reorganizeNotificationGroups() {
    final Map<String, List<NotificationModel>> newGrouped = {};

    for (var notification in notifications) {
      final dateKey =
          _getDateKey(_parseNotificationDate(notification.createdAt));

      if (!newGrouped.containsKey(dateKey)) {
        newGrouped[dateKey] = [];
      }

      newGrouped[dateKey]!.add(notification);
    }

    setState(() {
      groupedNotifications = newGrouped;
      sortedDateKeys = _sortDateKeys(groupedNotifications);
    });
  }

  // MÉTODO MEJORADO PARA CARGAR NOTIFICACIONES
  Future<void> loadAllNotifications() async {
    if (!mounted) return;

    setState(() {
      error = '';
      loading = true;
    });

    try {
      // Limpiar notificaciones del socket
      final socketProvider =
          Provider.of<SocketClientProvider>(context, listen: false);
      socketProvider.cleanNotification();

      // Obtener usuario
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userData = userProvider.currentUser;

      if (userData == null || userData.userId.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      // Obtener notificaciones
      final responseNotification =
          await getAllNotification(1, null, userData.userId);

      if (responseNotification.error != null) {
        throw Exception(responseNotification.error!);
      }

      // Procesar notificaciones
      final rawNotifications = responseNotification.data['data'] ?? [];
      final List<NotificationModel> loadedNotifications = [];

      for (var notify in rawNotifications) {
        try {
          final notification = NotificationModel.fromJson(notify);
          // Asegurar que la fecha se parse correctamente
          final parsedDate = _parseNotificationDate(notification.createdAt);
          loadedNotifications.add(notification.copyWith(
            createdAt: parsedDate
                .toIso8601String(), // Mantener la fecha parse como String
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Error procesando notificación: $e');
          }
        }
      }

      // Actualizar estado
      if (mounted) {
        setState(() {
          notifications = loadedNotifications;
          groupedNotifications = groupNotificationsByDate(loadedNotifications);
          sortedDateKeys = _sortDateKeys(groupedNotifications);
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = _translationProvider.trParams(
              "notification_screen.messages.error", {"error": e.toString()});
          loading = false;
        });
      }
    }
  }

  // MÉTODO MEJORADO PARA MARCAR TODAS COMO LEÍDAS
  Future<void> _markAllAsRead() async {
    if (notifications.isEmpty || !notifications.any((n) => !n.isRead)) return;

    LoadingService().showLoading(context);

    try {
      String userId = await PreferencesManager().getUserId();
      final ResponseData responseMarkedAllRead =
          await markAllAsReadNotifications(userId);

      if (responseMarkedAllRead.error != null) {
        throw Exception(responseMarkedAllRead.error!);
      }
      final socketProvider =
          Provider.of<SocketClientProvider>(context, listen: false);
      for (var notification in notifications.where((n) => !n.isRead)) {
        socketProvider.markNotificationAsRead(notification.id!);
      }

      // Actualizar todas las notificaciones localmente
      if (mounted) {
        setState(() {
          // Actualizar todas las notificaciones
          notifications =
              notifications.map((n) => n.copyWith(isRead: true)).toList();

          // Actualizar groupedNotifications
          groupedNotifications = groupNotificationsByDate(notifications);
          sortedDateKeys = _sortDateKeys(groupedNotifications);

          // Actualizar selectedNotification si existe
          if (selectedNotification != null) {
            selectedNotification = selectedNotification!.copyWith(isRead: true);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        await showCustomDialog(
          context,
          message: 'Error: ${e.toString()}',
          dialogType: DialogType.error,
        );
      }
    } finally {
      LoadingService().hideLoading();
    }
  }

  // ACTUALIZAR CONTADOR GLOBAL DE NOTIFICACIONES

  @override
  Widget build(BuildContext context) {
    final _isTablet = isTablet(context);

    return Scaffold(
      appBar:
          _isTablet ? _buildTabletAppBar(context) : _buildMobileAppBar(context),
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(context),
          tablet: _buildTabletLayout(context),
        ),
      ),
    );
  }

  // APPBAR PARA TABLET
  AppBar _buildTabletAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      centerTitle: false,
      leadingWidth: 45, // ← CRUCIAL
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: StyleColor.orange,
              foregroundColor: StyleColor.white,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              minimumSize: const Size(35, 35),
              fixedSize: const Size(35, 35),
              iconSize: 20,
            ),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      backgroundColor: StyleColor.turquoise,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _translationProvider.tr("notification_screen.title"),
            style: StylesApp(context).textStyleTitleOrange.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 4),
          if (notifications.isNotEmpty)
            Text(
              _translationProvider
                  .trParams("notification_screen.count.notifications", {
                "count": notifications.length.toString(),
              }),
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
            ),
        ],
      ),
      actions: [
        if (notifications.isNotEmpty && notifications.any((n) => !n.isRead))
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () async {
                await _markAllAsRead();
              },
              child: Row(
                children: [
                  Text(
                    _translationProvider.tr(
                        "notification_screen.tablet.detail_panel.mark_all_read"),
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.checklist_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // APPBAR PARA MÓVIL (original)
  AppBar _buildMobileAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton.filled(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
          foregroundColor: WidgetStatePropertyAll(StyleColor.white),
        ),
        padding: EdgeInsets.all(0),
        onPressed: () => Navigator.pop(context),
        splashColor: StyleColor.orange,
        color: StyleColor.white,
        icon: Icon(Icons.arrow_back, size: 30),
      ),
      title: Text(
        _translationProvider.tr("notification_screen.title"),
        style: StylesApp(context)
            .textStyleBody20
            .copyWith(color: StyleColor.white, fontSize: 20.0),
      ),
      backgroundColor: StyleColor.turquoise,
    );
  }

  // DISEÑO PARA TABLET A DOS COLUMNAS
  Widget _buildTabletLayout(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLUMNA IZQUIERDA - Lista de notificaciones
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Estadísticas
                  if (!loading && error.isEmpty && notifications.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: StyleColor.turquoise.withValues(alpha: 0.1),
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            context,
                            _translationProvider
                                .tr("notification_screen.tablet.stats.total"),
                            '${notifications.length}',
                            Icons.notifications,
                            StyleColor.orange,
                          ),
                          _buildStatCard(
                            context,
                            _translationProvider
                                .tr("notification_screen.tablet.stats.unread"),
                            '${notifications.where((n) => !n.isRead).length}',
                            Icons.notifications_active,
                            StyleColor.blue,
                          ),
                          _buildStatCard(
                            context,
                            _translationProvider
                                .tr("notification_screen.tablet.stats.read"),
                            '${notifications.where((n) => n.isRead).length}',
                            Icons.notifications_none,
                            StyleColor.greenMedium,
                          ),
                        ],
                      ),
                    ),

                  // Lista de notificaciones
                  Expanded(
                    child: RefreshIndicator(
                      color: StyleColor.orange,
                      backgroundColor: Colors.white,
                      onRefresh: () => loadAllNotifications(),
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.notifications_off,
                                            size: 80,
                                            color: Colors.grey[300],
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            _translationProvider.tr(
                                                "notification_screen.mobile.empty"),
                                            style: StylesApp(context)
                                                .textStyleBody16
                                                .copyWith(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[600]),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            _translationProvider.tr(
                                                "notification_screen.mobile.empty_detail"),
                                            textAlign: TextAlign.center,
                                            style: StylesApp(context)
                                                .textStyleBody14
                                                .copyWith(
                                                  fontSize: 14,
                                                  color: Colors.grey[400],
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _buildTabletNotificationList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // COLUMNA DERECHA - Detalle de notificación seleccionada
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.white,
              child: selectedNotification != null
                  ? _buildNotificationDetailPanel(context)
                  : _buildEmptyDetailPanel(context),
            ),
          ),
        ],
      ),
    );
  }

  // Lista de notificaciones para tablet
  Widget _buildTabletNotificationList() {
    return ListView.separated(
      padding: EdgeInsets.all(20.0),
      itemCount: sortedDateKeys.length,
      separatorBuilder: (_, index) => SizedBox(height: 24.0),
      itemBuilder: (context, sectionIndex) {
        final dateKey = sortedDateKeys[sectionIndex];
        final dateNotifications = groupedNotifications[dateKey] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de fecha
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: StyleColor.turquoise.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getDateIcon(dateKey),
                    color: StyleColor.orange,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    dateKey,
                    style: StylesApp(context).textStyleBody16.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: StyleColor.blueDark,
                        ),
                  ),
                  Spacer(),
                  Text(
                    '${dateNotifications.length}',
                    style: StylesApp(context).textStyleBody14.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: StyleColor.orange,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Lista de notificaciones de esta fecha
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dateNotifications.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                final notification = dateNotifications[index];
                return _buildTabletNotificationItem(notification);
              },
            ),
          ],
        );
      },
    );
  }

  // Item de notificación para tablet
  Widget _buildTabletNotificationItem(NotificationModel notification) {
    final DateTime notificationDate =
        _parseNotificationDate(notification.createdAt);
    final bool isSelected = selectedNotification == notification;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? StyleColor.turquoise.withValues(alpha: 0.2)
            : notification.isRead
                ? Colors.white
                : Colors.blue[50],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isSelected
              ? StyleColor.orange
              : notification.isRead
                  ? Colors.grey[300]!
                  : StyleColor.blue.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (!notification.isRead)
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              selectedNotification = notification;
            });
            // Marcar como leída al seleccionar
            // if (!notification.isRead) {
            //   _markAsRead(notification);
            // }
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono de estado
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Colors.grey[300]
                        : StyleColor.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        fontSize: 16.0,
                                        color: notification.isRead
                                            ? Colors.grey[700]
                                            : StyleColor.blueDark,
                                        fontWeight: notification.isRead
                                            ? FontWeight.w500
                                            : FontWeight.w700,
                                      ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            _formatTime(notificationDate),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontSize: 14.0,
                              color: notification.isRead
                                  ? Colors.grey[600]
                                  : Colors.grey[700],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (notification.actionLabel.isNotEmpty) ...[
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: StyleColor.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notification.actionLabel,
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: StyleColor.orange,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Panel de detalle para columna derecha
  Widget _buildNotificationDetailPanel(BuildContext context) {
    final notification = selectedNotification!;
    final DateTime notificationDate =
        _parseNotificationDate(notification.createdAt);

    return SingleChildScrollView(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _translationProvider
                    .tr("notification_screen.tablet.detail_panel.title"),
                style: StylesApp(context).textStyleBody24.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: StyleColor.blueDark,
                    ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    selectedNotification = null;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          // Información principal
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: notification.isRead
                            ? Colors.grey[300]
                            : StyleColor.orange,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Icon(
                          notification.isRead
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: StylesApp(context).textStyleBody20.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: StyleColor.blueDark,
                                ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 6),
                              Text(
                                '${_getDateKey(notificationDate)} a las ${_formatTime(notificationDate)}',
                                style:
                                    StylesApp(context).textStyleBody14.copyWith(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                // Mensaje completo
                Text(
                  _translationProvider
                      .tr("notification_screen.tablet.detail_panel.message"),
                  style: StylesApp(context).textStyleBody16.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: StyleColor.blueDark,
                      ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notification.message,
                    style: StylesApp(context).textStyleBody15.copyWith(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                  ),
                ),

                SizedBox(height: 25),

                // Acción (si existe)
                if (notification.actionLabel.isNotEmpty) ...[
                  Text(
                    _translationProvider
                        .tr("notification_screen.tablet.detail_panel.action"),
                    style: StylesApp(context).textStyleBody16.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: StyleColor.blueDark,
                        ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: StyleColor.orange.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: StyleColor.orange.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.open_in_new,
                                color: StyleColor.orange, size: 20),
                            SizedBox(width: 10),
                            Text(
                              notification.actionLabel,
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: StyleColor.orange,
                                      ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: ElevatedButton(
                            onPressed: () =>
                                _handleNotificationAction(notification),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: StyleColor.orange,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _translationProvider.tr(
                                      "notification_screen.tablet.detail_panel.go_to_action"),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 30),

          // Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!notification.isRead)
                OutlinedButton(
                  onPressed: () async {
                    await _markAsRead(notification);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: StyleColor.greenMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check,
                          color: StyleColor.greenMedium, size: 20),
                      SizedBox(width: 8),
                      Text(
                        _translationProvider.tr(
                            "notification_screen.tablet.detail_panel.mark_all_read"),
                        style: StylesApp(context).textStyleBody16.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: StyleColor.greenMedium,
                            ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 15),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedNotification = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.close, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      _translationProvider
                          .tr("notification_screen.tablet.detail_panel.close"),
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Panel vacío para columna derecha
  Widget _buildEmptyDetailPanel(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            _translationProvider
                .tr("notification_screen.tablet.empty_detail.title"),
            style: StylesApp(context).textStyleBody20.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
          ),
          SizedBox(height: 10),
          Text(
            _translationProvider
                .tr("notification_screen.tablet.empty_detail.subtitle"),
            textAlign: TextAlign.center,
            style: StylesApp(context).textStyleBody15.copyWith(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de estadísticas
  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: StylesApp(context).textStyleBody18.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: StyleColor.blueDark,
              ),
        ),
        Text(
          title,
          style: StylesApp(context).textStyleBody12.copyWith(
                fontSize: 12,
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  // Icono según la fecha
  IconData _getDateIcon(String dateKey) {
    if (_translationProvider.tr("notification_screen.date_groups.today") ==
        dateKey) {
      return Icons.today;
    } else if (_translationProvider
            .tr("notification_screen.date_groups.yesterday") ==
        dateKey) {
      return Icons.history;
    } else {
      return Icons.calendar_month;
    }
  }

  // DISEÑO MÓVIL (se mantiene exactamente igual)
  Widget _buildMobileLayout(BuildContext context) {
    return RefreshIndicator(
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
              onPressed: () async {
                await _markAllAsRead();
              },
              child: Row(
                spacing: 4.0,
                children: [
                  Text(_translationProvider
                      .tr("notification_screen.mobile.mark_all_read")),
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
                                  _translationProvider
                                      .tr("notification_screen.mobile.empty"),
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
    );
  }

  // Los métodos existentes se mantienen igual desde aquí...
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
                        await _handleNotificationAction(notification);
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

  Future<void> _handleNotificationAction(NotificationModel notification) async {
    await _markAsRead(notification);

    if (getRouterScreen(
                notification.model.toLowerCase(), notification.variables)
            .arguments !=
        null) {
      Navigator.pushNamed(
          context,
          getRouterScreen(
                  notification.model.toLowerCase(), notification.variables)
              .routeName,
          arguments: getRouterScreen(
                  notification.model.toLowerCase(), notification.variables)
              .arguments);
    } else {
      Navigator.pushNamed(context,
          getRouterScreen(notification.model.toLowerCase(), null).routeName);
    }
  }

  // Los métodos restantes se mantienen igual...
  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

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
    // Si es nulo o vacío, usar fecha actual
    if (dateInput == null || (dateInput is String && dateInput.trim().isEmpty)) {
      if (kDebugMode) {
        print('⚠️ Fecha vacía o nula, usando fecha actual');
      }
      return DateTime.now();
    }

    // Si ya es DateTime, devolverlo
    if (dateInput is DateTime) {
      return dateInput;
    }

    // Si es String, intentar parsear
    if (dateInput is String) {
      // Limpiar el string (quitar espacios extras)
      final cleanDate = dateInput.trim();
      
      // Intentar formato ISO (yyyy-MM-ddTHH:mm:ss)
      DateTime? parsed = DateTime.tryParse(cleanDate);
      if (parsed != null) return parsed;

      // Intentar formato personalizado dd/MM/yyyy HH:mm
      final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4}) (\d{2}):(\d{2})')
          .firstMatch(cleanDate);
      if (match != null) {
        return DateTime(
          int.parse(match.group(3)!),
          int.parse(match.group(2)!),
          int.parse(match.group(1)!),
          int.parse(match.group(4)!),
          int.parse(match.group(5)!),
        );
      }
      
      // Si llegamos aquí, el formato no es reconocido
      if (kDebugMode) {
        print('⚠️ Formato de fecha no reconocido: "$cleanDate", usando fecha actual');
      }
      return DateTime.now();
    }

    // Tipo no soportado, usar fecha actual
    if (kDebugMode) {
      print('⚠️ Tipo de fecha no soportado: ${dateInput.runtimeType}, usando fecha actual');
    }
    return DateTime.now();
    
  } catch (e) {
    // Error inesperado, usar fecha actual
    if (kDebugMode) {
      print('❌ Error parseando fecha: $dateInput - $e');
    }
    return DateTime.now();
  }
}

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return _translationProvider.tr("notification_screen.date_groups.today");
    } else if (notificationDate == yesterday) {
      return _translationProvider
          .tr("notification_screen.date_groups.yesterday");
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<String> _sortDateKeys(
      Map<String, List<NotificationModel>> groupedNotifications) {
    final keys = groupedNotifications.keys.toList();

    keys.sort((a, b) {
      if (a == _translationProvider.tr("notification_screen.date_groups.today"))
        return -1;
      if (b == _translationProvider.tr("notification_screen.date_groups.today"))
        return 1;
      if (a ==
          _translationProvider.tr("notification_screen.date_groups.yesterday"))
        return -1;
      if (b ==
          _translationProvider.tr("notification_screen.date_groups.yesterday"))
        return 1;

      final dateA = _parseDateKey(a);
      final dateB = _parseDateKey(b);

      return dateB.compareTo(dateA);
    });

    return keys;
  }

  DateTime _parseDateKey(String key) {
    if (key == _translationProvider.tr("notification_screen.date_groups.today"))
      return DateTime.now();
    if (key ==
        _translationProvider.tr("notification_screen.date_groups.yesterday"))
      return DateTime.now().subtract(Duration(days: 1));

    final parts = key.split('/');
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }
}
