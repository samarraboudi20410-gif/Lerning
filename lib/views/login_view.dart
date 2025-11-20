import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'signup_view.dart';
import 'course_view.dart';

class LoginView extends StatefulWidget {
  final AuthController authController;

  LoginView({required this.authController}); // <-- IMPORTANT

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String message = "";

  void handleLogin() {
    final user = User(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    final result = widget.authController.login(user);
    if (result.contains("réussie")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CourseView()),
      );
    } else {
      setState(() => message = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
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
            SizedBox(height: 20),
            ElevatedButton(onPressed: handleLogin, child: Text("Se connecter")),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: message.contains("réussie") ? Colors.green : Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SignupView(authController: widget.authController),
                  ),
                );
              },
              child: Text("Pas de compte ? S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
