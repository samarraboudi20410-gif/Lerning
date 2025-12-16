class QuizResultModel {
  final String quizId; // ID du quiz
  final String title; // Nom du quiz
  final double score; // Note obtenue par l'étudiant
  final double total; // Total des points possibles
  final String studentId; // ID de l'étudiant (optionnel)

  QuizResultModel({
    required this.quizId,
    required this.title,
    required this.score,
    required this.total,
    required this.studentId,
  });

  // Convertir depuis un document Firestore
  factory QuizResultModel.fromMap(Map<String, dynamic> map, String id) {
    return QuizResultModel(
      quizId: id,
      title: map['title'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      studentId: map['studentId'] ?? '',
    );
  }

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'score': score,
      'total': total,
      'studentId': studentId,
    };
  }
}
