import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/text_input_field.dart';

/// Pantalla de Registro de Usuario
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

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
                  onPressed: () {
                    // Aquí irá la lógica de registro
                    print('Registrarse con:');
                    print('Nombre: ${nameController.text}');
                    print('Apellidos: ${lastNameController.text}');
                    print('RFC: ${rfcController.text}');
                    print('Teléfono: ${phoneController.text}');
                  },
                  child: const Text(
                    'Iniciar',
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
