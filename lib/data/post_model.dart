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
      latitude: json['latitude'],
      longitude: json['longitude'],
      department: json['department'] ?? '',
      status: json['status'] ?? 'open',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      assignedOfficer: json['assignedOfficer'],
      contributors: List<String>.from(json['contributors'] ?? []),
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
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
  
  // New fields for enhanced features
  final double? latitude;
  final double? longitude;
  final String department;
  final String status; // 'open', 'in_progress', 'resolved'
  final DateTime timestamp;
  final String? assignedOfficer;
  final List<String> contributors;
  final List<String> mediaUrls;

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
    this.latitude,
    this.longitude,
    this.department = '',
    this.status = 'open',
    DateTime? timestamp,
    this.assignedOfficer,
    this.contributors = const [],
    this.mediaUrls = const [],
  }) : timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'community': community,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'videoPath': videoPath,
      'likes': likes,
      'comments': comments,
      'isUpvoted': isUpvoted,
      'latitude': latitude,
      'longitude': longitude,
      'department': department,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'assignedOfficer': assignedOfficer,
      'contributors': contributors,
      'mediaUrls': mediaUrls,
    };
  }
}
