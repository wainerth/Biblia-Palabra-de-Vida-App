import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/models/notification_model.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/socket_client_provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/home/settings/workspace_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({super.key});

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget>
    with SingleTickerProviderStateMixin {
  List<NotificationModel> notifications = [];
  late SocketClientProvider notificationProvider;
  late TabController _tabController; // ✅ NUEVO: Controlador para los tabs

  @override
  void initState() {
    super.initState();
    notificationProvider =
        Provider.of<SocketClientProvider>(context, listen: false);
    notifications = notificationProvider.notifications;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0, // ← Fuerza el tab inicial
    );
    // Listen for changes in notifications
    notificationProvider.addListener(_onNotificationsChanged);
  }

  void _onNotificationsChanged() {
    final newNotifications = [...notificationProvider.notifications];
    setState(() {
      notifications = newNotifications;
    });
  }

  @override
  void dispose() {
    notificationProvider.removeListener(_onNotificationsChanged);
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationModel> get unreadNotifications {
    return notifications.where((n) => n.isRead == false).toList();
  }

  List<NotificationModel> get readNotifications {
    return notifications.where((n) => n.isRead == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translationProvider.tr('workspace.notifications'),
                style: StylesApp(context).textStyleBody5.copyWith(
                    color: StyleColor.black, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // cerramos la modal

                  Navigator.pushNamed(context, '/notificationPage');
                },
                child: Text(translationProvider.tr('workspace.see_all'),
                    style: StylesApp(context)
                        .textStyleBody14
                        .copyWith(color: StyleColor.turquoise)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: StyleColor.orange,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: StyleColor.black,
              // unselectedLabelStyle: TextStyle(backgroundColor: Colors.blueGrey[200]),

              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(translationProvider.tr('workspace.unread')),
                      if (unreadNotifications.isNotEmpty) ...[
                        SizedBox(width: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadNotifications.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(text: translationProvider.tr('workspace.read')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(unreadNotifications),
                _buildNotificationsList(readNotifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notificationsToShow) {
    final translationProvider = context.read<AppTranslationProvider>();

    return notificationsToShow.isEmpty
        ? Center(
            child: Text(
              _tabController.index == 0
                  ? translationProvider.tr('workspace.no_unread_notifications')
                  : translationProvider.tr('workspace.no_read_notifications'),
              style: StylesApp(context)
                  .textStyleBody7
                  .copyWith(color: StyleColor.black),
            ),
          )
        : ListView.separated(
            itemCount: notificationsToShow.length,
            separatorBuilder: (_, __) => SizedBox(height: 20.0),
            itemBuilder: (context, index) {
              final notification = notificationsToShow[index];
              return _buildNotificationItem(notification);
            },
          );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
                  formatDateTime(notification.createdAt),
                  style: StylesApp(context).textStyleBody10.copyWith(
                      color: notification.isRead
                          ? StyleColor.grayMedium
                          : StyleColor.black),
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

                        if (getRouterScreen(notification.model.toLowerCase(),
                                    notification.variables)
                                .arguments !=
                            null) {
                          Navigator.pushNamed(
                              context,
                              getRouterScreen(notification.model.toLowerCase(),
                                      notification.variables)
                                  .routeName,
                              arguments: getRouterScreen(
                                      notification.model.toLowerCase(),
                                      notification.variables)
                                  .arguments);
                        } else {
                          Navigator.pushNamed(
                              context,
                              getRouterScreen(
                                      notification.model.toLowerCase(), null)
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
}