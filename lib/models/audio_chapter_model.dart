
class AudioChapterModel {
  final String id;
  final String audioUrl;
  final int chapter;

  AudioChapterModel({
    required this.id,
    required this.audioUrl,
    required this.chapter,
  });

  @override
  String toString() {
    return 'AudioChapterModel(id: $id, audioUrl: $audioUrl, chapter: $chapter)';
  }

  factory AudioChapterModel.fromJson(Map<String, dynamic> json) {
    return AudioChapterModel(
        id: json['id'] ?? '',
        audioUrl: json['audioUrl'] ?? '',
        chapter: json['chapter'] ?? 0);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audioUrl': audioUrl,
      'chapter': chapter,
    };
  }
}
