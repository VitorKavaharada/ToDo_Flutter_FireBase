import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.sair();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: const Center(
        child: Text("Bem-vindo! Em breve sua lista de tarefas aparecerá aqui."),
      ),
    );
  }
}