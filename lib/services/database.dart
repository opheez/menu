import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/message.dart';
import 'package:menu/models/user.dart';

class FirestoreDb {
  // makes this a singleton class
  FirestoreDb._privateConstructor();

  static final FirestoreDb instance = FirestoreDb._privateConstructor();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // /// Retrieve user with UID from database
  // Future<User> getUser(String uid) async {
  //   CollectionReference users = firestore.collection('users');
  //   var dbUser = await users.doc(uid).get();
  //   return User(uid: uid, phoneNumber: dbUser.phoneNumber, );
  // }
  //
  // /// Sets user of given UID with the given traits, creates a new user if none
  // /// with the UID exists
  // void setUser(String uid, Map updateTraits) async {
  //   Map kwargs = {};
  //   for (String key in updateTraits.keys){
  //     if (User[key])
  //   }
  //
  //   firestore.collection('users').doc(uid).update(data)
  //
  // }

  Future<List<Event>> getAllEvents(String cid) async {
    var dbEvents =
        await firestore.collection('events').where('cid', isEqualTo: cid).get();

    return List.generate(dbEvents.docs.length, (i) {
      return Event.fromMap(dbEvents.docs[i].id, dbEvents.docs[i].data());
    });
  }

  Future<List<Event>> getOpenEvents(String cid, String uid) async {
    var dbEvents = await firestore
        .collection('events')
        .where('cid', isEqualTo: cid)
        .where('hostId', isNotEqualTo: uid)
        .get();

    // filter out events that the user is attending TODO: possibly change confirmedPeople to be map???
    var openEvents = dbEvents.docs
        .where((element) => !element.data()['confirmedPeople'].contains(uid))
        .toList();
    print(openEvents);
    return List.generate(openEvents.length, (i) {
      return Event.fromMap(openEvents[i].id, openEvents[i].data());
    });
  }

  Future<List<Event>> getUserEvents(String cid, String uid) async {
    var hostedEvents = await firestore
        .collection('events')
        .where('cid', isEqualTo: cid)
        .where('hostId', isEqualTo: uid)
        .get();
    var attendingEvents = await firestore
        .collection('events')
        .where('cid', isEqualTo: cid)
        .where('confirmedPeople', arrayContains: uid)
        .get();

    List dbEvents = hostedEvents.docs + attendingEvents.docs;

    return List.generate(dbEvents.length, (i) {
      return Event.fromMap(dbEvents[i].id, dbEvents[i].data());
    });
  }

  Future<void> createEvent(Map<String, dynamic> eventMap) async {
    // TODO: check fields if they are valid
    // try{
    //   Map testMap = Map.from(eventMap);
    //   testMap['eid'] = -1;
    //   testEvent = Event(testMap);
    // }
    await firestore.collection('events').add(eventMap);
  }

  Future<void> setEvent(Event event) async {}

  Future<void> rsvpEvent(Event event, String uid) async {
    // TODO: instead of taking uid as input, get the current user's uid
    // TODO: try catch if doc doesn't exist
    DocumentReference eventRef = firestore.collection('events').doc(event.eid);

    await eventRef.update({
      'confirmedPeople': FieldValue.arrayUnion([uid])
    });
  }

// Future<Event> getEvent(String eid){
//
// }

  Future<void> sendMessage(Message msg) async {
    await firestore.collection('messages').add(msg.toMap());
  }

  Stream<List<Message>> getEventMessages(String eid) {
    // TODO auth
    Stream<List<Message>> messages = firestore
        .collection('messages')
        .where('eid', isEqualTo: eid)
        .orderBy('timestamp')
        .snapshots()
        .map((query) => query.docs.map((doc) => Message.fromMap(doc.data())).toList());
    return messages;
  }
}
