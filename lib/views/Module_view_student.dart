import 'package:flutter/material.dart';
import '../controllers/module_controller.dart';
import '../models/module_model.dart';
import 'Lesson_view_student.dart';

class ModuleViewStudent extends StatelessWidget {
  final ModuleController controller = ModuleController();

  ModuleViewStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Modules"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<ModuleModel>>(
        stream: controller
            .getModulesForStudents(), // utilise la méthode ajoutée
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final modules = snapshot.data!;
          if (modules.isEmpty) {
            return const Center(child: Text("Aucun module disponible"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    module.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(module.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonViewStudent(moduleId: module.id),
                      ),
                    );
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
