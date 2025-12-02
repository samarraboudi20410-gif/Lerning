import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 LOGIN
  Future<String> login(UserModel user) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return "Connexion réussie";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔹 SIGNUP
  Future<String> signup(UserModel user) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Sauvegarder dans Firestore
      await _db.collection("users").doc(credential.user!.uid).set(user.toMap());

      return "Compte créé avec succès";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔹 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
