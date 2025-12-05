import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'ModuleViewTrainer.dart';
import 'Module_view_student.dart';

class LoginView extends StatefulWidget {
  final AuthController authController;

  LoginView({required this.authController});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String message = "";
  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);

    try {
      // Crée UserModel pour login
      final user = UserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: '', // pas nécessaire pour login
      );

      final result = await widget.authController.login(user);

      if (!result.contains("réussie")) {
        setState(() => message = result);
        return;
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        setState(
          () => message = "Erreur: utilisateur non trouvé dans Firestore",
        );
        return;
      }

      final role = (userDoc['role'] ?? 'student')
          .toString()
          .trim()
          .toLowerCase();

      if (role == 'trainer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ModuleViewTrainer()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ModuleViewStudent()),
        );
      }
    } catch (e) {
      setState(() => message = "Erreur login: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : ElevatedButton(
                        onPressed: handleLogin,
                        child: Text("Login"),
                      ),
              ),
              SizedBox(height: 10),
              Text(message, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
