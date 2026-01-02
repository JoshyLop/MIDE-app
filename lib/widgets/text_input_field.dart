import 'package:flutter/material.dart';

/// Widget reutilizable para campos de entrada de texto
/// Se puede usar en Login, Registro, Perfil, etc.
class TextInputField extends StatelessWidget {
  // Variable que guarda lo que el usuario escribe
  final TextEditingController controller;
  
  // El texto que aparece encima del campo (ej: "Email")
  final String label;
  
  // El texto que aparece dentro del campo cuando está vacío (ej: "Ingresa tu email")
  final String hintText;
  
  // El ícono que aparece en la izquierda del campo
  final IconData prefixIcon;
  
  // Para campos de contraseña, oculta el texto
  final bool obscureText;
  
  // Función que se ejecuta cuando el usuario escribe algo
  final Function(String)? onChanged;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retorna una columna con el label y el TextField
    return Column(
      // Alinea los elementos al inicio (izquierda)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TEXTO DEL LABEL (ej: "Email")
        Text(
          label,
          // Estilo del texto
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        
        // Espacio vertical entre el label y el campo
        const SizedBox(height: 8),
        
        // CAMPO DE TEXTO
        TextField(
          // El controlador que maneja lo que el usuario escribe
          controller: controller,
          
          // Oculta el texto si es contraseña
          obscureText: obscureText,
          
          // Se ejecuta cada vez que el usuario escribe
          onChanged: onChanged,
          
          // DISEÑO DEL CAMPO
          decoration: InputDecoration(
            // Ícono a la izquierda
            prefixIcon: Icon(
              prefixIcon,
              color: const Color.fromARGB(255, 110, 13, 13), // Color vino
            ),
            
            // Texto que aparece cuando el campo está vacío
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            
            // Borde cuando el campo NO está enfocado
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            
            // Borde cuando el campo ESTÁ enfocado (usuario está escribiendo)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 110, 13, 13), // Color vino
                width: 2,
              ),
            ),
            
            // Relleno de fondo del campo
            filled: true,
            fillColor: Colors.grey[100],
            
            // Espaciado interno del texto
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        
        // Espacio vertical después del campo
        const SizedBox(height: 16),
      ],
    );
  }
}
