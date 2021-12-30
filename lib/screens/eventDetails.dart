import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';

class EventDetails extends StatefulWidget {
  final Event event;

  const EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Title')),
      body: Center(
        child: Column(
          children: [
            Text("Host: ${widget.event.hostId}"),
            Text("Confirmed attendees: ${widget.event.confirmedPeople}"),
            Text("Private: ${widget.event.private.toString()}"),
            Text("When: ${widget.event.confirmedDatetime.toString()}"),
            Text("Duration: ${widget.event.durationMin}"),
            Text("Max people: ${widget.event.maxPeople}"),
          ],
        ),
      ),
    );
  }
}
