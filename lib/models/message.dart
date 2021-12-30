import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String eid;
  final String senderId;
  final String message;
  final DateTime timestamp;

  Message(
      {required this.eid,
        required this.senderId,
        required this.message,
        required this.timestamp
        });

  Message.fromMap(String id, Map<String, Object?> map)
      : this(
    eid: map['eid'] as String,
    senderId: map['senderId'] as String,
    message: map['message'] as String,
    timestamp: (map['timestamp'] as Timestamp).toDate()
  );

  Map<String, Object?> toMap(){
    return {
      'eid': eid,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp
    };
  }
}
