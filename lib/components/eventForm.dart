import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu/models/user.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

class EventForm extends StatefulWidget {
  final BuildContext buildContext;

  const EventForm({Key? key, required this.buildContext}) : super(key: key);

  @override
  EventFormState createState() {
    return EventFormState();
  }
}

class EventFormState extends State<EventForm> {
  final FirestoreDb _db = FirestoreDb.instance;
  final durationController = TextEditingController();
  final maxPeopleController = TextEditingController();
  final confirmedStartController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<User>(widget.buildContext, listen: true).uid;

    return AlertDialog(
      title: const Text("Create event"),
      content: Column(
        children: <Widget>[
          TextFormField(
            controller: durationController,
            decoration: const InputDecoration(labelText: 'Duration (min)'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: maxPeopleController,
            decoration: const InputDecoration(labelText: 'Max attendees'),
            keyboardType: TextInputType.number,
          ),
          TextButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (_) => Container(
                          height: 500,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                height: 400,
                                child: CupertinoDatePicker(
                                  initialDateTime: DateTime.now()
                                      .add(const Duration(seconds: 1)),
                                  minimumDate: DateTime.now(),
                                  maximumDate: DateTime.now()
                                      .add(const Duration(days: 14)),
                                  onDateTimeChanged: (DateTime value) {
                                    confirmedStartController.text =
                                        value.toString();
                                  },
                                ),
                              ),
                              CupertinoButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ),
                        ));
              },
              child: TextFormField(
                readOnly: true,
                controller: confirmedStartController,
              )),
          TextFormField(
            controller: detailsController,
            decoration: const InputDecoration(labelText: 'Event details'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Create"),
          onPressed: () async {
            await _db.createEvent({
              'cid': '1',
              'hostId': uid,
              'durationMin': int.parse(durationController.text),
              'maxPeople': int.parse(maxPeopleController.text),
              'confirmedDatetime':
                  DateTime.parse(confirmedStartController.text),
              'confirmedPeople': [],
              'details': detailsController.text
            });

            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
