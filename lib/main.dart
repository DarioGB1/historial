import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa firebase_core
import 'firebase_options.dart'; // Importa las opciones de Firebase generadas
import 'medication_form.dart'; // Importa tu formulario médico

void main() async {
  // Asegura que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones de la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecuta la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulario Médico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          const MedicationForm(), // Usa tu formulario médico como pantalla principal
    );
  }
}
