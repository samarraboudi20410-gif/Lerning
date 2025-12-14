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
    try {
      await _auth.signOut(); // déconnexion Firebase
    } catch (e) {
      print("Erreur logout: $e");
      rethrow;
    }
  }

  // 🔹 GET CURRENT USER
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final snapshot = await _db.collection("users").doc(user.uid).get();

      if (!snapshot.exists) return null;

      return UserModel(
        email: snapshot["email"],
        password: "",
        role: snapshot["role"],
      );
    } catch (e) {
      return null;
    }
  }

  // 🔹 CHANGE PASSWORD
  Future<String> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return "Utilisateur non connecté";

      // Ré-authentification
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Mise à jour du mot de passe
      await user.updatePassword(newPassword);

      return "Mot de passe changé avec succès";
    } catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }
}
