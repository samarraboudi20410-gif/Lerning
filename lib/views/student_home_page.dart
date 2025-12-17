import 'package:elearningapplication/views/my_progress_view.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'module_view_student.dart';
import 'ask_question_view.dart';
import 'profile_view_student.dart';

class StudentHomePage extends StatelessWidget {
  final AuthController authController = AuthController();

  StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: authController.getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data!;
        final name = user.email.split('@')[0];
        final displayName = name[0].toUpperCase() + name.substring(1);

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text("Welcome $displayName"),
            backgroundColor: Colors.blueAccent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                dashboardCard(
                  context,
                  "Modules",
                  Icons.menu_book_outlined,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ModuleViewStudent()),
                  ),
                ),
                dashboardCard(
                  context,
                  "Questions",
                  Icons.help_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AskQuestionView()),
                  ),
                ),

                dashboardCard(
                  context,
                  "Profile",
                  Icons.person_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileViewStudent()),
                  ),
                ),
                dashboardCard(
                  context,
                  "My Progress",
                  Icons.trending_up_outlined,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyProgressView()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Function onTap,
  ) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: 4,
        shadowColor: Colors.blueAccent.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
