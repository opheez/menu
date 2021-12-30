import 'package:flutter/material.dart';
import 'package:menu/components/eventForm.dart';
import 'package:menu/components/eventTile.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/user.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with WidgetsBindingObserver {
  final FirestoreDb _db = FirestoreDb.instance;
  bool loading = true;
  late List<Event> eventList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _db.getUserEvents("1", Provider.of<User>(context, listen: false).uid).then((eventList) {
        setState(() {
          this.eventList = eventList;
          loading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      // load events
      _db.getUserEvents("1", Provider.of<User>(context, listen: false).uid).then((eventList) {
        setState(() {
          this.eventList = eventList;
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const CircularProgressIndicator();

    List<Widget> eventWidgets = List.generate(
        eventList.length, (index) => EventTile(event: eventList[index], attending: true,));

    return ListView(
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return EventForm(buildContext: context);
                  });
            },
            child: const Text("Create a new event")),
        ...eventWidgets
      ],
    );
  }
}
