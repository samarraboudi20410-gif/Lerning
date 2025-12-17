import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsListView extends StatelessWidget {
  const QuestionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Student Questions "),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading questions"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!.docs;

          if (questions.isEmpty) {
            return const Center(child: Text("No questionsat this time"));
          }

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final data = questions[index].data() as Map<String, dynamic>?;

              if (data == null) return const SizedBox();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(data['question'] ?? " Empty Question "),
                  subtitle: Text(
                    "De: ${data['studentEmail'] ?? 'Unknown student'}\nPour: ${data['trainerEmail'] ?? 'N/A'}",
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
