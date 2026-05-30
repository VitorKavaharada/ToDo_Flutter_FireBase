class TodoModel {
  String id;
  String titulo;
  String estimativa;
  bool pronto;
  String userId;

  TodoModel({
    required this.id,
    required this.titulo,
    required this.estimativa,
    this.pronto = false,
    required this.userId,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      titulo: map['titulo'] ?? '',
      estimativa: map['estimativa'] ?? 'Não informada',
      pronto: map['pronto'] ?? false,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'estimativa': estimativa,
      'pronto': pronto,
      'userId': userId,
    };
  }
}
