import 'package:flutter/material.dart';
import '../controllers/lesson_controller.dart';
import '../models/lesson_model.dart';
import 'add_lesson_view.dart';
import 'content_view_trainer.dart';

class LessonViewTrainer extends StatefulWidget {
  final String moduleId;

  const LessonViewTrainer({required this.moduleId, super.key});

  @override
  State<LessonViewTrainer> createState() => _LessonViewTrainerState();
}

class _LessonViewTrainerState extends State<LessonViewTrainer> {
  final LessonController _lessonController = LessonController();
  List<Lesson> _lessons = [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final lessons = await _lessonController.getLessons(widget.moduleId);
    setState(() => _lessons = lessons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Leçons"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _lessons.isEmpty
          ? const Center(child: Text("Aucune leçon disponible"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      lesson.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      lesson.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // ✅ Correction : passer moduleId également
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContentViewTrainer(
                            lessonId: lesson.id,
                            moduleId: widget.moduleId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddLessonView(moduleId: widget.moduleId),
            ),
          ).then((_) => _loadLessons()); // recharge la liste après ajout
        },
      ),
    );
  }
}
