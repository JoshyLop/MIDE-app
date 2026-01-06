import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/measurement.dart';
import '../models/monthly_goal.dart';

/// Servicio para interactuar con Firebase Firestore
/// Maneja todas las operaciones de guardado y lectura de datos
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// RFC del usuario actual (se establece al iniciar sesión)
  String? _currentUserRfc;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  /// Establece el RFC del usuario actual (llamar después del login)
  void setCurrentUserRfc(String rfc) {
    _currentUserRfc = rfc;
  }

  /// Obtiene el RFC del usuario actual
  String? getCurrentUserRfc() {
    return _currentUserRfc;
  }

  /// MEDICIONES - Guardar una nueva medición
  Future<void> saveMeasurement({
    required double glucose,
    required String mealTime,
  }) async {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    try {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final monthStr = '${now.year}-${now.month.toString().padLeft(2, '0')}';

      // Determinar si es normal (70-130 mg/dL) o alto
      final isNormal = glucose >= 70 && glucose <= 130;

      final measurement = Measurement(
        id: _firestore.collection('users').doc().id,
        rfc: _currentUserRfc!,
        glucose: glucose,
        mealTime: mealTime,
        timestamp: now,
        date: dateStr,
        month: monthStr,
        isNormal: isNormal,
      );

      // Guardar en Firestore: users/{rfc}/measurements/{medicionId}
      await _firestore
          .collection('users')
          .doc(_currentUserRfc)
          .collection('measurements')
          .doc(measurement.id)
          .set(measurement.toJson());
    } catch (e) {
      throw Exception('Error al guardar medición: $e');
    }
  }

  /// MEDICIONES - Obtener todas las mediciones del usuario
  Future<List<Measurement>> getAllMeasurements() async {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_currentUserRfc)
          .collection('measurements')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Measurement.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mediciones: $e');
    }
  }

  /// MEDICIONES - Obtener mediciones del mes actual
  Future<List<Measurement>> getMeasurementsForMonth(String month) async {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_currentUserRfc)
          .collection('measurements')
          .where('month', isEqualTo: month)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Measurement.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mediciones del mes: $e');
    }
  }

  /// MEDICIONES - Stream de mediciones (para actualizaciones en tiempo real)
  Stream<List<Measurement>> getMeasurementsStream() {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    return _firestore
        .collection('users')
        .doc(_currentUserRfc)
        .collection('measurements')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Measurement.fromJson(doc.data()))
            .toList());
  }

  /// METAS - Guardar o actualizar las metas del mes
  Future<void> saveMonthlyGoal({
    required String month,
    required double measurementsInRangePercent,
    required double lowLevelsPercent,
    required double hba1cPercent,
  }) async {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    try {
      final now = DateTime.now();
      final monthlyGoal = MonthlyGoal(
        id: '${_currentUserRfc}_$month',
        rfc: _currentUserRfc!,
        month: month,
        measurementsInRangePercent: measurementsInRangePercent,
        lowLevelsPercent: lowLevelsPercent,
        hba1cPercent: hba1cPercent,
        createdAt: now,
        updatedAt: now,
      );

      // Guardar en Firestore: users/{rfc}/monthlyGoals/{month}
      await _firestore
          .collection('users')
          .doc(_currentUserRfc)
          .collection('monthlyGoals')
          .doc(month)
          .set(monthlyGoal.toJson());
    } catch (e) {
      throw Exception('Error al guardar meta mensual: $e');
    }
  }

  /// METAS - Obtener la meta del mes
  Future<MonthlyGoal?> getMonthlyGoal(String month) async {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_currentUserRfc)
          .collection('monthlyGoals')
          .doc(month)
          .get();

      if (doc.exists) {
        return MonthlyGoal.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener meta mensual: $e');
    }
  }

  /// METAS - Stream de metas mensuales
  Stream<List<MonthlyGoal>> getMonthlyGoalsStream() {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    return _firestore
        .collection('users')
        .doc(_currentUserRfc)
        .collection('monthlyGoals')
        .orderBy('month', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MonthlyGoal.fromJson(doc.data()))
            .toList());
  }

  /// ESTADÍSTICAS - Calcular estadísticas del mes actual
  Future<Map<String, dynamic>> getMonthlyStats(String month) async {
    final measurements = await getMeasurementsForMonth(month);

    if (measurements.isEmpty) {
      return {
        'total': 0,
        'normal': 0,
        'high': 0,
        'normalPercent': 0.0,
        'highPercent': 0.0,
      };
    }

    final normalCount = measurements.where((m) => m.isNormal).length;
    final highCount = measurements.where((m) => !m.isNormal).length;

    return {
      'total': measurements.length,
      'normal': normalCount,
      'high': highCount,
      'normalPercent': (normalCount / measurements.length * 100).toStringAsFixed(1),
      'highPercent': (highCount / measurements.length * 100).toStringAsFixed(1),
    };
  }
}
