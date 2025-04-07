import 'package:flutter/material.dart';
import 'package:leafy_app_flutter/screens/calendar_screen.dart';
import 'package:leafy_app_flutter/screens/plants_screen.dart';
import 'package:leafy_app_flutter/screens/profile_screen.dart';
import 'package:leafy_app_flutter/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // <- Esto hace que arranque en SearchScreen

  final List<Widget> _screens = [
    SearchScreen(), // ✅ Esta es la pantalla principal (como TikTok)
    ProfileScreen(),
    CalendarPage(),
    PlantsScreen(),
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendario"),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: "Plantas"),
        ],
      ),
    );
  }
}
