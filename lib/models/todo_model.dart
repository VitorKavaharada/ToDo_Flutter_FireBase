class TodoModel {
  String id;
  String titulo;
  bool pronto;
  String userId;

  TodoModel({
    required this.id,
    required this.titulo,
    this.pronto = false,
    required this.userId,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      titulo: map['titulo'] ?? '',
      pronto: map['pronto'] ?? false,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'pronto': pronto,
      'userId': userId,
    };
  }
}