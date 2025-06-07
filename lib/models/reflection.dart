class Reflection {
  final String? id;
  final String? title;
  final String? url;
  final String? visibility;
  final String? statusContent;
  final int? status;

  Reflection({
    this.id,
    this.title,
    this.url,
    this.visibility,
    this.statusContent,
    this.status,
  });

  factory Reflection.fromJson(Map<String, dynamic> json) {
    return Reflection(
      id: json['id'],
      title: json['title'] as String?,
      url: json['url'] as String?,
      visibility: json['visibility'] ??'',
      statusContent: json['statusContent'] ??'',
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'visibility': visibility,
      'statusContent': statusContent,
      'status': status,
    };
  }
}
