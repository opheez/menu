import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/user.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  final BuildContext buildContext;
  final Event event;

  const RequestForm({Key? key, required this.buildContext, required this.event})
      : super(key: key);

  @override
  RequestFormState createState() {
    return RequestFormState();
  }
}

class RequestFormState extends State<RequestForm> {
  final FirestoreDb _db = FirestoreDb.instance;
  final detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<User>(widget.buildContext, listen: true).uid;

    return AlertDialog(
      title: const Text("RSVP to event"),
      content: Column(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              maxLines: 10,
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Event details'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Send"),
          onPressed: () async {
            await _db.rsvpEvent(widget.event, {
              'uid': Provider.of<User>(widget.buildContext, listen: false).uid,
              'details': detailsController.text
            });
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
