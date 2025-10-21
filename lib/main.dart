import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_providers.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/post_screen.dart';
import 'screens/ExploreScreen.dart';
import 'screens/status_screen.dart'; // Issues
import 'screens/alerts_screen.dart'; // Notifications
import 'screens/community_screen.dart'; // ✅ import for community pages
import 'widgets/app_header.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  
  runApp(
    const ProviderScope(child: CivicIssueApp()),
  );
}

class CivicIssueApp extends ConsumerWidget {
  const CivicIssueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Civic Issues',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const MainLayout(),
    );
  }
}

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Home feed
    const ExploreScreen(), // Explore
    PostScreen(), // Post new issue
    const StatusScreen(), // Issues
    const AlertsScreen(), // Notifications
  ];

  void _openCommunity(BuildContext context, String community) {
    Navigator.pop(context); // close drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityScreen(community: community),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                "Communities",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            /// Tamil Nadu Cities
            ExpansionTile(
              leading: const Icon(
                Icons.location_city,
                color: Colors.blueAccent,
              ),
              title: const Text("x/TamilNadu Cities"),
              children: [
                ListTile(
                  title: const Text("x/Chennai"),
                  onTap: () => _openCommunity(context, "Chennai"),
                ),
                ListTile(
                  title: const Text("x/Coimbatore"),
                  onTap: () => _openCommunity(context, "Coimbatore"),
                ),
                ListTile(
                  title: const Text("x/Madurai"),
                  onTap: () => _openCommunity(context, "Madurai"),
                ),
                ListTile(
                  title: const Text("x/Tiruchirappalli"),
                  onTap: () => _openCommunity(context, "Tiruchirappalli"),
                ),
                ListTile(
                  title: const Text("x/Salem"),
                  onTap: () => _openCommunity(context, "Salem"),
                ),
                ListTile(
                  title: const Text("x/Tirunelveli"),
                  onTap: () => _openCommunity(context, "Tirunelveli"),
                ),
              ],
            ),

            /// Departments
            ExpansionTile(
              leading: const Icon(
                Icons.account_balance,
                color: Colors.orangeAccent,
              ),
              title: const Text("d/Departments"),
              children: [
                ListTile(
                  title: const Text("d/Water"),
                  onTap: () => _openCommunity(context, "WaterDept"),
                ),
                ListTile(
                  title: const Text("d/RoadSafety"),
                  onTap: () => _openCommunity(context, "RoadSafetyDept"),
                ),
                ListTile(
                  title: const Text("d/Sanitation"),
                  onTap: () => _openCommunity(context, "SanitationDept"),
                ),
                ListTile(
                  title: const Text("d/Electricity"),
                  onTap: () => _openCommunity(context, "ElectricityDept"),
                ),
                ListTile(
                  title: const Text("d/Health"),
                  onTap: () => _openCommunity(context, "HealthDept"),
                ),
              ],
            ),

            const Divider(color: Colors.grey),

            /// Theme Toggle
            Consumer(
              builder: (context, ref, child) {
                final theme = ref.watch(themeProvider);
                final isDark = theme.brightness == Brightness.dark;
                
                return SwitchListTile(
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Toggle between light and dark themes"),
                  value: isDark,
                  activeThumbColor: Colors.orange,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.orange,
                  ),
                );
              },
            ),

            const Divider(color: Colors.grey),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Post"),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces),
            label: "Issues",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}
