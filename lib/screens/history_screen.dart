import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/firebase_service.dart';
import '../models/measurement.dart';

/// Pantalla de Historial - Muestra todas las mediciones
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Historial'),
      body: StreamBuilder<List<Measurement>>(
        stream: FirebaseService().getMeasurementsStream(),
        builder: (context, snapshot) {
          // Manejo de estados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final measurements = snapshot.data ?? [];

          // Calcular estadísticas
          int totalMeasurements = measurements.length;
          int normalMeasurements = measurements.where((m) => m.isNormal).length;
          int highMeasurements = measurements.where((m) => !m.isNormal).length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // CUADRO RESUMEN BEIGE - HORIZONTAL
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber[200]!, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Total de mediciones (izquierda)
                        Column(
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$totalMeasurements',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Mediciones normales (centro, verde)
                        Column(
                          children: [
                            const Text(
                              'Normales',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$normalMeasurements',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        // Mediciones altas (derecha, rojo)
                        Column(
                          children: [
                            const Text(
                              'Altas',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$highMeasurements',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // RECTÁNGULOS DE MEDICIONES
                  if (measurements.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No hay mediciones registradas',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: measurements.length,
                      itemBuilder: (context, index) {
                        final measurement = measurements[index];
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: measurement.isNormal ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: measurement.isNormal ? Colors.green : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${measurement.glucose.toStringAsFixed(0)} mg/dL',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    measurement.mealTime,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${measurement.timestamp.hour}:${measurement.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                measurement.isNormal ? 'Normal' : 'Alto',
                                style: TextStyle(
                                  color: measurement.isNormal ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
