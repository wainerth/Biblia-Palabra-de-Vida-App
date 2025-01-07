class CourseModel {
  final int? churchId;
  final String color;
  final String id;
  final String img;
  final int status;
  final String title;

  CourseModel({
    this.churchId,
    required this.color,
    required this.id,
    this.img = '',
    required this.status,
    required this.title,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      churchId: json['churchId'] as int?,
      color: json['color'] as String,
      id: json['id'] as String,
      img: json['img'] != null ?json['img'] : null,
      status: json['status'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['churchId'] = churchId;
    data['color'] = color;
    data['id'] = id;
    if (img != null) {
      data['img'] = img;
    }
    data['status'] = status;
    data['title'] = title;
    return data;
  }
}
