import 'package:flutter/cupertino.dart';
import 'package:menu/models/community.dart';
import 'package:menu/models/event.dart';

class User with ChangeNotifier{
  // Identifying info
  final String uid;
  final String phoneNumber;

  // Bio Info
  String name;
  int classYear;

  // int age;
  // String major;
  // String favLoc;
  // MealPlan mealPlan;

  // App Info
  List<Community> communities;
  List<Event> eventsAttending;
  List<Event> eventsHosting;

  User({required this.uid,
    required this.phoneNumber,
    required this.name,
    required this.classYear,
    required this.communities,
    required this.eventsAttending,
    required this.eventsHosting});
}
