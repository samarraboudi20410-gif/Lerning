import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_view.dart';

class AjouterCoursView extends StatefulWidget {
  @override
  State<AjouterCoursView> createState() => _AjouterCoursViewState();
}

class _AjouterCoursViewState extends State<AjouterCoursView> {
  final _nomController = TextEditingController();
  final _typeController = TextEditingController();
  String message = "";

  void ajouterCours() async {
    final nom = _nomController.text.trim();
    final type = _typeController.text.trim();

    if (nom.isEmpty || type.isEmpty) {
      setState(() => message = "Erreur : tous les champs sont requis");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('cours').add({
        'nom': nom,
        'type': type,
        'created_at': FieldValue.serverTimestamp(),
      });

      print("COURSE ADDED SUCCESSFULLY"); // 🔹 Debug print

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CourseView()),
      );
    } catch (e) {
      print("FIRESTORE ERROR: $e"); // 🔹 Affiche l’erreur exacte dans console
      setState(() => message = "Erreur lors de l'ajout du cours");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter Cours")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: "Nom du cours",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: "Type (Texte, Vidéo, Quiz)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ajouterCours,
              child: Text("Ajouter cours"),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: message.contains("succès") ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
