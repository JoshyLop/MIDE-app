import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/text_input_field.dart';
import '../services/firebase_service.dart';

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
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Variable para el tipo de paciente
  String selectedPatientType = 'regular';

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
              
              // CAMPO CORREO
              TextInputField(
                controller: emailController,
                label: 'Correo Electrónico',
                hintText: 'Ingresa tu correo',
                prefixIcon: Icons.email,
              ),
              
              // CAMPO TELÉFONO
              TextInputField(
                controller: phoneController,
                label: 'Teléfono',
                hintText: 'Ingresa tu teléfono',
                prefixIcon: Icons.phone,
              ),
              
              const SizedBox(height: 16),
              
              // TIPO DE PACIENTE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de Paciente',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Regular'),
                            value: 'regular',
                            groupValue: selectedPatientType,
                            onChanged: (value) {
                              setState(() {
                                selectedPatientType = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('No Regular'),
                            value: 'no_regular',
                            groupValue: selectedPatientType,
                            onChanged: (value) {
                              setState(() {
                                selectedPatientType = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        emailController.text.isEmpty ||
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
                      print('📤 [App] Registrando nuevo paciente...');
                      
                      // Guardar paciente en Firebase
                      await FirebaseService().savePatient(
                        rfc: rfcController.text.trim(),
                        nombre: nameController.text.trim(),
                        apellido: lastNameController.text.trim(),
                        correo: emailController.text.trim(),
                        telefono: phoneController.text.trim(),
                        tipoPatiente: selectedPatientType,
                      );

                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paciente registrado correctamente'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Limpiar campos y volver al login
                      nameController.clear();
                      lastNameController.clear();
                      rfcController.clear();
                      emailController.clear();
                      phoneController.clear();
                      
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print('❌ [App] Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al registrar: $e'),
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
}
