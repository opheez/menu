import 'package:flutter/material.dart';
import 'package:menu/components/eventForm.dart';
import 'package:menu/components/eventTile.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/user.dart';
import 'package:menu/services/auth.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  Function setUser;

  MyHomePage({Key? key, required this.setUser}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  final AuthService _auth = AuthService.instance;
  final FirestoreDb _db = FirestoreDb.instance;
  bool loading = true;
  late List<Event> eventList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _db.getOpenEvents("1", Provider.of<User>(context).uid).then((eventList) {
        print(eventList);
        setState(() {
          this.eventList = eventList;
          loading = false;
        });
      });

    });
  }

  @override
  void dispose(){
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      // load events
      _db.getOpenEvents("1", Provider.of<User>(context).uid).then((eventList) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text("menu"),
      ),
      body: Center(
        child: ListView(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _auth.signOut(() {
            widget.setUser(null);
          });
        },
        tooltip: 'Log out',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
