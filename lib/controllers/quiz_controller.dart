import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearningapplication/models/quiz_result_model.dart';
import '../models/quiz_model.dart';

class QuizController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter une question (Prof)
  Future<void> addQuestion({
    required String moduleId,
    required String title,
    required String description,
    required List<String> options,
    required int correctAnswer,
  }) async {
    await _firestore
        .collection('quizzes')
        .doc(moduleId)
        .collection('questions')
        .add({
          'title': title,
          'description': description,
          'options': options,
          'correctAnswer': correctAnswer,
        });
  }

  // Récupérer les quiz pour un module (Student)
  Stream<List<QuizModel>> getQuizzes(String moduleId) {
    return _firestore
        .collection('quizzes')
        .doc(moduleId)
        .collection('questions')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => QuizModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  // Récupère la liste des résultats de quiz pour un étudiant
  Future<List<QuizResultModel>> getQuizResults(String studentId) async {
    try {
      final querySnapshot = await _firestore
          .collection('quiz_results') // collection Firestore des résultats
          .where('studentId', isEqualTo: studentId)
          .get();

      return querySnapshot.docs.map((doc) {
        return QuizResultModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Erreur getQuizResults: $e");
      return [];
    }
  }
}
