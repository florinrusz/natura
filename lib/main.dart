import 'package:flutter/material.dart';
import 'app_state.dart';
import 'models.dart';
import 'screens/login.dart';
import 'screens/worker.dart';
import 'screens/supervisor.dart';
import 'screens/admin.dart';

void main() => runApp(const NaturaApp());

class NaturaApp extends StatefulWidget {
  const NaturaApp({super.key});

  @override
  State<NaturaApp> createState() => _NaturaAppState();
}

class _NaturaAppState extends State<NaturaApp> {
  final state = AppState();
  bool ready = false;

  @override
  void initState() {
    super.initState();
    state.addListener(() => setState(() {}));
    state.init().then((_) => setState(() => ready = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final u = state.currentUser;
    final Widget home = (u == null)
        ? LoginScreen(state: state)
        : (u.role == Role.worker)
            ? WorkerScreen(state: state)
            : (u.role == Role.supervisor)
                ? SupervisorScreen(state: state)
                : AdminScreen(state: state);

    return MaterialApp(
      title: 'Natura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: home,
    );
  }
}
