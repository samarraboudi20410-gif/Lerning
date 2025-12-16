import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz_result_model.dart';

class QuizResultsStudent extends StatelessWidget {
  final String studentId; // ID de l'étudiant
  final QuizController controller = QuizController();

  QuizResultsStudent({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Quiz"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<QuizResultModel>>(
        future: controller.getQuizResults(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun quiz passé"));
          }

          final results = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final quiz = results[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(
                    quiz.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text("Score : ${quiz.score} / ${quiz.total}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
