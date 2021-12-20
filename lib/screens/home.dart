import 'package:flutter/material.dart';
import 'package:menu/services/auth.dart';

class MyHomePage extends StatefulWidget {
  Function setUser;

  MyHomePage({Key? key, required this.setUser}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("menu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _auth.signOut(() {widget.setUser(null);});
        },
        tooltip: 'Log out',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
