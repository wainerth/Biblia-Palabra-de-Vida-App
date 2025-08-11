class CourseDetail {
  final String id;
  final String titleCourse;
  final String color;
  final String introduction;
  final String titleDescription;
  final String imgCourseUrl;
  final String titleImgId;
  final String titleImgUrl;
  final String titleName;

  CourseDetail({
    required this.id,
    required this.titleCourse,
    required this.color,
    required this.imgCourseUrl,
    required this.introduction,
    required this.titleDescription,
    required this.titleImgId,
    required this.titleImgUrl,
    required this.titleName,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'] as String,
      titleCourse: json['titleCourse'] as String,
      color: json['color'] as String,
      imgCourseUrl: json['imgCourseUrl'],
      introduction: json['introduction'],
      titleDescription: json['titleDescription'] ?? '',
      titleImgId: json['titleImgId'] ?? '',
      titleImgUrl: json['titleImgUrl'] ?? '',
      titleName: json['titleName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titleCourse'] = titleCourse;
    data['color'] = color;
    data['imgCourseUrl'] = imgCourseUrl;
    data['introduction'] = introduction;
    data['titleDescription'] = titleDescription;
    data['titleImgId'] = titleImgId;
    data['titleImgUrl'] = titleImgUrl;
    data['titleName'] = titleName;
    return data;
  }
}
