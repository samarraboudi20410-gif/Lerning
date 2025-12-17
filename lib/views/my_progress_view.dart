import 'package:flutter/material.dart';

class MyProgressView extends StatelessWidget {
  const MyProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            progressCard("Modules completed", "1/ 2"),
            progressCard("Lessons viewed", "2"),
            progressCard("Time spent", "3h 20min"),
          ],
        ),
      ),
    );
  }

  Widget progressCard(String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
