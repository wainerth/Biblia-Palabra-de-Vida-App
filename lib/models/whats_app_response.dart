import 'package:biblia_palabra_de_vida_app/models/models.dart';

class UserPreference {
  final String user_id;
  final bool is_active_send_whatsapp;
  final List<UserSchedules>? user_schedules;

  const UserPreference({
    required this.user_id,
    required this.is_active_send_whatsapp,
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
        user_schedules: schedules);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": user_id,
      "is_active_send_whatsapp": is_active_send_whatsapp,
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
