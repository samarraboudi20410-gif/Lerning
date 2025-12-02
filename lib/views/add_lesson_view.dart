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
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final LessonController _controller = LessonController();

  void _addLesson() async {
    if (_titleController.text.isEmpty) return;

    final lesson = Lesson(
      id: const Uuid().v4(),
      moduleId: widget.moduleId,
      title: _titleController.text,
      description: _descController.text,
    );

    await _controller.addLesson(lesson);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Lesson')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLesson,
              child: const Text('Add Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}
