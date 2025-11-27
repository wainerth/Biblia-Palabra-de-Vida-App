class ModelData<T> {
  final bool showLabel;
  final String label;
  final String value;
  final String clave;
  final T? originalData;

  ModelData({
    required this.label,
    required this.value,
    this.showLabel = true,
    this.clave = '',
    this.originalData,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ModelData<T> &&
        other.value == value &&
        other.originalData == originalData; // Compara por el ID
  }

  factory ModelData.fromJson(
    Map<String, dynamic> json, {
    T? originalData,
  }) {
    return ModelData(
      label: json['label'],
      value: json['value'],
      originalData: originalData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "value": value,
      "originalData":
          originalData != null ? _serializeOriginal(originalData) : null,
    };
  }

  // Helper para serializer el objeto original (implementa según tus necesidades)
  dynamic _serializeOriginal(T? data) {
    // ignore: unnecessary_type_check
    if (data is dynamic && data.toJson != null) {
      // Verifica en tiempo de ejecución
      return data.toJson();
    }
    return data.toString();
  }

  @override
  int get hashCode => value.hashCode ^ originalData.hashCode;
}
