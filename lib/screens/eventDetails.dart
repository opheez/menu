import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';
import 'package:menu/screens/chat.dart';

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
        child: Stack(
          children: [
            Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  // hei: MainAxisSize.max,
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
            ),
            Positioned(
              // bottom: 0,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                  child: Chat(event: widget.event)),
            ),
          ],
        ),
      ),
    );
  }
}
