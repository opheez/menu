import 'package:flutter/material.dart';
import 'package:menu/services/auth.dart';

class Profile extends StatefulWidget {
  Function setUser;

  Profile({Key? key, required this.setUser}) : super(key: key);

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
          _auth.signOut(() {
            widget.setUser(null);
          });
        }, child: const Text("Logout"))
      ],
    );
  }
}
