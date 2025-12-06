import 'package:flutter/material.dart';
import '../controllers/lesson_controller.dart';
import '../models/lesson_model.dart';
import 'add_content_view.dart';

class AddLessonView extends StatefulWidget {
  final String moduleId;
  const AddLessonView({required this.moduleId, super.key});

  @override
  State<AddLessonView> createState() => _AddLessonViewState();
}

class _AddLessonViewState extends State<AddLessonView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final LessonController _controller = LessonController();

  void _addLesson() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) return;

    final newLesson = Lesson(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      moduleId: widget.moduleId,
      title: _titleController.text,
      description: _descController.text,
    );

    await _controller.addLesson(newLesson);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AddContentView(lessonId: newLesson.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Ajouter Leçon"),
        backgroundColor: Colors.blueAccent,
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
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Titre de la leçon",
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descController,
                  maxLines: 4,
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
                    onPressed: _addLesson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ajouter Leçon",
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
