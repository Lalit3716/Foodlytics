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
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () {
            context.push('/scanner');
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 72,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          padding: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width / 5; // Divide width into 5 equal parts
              
              return Row(
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _buildNavItem(0, Icons.home, 'Home'),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildNavItem(1, Icons.leaderboard, 'Board'),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: const SizedBox(), // Space for FAB
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildNavItem(2, Icons.chat, 'Chat'),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _buildNavItem(3, Icons.person, 'Profile'),
                  ),
                ],
              );
            }
          ),
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
          SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 