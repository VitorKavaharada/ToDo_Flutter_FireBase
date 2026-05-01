import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _carregando = false;

  void _tentarCadastrar() async {
    setState(() => _carregando = true);

    String? erro = await _authService.cadastrar(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _carregando = false);

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conta criada com sucesso! Faça login.")),
      );
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Senha (mínimo 6 caracteres)"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _carregando 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _tentarCadastrar,
                  child: const Text("Cadastrar"),
                ),
          ],
        ),
      ),
    );
  }
}