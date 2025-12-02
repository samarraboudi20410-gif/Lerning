class Content {
  String id;
  String lessonId;
  String type;
  String data;

  Content({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {'lessonId': lessonId, 'type': type, 'data': data};
  }

  factory Content.fromMap(String id, Map<String, dynamic> map) {
    return Content(
      id: id,
      lessonId: map['lessonId'],
      type: map['type'],
      data: map['data'],
    );
  }
}
