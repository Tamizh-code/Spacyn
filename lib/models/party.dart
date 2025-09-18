class Party {
  final String id; // unique id (like student id)
  final String name;
  int votes;

  Party({
    required this.id,
    required this.name,
    this.votes = 0,
  });
}
