import 'dart:async';
import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const HomeworkTrackerApp());
}


class HomeworkTrackerApp extends StatelessWidget{
  const HomeworkTrackerApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Tracker',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.purple,
            body: Center(
              child: Text(
                'Homework Tracker',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
    );
  }
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.purple,
    body: Center(child: Text('Homework Tracker', style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold,)),)
  );
}


}

