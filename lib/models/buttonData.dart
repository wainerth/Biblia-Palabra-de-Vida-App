class ButtonData {
  final String id;
  final String name;
  final String urlAudio;
  final String imageUrl; // Puedes agregar una URL para una imagen si la necesitas

  ButtonData({
    required this.id,
    required this.name,
    required this.urlAudio,
    this.imageUrl = '', // Valor por defecto si no hay imagen
  });
}