import 'package:biblia_palabra_de_vida_app/models/models.dart';

class UserPreference {
  final String user_id;
  final bool is_active_send_whatsapp;
  final bool is_activate_send_notifications;
  final bool is_activate_send_email;
  final List<UserSchedules>? user_schedules;

  const UserPreference({
    required this.user_id,
    required this.is_active_send_whatsapp,
    required this.is_activate_send_notifications,
    required this.is_activate_send_email,
    this.user_schedules,
  });

  factory UserPreference.fromJson(Map<String, dynamic> json) {
    List<UserSchedules>? schedules;
    if (json["user_schedules"] != null) {
      schedules = (json["user_schedules"] as List)
          .map((item) => UserSchedules.fromJson(item))
          .toList();
    }

    return UserPreference(
        user_id: json["user_id"],
        is_active_send_whatsapp: json["is_active_send_whatsapp"],
         is_activate_send_notifications: json['is_activate_send_notifications'] ?? false,
      is_activate_send_email: json['is_activate_send_email'] ?? false,
        user_schedules: schedules);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": user_id,
      "is_active_send_whatsapp": is_active_send_whatsapp,
      "is_activate_send_notifications": is_activate_send_notifications,
      "is_activate_send_email": is_activate_send_email,
      "user_schedules": user_schedules
    };
  }
}

class UserSchedules {
  final String id;
  final ScheduleModel schedule;

  const UserSchedules({required this.id, required this.schedule});

  factory UserSchedules.fromJson(Map<String, dynamic> json) {
    return UserSchedules(
      id: json["id"],
      schedule: ScheduleModel.fromJson(json["schedule"]),
    );
  }
}
