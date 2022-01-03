import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';
import 'package:menu/screens/eventDetails.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';
import 'package:menu/models/user.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final bool attending;
  final FirestoreDb _db = FirestoreDb.instance;

  EventTile({Key? key, required this.event, this.attending = false})
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
          title: Text('Three-line ListTile'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.confirmedDatetime.toString()),
              const Text("<Location>")
            ],
          ),
          trailing: attending
              ? null
              : IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    _db.rsvpEvent(
                        event, Provider.of<User>(context, listen: false).uid);
                  },
                ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
