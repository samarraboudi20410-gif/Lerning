import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/ModuleController.dart';
import '../models/ModuleModel.dart';
import 'lesson_view.dart';

class AjouterModuleView extends StatefulWidget {
  const AjouterModuleView({Key? key}) : super(key: key);

  @override
  State<AjouterModuleView> createState() => _AjouterModuleViewState();
}

class _AjouterModuleViewState extends State<AjouterModuleView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final ModuleController controller = ModuleController();

  void _addModule() async {
    final user = FirebaseAuth.instance.currentUser;
    String profId = user?.uid ?? "";

    if (titleController.text.trim().isEmpty) return;

    String moduleId = const Uuid().v4();

    ModuleModel module = ModuleModel(
      id: moduleId,
      title: titleController.text.trim(),
      description: descController.text.trim(),
      profId: profId,
    );

    await controller.addModule(module);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LessonView(moduleId: moduleId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Ajouter Module"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Titre du module",
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addModule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ajouter Module",
                      style: TextStyle(fontSize: 16),
                    ),
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
