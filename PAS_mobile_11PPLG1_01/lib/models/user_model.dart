class User {
  String? username;
  String? email;
  String? fullName;
  String? token;

  User({
    this.username,
    this.email,
    this.fullName,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'] ?? json['full_name'], // Support both formats
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'token': token,
    };
  }
}