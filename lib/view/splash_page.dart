import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_page.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  final int minSplashDuration = 3000; // 3 segundos

  @override
  void initState() {
    super.initState();
    final startTime = DateTime.now();
    final user = FirebaseAuth.instance.currentUser;

    int elapsed = DateTime.now().difference(startTime).inMilliseconds;
    int waitTime = minSplashDuration - elapsed;
    if (waitTime < 0) waitTime = 0;

    _timer = Timer(Duration(milliseconds: waitTime), () {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TodoListPage(
              userName: user.displayName ?? 'Usuário',
              userEmail: user.email ?? '',
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imagens_flutter/eduardo.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}