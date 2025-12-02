class UserModel {
  final String email;
  final String password;
  final String role; // "student" or "trainer"

  UserModel({required this.email, required this.password, required this.role});

  Map<String, dynamic> toMap() {
    return {"email": email, "role": role};
  }
}
