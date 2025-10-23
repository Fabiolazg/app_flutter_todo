import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo_item.dart';

class TodoController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<TodoItem> todoItems = [];

  final textFieldController = TextEditingController();
  final editTextFieldController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  bool isHintError = false;
  String currentHintText = "Digite uma tarefa";

  TodoController() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .get();

    todoItems = snapshot.docs.map((doc) {
      final data = doc.data();
      return TodoItem(
        id: doc.id,
        text: data['text'] ?? '',
        isDone: data['isDone'] ?? false,
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addTodoItem() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final text = textFieldController.text.trim();
    if (text.isEmpty) {
      isHintError = true;
      currentHintText = "A tarefa não pode ser vazia!";
      notifyListeners();
      return;
    }

    isHintError = false;
    currentHintText = "Digite uma tarefa";

    // Cria tarefa localmente
    final newTodo = TodoItem(id: '', text: text, isDone: false);

    // Salva no Firestore
    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .add({'text': text, 'isDone': false});

    // Atualiza id local com o do Firestore
    newTodo.id = docRef.id;
    todoItems.add(newTodo);

    textFieldController.clear();
    notifyListeners();
  }

  Future<void> toggleTodoStatus(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final todo = todoItems[index];
    todo.isDone = !todo.isDone;

    // Atualiza Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(todo.id)
        .update({'isDone': todo.isDone});

    notifyListeners();
  }

  Future<void> removeTodoItem(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final todo = todoItems[index];

    // Remove do Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(todo.id)
        .delete();

    todoItems.removeAt(index);
    notifyListeners();
  }

  int? editingIndex;

  void prepareEdit(int index) {
    editingIndex = index;
    editTextFieldController.text = todoItems[index].text;
    notifyListeners();
  }

  Future<void> editTodoItem(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;
    if (editingIndex == null) return;

    final newText = editTextFieldController.text.trim();
    if (newText.isEmpty) return;

    final todo = todoItems[index];
    todo.text = newText;

    // Atualiza Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(todo.id)
        .update({'text': newText});

    editingIndex = null;
    editTextFieldController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    editTextFieldController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }
}