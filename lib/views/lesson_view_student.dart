import 'package:flutter/material.dart';
import '../controllers/lesson_controller.dart';
import '../models/lesson_model.dart';
import 'content_view_student.dart';

class LessonViewStudent extends StatefulWidget {
  final String moduleId;

  const LessonViewStudent({required this.moduleId, super.key});

  @override
  State<LessonViewStudent> createState() => _LessonViewStudentState();
}

class _LessonViewStudentState extends State<LessonViewStudent> {
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
      appBar: AppBar(
        title: const Text("Leçons"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _lessons.isEmpty
          ? const Center(child: Text("Aucune leçon disponible"))
          : ListView.builder(
              itemCount: _lessons.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      lesson.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(lesson.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ContentViewStudent(lessonId: lesson.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
