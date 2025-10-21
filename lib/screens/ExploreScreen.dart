import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:badges/badges.dart' as badges;
import '../app_providers.dart';
import 'issue_detail_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String? currentCommunity;

  const ExploreScreen({super.key, this.currentCommunity});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final List<String> departments = [
    "All",
    "Road Safety",
    "Water Issue",
    "Sanitation",
    "Electricity",
    "Health",
    "Education",
  ];

  final List<String> statuses = [
    "All",
    "open",
    "in_progress",
    "resolved",
  ];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final filteredIssues = ref.watch(filteredIssuesProvider);
    final filters = ref.watch(filtersProvider);
    final theme = ref.watch(themeProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // Department Filter Chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter by Department",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: departments.map((dept) {
                        final isSelected = filters.department == dept ||
                            (dept == "All" && filters.department == null);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(dept),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (dept == "All") {
                                ref.read(filtersProvider.notifier).setDepartment(null);
                              } else {
                                ref.read(filtersProvider.notifier).setDepartment(dept);
                              }
                            },
                            selectedColor: Colors.orange,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Status Filter Chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter by Status",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: statuses.map((status) {
                        final isSelected = filters.status == status ||
                            (status == "All" && filters.status == null);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(status == "All" ? status : status.replaceAll('_', ' ').toUpperCase()),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (status == "All") {
                                ref.read(filtersProvider.notifier).setStatus(null);
                              } else {
                                ref.read(filtersProvider.notifier).setStatus(status);
                              }
                            },
                            selectedColor: Colors.blue,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nearby Filter Toggle
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SwitchListTile(
                title: const Text(
                  "Show only nearby issues (2km)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  filters.onlyNearby 
                      ? "Showing issues within ${filters.maxDistance ~/1000}km"
                      : "Showing all issues",
                  style: const TextStyle(fontSize: 12),
                ),
                value: filters.onlyNearby,
                activeThumbColor: Colors.orange,
                onChanged: (value) {
                  ref.read(filtersProvider.notifier).toggleNearbyOnly();
                },
                secondary: badges.Badge(
                  badgeContent: Text(
                    '${filteredIssues.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.orange,
                  ),
                  child: const Icon(Icons.location_on, color: Colors.orange),
                ),
              ),
            ),
          ),

          // Clear Filters Button
          if (filters.department != null ||
              filters.status != null ||
              filters.onlyNearby)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextButton.icon(
                  onPressed: () {
                    ref.read(filtersProvider.notifier).clearFilters();
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear All Filters"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: Divider(),
          ),

          // Results Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "${filteredIssues.length} ${filteredIssues.length == 1 ? 'issue' : 'issues'} found",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Issues Grid
          filteredIssues.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No issues match your filters",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Try adjusting your filters",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: filteredIssues.length,
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
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(issue.status).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    issue.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(issue.status),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Title
                                Text(
                                  issue.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Department
                                Text(
                                  issue.department,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Stats
                                Row(
                                  children: [
                                    Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${issue.likes}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.comment_outlined, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${issue.comments}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
