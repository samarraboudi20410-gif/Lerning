import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Module_model.dart';

class ModuleController {
  final CollectionReference modulesRef = FirebaseFirestore.instance.collection(
    'modules',
  );

  // Ajouter un module
  Future<void> addModule(ModuleModel module) async {
    await modulesRef.doc(module.id).set(module.toMap());
  }

  // Pour trainer : récupérer ses modules
  Stream<List<ModuleModel>> getModules(String profId) {
    return modulesRef.where('profId', isEqualTo: profId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) =>
                ModuleModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }

  // Pour student : récupérer tous les modules
  Stream<List<ModuleModel>> getModulesForStudents() {
    return modulesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                ModuleModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }
}
