import 'package:flutter/material.dart';
import '../app_state.dart';

class LoginScreen extends StatefulWidget {
  final AppState state;
  const LoginScreen({super.key, required this.state});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final pinCtrl = TextEditingController();
  String? err;

  @override
  void dispose() {
    pinCtrl.dispose();
    super.dispose();
  }

  void _doLogin() {
    final ok = widget.state.loginWithPin(pinCtrl.text.trim());
    setState(() => err = ok ? null : 'Invalid PIN');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Natura • Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Demo PINs: 0000 admin • 1111 supervisor • 2222 worker'),
            const SizedBox(height: 16),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(labelText: 'PIN (4 digits)'),
              onSubmitted: (_) => _doLogin(),
            ),
            if (err != null) Text(err!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            FilledButton(onPressed: _doLogin, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}

