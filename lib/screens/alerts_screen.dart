import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications
    NotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        "title": "⚠️ Waterlogging in Anna Nagar",
        "description":
            "Heavy rains have caused waterlogging in multiple streets. Avoid travel in low-lying areas.",
        "time": "10 mins ago",
        "color": Colors.blueAccent,
      },
      {
        "title": "🚧 Road Block at Mount Road",
        "description":
            "Major road work is ongoing. Expect heavy traffic and take alternate routes.",
        "time": "1 hr ago",
        "color": Colors.orange,
      },
      {
        "title": "🔥 Fire Accident near T Nagar Market",
        "description":
            "Fire services are at the spot. Please avoid the area and follow official updates.",
        "time": "2 hrs ago",
        "color": Colors.redAccent,
      },
      {
        "title": "💡 Power Outage Scheduled",
        "description":
            "Electricity Dept. announced power cut tomorrow 10AM–2PM in Chennai Central for maintenance.",
        "time": "5 hrs ago",
        "color": Colors.yellow.shade700,
      },
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: alert["color"],
                child: const Icon(Icons.warning, color: Colors.white),
              ),
              title: Text(
                alert["title"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "${alert["description"]}\n${alert["time"]}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
