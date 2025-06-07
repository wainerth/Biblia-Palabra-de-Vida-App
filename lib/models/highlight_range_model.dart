class HighlightRangeModel {
  final String verseId;
  final int start;
  final int end;
  final String? color;

  HighlightRangeModel({
    required this.verseId,
    required this.start,
    required this.end,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'verseId': verseId,
        'start': start,
        'end': end,
        'color': color,
      };

  factory HighlightRangeModel.fromJson(Map<String, dynamic> json) => HighlightRangeModel(
        verseId: json['verseId'],
        start: json['start'],
        end: json['end'],
        color: json['color'] ?? null,
      );
}
