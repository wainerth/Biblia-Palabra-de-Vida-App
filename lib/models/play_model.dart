class PlayModel {
  final String title;
  final String description;
  final String img;
  final String url;
  PlayModel(
      {required this.title,
      required this.description,
      required this.img,
      required this.url});

  factory PlayModel.fromJson(Map<String, dynamic> json) {
    return PlayModel(
        title: json['title'],
        description: json['description'],
        img: json['img'],
        url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "img": img, "url": url};
  }
}
