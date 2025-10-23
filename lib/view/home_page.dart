import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/todo_controller.dart';
import '../utils/app_colors.dart';
import 'welcome_page.dart';
import '../services/auth_service.dart';

class TodoListPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const TodoListPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TodoController>(context);

    Future<void> displayEditDialog(int index) async {
      controller.prepareEdit(index);
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: AppColors.cardBackground,
            title: const Text('Editar Tarefa', style: TextStyle(color: AppColors.primaryText)),
            content: TextField(
              controller: controller.editTextFieldController,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Edite sua tarefa aqui"),
              onSubmitted: (value) {
                controller.editTodoItem(index);
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar', style: TextStyle(color: AppColors.secondaryText)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.textOnDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Salvar'),
                onPressed: () {
                  controller.editTodoItem(index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final todoItems = controller.todoItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Neodímio Tasks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: AppColors.textOnDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.cardBackground,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.primaryAccent,
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 40, color: AppColors.textOnDark),
                ),
              ),
              accountName: Text(
                widget.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(widget.userEmail),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/imagens_flutter/fundo.jpg"),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            ListTile(
              tileColor: AppColors.cardBackground,
              splashColor: AppColors.primaryAccent.withAlpha(50),
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Sair', style: TextStyle(color: AppColors.primaryText)),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagens_flutter/fundo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, kToolbarHeight + 40, 16.0, 16.0),
          child: Column(
            children: <Widget>[
              Card(
                color: AppColors.cardWhite,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: controller.textFieldController,
                          focusNode: controller.inputFocusNode,
                          decoration: InputDecoration(
                            hintText: controller.currentHintText,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: controller.isHintError
                                  ? Colors.redAccent.shade100
                                  : AppColors.secondaryText,
                            ),
                          ),
                          style: const TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
                          onSubmitted: (value) => controller.addTodoItem(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: controller.addTodoItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: AppColors.textOnDark,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Adicionar'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: todoItems.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/imagens_flutter/logo.png', width: 100),
                      const SizedBox(height: 20),
                      const Text(
                        'Tudo em ordem!',
                        style: TextStyle(fontSize: 20, color: AppColors.textOnDark),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adicione sua primeira tarefa, ${widget.userName}.',
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: todoItems.length,
                  itemBuilder: (context, index) {
                    final todo = todoItems[index];
                    return Card(
                      color: todo.isDone ? AppColors.taskDoneGreen : AppColors.cardWhite,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (bool? value) => controller.toggleTodoStatus(index),
                          activeColor: AppColors.primaryAccent,
                          checkColor: AppColors.cardWhite,
                          side: BorderSide(
                              color: todo.isDone ? Colors.green.shade800 : AppColors.secondaryText,
                              width: 2),
                          shape: const CircleBorder(),
                        ),
                        title: Text(
                          todo.text,
                          style: TextStyle(
                            decoration: todo.isDone ? TextDecoration.lineThrough : null,
                            decorationColor: AppColors.textOnDark,
                            color: todo.isDone ? AppColors.textOnDark : AppColors.primaryText,
                            fontWeight: todo.isDone ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit_note_outlined,
                                color: todo.isDone ? AppColors.textOnDark.withAlpha(200) : AppColors.secondaryText,
                              ),
                              onPressed: () => displayEditDialog(index),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: todo.isDone ? AppColors.textOnDark.withAlpha(200) : Colors.redAccent,
                              ),
                              onPressed: () => controller.removeTodoItem(index),
                            ),
                          ],
                        ),
                        onTap: () => controller.toggleTodoStatus(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}