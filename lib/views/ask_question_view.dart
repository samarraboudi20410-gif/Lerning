import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AskQuestionView extends StatefulWidget {
  const AskQuestionView({super.key});

  @override
  State<AskQuestionView> createState() => _AskQuestionViewState();
}

class _AskQuestionViewState extends State<AskQuestionView> {
  final TextEditingController questionCtrl = TextEditingController();
  String? selectedTrainerId;
  String? selectedTrainerEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Ask question"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Send your question to a trainer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Sélection du formateur
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'trainer')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error loading trainers");
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final trainers = snapshot.data!.docs;

                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Select  trainer",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      items: trainers.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(data['email']),
                          onTap: () {
                            selectedTrainerEmail = data['email'];
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedTrainerId = value.toString();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Champ de question
                TextField(
                  controller: questionCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Your question",
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.help_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton envoyer
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text(
                      "Send question",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (questionCtrl.text.isEmpty ||
                          selectedTrainerId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select a trainer  and write a question",
                            ),
                          ),
                        );
                        return;
                      }

                      final user = FirebaseAuth.instance.currentUser!;

                      await FirebaseFirestore.instance
                          .collection('questions')
                          .add({
                            'studentId': user.uid,
                            'studentEmail': user.email,
                            'trainerId': selectedTrainerId,
                            'trainerEmail': selectedTrainerEmail,
                            'question': questionCtrl.text,
                            'createdAt': Timestamp.now(),
                          });

                      questionCtrl.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Question sent successfully"),
                        ),
                      );
                    },
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
