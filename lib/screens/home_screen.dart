import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../data/post_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(
          username: post.username,
          community: post.community,
          title: post.title,
          description: post.description,
          imagePath: post.imagePath,
          comments: post.comments,
          likes: post.likes,
        );
      },
    );
  }
}
