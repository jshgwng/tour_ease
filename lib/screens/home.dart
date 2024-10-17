import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tour_ease/screens/accomodation.dart';
import 'package:tour_ease/screens/setting.dart';
import 'package:tour_ease/screens/tourist_site.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    TouristSitesScreen(),
    AccommodationsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location),
            activeIcon: Icon(CupertinoIcons.location_solid),
            label: 'Tourist Sites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bed_double),
            activeIcon: Icon(CupertinoIcons.bed_double_fill),
            label: 'Accommodation',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            activeIcon: Icon(CupertinoIcons.settings_solid),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF7043),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}