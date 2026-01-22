import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  static const _kSessionsKey = 'sessions_v1';

  final List<UserProfile> demoUsers = const [
    UserProfile('Admin', '0000', Role.admin),
    UserProfile('Supervisor', '1111', Role.supervisor),
    UserProfile('Demo Worker', '2222', Role.worker),
  ];

  UserProfile? currentUser;
  List<WorkSession> sessions = [];

  // EN procedures
  final List<String> procedures = const [
    'Suckering',
    'Defoliation',
    'Tying',
    'Harvesting',
    'Treatments',
    'Cleaning',
    'Other',
  ];

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kSessionsKey);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      sessions = list.map(WorkSession.fromMap).toList();
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(sessions.map((e) => e.toMap()).toList());
    await sp.setString(_kSessionsKey, raw);
  }

  bool loginWithPin(String pin) {
    final u = demoUsers.where((e) => e.pin == pin).toList();
    if (u.isEmpty) return false;
    currentUser = u.first;
    notifyListeners();
    return true;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  WorkSession? get openSessionForCurrentWorker {
    final u = currentUser;
    if (u == null || u.role != Role.worker) return null;
    final opens = sessions.where((s) => s.workerName == u.name && s.status == 'OPEN').toList();
    return opens.isEmpty ? null : opens.first;
  }

  Future<void> startWork({required int rowNo, required String procedure}) async {
    final u = currentUser!;
    if (openSessionForCurrentWorker != null) {
      throw Exception('You already have an open session. Please stop it first.');
    }
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    sessions.insert(
      0,
      WorkSession(
        id: id,
        workerName: u.name,
        rowNo: rowNo,
        procedure: procedure,
        startMs: DateTime.now().millisecondsSinceEpoch,
        endMs: null,
        score: null,
        status: 'OPEN',
      ),
    );
    await _save();
    notifyListeners();
  }

  Future<void> stopWork(String sessionId) async {
    final idx = sessions.indexWhere((s) => s.id == sessionId);
    if (idx < 0) return;
    final s = sessions[idx];
    sessions[idx] = WorkSession(
      id: s.id,
      workerName: s.workerName,
      rowNo: s.rowNo,
      procedure: s.procedure,
      startMs: s.startMs,
      endMs: DateTime.now().millisecondsSinceEpoch,
      score: null,
      status: 'CLOSED',
    );
    await _save();
    notifyListeners();
  }

  List<WorkSession> get pendingValidations =>
      sessions.where((s) => s.status == 'CLOSED').toList();

  Future<void> validate(String sessionId, int score) async {
    final idx = sessions.indexWhere((s) => s.id == sessionId);
    if (idx < 0) return;
    final s = sessions[idx];
    sessions[idx] = WorkSession(
      id: s.id,
      workerName: s.workerName,
      rowNo: s.rowNo,
      procedure: s.procedure,
      startMs: s.startMs,
      endMs: s.endMs,
      score: score,
      status: 'VALIDATED',
    );
    await _save();
    notifyListeners();
  }

  List<WorkSession> get validated => sessions.where((s) => s.status == 'VALIDATED').toList();
}

