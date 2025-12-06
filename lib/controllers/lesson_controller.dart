import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class LessonController {
  final CollectionReference lessonsRef = FirebaseFirestore.instance.collection(
    'lessons',
  );

  // Récupérer les leçons d'un module
  Future<List<Lesson>> getLessons(String moduleId) async {
    final snapshot = await lessonsRef
        .where('moduleId', isEqualTo: moduleId)
        .get();

    return snapshot.docs
        .map(
          (doc) => Lesson.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  // Ajouter une leçon
  Future<void> addLesson(Lesson lesson) async {
    await lessonsRef.doc(lesson.id).set(lesson.toMap());
  }
}
