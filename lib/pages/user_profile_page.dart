import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/api_calls.dart';
import '../routes.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  void _logout(BuildContext context) async {
    try {
      await ApiCalls.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.welcome,
              (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<UserProfile>(
        future: ApiCalls.getUserProfile(),
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("${profile.firstName} ${profile.lastName}"),
                const SizedBox(height: 8),
                Text(profile.bio ?? "No bio"),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on),
                    const SizedBox(width: 4),
                    Text("Balance: ${profile.balance} points"),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Joined: ${profile.createdAt.toLocal().toString().split(' ').first}"),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.transactions);
                  },
                  icon: const Icon(Icons.history),
                  label: const Text("Transaction History"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  )
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
