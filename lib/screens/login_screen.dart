import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  bool _carregando = false;

  void _tentarLogar() async {
    setState(() => _carregando = true);

    String? erro = await _authService.logar(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _carregando = false);

    if (erro == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login - ToDo List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true, 
            ),
            const SizedBox(height: 20),
            _carregando 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _tentarLogar,
                  child: const Text("Entrar"),
                ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const RegisterScreen())
                );
              },
              child: const Text("Não tem conta? Cadastre-se"),
            )
          ],
        ),
      ),
    );
  }
}