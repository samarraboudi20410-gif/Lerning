import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  final AuthController authController;

  SignupView({required this.authController});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isTrainer = false;
  String message = "";
  bool isLoading = false;

  void handleSignup() async {
    setState(() => isLoading = true);

    try {
      // Crée UserModel avec rôle
      final user = UserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _isTrainer ? 'trainer' : 'student',
      );

      final result = await widget.authController.signup(user);

      setState(() => message = result);

      if (result.contains("succès")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginView(authController: widget.authController),
          ),
        );
      }
    } catch (e) {
      setState(() => message = "Erreur signup: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/flutterlearn_logo.png', height: 50),
              SizedBox(height: 20),
              Text(
                "Create an account",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isTrainer ? "I am a Trainer" : "I am a Student",
                            style: TextStyle(fontSize: 16),
                          ),
                          Switch(
                            value: _isTrainer,
                            onChanged: (value) =>
                                setState(() => _isTrainer = value),
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: handleSignup,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  color: message.contains("succès") ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
