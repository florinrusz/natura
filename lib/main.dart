import 'package:flutter/material.dart';

void main() => runApp(const NaturaApp());

class NaturaApp extends StatelessWidget {
  const NaturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Natura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}

enum Role { admin, supervisor, worker }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final pinCtrl = TextEditingController();
  String? err;

  Role? roleFromPin(String pin) {
    if (pin == '0000') return Role.admin;
    if (pin == '1111') return Role.supervisor;
    if (pin == '2222') return Role.worker;
    return null;
  }

  void go() {
    final r = roleFromPin(pinCtrl.text.trim());
    if (r == null) {
      setState(() => err = 'PIN greșit');
      return;
    }
    Widget screen = switch (r) {
      Role.admin => const AdminHome(),
      Role.supervisor => const SupervisorHome(),
      Role.worker => const WorkerHome(),
    };
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Natura • Login (PIN)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'PIN (4 cifre)'),
              onSubmitted: (_) => go(),
            ),
            if (err != null) Text(err!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            FilledButton(onPressed: go, child: const Text('Intră')),
            const SizedBox(height: 12),
            const Text('Demo PIN: admin 0000 • supervisor 1111 • angajat 2222'),
          ],
        ),
      ),
    );
  }
}

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});
  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  int rowNo = 1;
  String proc = 'Copilire';
  bool working = false;
  DateTime? start;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angajat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: working
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lucrezi acum: Rând $rowNo • $proc'),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.stop),
                    label: const Text('STOP'),
                    onPressed: () {
                      setState(() {
                        working = false;
                        start = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lucrare trimisă la validare (demo).')),
                      );
                    },
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      const Text('Rând: '),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: rowNo,
                        items: List.generate(66, (i) => i + 1)
                            .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                            .toList(),
                        onChanged: (v) => setState(() => rowNo = v ?? 1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Procedură: '),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: proc,
                        items: const ['Copilire','Defoliere','Legare','Recoltare','Tratamente','Curățenie','Altele']
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setState(() => proc = v ?? 'Copilire'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('START'),
                    onPressed: () => setState(() {
                      working = true;
                      start = DateTime.now();
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}

class SupervisorHome extends StatelessWidget {
  const SupervisorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          )
        ],
      ),
      body: Center(
        child: FilledButton(
          child: const Text('Validează o lucrare (demo)'),
          onPressed: () async {
            int score = 8;
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Validează'),
                content: DropdownButton<int>(
                  value: score,
                  items: List.generate(10, (i) => i + 1)
                      .map((v) => DropdownMenuItem(value: v, child: Text('Notă: $v')))
                      .toList(),
                  onChanged: (v) => score = v ?? 8,
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Închide')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text('Aici vine raportul lunar + bonus (următorul pas).'),
      ),
    );
  }
}
