import 'package:flutter/material.dart';
import 'package:menu/components/requestTile.dart';
import 'package:menu/models/event.dart';
import 'package:menu/screens/chat.dart';
import 'package:menu/services/database.dart';

class EventDetails extends StatefulWidget {
  final BuildContext context;
  final Event event;
  final bool attending;

  const EventDetails(
      {Key? key,
      required this.context,
      required this.event,
      this.attending = false})
      : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final FirestoreDb _db = FirestoreDb.instance;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<Event>(
      stream: _db.getEventStream(widget.event.eid),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        Event event = snapshot.data!;
        List<Widget> requestWidgets = List.generate(
          event.joinRequests.length, (index) => RequestTile(event: widget.event, request: event.joinRequests[index]));

        return Scaffold(
          appBar: AppBar(title: Text('Event Title')),
          body: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // hei: MainAxisSize.max,
                    children: [
                      Text("Host: ${event.hostId}"),
                      Text(
                          "Confirmed attendees: ${event.confirmedPeople}"),
                      Text("Private: ${event.private.toString()}"),
                      Text("When: ${event.confirmedDatetime.toString()}"),
                      Text("Duration: ${event.durationMin}"),
                      Text("Max people: ${event.maxPeople}"),
                      Text("Event Details: ${event.details}"),
                      const Text("Join Requests:"),
                      ...requestWidgets
                    ],
                  ),
                ),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: widget.attending ? Chat(widget.context, event: event) : null),
              ],
            ),
          ),
        );
      }
    );
  }
}
