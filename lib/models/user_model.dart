class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('👤 Parsing user from JSON: $json');
    
    return User(
      id: json['id']?.toString() ?? 
          json['user_id']?.toString() ?? 
          json['uid']?.toString() ?? 
          '0',
      name: json['name'] ?? 
            json['full_name'] ?? 
            json['display_name'] ?? 
            'User',
      username: json['username'] ?? 
                json['user_name'] ?? 
                json['email'] ?? // Fallback ke email jika username tidak ada
                'unknown',
      email: json['email'] ?? '',
      token: json['token'] ?? 
             json['access_token'] ?? 
             json['auth_token'] ?? 
             json['bearer_token'] ??
             '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'token': token,
    };
  }
}