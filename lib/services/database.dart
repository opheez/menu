import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu/models/event.dart';
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

  Future<List<Event>> getEvents(String cid) async {
    var dbEvents = await firestore
        .collection('events').where('cid', isEqualTo: cid)
        .withConverter<Event>(
            fromFirestore: (snapshot, _) =>
                Event.fromMap(snapshot.id, snapshot.data()!),
            toFirestore: (event, _) => event.toMap()).get();

    return List.generate(dbEvents.docs.length, (i) {
      return dbEvents.docs[i].data();
    });
  }

  Future<void> setEvent() async {}


// Future<Event> getEvent(String eid){
//
// }

}
