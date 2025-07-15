class HighlightRangeModel {
  final String id;
  final int verse;
  final int startIndex;
  final int endIndex;
  final String? color;

  HighlightRangeModel({
    required this.id,
    required this.verse,
    required this.startIndex,
    required this.endIndex,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'verse': verse,
        'startIndex': startIndex,
        'endIndex': endIndex,
        'color': color,
      };

  factory HighlightRangeModel.fromJson(Map<String, dynamic> json) => HighlightRangeModel(
        id: json['id'],
        verse: json['verse'],
        startIndex: json['startIndex'],
        endIndex: json['endIndex'],
        color: json['color'],
      );
}
