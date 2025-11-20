import '../models/user_model.dart';

class AuthController {
  String validateEmail(String email) {
    if (email.isEmpty) return "Email requis";
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      return "Email invalide";
    }
    return "";
  }

  String validatePassword(String password) {
    if (password.isEmpty) return "Mot de passe requis";
    return "";
  }

  String validateConfirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return "Confirmation requise";
    if (password != confirm) return "Les mots de passe ne correspondent pas";
    return "";
  }

  String login(User user) {
    final emailError = validateEmail(user.email);
    final passwordError = validatePassword(user.password);

    if (emailError.isNotEmpty) return "Erreur: $emailError";
    if (passwordError.isNotEmpty) return "Erreur: $passwordError";
    return "Connexion réussie !";
  }

  String signup(User user) {
    final emailError = validateEmail(user.email);
    final passwordError = validatePassword(user.password);
    final confirmError = validateConfirmPassword(
      user.password,
      user.confirmPassword,
    );

    if (emailError.isNotEmpty) return "Erreur: $emailError";
    if (passwordError.isNotEmpty) return "Erreur: $passwordError";
    if (confirmError.isNotEmpty) return "Erreur: $confirmError";
    return "Inscription réussie !";
  }
}
