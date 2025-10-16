import 'package:flutter/material.dart';
import 'dart:io';

class PostCard extends StatefulWidget {
  final String username;
  final String community;
  final String title;
  final String description;
  final String? imagePath;
  int likes;
  final int comments;
  bool isUpvoted;
  final String? tag;
  final VoidCallback? onToggleUpvote;

  PostCard({
    super.key,
    required this.username,
    required this.community,
    required this.title,
    required this.description,
    this.imagePath,
    this.likes = 0,
    this.comments = 0,
    this.isUpvoted = false,
    this.tag,
    this.onToggleUpvote,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void _toggleUpvote() {
    setState(() {
      if (widget.isUpvoted) {
        widget.isUpvoted = false;
        widget.likes -= 1;
      } else {
        widget.isUpvoted = true;
        widget.likes += 1;
      }
    });

    if (widget.onToggleUpvote != null) {
      widget.onToggleUpvote!();
    }
  }

  /// Flair color logic
  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case "road safety":
        return Colors.redAccent;
      case "water issue":
        return Colors.blueAccent;
      case "sanitation":
        return Colors.green;
      case "electricity":
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top info row with small flair
            Row(
              children: [
                Text(
                  "x/${widget.community}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (widget.tag != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getTagColor(widget.tag!).withOpacity(0.15),
                      border: Border.all(
                        color: _getTagColor(widget.tag!),
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.tag!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _getTagColor(widget.tag!),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  "u/${widget.username}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            /// Description
            Text(
              widget.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            /// Image (if present)
            if (widget.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(widget.imagePath!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            /// Actions row
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    widget.isUpvoted
                        ? Icons.arrow_upward
                        : Icons.arrow_upward_outlined,
                    color: widget.isUpvoted ? Colors.orange : Colors.white,
                  ),
                  onPressed: _toggleUpvote,
                ),
                Text(
                  "${widget.likes}",
                  style: TextStyle(
                    color: widget.isUpvoted ? Colors.orange : Colors.white,
                    fontWeight: widget.isUpvoted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.comment_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  "${widget.comments}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
