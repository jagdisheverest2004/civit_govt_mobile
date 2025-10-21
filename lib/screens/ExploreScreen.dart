import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_providers.dart';
import '../widgets/issue_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String? currentCommunity;

  const ExploreScreen({super.key, this.currentCommunity});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  static const List<String> departments = [
    'All',
    'Public Works',
    'Parks & Recreation',
    'Transportation',
    'Utilities',
    'Public Safety',
    'Environmental',
  ];

  static const List<String> statuses = [
    'All',
    'open',
    'in_progress',
    'resolved',
    'closed',
  ];

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

  Widget _buildFilterSection(bool isDark, dynamic filters) {
    return Container(
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Department',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final label = departments[index];
                final isSelected = label == 'All'
                    ? filters.department == null
                    : filters.department == label;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      if (label == 'All') {
                        ref.read(filtersProvider.notifier).setDepartment(null);
                      } else {
                        ref
                            .read(filtersProvider.notifier)
                            .setDepartment(
                              filters.department == label ? null : label,
                            );
                      }
                    },
                    backgroundColor: isDark
                        ? Colors.grey[850]
                        : Colors.grey[200],
                    selectedColor: Colors.orange.withOpacity(0.2),
                    checkmarkColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.orange
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                final label = statuses[index];
                final isSelected = label == 'All'
                    ? filters.status == null
                    : filters.status == label;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      label == 'All'
                          ? label
                          : label.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(fontSize: 12),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      if (label == 'All') {
                        ref.read(filtersProvider.notifier).setStatus(null);
                      } else {
                        ref
                            .read(filtersProvider.notifier)
                            .setStatus(filters.status == label ? null : label);
                      }
                    },
                    backgroundColor: isDark
                        ? Colors.grey[850]
                        : Colors.grey[200],
                    selectedColor: _getStatusColor(label).withOpacity(0.2),
                    checkmarkColor: _getStatusColor(label),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? _getStatusColor(label)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  @override
  Widget build(BuildContext context) {
    final filteredIssues = ref.watch(filteredIssuesProvider);
    final filters = ref.watch(filtersProvider);
    final theme = ref.watch(themeProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        title: const Text(
          'Explore Issues',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          if (filters.department != null || filters.status != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  ref.read(filtersProvider.notifier).clearFilters(),
              tooltip: 'Clear filters',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(isDark, filters),
          const Divider(height: 1),
          if (filters.department != null || filters.status != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Text(
                    '${filteredIssues.length} ${filteredIssues.length == 1 ? 'issue' : 'issues'} found',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(filtersProvider.notifier).clearFilters(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear filters'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ),
          if (filteredIssues.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredIssues.length,
                itemBuilder: (context, index) {
                  final issue = filteredIssues[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IssueCard(issue: issue),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No issues found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ),
                    if (filters.department != null || filters.status != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[600] : Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
