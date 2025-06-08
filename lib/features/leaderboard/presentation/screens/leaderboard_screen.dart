import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final List<LeaderboardUser> _users = [
    LeaderboardUser(name: 'John Doe', points: 1250, rank: 1),
    LeaderboardUser(name: 'Jane Smith', points: 1120, rank: 2),
    LeaderboardUser(name: 'Robert Johnson', points: 980, rank: 3),
    LeaderboardUser(name: 'Lisa Williams', points: 875, rank: 4),
    LeaderboardUser(name: 'Michael Brown', points: 760, rank: 5),
    LeaderboardUser(name: 'Emily Davis', points: 740, rank: 6),
    LeaderboardUser(name: 'Daniel Miller', points: 695, rank: 7),
    LeaderboardUser(name: 'Sarah Wilson', points: 650, rank: 8),
    LeaderboardUser(name: 'James Taylor', points: 610, rank: 9),
    LeaderboardUser(name: 'Jennifer Anderson', points: 590, rank: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildLeaderboardHeader(),
          Expanded(
            child: _buildLeaderboardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTopRanker(_users[1], 2),
                _buildTopRanker(_users[0], 1, isFirst: true),
                _buildTopRanker(_users[2], 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRanker(LeaderboardUser user, int position, {bool isFirst = false}) {
    final double avatarSize = isFirst ? 80 : 60;
    final double textSize = isFirst ? 16 : 14;
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.white,
              child: Text(
                user.name.substring(0, 1),
                style: TextStyle(
                  fontSize: avatarSize / 2,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRankColor(position),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user.name,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${user.points} pts',
          style: TextStyle(
            fontSize: textSize - 2,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      itemCount: _users.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(user.rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${user.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${user.points} pts',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue[300]!;
    }
  }
}

class LeaderboardUser {
  final String name;
  final int points;
  final int rank;

  LeaderboardUser({
    required this.name,
    required this.points,
    required this.rank,
  });
} 