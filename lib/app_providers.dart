import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'config/app_themes.dart';
import 'data/post_model.dart';
import 'data/post_data.dart';
import 'utils/distance_utils.dart';

// ============================================================================
// THEME PROVIDER
// ============================================================================
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(darkTheme);

  void toggleTheme() {
    state = state.brightness == Brightness.dark ? lightTheme : darkTheme;
  }
}

// ============================================================================
// USER LOCATION PROVIDER
// ============================================================================
final userLocationProvider = StateNotifierProvider<UserLocationNotifier, AsyncValue<Position?>>(
  (ref) => UserLocationNotifier(),
);

// ============================================================================
// FILTER PROVIDERS
// ============================================================================
class IssueFilters {
  final String? department;
  final String? status;
  final bool showNearby;

  IssueFilters({
    this.department,
    this.status,
    this.showNearby = false,
  });

  IssueFilters copyWith({
    String? department,
    String? status,
    bool? showNearby,
  }) {
    return IssueFilters(
      department: department ?? this.department,
      status: status ?? this.status,
      showNearby: showNearby ?? this.showNearby,
    );
  }
}

class UserLocationNotifier extends StateNotifier<AsyncValue<Position?>> {
  UserLocationNotifier() : super(const AsyncValue.loading()) {
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = AsyncValue.error(
          'Location services are disabled.',
          StackTrace.current,
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = AsyncValue.error(
            'Location permissions are denied',
            StackTrace.current,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = AsyncValue.error(
          'Location permissions are permanently denied',
          StackTrace.current,
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      state = AsyncValue.data(position);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    await _getCurrentLocation();
  }
}

// ============================================================================
// ISSUES PROVIDER
// ============================================================================
final issuesProvider = StateNotifierProvider<IssuesNotifier, List<Post>>(
  (ref) => IssuesNotifier(),
);

class IssuesNotifier extends StateNotifier<List<Post>> {
  IssuesNotifier() : super(dummyPosts);

  void addIssue(Post post) {
    state = [post, ...state];
  }

  void updateIssue(int index, Post post) {
    final newState = [...state];
    newState[index] = post;
    state = newState;
  }

  void removeIssue(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }

  void toggleUpvote(int index) {
    final newState = [...state];
    final post = newState[index];
    if (post.isUpvoted) {
      post.likes -= 1;
      post.isUpvoted = false;
    } else {
      post.likes += 1;
      post.isUpvoted = true;
    }
    state = newState;
  }
}

// ============================================================================
// FILTERS PROVIDER
// ============================================================================
final filtersProvider = StateNotifierProvider<FiltersNotifier, IssueFilters>(
  (ref) => FiltersNotifier(),
);

// Using the IssueFilters class defined above

class FiltersNotifier extends StateNotifier<IssueFilters> {
  FiltersNotifier() : super(IssueFilters());

  void setDepartment(String? department) {
    state = state.copyWith(department: department);
  }

  void setStatus(String? status) {
    state = state.copyWith(status: status);
  }

  void setShowNearby(bool show) {
    state = state.copyWith(showNearby: show);
  }

  void clearFilters() {
    state = IssueFilters();
  }
}

// ============================================================================
// FILTERED ISSUES PROVIDER
// ============================================================================
final filteredIssuesProvider = Provider<List<Post>>((ref) {
  final issues = ref.watch(issuesProvider);
  final filters = ref.watch(filtersProvider);
  final locationAsync = ref.watch(userLocationProvider);

  // Start with all issues
  List<Post> filtered = issues;

  // Filter by department
  if (filters.department != null && filters.department!.isNotEmpty) {
    filtered = filtered.where((post) => 
      post.department.toLowerCase() == filters.department!.toLowerCase()
    ).toList();
  }

  // Filter by status
  if (filters.status != null && filters.status!.isNotEmpty) {
    filtered = filtered.where((post) => 
      post.status.toLowerCase() == filters.status!.toLowerCase()
    ).toList();
  }

  // Filter by proximity (if location is available)
  if (filters.showNearby && locationAsync.hasValue && locationAsync.value != null) {
    final userPos = locationAsync.value!;
    filtered = filtered.where((post) {
      if (post.latitude == null || post.longitude == null) return false;
      
      final distance = haversineDistance(
        userPos.latitude,
        userPos.longitude,
        post.latitude!,
        post.longitude!,
      );
      
      return distance <= 2000; // 2km in meters
    }).toList();
  }

  return filtered;
});
