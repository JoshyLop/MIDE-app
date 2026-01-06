/// Modelo para representar una medición de glucosa
class Measurement {
  final String id;
  final String rfc;
  final double glucose;
  final String mealTime; // "Antes de comer" o "Después de comer"
  final DateTime timestamp;
  final String date; // Formato: "2026-01-06"
  final String month; // Formato: "2026-01"
  final bool isNormal; // true si es normal, false si es alto

  Measurement({
    required this.id,
    required this.rfc,
    required this.glucose,
    required this.mealTime,
    required this.timestamp,
    required this.date,
    required this.month,
    required this.isNormal,
  });

  /// Convierte el modelo a JSON para enviar a Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rfc': rfc,
      'glucose': glucose,
      'mealTime': mealTime,
      'timestamp': timestamp.toIso8601String(),
      'date': date,
      'month': month,
      'isNormal': isNormal,
    };
  }

  /// Crea un Measurement desde los datos de Firestore
  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as String,
      rfc: json['rfc'] as String,
      glucose: (json['glucose'] as num).toDouble(),
      mealTime: json['mealTime'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      date: json['date'] as String,
      month: json['month'] as String,
      isNormal: json['isNormal'] as bool,
    );
  }
}
