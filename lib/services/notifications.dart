//
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class PushNotificationService {
//
//   // makes this a singleton class
//   PushNotificationService._privateConstructor();
//   static final PushNotificationService instance = PushNotificationService._privateConstructor();
//
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//   Future initialize() async {
//     // if (Platform.isIOS) {
//     //   _fcm.requestNotificationPermissions(IosNotificationSettings());
//     // }
//
//     String? token = await _fcm.getToken();
//
//     print("FirebaseMessaging token: $token");
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(message.data);
//       print(message.senderId);
//       print(message.from);
//       print(message.notification.toString());
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print(message.data);
//       print(message.senderId);
//       print(message.from);
//       print(message.notification.toString());
//     });
//   }
// }