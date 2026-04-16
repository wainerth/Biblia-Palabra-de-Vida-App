class ScheduleModel {
  String id;
  String time;

  ScheduleModel({required this.id, required this.time});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json["id"],
      time: json["time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "time": time};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduleModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
