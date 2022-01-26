import 'package:flutter/material.dart';
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
  late List<Event> pastEventList;
  late List<Event> reqEventList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getEventLists();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getEventLists();
    }
  }

  void getEventLists() async{
    List<Event> eventList = await _db.getUserEvents("1", Provider.of<User>(context, listen: false).uid);
    List<Event> reqEventList = await _db.getReqUserEvents("1", Provider.of<User>(context, listen: false).uid);

    setState(() {
      this.eventList =  eventList.where((element) => element.confirmedDatetime.isAfter(DateTime.now())).toList();
      pastEventList = eventList.where((element) => element.confirmedDatetime.isBefore(DateTime.now())).toList();
      this.reqEventList = reqEventList;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const CircularProgressIndicator();

    List<Widget> eventWidgets = List.generate(
        eventList.length, (index) => EventTile(event: eventList[index], attending: true,));
    List<Widget> pastEventWidgets = List.generate(
        pastEventList.length, (index) => EventTile(event: pastEventList[index], attending: true,));
    List<Widget> reqEventWidgets = List.generate(
        reqEventList.length, (index) => EventTile(event: reqEventList[index], attending: true,));

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: eventWidgets,
          ),
        ),
        const Text("Requested Events"),
        SizedBox(
          height: 150,
          child: ListView(
            children: reqEventWidgets,
          ),
        ),
        const Text("Past Events"),
        SizedBox(
          height: 150,
          child: ListView(
            children: pastEventWidgets,
          ),
        )
      ],
    );
  }
}
