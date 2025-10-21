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
    switch (status) {
      case 'open':
        return Colors.red;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildFilterGrid(bool isDark, dynamic filters) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: departments.length + statuses.length,
        itemBuilder: (context, index) {
          bool isDepartmentFilter = index < departments.length;
          String label = isDepartmentFilter 
              ? departments[index]
              : statuses[index - departments.length];
          bool isSelected = isDepartmentFilter
              ? (label == 'All' ? filters.department == null : filters.department == label)
              : (label == 'All' ? filters.status == null : filters.status == label);
          
          return Material(
            color: isSelected 
                ? (isDepartmentFilter ? Colors.orange : _getStatusColor(label)).withOpacity(0.2)
                : isDark ? Colors.grey[850]! : Colors.grey[100]!,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                if (isDepartmentFilter) {
                  if (label == 'All') {
                    ref.read(filtersProvider.notifier).setDepartment(null);
                  } else {
                    ref.read(filtersProvider.notifier).setDepartment(
                      filters.department == label ? null : label
                    );
                  }
                } else {
                  if (label == 'All') {
                    ref.read(filtersProvider.notifier).setStatus(null);
                  } else {
                    ref.read(filtersProvider.notifier).setStatus(
                      filters.status == label ? null : label
                    );
                  }
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: Text(
                  label == 'All' ? label : label.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? isDepartmentFilter ? Colors.orange : _getStatusColor(label)
                        : isDark ? Colors.white70 : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
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
        title: const Text('Explore Issues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(filtersProvider.notifier).clearFilters();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterGrid(isDark, filters),
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
            const Expanded(
              child: Center(
                child: Text(
                  'No issues found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
