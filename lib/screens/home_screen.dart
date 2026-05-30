import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/todo_model.dart';
import '../widgets/todo_item_widget.dart';
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

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _exibirDialogoAdicionar() {
    _taskController.clear();
    int hora = 0;
    int minuto = 30; 

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Nova Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: "O que fazer?"),
              ),
              const SizedBox(height: 25),
              const Text("Tempo Estimado:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: hora,
                      decoration: const InputDecoration(labelText: "Horas"),
                      items: List.generate(24, (i) => i)
                          .map((h) => DropdownMenuItem(value: h, child: Text("${h}h")))
                          .toList(),
                      onChanged: (v) => setDialogState(() => hora = v!),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: minuto,
                      decoration: const InputDecoration(labelText: "Minutos"),
                      items: List.generate(60, (i) => i)
                          .map((m) => DropdownMenuItem(value: m, child: Text("${m}m")))
                          .toList(),
                      onChanged: (v) => setDialogState(() => minuto = v!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                if (_taskController.text.isNotEmpty) {
                  final user = FirebaseAuth.instance.currentUser;
                  String estimativaDinamica = "${hora}h ${minuto}m"; 
                  
                  await _dbService.adicionarTarefa(_taskController.text, estimativaDinamica, user!.uid);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Adicionar"),
            ),
          ],
        ),
      ),
    );
  }

  void _exibirDialogoEditar(TodoModel tarefa) {
    _taskController.text = tarefa.titulo; 
    int hora = 0;
    int minuto = 30;

    try {
      if (tarefa.estimativa.contains('h') && tarefa.estimativa.contains('m')) {
        final partes = tarefa.estimativa.split(' ');
        hora = int.parse(partes[0].replaceAll('h', ''));
        minuto = int.parse(partes[1].replaceAll('m', ''));
      }
    } catch (_) {}

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Editar Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: "Novo título"),
              ),
              const SizedBox(height: 25),
              const Text("Nova Estimativa:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: hora,
                      decoration: const InputDecoration(labelText: "Horas"),
                      items: List.generate(24, (i) => i)
                          .map((h) => DropdownMenuItem(value: h, child: Text("${h}h")))
                          .toList(),
                      onChanged: (v) => setDialogState(() => hora = v!),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: minuto,
                      decoration: const InputDecoration(labelText: "Minutos"),
                      items: List.generate(60, (i) => i)
                          .map((m) => DropdownMenuItem(value: m, child: Text("${m}m")))
                          .toList(),
                      onChanged: (v) => setDialogState(() => minuto = v!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                if (_taskController.text.isNotEmpty) {
                  String novaEstimativa = "${hora}h ${minuto}m";
                  await _dbService.editarTarefa(tarefa.id, _taskController.text, novaEstimativa);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
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
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              }
            },
          )
        ],
      ),
      body: StreamBuilder<List<TodoModel>>(
        stream: _dbService.getTarefas(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma tarefa cadastrada."));
          }

          final tarefas = snapshot.data!;

          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              return TodoItemWidget(
                tarefa: tarefa,
                onStatusChanged: (valor) => _dbService.alternarStatus(tarefa.id, tarefa.pronto),
                onEdit: () => _exibirDialogoEditar(tarefa),
                onDelete: () => _dbService.removerTarefa(tarefa.id),
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
