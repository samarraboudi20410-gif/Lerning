class ModuleModel {
  String id;
  String title;
  String description;
  String profId;

  ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.profId,
  });

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'profId': profId};
  }

  factory ModuleModel.fromMap(String id, Map<String, dynamic> map) {
    return ModuleModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      profId: map['profId'] ?? '',
    );
  }
}
