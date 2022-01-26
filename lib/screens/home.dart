import 'package:flutter/material.dart';
import 'package:menu/screens/community.dart';
import 'package:menu/screens/profile.dart';

import 'events.dart';

class Home extends StatefulWidget {
  final List<Widget> widgetOptions;

  Home({Key? key}) :  widgetOptions = [
  Community(),
  Events(),
  Profile(),
  ], super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("menu"),
      ),
      body: Center(
        child: widget.widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available_outlined), label: 'Your events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }
}
