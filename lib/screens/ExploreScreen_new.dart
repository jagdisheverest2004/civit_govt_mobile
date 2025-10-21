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
  bool _showFilters = false;

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

  IconData _getDepartmentIcon(String department) {
    switch (department.toLowerCase()) {
      case 'public works':
        return Icons.construction;
      case 'parks & recreation':
        return Icons.park;
      case 'transportation':
        return Icons.directions_bus;
      case 'utilities':
        return Icons.power;
      case 'public safety':
        return Icons.local_police;
      case 'environmental':
        return Icons.eco;
      default:
        return Icons.category;
    }
  }

  Widget _buildFilterChips({
    required List<String> items,
    required bool isDark,
    required String? selectedValue,
    required Function(String?) onSelected,
    required bool isDepartment,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: items.map((label) {
        final isSelected = label == 'All' ? selectedValue == null : selectedValue == label;
        final color = isDepartment 
            ? Colors.orange 
            : _getStatusColor(label);
            
        return Material(
          elevation: isSelected ? 4 : 0,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isSelected ? LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
              color: isSelected 
                  ? null 
                  : isDark ? Colors.grey[850] : Colors.grey[200],
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (label == 'All') {
                  onSelected(null);
                } else {
                  onSelected(selectedValue == label ? null : label);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected && !isDepartment)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Icon(
                        Icons.check_circle,
                        size: 14,
                        color: color,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isDepartment && label != 'All')
                          Icon(
                            _getDepartmentIcon(label),
                            size: 16,
                            color: isSelected ? color : isDark ? Colors.white70 : Colors.black54,
                          ),
                        const SizedBox(height: 2),
                        Text(
                          label == 'All' ? label : label.replaceAll('_', ' ').toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? color
                                : isDark ? Colors.white70 : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterSection(bool isDark, dynamic filters) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showFilters ? null : 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _showFilters ? 1.0 : 0.0,
        child: Container(
          color: isDark ? Colors.grey[850] : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.category_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Department',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildFilterChips(
                  items: departments,
                  isDark: isDark,
                  selectedValue: filters.department,
                  onSelected: (value) => ref.read(filtersProvider.notifier).setDepartment(value),
                  isDepartment: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.playlist_add_check_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildFilterChips(
                  items: statuses,
                  isDark: isDark,
                  selectedValue: filters.status,
                  onSelected: (value) => ref.read(filtersProvider.notifier).setStatus(value),
                  isDepartment: false,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.explore,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Explore Issues',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: _showFilters || filters.department != null || filters.status != null
                      ? Colors.orange
                      : isDark ? Colors.white70 : Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                tooltip: 'Toggle filters',
              ),
              if (filters.department != null || filters.status != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(isDark, filters),
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
                    onPressed: () {
                      ref.read(filtersProvider.notifier).clearFilters();
                      setState(() {
                        _showFilters = false;
                      });
                    },
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
          const Divider(height: 1),
          Expanded(
            child: filteredIssues.isEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDark 
                                        ? Colors.grey[800]!.withOpacity(0.5) 
                                        : Colors.grey[100]!,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search_off_rounded,
                                    size: 48,
                                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No issues found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                    color: isDark ? Colors.white70 : Colors.grey[800],
                                  ),
                                ),
                                if (filters.department != null || filters.status != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Try adjusting your filters',
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredIssues.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final issue = filteredIssues[index];
                      return IssueCard(issue: issue);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}