import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/text_input_field.dart';
import '../services/firebase_service.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

/// Pantalla de Inicio de Sesión
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controlador para el RFC
  final rfcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Inicio de Sesión'),
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
              
              // TÍTULO "Iniciar sesión" en color vino
              const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 13, 13),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // CAMPO RFC
              TextInputField(
                controller: rfcController,
                label: 'RFC',
                hintText: 'Ingresa tu RFC',
                prefixIcon: Icons.assignment,
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
                    if (rfcController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa tu RFC')),
                      );
                      return;
                    }
                    // Guardar el RFC en el servicio Firebase
                    FirebaseService().setCurrentUserRfc(rfcController.text);
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
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
              
              // LINK A REGISTRO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta? '),
                  GestureDetector(
                    onTap: () {
                      // Navegar a registro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Registrarme',
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
    rfcController.dispose();
    super.dispose();
  }
}

