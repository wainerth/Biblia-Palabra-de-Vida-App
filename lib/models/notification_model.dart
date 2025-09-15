class NotificationModel {
  final String? id;
  final String title;
  final String message;
  final bool isRead;
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
    required this.action,
    required this.actionLabel,
    required this.notificationType,
    required this.notificationTypeName,
    this.variables,
    required this.model,
    
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
