class Profile{
  final String firstName;
  final String lastName;
  final String username;
  final String? bio;
  final String? profilePicture;
  final DateTime createdAt;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.username,
    this.bio,
    this.profilePicture,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'bio': bio,
      'profile_picture': profilePicture,
      'created_at': createdAt.toIso8601String(),
    };
  }
}