// bible_cache.dart
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:flutter/foundation.dart';

class BibleCache {
  static final BibleCache _instance = BibleCache._internal();
  factory BibleCache() => _instance;
  BibleCache._internal();

  // Cache principal
  final Map<String, Map<String, Map<int, ChapterModel>>> _chapterCache = {};
  final Map<String, List<BookModel>> _booksCache = {};
  final Map<String, List<HighlightRangeModel>> _highlightsCache = {};
  final Map<String, List<FavoriteVerse>> _favoritesCache = {};
  final Map<String, Video> _videoCache = {};

  // Métodos para chapters
  void cacheChapter(String versionId, String bookId, int chapter, ChapterModel chapterData) {
    _chapterCache.putIfAbsent(versionId, () => {});
    _chapterCache[versionId]!.putIfAbsent(bookId, () => {});
    _chapterCache[versionId]![bookId]![chapter] = chapterData;
  }

  ChapterModel? getCachedChapter(String versionId, String bookId, int chapter) {
    return _chapterCache[versionId]?[bookId]?[chapter];
  }

  bool hasCachedChapter(String versionId, String bookId, int chapter) {
    return _chapterCache.containsKey(versionId) &&
        _chapterCache[versionId]!.containsKey(bookId) &&
        _chapterCache[versionId]![bookId]!.containsKey(chapter);
  }

  // Métodos para books
  void cacheBooks(String versionId, List<BookModel> books) {
    _booksCache[versionId] = books;
  }

  List<BookModel>? getCachedBooks(String versionId) {
    return _booksCache[versionId];
  }

  // Métodos para highlights
  void cacheHighlights(String cacheKey, List<HighlightRangeModel> highlights) {
    _highlightsCache[cacheKey] = highlights;
  }

  List<HighlightRangeModel>? getCachedHighlights(String cacheKey) {
    return _highlightsCache[cacheKey];
  }

  String getHighlightCacheKey(String userId, String versionId, String chapterId) {
    return 'hl-$userId-$versionId-$chapterId';
  }

  // Métodos para videos
  void cacheVideo(String chapterId, Video video) {
    _videoCache[chapterId] = video;
  }

  Video? getCachedVideo(String chapterId) {
    return _videoCache[chapterId];
  }

  // Métodos para favorites
  void cacheFavorites(String cacheKey, List<FavoriteVerse> favorites) {
    _favoritesCache[cacheKey] = favorites;
  }

  List<FavoriteVerse>? getCachedFavorites(String cacheKey) {
    return _favoritesCache[cacheKey];
  }

  String getFavoriteCacheKey(String userId, String versionId) {
    return 'fav-$userId-$versionId';
  }

  // Limpiar caché
  void clearAllCache() {
    _chapterCache.clear();
    _booksCache.clear();
    _highlightsCache.clear();
    _favoritesCache.clear();
    _videoCache.clear();
  }
}