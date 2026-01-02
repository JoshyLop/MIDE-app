import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

/// Pantalla principal con el contador
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {//Clase principal del estado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MIDE'),
      body: const Center(
        child: Text('Home Screen - Se rellenará después'),
      ),
    );
  }
}