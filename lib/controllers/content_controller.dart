import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content_model.dart';

class ContentController {
  final CollectionReference contentsRef = FirebaseFirestore.instance.collection(
    'contents',
  );

  // Ajouter un contenu
  Future<void> addContent(Content content) async {
    await contentsRef.doc(content.id).set(content.toMap());
  }

  // Supprimer un contenu
  Future<void> deleteContent(String contentId) async {
    await contentsRef.doc(contentId).delete();
  }

  // Récupérer les contenus d'une leçon
  Future<List<Content>> getContents(String lessonId) async {
    final snapshot = await contentsRef
        .where('lessonId', isEqualTo: lessonId)
        .get();
    return snapshot.docs
        .map(
          (doc) => Content.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
