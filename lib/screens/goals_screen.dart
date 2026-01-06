import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

/// Pantalla de Metas - Muestra los objetivos y progreso del usuario
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Mis Metas'),
      body: SingleChildScrollView(
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
                progress: 0.75, // 75%
              ),
              
              const SizedBox(height: 16),
              
              // META 2: EVITAR NIVELES MUY BAJOS
              _buildGoalCard(
                title: 'Evitar niveles muy bajos',
                icon: Icons.trending_down,
                description: 'Manten tus niveles de glucosa seguros, evitando que bajen demasiado',
                goal: 'Meta: Menos del 4%',
                progress: 0.15, // 15%
              ),
              
              const SizedBox(height: 16),
              
              // META 3: HEMOGLOBINA GLUCOSILADA
              _buildGoalCard(
                title: 'Hemoglobina glucosilada',
                icon: Icons.medical_services,
                description: 'Este valor muestra tu control de glucosa en los últimos 3 meses',
                goal: 'Meta: Menos del 7%',
                progress: 0.55, // 55%
                label: 'HbA1c',
              ),
            ],
          ),
        ),
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
