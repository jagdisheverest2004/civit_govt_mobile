import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../app_providers.dart';
import '../services/location_service.dart';
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
    "OPEN",
    "IN PROGRESS",
    "RESOLVED",
  ];

  bool showFilters = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredIssues = ref.watch(filteredIssuesProvider);
    final filters = ref.watch(filtersProvider);
    final theme = ref.watch(themeProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Filter Button
              SliverAppBar(
                floating: true,
                backgroundColor: isDark ? Colors.grey[850] : Colors.white,
                title: Row(
                  children: [
                    Text(
                      'Issues',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => setState(() => showFilters = !showFilters),
                    ),
                  ],
                ),
              ),

              // Issues Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final issue = filteredIssues[index];
                      return IssueCard(issue: issue);
                    },
                    childCount: filteredIssues.length,
                  ),
                ),
              ),
            ],
          ),

          // Filter Panel
          if (showFilters)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: isDark ? Colors.black87 : Colors.white,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Filter Issues',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => setState(() => showFilters = false),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // Department Filter
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(
                              'Department',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: departments.map((dept) {
                                final isSelected = filters.department == dept ||
                                    (dept == "All" && filters.department == null);
                                return ChoiceChip(
                                  label: Text(dept),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    ref.read(filtersProvider.notifier).setDepartment(
                                          selected ? (dept == "All" ? null : dept) : null,
                                        );
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Status Filter
                            Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: statuses.map((status) {
                                final isSelected = filters.status?.toUpperCase() == status ||
                                    (status == "All" && filters.status == null);
                                return ChoiceChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    ref.read(filtersProvider.notifier).setStatus(
                                          selected
                                              ? (status == "All" ? null : status.toLowerCase())
                                              : null,
                                        );
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Location Filter
                            SwitchListTile(
                              title: const Text('Show Nearby Issues Only'),
                              subtitle: Text(
                                'Within 2km of your location',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                              value: filters.showNearby,
                              onChanged: (value) async {
                                if (value) {
                                  final permission = await LocationService.checkPermission();
                                  if (permission == LocationPermission.whileInUse ||
                                      permission == LocationPermission.always) {
                                    ref.read(filtersProvider.notifier).setShowNearby(true);
                                  }
                                } else {
                                  ref.read(filtersProvider.notifier).setShowNearby(false);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final dynamic issue;

  const IssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IssueDetailScreen(issue: issue),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  image: DecorationImage(
                    image: NetworkImage(issue.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    issue.department,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(issue.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          issue.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${issue.upvotes}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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