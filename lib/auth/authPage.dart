import 'package:firebase/page/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase/page/RegisterPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  // Function to toggle between Login and Register pages
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        showRegisterPage: togglePage,
      );
    } else {
      return RegisterPage(
        showLoginPage: togglePage,
      );
    }
  }
}
