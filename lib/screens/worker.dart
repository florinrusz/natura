import 'package:flutter/material.dart';
import '../app_state.dart';

class WorkerScreen extends StatefulWidget {
  final AppState state;
  const WorkerScreen({super.key, required this.state});

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  int rowNo = 1;
  String procedure = 'Suckering';

  @override
  Widget build(BuildContext context) {
    final open = widget.state.openSessionForCurrentWorker;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Natura • Worker'),
        actions: [
          IconButton(onPressed: widget.state.logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: open == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('Row: '),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: rowNo,
                      items: List.generate(66, (i) => i + 1)
                          .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                          .toList(),
                      onChanged: (v) => setState(() => rowNo = v ?? 1),
                    ),
                  ]),
                  Row(children: [
                    const Text('Procedure: '),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: procedure,
                      items: widget.state.procedures
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (v) => setState(() => procedure = v ?? 'Suckering'),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () async {
                      try {
                        await widget.state.startWork(rowNo: rowNo, procedure: procedure);
                        if (mounted) setState(() {});
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('START'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Currently working: Row ${open.rowNo} • ${open.procedure}'),
                  const SizedBox(height: 12),
                  Text('Time: ~${(open.durationSec / 60).toStringAsFixed(1)} min'),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      await widget.state.stopWork(open.id);
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.stop),
                    label: const Text('STOP'),
                  ),
                  const SizedBox(height: 8),
                  const Text('After STOP, the task will appear for supervisor validation.'),
                ],
              ),
      ),
    );
  }
}

