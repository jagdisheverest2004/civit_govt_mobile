import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      titleSpacing: 0,
      title: const Text(
        "Civic Issues",
        style: TextStyle(
          color: Colors.orange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // TODO: Add search page later
          },
        ),

        // Profile avatar with popup menu
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          icon: const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage("assets/default_user.jpg"),
          ),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                _openProfile(context);
                break;
              case 'settings':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Settings coming soon!")),
                );
                break;
              case 'logout':
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Logged out")));
                // TODO: Add real logout logic
                break;
              case 'help':
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Help section")));
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Text(
                "View Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text("Settings", style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Text("Help", style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Text("Logout", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
