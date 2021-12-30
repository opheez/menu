import 'package:flutter/material.dart';
import 'package:menu/components/eventForm.dart';
import 'package:menu/components/eventTile.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/user.dart';
import 'package:menu/screens/community.dart';
import 'package:menu/screens/profile.dart';
import 'package:menu/services/auth.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

import 'events.dart';

class Home extends StatefulWidget {
  Function setUser;
  final List<Widget> widgetOptions;

  Home({Key? key, required this.setUser}) :  widgetOptions = [
  Community(),
  Events(),
  Profile(setUser: setUser),
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
