import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/screens/calendar_screen.dart';
import 'package:leafy_app_flutter/screens/plants_screen.dart';
import 'package:leafy_app_flutter/screens/profile_screen.dart';
import 'package:leafy_app_flutter/screens/search_screen.dart';

// Pantalla principal que contiene la navegación entre pestañas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex =
      0; // Índice actual de la pestaña seleccionada (0 = Buscar)

  // Lista de pantallas asociadas a cada pestaña
  final List<Widget> _screens = [
    SearchScreen(), // Índice 0: Buscar plantas
    ProfileScreen(), // Índice 1: Perfil del usuario
    CalendarPage(), // Índice 2: Calendario de cuidados
    PlantsScreen(), // Índice 3: Jardín del usuario
  ];

  // Cambia la pestaña activa cuando el usuario pulsa en una del BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Muestra la pantalla seleccionada
      // Barra de navegación inferior con iconos y etiquetas
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Pestaña seleccionada
        onTap: _onItemTapped, // Manejador al pulsar
        type:
            BottomNavigationBarType
                .fixed, // Estilo fijo (todas las pestañas visibles)
        selectedItemColor: Colors.green, // Color del icono activo
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendario",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: "Plantas",
          ),
        ],
      ),
    );
  }
}
