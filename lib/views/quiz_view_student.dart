import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz_model.dart';

class QuizViewStudent extends StatelessWidget {
  final QuizController controller = QuizController();

  QuizViewStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<QuizModel>>(
        stream: controller.getQuizzes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final quizzes = snapshot.data!;
          if (quizzes.isEmpty)
            return const Center(child: Text("Aucun quiz disponible"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(
                    Icons.quiz,
                    color: Colors.blueAccent,
                    size: 35,
                  ),
                  title: Text(
                    quiz.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(quiz.description),
                  onTap: () {
                    // TODO: Open quiz page
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
