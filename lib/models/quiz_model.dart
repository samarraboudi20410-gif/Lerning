class QuizModel {
  final String id;
  final String title;
  final String description;

  QuizModel({required this.id, required this.title, required this.description});

  factory QuizModel.fromMap(Map<String, dynamic> data, String id) {
    return QuizModel(
      id: id,
      title: data['title'],
      description: data['description'],
    );
  }
}
