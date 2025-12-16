class QuizModel {
  final String id;
  final String title; // pour le titre du quiz
  final String description; // pour la description
  final List<String> options;
  final int correctAnswer;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizModel.fromFirestore(String id, Map<String, dynamic> data) {
    return QuizModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? 0,
    );
  }
}
