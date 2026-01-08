class Video {
  String url;

  Video({required this.url});
// Método copyWith
  Video copyWith({
    String? url,
  }) {
    return Video(
      url: url ?? this.url,
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
