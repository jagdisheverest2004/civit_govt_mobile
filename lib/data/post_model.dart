class Post {
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'] ?? '',
      community: json['community'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'],
      videoPath: json['videoPath'],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isUpvoted: json['isUpvoted'] ?? false,
    );
  }
  final String username;
  final String community;
  final String title;
  final String description;
  final String? imagePath;
  final String? videoPath;
  int likes;
  int comments;
  bool isUpvoted;

  Post({
    required this.username,
    required this.community,
    required this.title,
    required this.description,
    this.imagePath,
    this.videoPath,
    this.likes = 0,
    this.comments = 0,
    this.isUpvoted = false,
  });
}
