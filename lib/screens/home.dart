import 'package:flutter/material.dart';
import 'package:menu/components/eventForm.dart';
import 'package:menu/components/eventTile.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/user.dart';
import 'package:menu/screens/community.dart';
import 'package:menu/services/auth.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

import 'events.dart';

class Home extends StatefulWidget {
  Function setUser;

  Home({Key? key, required this.setUser}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService.instance;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Community(),
    Events(),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("menu"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
        // ListView(
        //   children: <Widget>[
        //     ElevatedButton(
        //         onPressed: () {
        //           showDialog(
        //               context: context,
        //               builder: (BuildContext dialogContext) {
        //                 return EventForm(buildContext: context);
        //               });
        //         },
        //         child: const Text("Create a new event")),
        //     ...eventWidgets
        //   ],
        // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _auth.signOut(() {
            widget.setUser(null);
          });
        },
        tooltip: 'Log out',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
