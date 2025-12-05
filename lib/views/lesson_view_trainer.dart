import 'package:flutter/material.dart';
import '../controllers/lesson_controller.dart';
import '../models/lesson_model.dart';
import 'add_lesson_view.dart';

class LessonViewTrainer extends StatefulWidget {
  final String moduleId;
  const LessonViewTrainer({required this.moduleId, super.key});

  @override
  State<LessonViewTrainer> createState() => _LessonViewTrainerState();
}

class _LessonViewTrainerState extends State<LessonViewTrainer> {
  final LessonController _controller = LessonController();
  List<Lesson> _lessons = [];

  void _loadLessons() async {
    final lessons = await _controller.getLessons(widget.moduleId);
    setState(() => _lessons = lessons);
  }

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Leçons"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _lessons.length,
        itemBuilder: (context, index) {
          final lesson = _lessons[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                lesson.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                lesson.description,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddLessonView(moduleId: widget.moduleId),
          ),
        ).then((_) => _loadLessons()),
      ),
    );
  }
}
