import 'package:flutter/material.dart';
import 'package:menu/components/eventForm.dart';
import 'package:menu/components/eventTile.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/user.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> with WidgetsBindingObserver {
  final FirestoreDb _db = FirestoreDb.instance;
  bool loading = true;
  late List<Event> eventList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _db.getOpenEvents("1", Provider.of<User>(context, listen: false).uid).then((eventList) {
        print(eventList);
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
      _db.getOpenEvents("1", Provider.of<User>(context, listen: false).uid).then((eventList) {
        print(eventList);
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
        eventList.length, (index) => EventTile(event: eventList[index]));

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
