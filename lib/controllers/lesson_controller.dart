import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class LessonController {
  // Récupérer les leçons d'un module
  Future<List<Lesson>> getLessons(String moduleId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('modules')
        .doc(moduleId)
        .collection('lessons')
        .get();

    return snapshot.docs
        .map(
          (doc) => Lesson.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> addLesson(String moduleId, Lesson lesson) async {
    await FirebaseFirestore.instance
        .collection('modules')
        .doc(moduleId)
        .collection('lessons')
        .doc(lesson.id)
        .set(lesson.toMap());
  }
}
