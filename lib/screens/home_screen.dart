import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/todo_model.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _taskController = TextEditingController();

  // DIÁLOGO PARA ADICIONAR
  void _exibirDialogoAdicionar() {
    _taskController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nova Tarefa"),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: "O que precisa fazer?"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              if (_taskController.text.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                await _dbService.adicionarTarefa(_taskController.text, user!.uid);
                Navigator.pop(context);
              }
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  void _exibirDialogoEditar(TodoModel tarefa) {
    _taskController.text = tarefa.titulo; 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Tarefa"),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: "Novo título"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              if (_taskController.text.isNotEmpty) {
                await _dbService.editarTarefa(tarefa.id, _taskController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.sair();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: StreamBuilder<List<TodoModel>>(
        stream: _dbService.getTarefas(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Nenhuma tarefa cadastrada."));

          final tarefas = snapshot.data!;

          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              return ListTile(
                title: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    decoration: tarefa.pronto ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                  value: tarefa.pronto,
                  onChanged: (valor) => _dbService.alternarStatus(tarefa.id, tarefa.pronto),
                ),
                trailing: Row( // Usamos um Row para ter dois botões no final
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _exibirDialogoEditar(tarefa),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _dbService.removerTarefa(tarefa.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogoAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}