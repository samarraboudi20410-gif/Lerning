import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuizView extends StatefulWidget {
  final String moduleId;

  const AddQuizView({required this.moduleId, super.key});

  @override
  State<AddQuizView> createState() => _AddQuizViewState();
}

class _AddQuizViewState extends State<AddQuizView> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  int correctAnswerIndex = 0;

  void _saveQuestion() async {
    if (questionController.text.isEmpty ||
        optionControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.moduleId)
        .collection('questions')
        .add({
          'title': questionController.text,
          'options': optionControllers.map((e) => e.text).toList(),
          'correctAnswer': correctAnswerIndex,
        });

    questionController.clear();
    for (var c in optionControllers) {
      c.clear();
    }

    setState(() {
      correctAnswerIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Question ajoutée avec succès")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Ajouter un quiz"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shadowColor: Colors.blueAccent.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: "Question",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: optionControllers[index],
                      decoration: InputDecoration(
                        labelText: "Option ${index + 1}",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),
                const Text(
                  "Bonne réponse",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: correctAnswerIndex,
                  items: List.generate(
                    4,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text("Option ${index + 1}"),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      correctAnswerIndex = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveQuestion,
                  child: const Text(
                    "Ajouter la question",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
