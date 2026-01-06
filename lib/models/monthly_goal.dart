/// Modelo para representar las metas mensuales del usuario
class MonthlyGoal {
  final String id;
  final String rfc;
  final String month; // Formato: "2026-01"
  final double measurementsInRangePercent; // % de mediciones en rango (70%+)
  final double lowLevelsPercent; // % de niveles bajos (<4%)
  final double hba1cPercent; // % HbA1c (<7%)
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyGoal({
    required this.id,
    required this.rfc,
    required this.month,
    required this.measurementsInRangePercent,
    required this.lowLevelsPercent,
    required this.hba1cPercent,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convierte el modelo a JSON para enviar a Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rfc': rfc,
      'month': month,
      'measurementsInRangePercent': measurementsInRangePercent,
      'lowLevelsPercent': lowLevelsPercent,
      'hba1cPercent': hba1cPercent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea un MonthlyGoal desde los datos de Firestore
  factory MonthlyGoal.fromJson(Map<String, dynamic> json) {
    return MonthlyGoal(
      id: json['id'] as String,
      rfc: json['rfc'] as String,
      month: json['month'] as String,
      measurementsInRangePercent: (json['measurementsInRangePercent'] as num).toDouble(),
      lowLevelsPercent: (json['lowLevelsPercent'] as num).toDouble(),
      hba1cPercent: (json['hba1cPercent'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
