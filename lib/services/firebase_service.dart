import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/measurement.dart';
import '../models/monthly_goal.dart';
import '../models/patient.dart';

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
    print('🔐 [Firebase] RFC configurado: $rfc');
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
      
      // Determinar tipo: 0 = "Antes de comer", 1 = "Después de comer"
      final tipo = mealTime.toLowerCase().contains('antes') ? 0 : 1;
      
      // Determinar si es normal (70-130 mg/dL) o alto
      final isNormal = glucose >= 70 && glucose <= 130;

      // Guardar en Firestore: Medicion_Glucosa/{idAleatorio}
      final docRef = _firestore.collection('Medicion_Glucosa').doc();
      
      await docRef.set({
        'curp': _currentUserRfc, // RFC del usuario
        'fecha_hora': now,
        'tipo': tipo, // 0 = antes, 1 = después
        'valor_glucosa': glucose,
        'isNormal': isNormal, // Campo adicional para facilitar consultas
        'mealTimeLabel': mealTime, // Label para mostrar en UI
      });
      
      print('✅ [Firebase] Medición guardada exitosamente');
      print('   CURP: $_currentUserRfc');
      print('   Glucosa: $glucose mg/dL');
      print('   Tipo: ${tipo == 0 ? 'Antes de comer' : 'Después de comer'}');
      print('   ID Documento: ${docRef.id}');
      print('   Timestamp: $now');
    } catch (e) {
      print('❌ [Firebase] Error al guardar: $e');
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
          .collection('Medicion_Glucosa')
          .where('curp', isEqualTo: _currentUserRfc)
          .orderBy('fecha_hora', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Measurement(
          id: doc.id,
          rfc: data['curp'] as String,
          glucose: (data['valor_glucosa'] as num).toDouble(),
          mealTime: data['mealTimeLabel'] as String? ?? 'Desconocido',
          timestamp: (data['fecha_hora'] as Timestamp).toDate(),
          date: (data['fecha_hora'] as Timestamp).toDate().toString().split(' ')[0],
          month: _getMonthFromTimestamp(data['fecha_hora'] as Timestamp),
          isNormal: data['isNormal'] as bool? ?? false,
        );
      }).toList();
    } catch (e) {
      print('❌ [Firebase] Error al obtener mediciones: $e');
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
          .collection('Medicion_Glucosa')
          .where('curp', isEqualTo: _currentUserRfc)
          .orderBy('fecha_hora', descending: true)
          .get();

      // Filtrar por mes en memoria
      final measurements = snapshot.docs.map((doc) {
        final data = doc.data();
        return Measurement(
          id: doc.id,
          rfc: data['curp'] as String,
          glucose: (data['valor_glucosa'] as num).toDouble(),
          mealTime: data['mealTimeLabel'] as String? ?? 'Desconocido',
          timestamp: (data['fecha_hora'] as Timestamp).toDate(),
          date: (data['fecha_hora'] as Timestamp).toDate().toString().split(' ')[0],
          month: _getMonthFromTimestamp(data['fecha_hora'] as Timestamp),
          isNormal: data['isNormal'] as bool? ?? false,
        );
      }).where((m) => m.month == month).toList();

      return measurements;
    } catch (e) {
      print('❌ [Firebase] Error al obtener mediciones del mes: $e');
      throw Exception('Error al obtener mediciones del mes: $e');
    }
  }

  /// MEDICIONES - Stream de mediciones (para actualizaciones en tiempo real)
  Stream<List<Measurement>> getMeasurementsStream() {
    if (_currentUserRfc == null) {
      throw Exception('RFC de usuario no configurado');
    }

    return _firestore
        .collection('Medicion_Glucosa')
        .where('curp', isEqualTo: _currentUserRfc)
        .orderBy('fecha_hora', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return Measurement(
            id: doc.id,
            rfc: data['curp'] as String,
            glucose: (data['valor_glucosa'] as num).toDouble(),
            mealTime: data['mealTimeLabel'] as String? ?? 'Desconocido',
            timestamp: (data['fecha_hora'] as Timestamp).toDate(),
            date: (data['fecha_hora'] as Timestamp).toDate().toString().split(' ')[0],
            month: _getMonthFromTimestamp(data['fecha_hora'] as Timestamp),
            isNormal: data['isNormal'] as bool? ?? false,
          );
        }).toList());
  }

  /// Helper para extraer mes de Timestamp
  String _getMonthFromTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
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

  /// METAS - Stream de metas mensuales (placeholder por ahora)
  Stream<List<MonthlyGoal>> getMonthlyGoalsStream() {
    // Por ahora retorna stream vacío, puede actualizarse después
    return Stream.value([]);
  }

  /// PACIENTES - Guardar un nuevo paciente
  Future<void> savePatient({
    required String rfc,
    required String nombre,
    required String apellido,
    required String correo,
    required String telefono,
    required String tipoPatiente,
    String origen = 'app', // Por defecto "app", puede ser "web"
    DateTime? fechaNacimiento,
    String? direccion,
  }) async {
    try {
      final patient = Patient(
        rfc: rfc,
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        telefono: telefono,
        tipoPatiente: tipoPatiente,
        origen: origen,
        fechaNacimiento: fechaNacimiento,
        direccion: direccion,
      );

      await _firestore.collection('Paciente').doc(rfc).set(patient.toJson());
      
      print('✅ [Firebase] Paciente guardado exitosamente');
      print('   RFC: $rfc');
      print('   Nombre: $nombre $apellido');
      print('   Origen: $origen');
      print('   Teléfono: $telefono');
    } catch (e) {
      print('❌ [Firebase] Error al guardar paciente: $e');
      throw Exception('Error al guardar paciente: $e');
    }
  }

  /// PACIENTES - Obtener datos de un paciente por RFC
  Future<Patient?> getPatient(String rfc) async {
    try {
      final doc = await _firestore.collection('Paciente').doc(rfc).get();
      
      if (doc.exists) {
        print('✅ [Firebase] Paciente encontrado: $rfc');
        return Patient.fromJson(doc.data()!);
      } else {
        print('⚠️ [Firebase] Paciente no encontrado: $rfc');
        return null;
      }
    } catch (e) {
      print('❌ [Firebase] Error al obtener paciente: $e');
      throw Exception('Error al obtener paciente: $e');
    }
  }

  /// PACIENTES - Stream de datos de un paciente (actualización en tiempo real)
  Stream<Patient?> getPatientStream(String rfc) {
    return _firestore
        .collection('Paciente')
        .doc(rfc)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return Patient.fromJson(doc.data()!);
      }
      return null;
    });
  }
}
