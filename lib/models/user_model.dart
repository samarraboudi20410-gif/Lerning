class User {
  String email;
  String password;
  String confirmPassword;

  User({
    required this.email,
    required this.password,
    this.confirmPassword = "",
  });
}
