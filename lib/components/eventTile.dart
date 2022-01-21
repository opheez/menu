import 'package:flutter/material.dart';
import 'package:menu/components/requestForm.dart';
import 'package:menu/models/event.dart';
import 'package:menu/screens/eventDetails.dart';
import 'package:menu/services/database.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final bool attending;

  const EventTile({Key? key, required this.event, this.attending = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (buildContext) => EventDetails(
                        context: context,
                        event: event,
                        attending: attending,
                      )));
        },
        child: ListTile(
          leading: FlutterLogo(size: 72.0),
          title: Text(event.confirmedDatetime.toString() + " at <LOCATION>"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hosted by: " + event.hostId),
              Text(event.details),
            ],
          ),
          trailing: attending
              ? null
              : IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return RequestForm(buildContext: context, event: event);
                        });
                  },
                ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
