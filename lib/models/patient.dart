/// Modelo para representar un Paciente
class Patient {
  final String rfc;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String tipoPatiente; // "regular" o "no_regular"
  final DateTime? fechaNacimiento; // Opcional
  final String? direccion; // Opcional

  Patient({
    required this.rfc,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    required this.tipoPatiente,
    this.fechaNacimiento,
    this.direccion,
  });

  /// Convierte el modelo a JSON para enviar a Firestore
  Map<String, dynamic> toJson() {
    return {
      'rfc': rfc,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'telefono': telefono,
      'tipoPatiente': tipoPatiente,
      'fechaNacimiento': fechaNacimiento,
      'direccion': direccion,
    };
  }

  /// Crea un Patient desde los datos de Firestore
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      rfc: json['rfc'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      correo: json['correo'] as String,
      telefono: json['telefono'] as String,
      tipoPatiente: json['tipoPatiente'] as String? ?? 'regular',
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'] as String)
          : null,
      direccion: json['direccion'] as String?,
    );
  }
}
