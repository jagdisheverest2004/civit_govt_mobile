import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample user data (replace with actual data from your backend/state management)
  final Map<String, dynamic> userData = {
    'name': 'Jagdish Kumar',
    'email': 'jagdish@example.com',
    'phone': '+91 9876543210',
    'location': 'Tamil Nadu, India',
    'issuesReported': 15,
    'issuesResolved': 8,
    'upvotes': 45,
    'comments': 23,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            // Handle bar and Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.orange,
                      tooltip: 'Back to Home',
                      iconSize: 22,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40), // Balance for the back button
                ],
              ),
            ),
            const SizedBox(height: 15),

            // User Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Profile Image and Basic Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orange[100],
                        child: Text(
                          userData['name'].toString().substring(0, 1),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userData['email'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              userData['phone'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats Cards
                  Row(
                    children: [
                      _buildStatCard(
                        'Issues Reported',
                        userData['issuesReported'].toString(),
                        Icons.report_problem_outlined,
                        Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Issues Resolved',
                        userData['issuesResolved'].toString(),
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildStatCard(
                        'Upvotes',
                        userData['upvotes'].toString(),
                        Icons.thumb_up_outlined,
                        Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Comments',
                        userData['comments'].toString(),
                        Icons.comment_outlined,
                        Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'My Issues'),
                Tab(text: 'Activity'),
                Tab(text: 'Settings'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // My Issues Tab
                  ListView.builder(
                    itemCount: 5, // Replace with actual data
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.report_problem_outlined, color: Colors.orange),
                          title: Text('Issue #${index + 1}'),
                          subtitle: Text('Status: ${index % 2 == 0 ? "In Progress" : "Resolved"}'),
                          trailing: Text(
                            '${DateTime.now().subtract(Duration(days: index)).day}/10/2023',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      );
                    },
                  ),

                  // Activity Tab
                  ListView.builder(
                    itemCount: 10, // Replace with actual data
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Icon(
                            index % 3 == 0 ? Icons.comment : (index % 3 == 1 ? Icons.thumb_up : Icons.share),
                            color: index % 3 == 0 ? Colors.blue : (index % 3 == 1 ? Colors.green : Colors.purple),
                          ),
                          title: Text(
                            index % 3 == 0
                                ? 'Commented on Issue #${index + 1}'
                                : (index % 3 == 1 ? 'Upvoted Issue #${index + 1}' : 'Shared Issue #${index + 1}'),
                          ),
                          subtitle: const Text('2 hours ago'),
                        ),
                      );
                    },
                  ),

                  // Settings Tab
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Handle edit profile
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Handle notifications settings
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('Privacy'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Handle privacy settings
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Help & Support'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Handle help and support
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          // Handle logout
                        },
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
}