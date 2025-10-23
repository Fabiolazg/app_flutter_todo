// lib/models/todo_item.dart

class TodoItem {
  String id;
  String text;
  bool isDone;

  TodoItem({
    required this.id,
    required this.text,
    required this.isDone,
  });

  // Para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isDone': isDone,
    };
  }

  // Para ler do Firestore
  factory TodoItem.fromMap(String id, Map<String, dynamic> map) {
    return TodoItem(
      id: id,
      text: map['text'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}
