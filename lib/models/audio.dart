class Audio {
  String url;

  Audio({required this.url});

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

