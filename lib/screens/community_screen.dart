import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class CommunityScreen extends StatelessWidget {
  final String community;

  const CommunityScreen({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("x/$community")),
      body: ListView(
        children: [
          // Banner
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                "Welcome to x/$community",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Example posts
          PostCard(
            username: "user123",
            community: community,
            title: "First post in $community",
            description: "This is an example discussion in $community.",
            likes: 10,
            comments: 2,
          ),
          PostCard(
            username: "civic_user",
            community: community,
            title: "Another update",
            description: "Sharing an update related to $community issues.",
            likes: 5,
            comments: 1,
          ),
        ],
      ),
    );
  }
}
