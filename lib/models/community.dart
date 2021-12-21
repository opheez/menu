class Community {
  final cid;
  final String creatorId;
  String name;

  //TODO: sign in method for private
  // List<String> locations; // TODO: make location type

  List<String> members;
  List<String> events;

  Community(
      {required this.cid,
      required this.creatorId,
      required this.name,
      required this.members,
      required this.events});
}
