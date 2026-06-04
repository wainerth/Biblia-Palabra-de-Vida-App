// lib/api_rest/models/book_format_model.dart
enum FormatType {
  physical,
  ebook,
  audiobook;
  
  String get displayName {
    switch (this) {
      case FormatType.physical:
        return 'Físico';
      case FormatType.ebook:
        return 'Libro Digital';
      case FormatType.audiobook:
        return 'Audiolibro';
    }
  }
  
  String get apiValue => name;
  
  static FormatType fromString(String value) {
    return FormatType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FormatType.physical,
    );
  }
}

class BookFormat {
  final int id;
  final int bookId;
  final FormatType formatType;
  final double price;
  final double? discountPrice;
  final bool isFree;
  final int stock;
  final int lowStockThreshold;
  final String? fileUrl;
  final double? fileSizeMb;
  final String? fileFormat;
  final String? narrator;
  final int? durationMinutes;
  final String? audioSampleUrl;
  final String? audioBitrate;
  final bool isDrmProtected;
  final String? previewUrl;
  final int samplePages;
  final int? weightGrams;
  final String? dimensions;
  final String? bindingType;
  final int? shippingDays;
  final bool isAvailable;
  final DateTime? availableFrom;
  final DateTime? availableUntil;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Campos calculados
  double get finalPrice {
    if (isFree) return 0;
    if (discountPrice != null && discountPrice! > 0) {
      return discountPrice!;
    }
    return price;
  }
  
  double get discountPercentage {
    if (discountPrice == null || discountPrice == 0) return 0;
    return ((price - discountPrice!) / price) * 100;
  }
  
  bool get hasDiscount => discountPrice != null && discountPrice! > 0 && discountPrice! < price;
  
  bool get isLowStock => stock <= lowStockThreshold && stock > 0;
  
  bool get isOutOfStock => stock == 0 && formatType == FormatType.physical;
  
  BookFormat({
    required this.id,
    required this.bookId,
    required this.formatType,
    required this.price,
    this.discountPrice,
    this.isFree = false,
    this.stock = 0,
    this.lowStockThreshold = 5,
    this.fileUrl,
    this.fileSizeMb,
    this.fileFormat,
    this.narrator,
    this.durationMinutes,
    this.audioSampleUrl,
    this.audioBitrate,
    this.isDrmProtected = false,
    this.previewUrl,
    this.samplePages = 10,
    this.weightGrams,
    this.dimensions,
    this.bindingType,
    this.shippingDays = 3,
    this.isAvailable = true,
    this.availableFrom,
    this.availableUntil,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory BookFormat.fromJson(Map<String, dynamic> json) {
    return BookFormat(
      id: json['id'],
      bookId: json['book_id'],
      formatType: FormatType.fromString(json['format_type']),
      price: json['price'] != null 
          ? double.tryParse(json['price'].toString()) ?? 0
          : 0,
      discountPrice: json['discount_price'] != null 
          ? double.tryParse(json['discount_price'].toString())
          : null,
      isFree: json['is_free'] ?? false,
      stock: json['stock'] ?? 0,
      lowStockThreshold: json['low_stock_threshold'] ?? 5,
      fileUrl: json['file_url'],
      fileSizeMb: json['file_size_mb'] != null 
          ? double.tryParse(json['file_size_mb'].toString())
          : null,
      fileFormat: json['file_format'],
      narrator: json['narrator'],
      durationMinutes: json['duration_minutes'],
      audioSampleUrl: json['audio_sample_url'],
      audioBitrate: json['audio_bitrate'],
      isDrmProtected: json['is_drm_protected'] ?? false,
      previewUrl: json['preview_url'],
      samplePages: json['sample_pages'] ?? 10,
      weightGrams: json['weight_grams'],
      dimensions: json['dimensions'],
      bindingType: json['binding_type'],
      shippingDays: json['shipping_days'] ?? 3,
      isAvailable: json['is_available'] ?? true,
      availableFrom: json['available_from'] != null 
          ? DateTime.tryParse(json['available_from']) 
          : null,
      availableUntil: json['available_until'] != null 
          ? DateTime.tryParse(json['available_until']) 
          : null,
      createdAt:  json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'format_type': formatType.apiValue,
      'price': price,
      'discount_price': discountPrice,
      'is_free': isFree,
      'stock': stock,
      'low_stock_threshold': lowStockThreshold,
      'file_url': fileUrl,
      'file_size_mb': fileSizeMb,
      'file_format': fileFormat,
      'narrator': narrator,
      'duration_minutes': durationMinutes,
      'audio_sample_url': audioSampleUrl,
      'audio_bitrate': audioBitrate,
      'is_drm_protected': isDrmProtected,
      'preview_url': previewUrl,
      'sample_pages': samplePages,
      'weight_grams': weightGrams,
      'dimensions': dimensions,
      'binding_type': bindingType,
      'shipping_days': shippingDays,
      'is_available': isAvailable,
      'available_from': availableFrom?.toIso8601String().split('T').first,
      'available_until': availableUntil?.toIso8601String().split('T').first,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}