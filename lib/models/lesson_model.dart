class Lesson {
  String id;
  String moduleId;
  String title;
  String description;

  Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {'moduleId': moduleId, 'title': title, 'description': description};
  }

  factory Lesson.fromMap(String id, Map<String, dynamic> map) {
    return Lesson(
      id: id,
      moduleId: map['moduleId'],
      title: map['title'],
      description: map['description'],
    );
  }
}
