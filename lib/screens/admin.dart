import 'package:flutter/material.dart';
import '../app_state.dart';

class AdminScreen extends StatelessWidget {
  final AppState state;
  const AdminScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final validated = state.validated;

    int totalSec = 0;
    double sumScore = 0;
    for (final s in validated) {
      totalSec += s.durationSec;
      sumScore += (s.score ?? 0).toDouble();
    }
    final avg = validated.isEmpty ? 0 : (sumScore / validated.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Natura • Admin'),
        actions: [
          IconButton(onPressed: state.logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Validated tasks: ${validated.length}'),
            Text('Total time: ${(totalSec / 3600).toStringAsFixed(2)} hours'),
            Text('Average quality score: ${avg.toStringAsFixed(2)}'),
            const Divider(),
            const Text('Latest tasks:'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: validated.length,
                itemBuilder: (_, i) {
                  final s = validated[i];
                  return ListTile(
                    title: Text('${s.workerName} • Row ${s.rowNo} • ${s.procedure}'),
                    subtitle: Text('Score: ${s.score} • ${(s.durationSec / 60).toStringAsFixed(1)} min'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

