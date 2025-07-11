class NotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String action;
  final String actionLabel;
  final String notificationType;
  final String notificationTypeName;
  final String img;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.action,
    required this.actionLabel,
    required this.notificationType,
    required this.notificationTypeName,
    required this.img,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      action: json['action'] ?? '',
      actionLabel: json['actionLabel'] ?? '',
      notificationType: json['notificationType'],
      notificationTypeName: json['notificationTypeName'],
      img: json['img'] ?? '',
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "message": message,
      "isRead": isRead,
      "action": action,
      "actionLabel": actionLabel,
      "notificationType": notificationType,
      "notificationTypeName": notificationTypeName,
      "img": img,
      "createdAt": createdAt,
    };
  }
}
