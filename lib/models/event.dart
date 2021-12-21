class Event {
  final String eid;
  final String cid;
  final String hostId;

  // bool private;
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

  Event(
      {required this.eid,
      required this.cid,
      required this.hostId,
      // this.private = false,
      this.durationMin = 60,
      this.maxPeople = 3,
      required this.confirmedDatetime,
      required this.confirmedPeople});
}
