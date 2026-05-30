import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = "tarefas";

  Future<void> adicionarTarefa(String titulo,String estimativa, String userId) async {
    await _firestore.collection(collection).add({
      'titulo': titulo,
      'estimativa': estimativa,
      'pronto': false,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TodoModel>> getTarefas(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> alternarStatus(String id, bool statusAtual) async {
    await _firestore.collection(collection).doc(id).update({'pronto': !statusAtual});
  }

  Future<void> removerTarefa(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  Future<void> editarTarefa(String id, String novoTitulo, String novaEstimativa) async {
  await _firestore.collection(collection).doc(id).update({
    'titulo': novoTitulo,
    'estimativa': novaEstimativa,
  });
}
}
