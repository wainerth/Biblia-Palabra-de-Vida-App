class Reflection {
  final String? id;
  final String? title;
  final String? url;
  final int? countCards;
  final int? status;

  Reflection({
    this.id,
    this.title,
    this.url,
    this.countCards,
    this.status,
  });

  factory Reflection.fromJson(Map<String, dynamic> json) {
    return Reflection(
      id: json['id'],
      title: json['title'] as String?,
      url: json['url'] as String?,
      countCards: json['countCards'] ?? 0,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'countCards': countCards,
      'status': status,
    };
  }
}