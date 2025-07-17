class UserProfile{
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String? bio;
  final String? profilePicture;
  final DateTime createdAt;
  final int userId;
  final int balance;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.bio,
    this.profilePicture,
    required this.createdAt,
    required this.userId,
    required this.balance,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      balance: json['balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'bio': bio,
      'profile_picture': profilePicture,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'balance': balance,
    };
  }
}