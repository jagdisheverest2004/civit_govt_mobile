import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/post_data.dart' as postData;
import '../data/post_model.dart';
import 'dart:io';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _descController = TextEditingController();
  final _customIssueController = TextEditingController();

  String? _selectedTitle;
  String? _selectedIssue;
  String? _selectedDepartment;
  String? _selectedCommunity;
  String? _imagePath;
  String? _videoPath;

  final ImagePicker _picker = ImagePicker();

  // Departments (Tamil Nadu Govt.)
  final List<String> _departments = [
    "Agriculture & Farmers Welfare",
    "Animal Husbandry, Dairying and Fisheries",
    "Adi Dravidar & Tribal Welfare",
    "Backward Classes, Minorities Welfare",
    "Commercial Taxes & Registration",
    "Co-operation, Food and Consumer Protection",
    "Energy (Electricity)",
    "Environment & Forests",
    "Finance",
    "Handlooms, Textiles & Khadi",
    "Health & Family Welfare",
    "Higher Education",
    "Highways & Minor Ports",
    "Home, Prohibition & Excise (Police)",
    "Housing & Urban Development",
    "Industries",
    "Information Technology & Digital Services",
    "Labour & Employment",
    "Law",
    "Municipal Administration & Water Supply",
    "Public Works",
    "Revenue & Disaster Management",
    "Rural Development & Panchayat Raj",
    "School Education",
    "Social Welfare & Women Empowerment",
    "Transport",
    "Tourism, Culture & Religious Endowments",
    "Water Resources",
    "Welfare of Differently Abled Persons",
    "Youth Welfare & Sports Development",
  ];

  // Common issues
  final List<String> _issues = [
    "Pothole",
    "Streetlight Not Working",
    "Garbage Not Collected",
    "No Water Supply",
    "Water Leakage",
    "Illegal Construction",
    "Flooded Road",
    "Noise Pollution",
    "Power Cut",
    "Broken Pipeline",
    "Other", // triggers custom text field
  ];

  // Communities (use districts as base level)
  final List<String> _communities = [
    "Chennai",
    "Coimbatore",
    "Madurai",
    "Tiruchirappalli",
    "Salem",
    "Tirunelveli",
    "Erode",
    "Vellore",
    "Thoothukudi",
    "Kanchipuram",
    "Dindigul",
    "Thanjavur",
    "Virudhunagar",
    "Karur",
    "Sivaganga",
    "Nagapattinam",
    "Krishnagiri",
    "Namakkal",
    "Ramanathapuram",
    "Tiruppur",
    "Tiruvannamalai",
    "Villupuram",
    "Kanyakumari",
    "Dharmapuri",
    "Ariyalur",
    "Perambalur",
    "Thiruvarur",
    "Nilgiris",
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _videoPath = pickedFile.path;
      });
    }
  }

  void _submitPost() {
    if (_selectedTitle == null ||
        _selectedIssue == null ||
        _selectedDepartment == null ||
        _selectedCommunity == null ||
        _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    // If issue = Other, take from custom text field
    String issueToSave = _selectedIssue == "Other"
        ? _customIssueController.text
        : _selectedIssue!;

    final newPost = Post(
      username: "Kailash", // Hardcoded sample username
      community: _selectedCommunity!,
      title: _selectedTitle!,
      description: "$issueToSave - ${_descController.text}",
      imagePath: _imagePath,
      videoPath: _videoPath,
    );

    setState(() {
      postData.dummyPosts.insert(0, newPost);
      _descController.clear();
      _customIssueController.clear();
      _imagePath = null;
      _videoPath = null;
      _selectedTitle = null;
      _selectedIssue = null;
      _selectedDepartment = null;
      _selectedCommunity = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post submitted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Issue")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title field
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Title",
                ),
                onChanged: (val) {
                  _selectedTitle = val;
                },
              ),
              const SizedBox(height: 16),

              // Issue Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedIssue,
                hint: const Text("Select Issue"),
                items: _issues.map((issue) {
                  return DropdownMenuItem(value: issue, child: Text(issue));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIssue = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Issue",
                ),
              ),
              const SizedBox(height: 16),

              // Show custom text field if "Other" is selected
              if (_selectedIssue == "Other")
                TextField(
                  controller: _customIssueController,
                  decoration: const InputDecoration(
                    labelText: "Enter custom issue",
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 16),

              // Department Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedDepartment,
                hint: const Text("Select Department"),
                items: _departments.map((dept) {
                  return DropdownMenuItem(value: dept, child: Text(dept));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Department",
                ),
              ),
              const SizedBox(height: 16),

              // Community Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCommunity,
                hint: const Text("Select Community"),
                items: _communities.map((comm) {
                  return DropdownMenuItem(value: comm, child: Text(comm));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCommunity = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Community",
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Enter description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Image/Video buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Image"),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickVideo,
                      icon: const Icon(Icons.videocam),
                      label: const Text("Video"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text("Submit"),
              ),
              const SizedBox(height: 16),

              // Preview image/video
              if (_imagePath != null)
                Image.file(File(_imagePath!), height: 150),
              if (_videoPath != null)
                Text("Video selected: ${_videoPath!.split('/').last}"),
            ],
          ),
        ),
      ),
    );
  }
}
