class ModelData {
  final bool showLabel;
  final String label;
  final String value;
  final String clave;

  ModelData({
    required this.label,
    required this.value,
    this.showLabel = true,
    this.clave = '',
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ModelData && other.value == value; // Compara por el ID
  }

  factory ModelData.fromJson(Map<String, dynamic> json) {
    return ModelData(label: json['label'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {"label": label, "value": value};
  }

  @override
  int get hashCode => value.hashCode;
}
