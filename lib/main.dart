import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:menu/screens/home.dart';
import 'package:menu/screens/login.dart';
import 'package:menu/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user = null;

  setUser(user){
    setState(() {
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {

    return user != null
        ? MyHomePage(setUser: setUser)
        : Login(setUser: setUser);
  }
}
