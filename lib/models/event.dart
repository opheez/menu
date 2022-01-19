import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eid;
  final String cid;
  final String hostId;

  bool private;
  int durationMin;
  int maxPeople;

  // List<DateTime> tentDatetimes;
  // List<String> tentLocations;
  // List<String> tentPeople;
  DateTime confirmedDatetime;

  // String confirmedLocation;
  List<String> confirmedPeople;

  // List<DateTime> preferredDatetimes;
  // List<String> preferredLocations;

  String details;

  Event(
      {required this.eid,
      required this.cid,
      required this.hostId,
      this.private = false,
      this.durationMin = 60,
      this.maxPeople = 3,
      required this.confirmedDatetime,
      required this.confirmedPeople,
      this.details = ""
      });

  Event.fromMap(String id, Map<String, Object?> map)
      : this(
            eid: id,
            cid: map['cid']! as String,
            hostId: map['hostId']! as String,
            private: (map['private'] ?? false) as bool,
            durationMin: map['durationMin']! as int,
            maxPeople: map['maxPeople']! as int,
            confirmedDatetime:
              (map['confirmedDatetime']! as Timestamp).toDate(),
            confirmedPeople:
                List<String>.from(map['confirmedPeople']! as List),
            details: (map['details'] ?? "") as String,
  );

  Map<String, Object?> toMap(){
    return {
      'eid': eid,
      'cid': cid,
      'hostId': hostId,
      'private': private,
      'durationMin': durationMin,
      'maxPeople': maxPeople,
      'confirmedDatetime': confirmedDatetime,
      'confirmedPeople': confirmedPeople,
      'details': details
    };
  }
}
