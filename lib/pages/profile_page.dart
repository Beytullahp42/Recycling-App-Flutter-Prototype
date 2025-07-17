import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../services/api_calls.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<Profile>(
        future: ApiCalls.getProfileByUsername(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No profile data"));
          }

          final profile = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profile.profilePicture != null
                        ? NetworkImage(profile.profilePicture!)
                        : null,
                    child: profile.profilePicture == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "@${profile.username}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("${profile.firstName} ${profile.lastName}"),
                  const SizedBox(height: 8),
                  Text(profile.bio ?? "No bio"),
                  const SizedBox(height: 8),
                  Text(
                    "Joined: ${profile.createdAt.toLocal().toString().split(' ').first}",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
