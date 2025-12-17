import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsListView extends StatelessWidget {
  const StudentsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'student')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;

          if (students.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final data = students[index].data() as Map<String, dynamic>;

              final email = data['email'] ?? 'No email';
              final name = data['name'] ?? email.split('@')[0];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(name),
                  subtitle: Text(email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
