class Img {
  String urlImg;

  Img({required this.urlImg});

  factory Img.fromJson(Map<String, dynamic> json) {
    print("a");
    return Img(
      urlImg: json['urlImg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlImg': urlImg,
    };
  }
}

