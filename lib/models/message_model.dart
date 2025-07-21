class Message {
  final String? id;
  final String? resultTitle;
  final String? resultDescription;
  final String? category;
  final String? difficulty;
  Message(
      {this.id,
      required this.resultTitle,
      required this.resultDescription,
      this.category,
      this.difficulty});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      resultTitle: json['resultTitle'],
      resultDescription: json['resultDescription'],
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "resultTitle": resultTitle,
      "resultDescription": resultDescription,
      "category": category,
      "difficulty": difficulty
    };
  }
}
