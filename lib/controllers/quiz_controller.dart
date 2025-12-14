import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizController {
  Stream<List<QuizModel>> getQuizzes() {
    return FirebaseFirestore.instance
        .collection("quiz")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => QuizModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
