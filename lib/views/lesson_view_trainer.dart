import 'package:flutter/material.dart';
import '../controllers/module_controller.dart';
import '../models/module_model.dart';
import 'lesson_view.dart';

class ModuleViewTrainer extends StatefulWidget {
  @override
  State<ModuleViewTrainer> createState() => _ModuleViewTrainerState();
}

class _ModuleViewTrainerState extends State<ModuleViewTrainer> {
  final ModuleController _controller = ModuleController();
  List<Module> _modules = [];

  void _loadModules() async {
    // Récupérer les modules depuis Firestore ou ton controller
    final modules = await _controller.getModules(); // adapter selon ton code
    setState(() => _modules = modules);
  }

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Modules"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _modules.isEmpty
          ? Center(child: Text("Aucun module trouvé"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _modules.length,
              itemBuilder: (context, index) {
                final module = _modules[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      module.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      module.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueAccent,
                    ),
                    onTap: () {
                      // Redirection vers les leçons avec l'id du module
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonView(moduleId: module.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          // Ici tu peux ajouter la logique pour créer un module
        },
      ),
    );
  }
}
