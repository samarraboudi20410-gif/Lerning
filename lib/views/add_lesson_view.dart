import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/lesson_controller.dart';
import '../models/lesson_model.dart';

class AddLessonView extends StatefulWidget {
  final String moduleId;
  const AddLessonView({required this.moduleId, Key? key}) : super(key: key);

  @override
  State<AddLessonView> createState() => _AddLessonViewState();
}

class _AddLessonViewState extends State<AddLessonView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final LessonController _controller = LessonController();
  bool _isLoading = false;

  void _addLesson() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final lesson = Lesson(
      id: const Uuid().v4(),
      moduleId: widget.moduleId,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
    );

    try {
      await _controller.addLesson(widget.moduleId, lesson);
      Navigator.pop(context); // Retour à la vue des leçons
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout de la leçon : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une leçon'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addLesson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ajouter la leçon',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
