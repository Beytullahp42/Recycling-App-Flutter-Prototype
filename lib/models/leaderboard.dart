class LeaderboardEntry {
  final String username;
  final int points;

  LeaderboardEntry({
    required this.username,
    required this.points,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      username: json['username'],
      points: json['points'],
    );
  }
}

class Leaderboard {
  final List<LeaderboardEntry> leaderboard;
  final DateTime startDate;
  final DateTime endDate;

  Leaderboard({
    required this.leaderboard,
    required this.startDate,
    required this.endDate,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      leaderboard: (json['leaderboard'] as List)
          .map((e) => LeaderboardEntry.fromJson(e))
          .toList(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}
