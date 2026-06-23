class Church {
  final String id;
  final String name;
  final bool status;
  final String? address;
  final String? phone;
  final String? email;
  final String? qrCode;
  Church({
    required this.id,
    required this.name,
    required this.status,
    this.address,
    this.phone,
    this.email,
    this.qrCode,
  });

  factory Church.fromJson(Map<String, dynamic> json) {
    return Church(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      qrCode: json['qrCode'],
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'email': email,
        'phone': phone,
        'qrCode': qrCode,
        'status': status
      };
}
