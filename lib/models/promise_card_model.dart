class PromiseCardModel {
  final String id;
  final String title;
  final String description;
  final String images;
  final bool hasViewed;

  PromiseCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.hasViewed,
  });

  factory PromiseCardModel.fromJson(Map<String, dynamic> json) {
    return PromiseCardModel(
      id: json['id'],
      title: json['title'] as String,
      description: json['description'] as String,
      images: json['images'] as String,
      hasViewed: json['hasViewed'] as bool,
    );
  }
  PromiseCardModel copyWith({
    String? id,
    String? title,
    String? description,
    String? images,
    bool? hasViewed,
  }) {
    return PromiseCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      hasViewed: hasViewed ?? this.hasViewed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'images': images,
      'description': description,
      'hasViewed': hasViewed,
    };
  }
}
