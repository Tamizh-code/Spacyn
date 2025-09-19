class Party {
  final String id; // creatorId
  final String name;
  final String description;
  final String leaderId; // final year student
  final List<String> collaborators;
  final Map<String, Candidate?> candidates; // role → candidate

  Party({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderId,
    this.collaborators = const [],
    this.candidates = const {
      "President": null,
      "Vice President": null,
      "Secretary": null,
      "Vice Secretary": null,
    },
  });
}

class Candidate {
  final String studentId;
  final String name;
  final String role; // President, VP, Secretary, etc.
  final String partyId;

  Candidate({
    required this.studentId,
    required this.name,
    required this.role,
    required this.partyId,
  });
}

class Vote {
  final String voterId;
  final String candidateId;

  Vote({required this.voterId, required this.candidateId});
}
