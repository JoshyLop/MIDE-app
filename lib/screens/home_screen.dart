import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/firebase_service.dart';
import 'history_screen.dart';
import 'goals_screen.dart';

/// Pantalla Principal - Registro de Glucosa
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controlador para el nivel de glucosa
  final glucoseController = TextEditingController();

  // Variable para guardar la opción seleccionada
  String? selectedMealTime;

  // Variables para guardar los datos antes de confirmar
  String? tempGlucose;
  String? tempMealTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MIDE'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ICONO/IMAGEN ARRIBA
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bloodtype,
                  color: Color.fromARGB(255, 110, 13, 13),
                  size: 50,
                ),
              ),

              const SizedBox(height: 48),

              // BOTONES: METAS y HISTORIAL
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 110, 13, 13),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GoalsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.flag, color: Colors.white),
                      label: const Text(
                        'Metas',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 110, 13, 13),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: const Text(
                        'Historial',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // RECUADRO BEIGE - REGISTRAR GLUCOSA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título "Registrar glucosa"
                    const Text(
                      'Registrar glucosa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtítulo "Nivel de glucosa"
                    const Text(
                      'Nivel de glucosa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Campo de entrada
                    TextField(
                      controller: glucoseController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ingresa el nivel',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Leyenda "mg/dL"
                    const Text(
                      'mg/dL',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    // "¿Cuándo mediste?"
                    const Text(
                      '¿Cuándo mediste?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botones: Antes/Después de comer
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedMealTime == 'Antes'
                                  ? const Color.fromARGB(255, 110, 13, 13)
                                  : Colors.grey[300],
                            ),
                            onPressed: () {
                              setState(() => selectedMealTime = 'Antes');
                            },
                            child: Text(
                              'Antes de comer',
                              style: TextStyle(
                                color: selectedMealTime == 'Antes'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedMealTime == 'Después'
                                  ? const Color.fromARGB(255, 110, 13, 13)
                                  : Colors.grey[300],
                            ),
                            onPressed: () {
                              setState(() => selectedMealTime = 'Después');
                            },
                            child: Text(
                              'Después de comer',
                              style: TextStyle(
                                color: selectedMealTime == 'Después'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Botón Guardar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            110,
                            13,
                            13,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          // Guardar temporalmente
                          tempGlucose = glucoseController.text;
                          tempMealTime = selectedMealTime;

                          // Mostrar modal de confirmación
                          _showConfirmationModal(context);
                        },
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modal de confirmación
  void _showConfirmationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono verde de palomita
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),

              const SizedBox(height: 16),

              // Título "Confirmar Medición"
              const Text(
                'Confirmar Medición',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // Recuadro beige con datos
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Glucosa: $tempGlucose mg/dL'),
                    const SizedBox(height: 8),
                    Text('Momento: $tempMealTime de comer'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        try {
                          print('📤 [App] Intentando guardar medición...');
                          // Guardar la medición en Firebase
                          await FirebaseService().saveMeasurement(
                            glucose: double.parse(tempGlucose ?? '0'),
                            mealTime: tempMealTime ?? 'Desconocido',
                          );

                          Navigator.pop(context);
                          // Mostrar confirmación
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Medición guardada correctamente'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          glucoseController.clear();
                          setState(() => selectedMealTime = null);
                        } catch (e) {
                          print('❌ [App] Error: $e');
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al guardar: $e'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Editar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    glucoseController.dispose();
    super.dispose();
  }
}
