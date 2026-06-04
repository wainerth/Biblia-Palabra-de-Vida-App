class NotificationModel {
  final String? id;
  final String title;
  final String message;
  final bool isRead;
  final bool isView;
  final String action;
  final String actionLabel;
  final String notificationType;
  final Map<String, dynamic>? variables;
  final String notificationTypeName;
  final String model;

  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.isView, 
    required this.action,
    required this.actionLabel,
    required this.notificationType,
    required this.notificationTypeName,
    this.variables,
    required this.model,
    required this.createdAt,
  });
  NotificationModel copyWith(
      {String? id,
      String? title,
      String? message,
      bool? isRead,
      String? action,
      String? actionLabel,
      String? notificationType,
      Map<String, dynamic>? variables,
      String? notificationTypeName,
      String? model,
      String? createdAt}) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      isView: isView ,
      action: action ?? this.action,
      actionLabel: actionLabel ?? this.actionLabel,
      notificationType: notificationType ?? this.notificationType,
      variables: variables ?? this.variables,
      notificationTypeName: notificationTypeName ?? this.notificationTypeName,
      model: model ?? this.model,
      createdAt: '',
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      isView: json['isView'] ?? false,
      action: json['action'] ?? '',
      actionLabel: json['actionLabel'] ?? '',
      notificationType: json['notificationType'],
      notificationTypeName: json['notificationTypeName'],
      variables: json['variables'],
      model: json['model'] ?? '',
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "message": message,
      "isRead": isRead,
      "isView": isView,
      "action": action,
      "actionLabel": actionLabel,
      "notificationType": notificationType,
      "notificationTypeName": notificationTypeName,
      "variables": variables,
      "model": model,
      "createdAt": createdAt,
    };
  }
}
