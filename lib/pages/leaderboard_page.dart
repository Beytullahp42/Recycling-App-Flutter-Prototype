import 'package:flutter/material.dart';

import '../models/leaderboard.dart';
import '../services/api_calls.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<Leaderboard> leaderboardFuture;

  @override
  void initState() {
    super.initState();
    leaderboardFuture = ApiCalls.getLeaderboard();
  }

  Future<void> _refreshLeaderboard() async {
    setState(() {
      leaderboardFuture = ApiCalls.getLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: FutureBuilder<Leaderboard>(
        future: leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final leaderboard = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshLeaderboard,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: leaderboard.leaderboard.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Season: ${leaderboard.startDate.toLocal().toString().split(' ')[0]} - '
                        '${leaderboard.endDate.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  final entry = leaderboard.leaderboard[index - 1];
                  return ListTile(
                    leading: CircleAvatar(child: Text('$index')),
                    title: GestureDetector(child: Text(entry.username),
                      onTap: () {
                        Navigator.pushNamed(context, '/profile', arguments: entry.username);
                      },
                    ),
                    trailing: Text('${entry.points} pts'),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No leaderboard data available.'));
          }
        },
      ),
    );
  }
}
