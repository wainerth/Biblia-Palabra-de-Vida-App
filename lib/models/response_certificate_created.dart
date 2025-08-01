class ResponseCertificateCreated {
  final bool success;
  final String rutaArchivo;
  final String nombreArchivo;
  final String mensaje;

  ResponseCertificateCreated(
      {required this.success,
      required this.rutaArchivo,
      required this.nombreArchivo,
      required this.mensaje});

  factory ResponseCertificateCreated.fromJson(Map<String, dynamic> json) {
    return ResponseCertificateCreated(
      success: json['success'],
      rutaArchivo: json['rutaArchivo'],
      nombreArchivo: json['nombreArchivo'],
      mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "rutaArchivo": rutaArchivo,
      "nombreArchivo": nombreArchivo,
      "mensaje": mensaje
    };
  }
}
