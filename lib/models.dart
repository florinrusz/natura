enum Role { admin, supervisor, worker }

class UserProfile {
  final String name;
  final String pin;
  final Role role;
  const UserProfile(this.name, this.pin, this.role);
}

class WorkSession {
  final String id;
  final String workerName;
  final int rowNo;
  final String procedure;
  final int startMs;
  final int? endMs;
  final int? score; // 1..10
  final String status; // OPEN | CLOSED | VALIDATED

  const WorkSession({
    required this.id,
    required this.workerName,
    required this.rowNo,
    required this.procedure,
    required this.startMs,
    required this.endMs,
    required this.score,
    required this.status,
  });

  int get durationSec {
    final end = endMs ?? DateTime.now().millisecondsSinceEpoch;
    return ((end - startMs) / 1000).round();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'workerName': workerName,
        'rowNo': rowNo,
        'procedure': procedure,
        'startMs': startMs,
        'endMs': endMs,
        'score': score,
        'status': status,
      };

  static WorkSession fromMap(Map<String, dynamic> m) => WorkSession(
        id: m['id'],
        workerName: m['workerName'],
        rowNo: m['rowNo'],
        procedure: m['procedure'],
        startMs: m['startMs'],
        endMs: m['endMs'],
        score: m['score'],
        status: m['status'],
      );
}

