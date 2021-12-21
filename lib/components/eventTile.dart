import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: FlutterLogo(size: 72.0),
          title: Text('Three-line ListTile'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  event.confirmedDatetime.toString()
              ),
              const Text("<Location>")
            ],
          ),
          isThreeLine: true,
        ),);
  }
}
