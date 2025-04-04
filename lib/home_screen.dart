import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/screens/calendar_screen.dart';
import 'package:leafy_app_flutter/screens/plants_screen.dart';
import 'package:leafy_app_flutter/screens/profile_screen.dart';
import 'package:leafy_app_flutter/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    SearchScreen(),  // Pantalla principal con buscador
    //ProfileScreen(), // Mi Perfil
    //CalendarScreen(), // Calendario
    //PlantsScreen(), // Plantas
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mi Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendario"),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: "Plantas"),
        ],
      ),
    );
  }
}
