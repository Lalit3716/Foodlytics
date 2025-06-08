import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodlytics/features/home/presentation/screens/home_screen.dart';
import 'package:foodlytics/features/profile/presentation/screens/profile_screen.dart';
import 'package:foodlytics/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:foodlytics/features/chatbot/presentation/screens/chatbot_screen.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/scanner');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildNavItem(0, Icons.home, 'Home')),
            Expanded(child: _buildNavItem(1, Icons.leaderboard, 'Leaderboard')),
            const Expanded(child: SizedBox()), // Space for FAB
            Expanded(child: _buildNavItem(2, Icons.chat, 'Chat')),
            Expanded(child: _buildNavItem(3, Icons.person, 'Profile')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.currentIndex == index;
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/leaderboard');
            break;
          case 2:
            context.go('/chatbot');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
} 