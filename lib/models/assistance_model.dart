class AssistanceRecord {
  final String id;
  final String churchId;
  final String churchName;
  final String? eventId;
  final String? eventName;
  final DateTime date;
  final DateTime time;
  final double? latitude;
  final double? longitude;
  final String method; // qr, manual, event

  AssistanceRecord({
    required this.id,
    required this.churchId,
    required this.churchName,
    this.eventId,
    this.eventName,
    required this.date,
    required this.time,
    this.latitude,
    this.longitude,
    required this.method,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
