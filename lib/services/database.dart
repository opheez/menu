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

  /// EVENTS

  Future<List<Event>> getAllEvents(String cid) async {
    var dbEvents =
        await firestore.collection('events').where('cid', isEqualTo: cid).get();

    return List.generate(dbEvents.docs.length, (i) {
      return Event.fromMap(dbEvents.docs[i].id, dbEvents.docs[i].data());
    });
  }

  /// Gets future events that the user is not already attending
  Future<List<Event>> getOpenEvents(String cid, String uid) async {
    var dbEvents = await firestore
        .collection('events')
        .where('cid', isEqualTo: cid)
        .where('confirmedDatetime', isGreaterThanOrEqualTo: DateTime.now())
        .get();

    // filter out events that the user is attending TODO: possibly change confirmedPeople to be map???
    var openEvents = dbEvents.docs
        .where((element) => !element.data()['confirmedPeople'].contains(uid) && !(element.data()['hostId'] == uid))
        .toList();

    return List.generate(openEvents.length, (i) {
      print(openEvents[i].data());
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

  Stream<Event> getEventStream(String eid){
    return firestore.collection('events').doc(eid).snapshots()
        .map((doc) => Event.fromMap(eid, doc.data()!));
  }

  Future<void> setEvent(Event event) async {}

  /// Issue a join request to the event
  Future<void> rsvpEvent(Event event, Map request) async {
    // TODO: instead of taking uid as input, get the current user's uid from auth
    // TODO: try catch if doc doesn't exist
    // TODO: verify that request has all of the required fields (uid)
    DocumentReference eventRef = firestore.collection('events').doc(event.eid);

    await eventRef.update({
      'joinRequests': FieldValue.arrayUnion([request])
    });
  }

  /// Approve or decline a join request to the event
  Future<void> ackRequest(Event event, Map request, bool approved) async {
    // TODO: instead of taking uid as input, get the current user's uid from auth
    // TODO: try catch if doc doesn't exist
    // TODO: verify that request has all of the required fields (uid)
    DocumentReference eventRef = firestore.collection('events').doc(event.eid);

    approved ? await eventRef.update({
      'confirmedPeople': FieldValue.arrayUnion([request['uid']]),
      'joinRequests': FieldValue.arrayRemove([request])
    }) : await eventRef.update({
      'joinRequests': FieldValue.arrayRemove([request])
    }) ;
  }

// Future<Event> getEvent(String eid){
//
// }

  /// MESSAGES

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
        .map((query) =>
            query.docs.map((doc) => Message.fromMap(doc.data())).toList());
    return messages;
  }
}
