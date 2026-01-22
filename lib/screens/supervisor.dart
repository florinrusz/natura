import 'package:flutter/material.dart';
import '../app_state.dart';

class SupervisorScreen extends StatelessWidget {
  final AppState state;
  const SupervisorScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = state.pendingValidations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Natura • Supervisor'),
        actions: [
          IconButton(onPressed: state.logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('Nothing to validate.'))
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = items[i];
                return ListTile(
                  title: Text('${s.workerName} • Row ${s.rowNo} • ${s.procedure}'),
                  subtitle: Text('Duration: ${(s.durationSec / 60).toStringAsFixed(1)} min'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    int score = 8;
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Validate'),
                        content: Row(
                          children: [
                            const Text('Score 1–10: '),
                            const SizedBox(width: 8),
                            DropdownButton<int>(
                              value: score,
                              items: List.generate(10, (x) => x + 1)
                                  .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                                  .toList(),
                              onChanged: (v) => score = v ?? 8,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          FilledButton(
                            onPressed: () async {
                              await state.validate(s.id, score);
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

