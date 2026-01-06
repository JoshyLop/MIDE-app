import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/firebase_service.dart';
import '../models/monthly_goal.dart';

/// Pantalla de Metas - Muestra los objetivos y progreso del usuario
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late Future<String> _monthFuture;

  @override
  void initState() {
    super.initState();
    _monthFuture = _getCurrentMonth();
  }

  /// Obtiene el mes actual en formato "YYYY-MM"
  Future<String> _getCurrentMonth() async {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Mis Metas'),
      body: FutureBuilder<String>(
        future: _monthFuture,
        builder: (context, monthSnapshot) {
          if (!monthSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentMonth = monthSnapshot.data!;

          return StreamBuilder<List<MonthlyGoal>>(
            stream: FirebaseService().getMonthlyGoalsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Obtener la meta del mes actual
              MonthlyGoal? currentMonthGoal;
              if (snapshot.hasData && snapshot.data != null) {
                try {
                  currentMonthGoal = snapshot.data!
                      .firstWhere((goal) => goal.month == currentMonth);
                } catch (e) {
                  // No hay meta para este mes
                  currentMonthGoal = null;
                }
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // CUADRO BEIGE INICIAL - "¡Trabajemos juntos!"
                      Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo/Icono
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.handshake, size: 36),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      '¡Trabajemos juntos!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      'Estas son tus metas para mantener tu salud en el mejor estado posible',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // META 1: MEDICIONES EN RANGO
              _buildGoalCard(
                title: 'Mediciones en rango',
                icon: Icons.trending_up,
                description: 'Manten tus niveles de glucosa dentro del rango saludable, la mayor parte del tiempo',
                goal: 'Meta: 70% o más',
                progress: (currentMonthGoal?.measurementsInRangePercent ?? 75) / 100,
              ),
              
              const SizedBox(height: 16),
              
              // META 2: EVITAR NIVELES MUY BAJOS
              _buildGoalCard(
                title: 'Evitar niveles muy bajos',
                icon: Icons.trending_down,
                description: 'Manten tus niveles de glucosa seguros, evitando que bajen demasiado',
                goal: 'Meta: Menos del 4%',
                progress: (currentMonthGoal?.lowLevelsPercent ?? 15) / 100,
              ),
              
              const SizedBox(height: 16),
              
              // META 3: HEMOGLOBINA GLUCOSILADA
              _buildGoalCard(
                title: 'Hemoglobina glucosilada',
                icon: Icons.medical_services,
                description: 'Este valor muestra tu control de glucosa en los últimos 3 meses',
                goal: 'Meta: Menos del 7%',
                progress: (currentMonthGoal?.hba1cPercent ?? 55) / 100,
                label: 'HbA1c',
              ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Widget reutilizable para cada meta
  Widget _buildGoalCard({
    required String title,
    required IconData icon,
    required String description,
    required String goal,
    required double progress,
    String? label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        children: [
          // ENCABEZADO CON ÍCONO Y TÍTULO
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, size: 28, color: const Color.fromARGB(255, 110, 13, 13)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // SEPARADOR
          const Divider(height: 1, color: Colors.black),
          
          // CONTENIDO: META Y PROGRESO
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recuadro beige con la meta
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber[200]!, width: 1),
                  ),
                  child: Text(
                    goal,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Tu progreso
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu progreso:',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Barra de progreso
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(
                          progress > 0.7 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Porcentaje en grande
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 110, 13, 13),
                          ),
                        ),
                        if (label != null)
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
