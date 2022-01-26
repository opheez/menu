import 'package:flutter/material.dart';
import 'package:menu/services/auth.dart';

class Profile extends StatefulWidget {

  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () async {
          _auth.signOut();
        }, child: const Text("Logout"))
      ],
    );
  }
}
