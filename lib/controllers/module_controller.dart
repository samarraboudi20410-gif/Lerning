import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/module_model.dart';

class ModuleController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Modules du prof
  Stream<List<ModuleModel>> getModules(String profId) {
    return _db
        .collection('modules')
        .where('profId', isEqualTo: profId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ModuleModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // Modules pour étudiants (tous les modules)
  Stream<List<ModuleModel>> getModulesForStudents() {
    return _db
        .collection('modules')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ModuleModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addModule(ModuleModel module) async {
    await _db.collection('modules').doc(module.id).set(module.toMap());
  }
}
