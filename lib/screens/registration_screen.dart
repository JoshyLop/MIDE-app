import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/text_input_field.dart';
import '../services/firebase_service.dart';
import '../models/patient.dart';
import 'login_screen.dart';

/// Pantalla de Registro de Usuario
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controladores para manejar los inputs del usuario
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final rfcController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Registro'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LOGO - Espacio para imagen
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Logo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // TÍTULO "Registro" en color vino
              const Text(
                'Registro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 13, 13),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // CAMPO NOMBRE
              TextInputField(
                controller: nameController,
                label: 'Nombre',
                hintText: 'Ingresa tu nombre',
                prefixIcon: Icons.person,
              ),
              
              // CAMPO APELLIDOS
              TextInputField(
                controller: lastNameController,
                label: 'Apellidos',
                hintText: 'Ingresa tus apellidos',
                prefixIcon: Icons.person_outline,
              ),
              
              // CAMPO RFC
              TextInputField(
                controller: rfcController,
                label: 'RFC',
                hintText: 'Ingresa tu RFC',
                prefixIcon: Icons.assignment,
              ),
              
              // CAMPO TELÉFONO
              TextInputField(
                controller: phoneController,
                label: 'Teléfono',
                hintText: 'Ingresa tu teléfono',
                prefixIcon: Icons.phone,
              ),
              
              const SizedBox(height: 24),
              
              // BOTÓN INICIAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 110, 13, 13),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    // Validar campos obligatorios
                    if (nameController.text.isEmpty ||
                        lastNameController.text.isEmpty ||
                        rfcController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor completa todos los campos'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    try {
                      final rfc = rfcController.text.trim();
                      
                      // Buscar si el paciente ya existe en BD
                      final pacienteExistente = await FirebaseService().getPatient(rfc);
                      
                      if (pacienteExistente != null) {
                        // Paciente EXISTE → Mostrar modal de confirmación
                        _showPatientFoundModal(context, pacienteExistente);
                      } else {
                        // Paciente NO existe → Crear nuevo registro con origen "app"
                        await _registrarPacienteNuevo(context, rfc);
                      }
                    } catch (e) {
                      print('❌ [App] Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // LINK A INICIO DE SESIÓN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta? '),
                  GestureDetector(
                    onTap: () {
                      // Navegar a login
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Color.fromARGB(255, 110, 13, 13),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
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
    nameController.dispose();
    lastNameController.dispose();
    rfcController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  /// Modal cuando el paciente YA existe (registrado por enfermera)
  void _showPatientFoundModal(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paciente Encontrado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Se encontró tu registro en el sistema:'),
            const SizedBox(height: 16),
            Text('Nombre: ${patient.nombre} ${patient.apellido}'),
            const SizedBox(height: 8),
            Text('RFC: ${patient.rfc}'),
            const SizedBox(height: 8),
            Text('Teléfono: ${patient.telefono}'),
            const SizedBox(height: 16),
            const Text(
              '¿Es correcto?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 110, 13, 13),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Ir a LoginScreen con el RFC confirmado
              FirebaseService().setCurrentUserRfc(patient.rfc);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Registrar nuevo paciente (SI NO existe en BD)
  Future<void> _registrarPacienteNuevo(BuildContext context, String rfc) async {
    print('📤 [App] Registrando nuevo paciente desde app...');
    
    await FirebaseService().savePatient(
      rfc: rfc,
      nombre: nameController.text.trim(),
      apellido: lastNameController.text.trim(),
      correo: '',
      telefono: phoneController.text.trim(),
      tipoPatiente: '',
      origen: 'app', // Indica que fue registrado desde la app
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro enviado correctamente'),
        duration: Duration(seconds: 2),
      ),
    );

    // Limpiar y volver a LoginScreen
    nameController.clear();
    lastNameController.clear();
    rfcController.clear();
    phoneController.clear();
    
    if (mounted) {
      FirebaseService().setCurrentUserRfc(rfc);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
