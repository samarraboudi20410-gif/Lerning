import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  final AuthController authController;

  const SignupView({required this.authController, super.key});

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Image.asset('assets/flutterlearn_logo.png', height: 110),

              const SizedBox(height: 25),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isTrainer ? "I am a Trainer" : "I am a Student",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Switch(
                              value: _isTrainer,
                              onChanged: (value) =>
                                  setState(() => _isTrainer = value),
                              activeColor: Colors.blueAccent,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: handleSignup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          message,
                          style: TextStyle(
                            color: message.contains("succès")
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginView(
                                  authController: widget.authController,
                                ),
                              ),
                            );
                          },
                          child: const Text("Back to Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
