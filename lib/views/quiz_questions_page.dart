import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizQuestionsPage extends StatefulWidget {
  final String quizId;
  const QuizQuestionsPage({required this.quizId, super.key});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  List<QuizModel> questions = [];
  Map<String, int> selectedOptions = {}; // questionId -> optionIndex

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizId)
        .collection('questions')
        .get();

    final loadedQuestions = snapshot.docs.map((doc) {
      return QuizModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();

    setState(() {
      questions = loadedQuestions;
    });
  }

  void _submitQuiz() {
    int score = 0;

    for (var q in questions) {
      if (selectedOptions[q.id] != null &&
          selectedOptions[q.id] == q.correctAnswer) {
        score++;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz finished"),
        content: Text(
          "You have earned $score/${questions.length} points",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz"),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Quiz (${questions.length} questions)"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Text(
                    "Q${index + 1}: ${q.title}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (q.description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(q.description),
                  ],
                  const SizedBox(height: 10),

                  // Options
                  ...List.generate(q.options.length, (i) {
                    return RadioListTile<int>(
                      value: i,
                      groupValue: selectedOptions[q.id],
                      title: Text(q.options[i]),
                      activeColor: Colors.blueAccent,
                      onChanged: (val) {
                        setState(() {
                          selectedOptions[q.id] = val!;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _submitQuiz,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Submit the quiz",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
