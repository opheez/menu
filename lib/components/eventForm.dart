import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu/services/database.dart';

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
  final _formKey = GlobalKey<FormState>();
  final confirmedStartController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return AlertDialog(
      title: Text("Create event"),
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // 'cid': cid,
            // 'hostId': hostId,
            // 'durationMin': durationMin,
            // 'maxPeople': maxPeople,
            // 'confirmedDatetime': confirmedDatetime,
            TextFormField(
              decoration: const InputDecoration(labelText: 'Duration (min)'),
              keyboardType: TextInputType.number,
              onSaved: (val) {
                print(val);
              },
            ),
            TextFormField(
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
                                    initialDateTime: DateTime.now().add(const Duration(seconds: 1)),
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
                ))
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Create"),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              _formKey.currentState!.save();
              await _db.createEvent({
                'cid': '1',
                'hostId': 'x',
                'durationMin': 60,
                'maxPeople': 3,
                'confirmedDatetime': DateTime.parse(confirmedStartController.text),
                'confirmedPeople': []
              });
            }
            Navigator.of(widget.buildContext).pop();
          },
        )
      ],
    );
  }
}
