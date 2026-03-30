import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'controllers/todo_controller.dart';
import 'view/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB9qlgxkU4iP6K64jqJWTZLzCw8Bi2Md0A",
          authDomain: "testeflutter-e1c1b.firebaseapp.com",
          projectId: "testeflutter-e1c1b",
          storageBucket: "testeflutter-e1c1b.firebasestorage.app",
          messagingSenderId: "94876127409",
          appId: "1:94876127409:web:bf6b8370d776f55ff2d290"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neodímio Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}