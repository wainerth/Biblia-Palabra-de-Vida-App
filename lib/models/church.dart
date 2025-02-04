class Church {
  final String id;
  final String name;
  final bool status;
  Church({required this.id, required this.name, required this.status});

  factory Church.fromJson(Map<String, dynamic> json) {
    return Church(
        id: json['id'], name: json['name'], status: json['status'] ?? false);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'status': status };
}
