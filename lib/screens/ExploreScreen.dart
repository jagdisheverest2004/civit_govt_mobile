import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/post_card.dart';
import '../data/post_model.dart';

class ExploreScreen extends StatefulWidget {
  final String? currentCommunity;

  const ExploreScreen({super.key, this.currentCommunity});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Post> posts = [];
  List<String> recommendedDepartments = [
    "Health",
    "Education",
    "Transport",
    "Environment",
    "Public Safety",
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(
          // 👉 Add your endpoint here
          "",
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          posts = data.map((json) => Post.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore - ${widget.currentCommunity ?? "All"}"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended Departments
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Recommended Departments",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedDepartments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ActionChip(
                            label: Text(recommendedDepartments[index]),
                            onPressed: () {
                              // 👉 Later you can navigate to department page
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  // Posts
                  posts.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No posts available in your community.",
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                        ),
                ],
              ),
            ),
    );
  }
}
