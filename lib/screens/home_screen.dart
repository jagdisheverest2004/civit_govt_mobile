import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import '../widgets/post_card.dart';
import '../app_providers.dart';
import 'issue_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;

  Future<void> _refreshIssues() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Refresh location
    await ref.read(userLocationProvider.notifier).refreshLocation();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredIssues = ref.watch(filteredIssuesProvider);
    final locationAsync = ref.watch(userLocationProvider);
    final theme = ref.watch(themeProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Location status banner
        locationAsync.when(
          data: (position) {
            if (position != null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green.withOpacity(0.2),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location enabled • Showing nearby issues',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.green[200] : Colors.green[800],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 16),
                      onPressed: () => ref.read(userLocationProvider.notifier).refreshLocation(),
                      tooltip: 'Refresh location',
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
          loading: () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.orange.withOpacity(0.2),
            child: const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Getting your location...',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          error: (error, stack) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.red.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(Icons.location_off, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location disabled • Showing all issues',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.red[200] : Colors.red[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Issues list
        Expanded(
          child: _isLoading
              ? _buildLoadingShimmer()
              : filteredIssues.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _refreshIssues,
                      color: Colors.orange,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredIssues.length,
                        itemBuilder: (context, index) {
                          final issue = filteredIssues[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IssueDetailScreen(issue: issue),
                                ),
                              );
                            },
                            child: PostCard(
                              username: issue.username,
                              community: issue.community,
                              title: issue.title,
                              description: issue.description,
                              imagePath: issue.imagePath,
                              comments: issue.comments,
                              likes: issue.likes,
                              isUpvoted: issue.isUpvoted,
                              tag: issue.department,
                              onToggleUpvote: () {
                                ref.read(issuesProvider.notifier).toggleUpvote(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[700]!,
          highlightColor: Colors.grey[600]!,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/animations/empty.json',
              fit: BoxFit.contain,
              // Fallback to icon if animation not found
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.inbox_outlined,
                  size: 100,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No issues found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
