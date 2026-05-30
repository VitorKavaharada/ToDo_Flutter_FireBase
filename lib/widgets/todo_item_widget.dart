import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel tarefa;
  final Function(bool?) onStatusChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.tarefa,
    required this.onStatusChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        tarefa.titulo,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: tarefa.pronto ? TextDecoration.lineThrough : null,
          color: tarefa.pronto ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        "Estimativa: ${tarefa.estimativa}",
        style: TextStyle(
          fontSize: 12,
          color: tarefa.pronto ? Colors.grey : Colors.blueGrey,
        ),
      ),
      leading: Checkbox(
        value: tarefa.pronto,
        onChanged: onStatusChanged,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
