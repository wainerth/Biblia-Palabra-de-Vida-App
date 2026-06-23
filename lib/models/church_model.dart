class ChurchModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String? logoUrl;
  final String qrCode;
  final bool isAffiliated;

  ChurchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    this.logoUrl,
    required this.qrCode,
    this.isAffiliated = false,
  });

  factory ChurchModel.fromJson(Map<String, dynamic> json) {
    return ChurchModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      logoUrl: json['logoUrl'],
      qrCode: json['qrCode'],
      isAffiliated: json['isAffiliated'] ?? false,
    );
  }
}