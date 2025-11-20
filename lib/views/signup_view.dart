import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_view.dart';
import 'course_view.dart';

class SignupView extends StatefulWidget {
  final AuthController authController;

  SignupView({required this.authController}); // <-- prend le controller

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String message = "";

  void handleSignup() {
    final user = User(
      email: _emailController.text.trim(),
      password: _password_controller_text(), // helper below
      confirmPassword: _confirmController.text,
    );

    final result = widget.authController.signup(user);
    if (result.contains("réussie")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CourseView()),
      );
    } else {
      setState(() => message = result);
    }
  }

  // petit helper pour éviter warning si tu veux utiliser trim() sur password aussi
  String _password_controller_text() => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup MVC")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            TextField(
              controller: _confirmController,
              decoration: InputDecoration(labelText: "Confirmer mot de passe"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: handleSignup, child: Text("S'inscrire")),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: message.contains("réussie") ? Colors.green : Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {
                // <-- on passe le controller à LoginView
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LoginView(authController: widget.authController),
                  ),
                );
              },
              child: Text("Déjà un compte ? Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
