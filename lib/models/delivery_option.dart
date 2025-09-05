class DeliveryOption {
  final String id;
  final String title;
  final String description;
  final String currency;
  final String price;

  DeliveryOption({
    required this.id,
    required this.title,
    required this.description,
    required this.currency,
    required this.price,
  });

  DeliveryOption copyWith(
      {String? title, String? description, String? currency, String? price}) {
    return DeliveryOption(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      price: price ?? this.price,
    );
  }

  factory DeliveryOption.fromJson(Map<String, dynamic> json) {
    return DeliveryOption(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      currency: json['currency'],
      price: json['price'],
    );
  }
}
