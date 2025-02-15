import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MeetingApp());
}

class MeetingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MeetingScreen(),
    );
  }
}

class MeetingScreen extends StatefulWidget {
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _objectivesController = TextEditingController();
  final TextEditingController _constraintsController = TextEditingController();
  String recommendation = "";

  Future<void> sendMeetingData() async {
    final url = Uri.parse('http://127.0.0.1:8000/analyze_meeting'); // Backend URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": _nameController.text,
        "objectives": _objectivesController.text.split(","),
        "constraints": _constraintsController.text.split(","),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        recommendation = jsonDecode(response.body)['recommendation'];
      });
    } else {
      setState(() {
        recommendation = "Error fetching recommendation.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meeting 2.0")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Meeting Name")),
            TextField(controller: _objectivesController, decoration: InputDecoration(labelText: "Objectives (comma-separated)")),
            TextField(controller: _constraintsController, decoration: InputDecoration(labelText: "Constraints (comma-separated)")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: sendMeetingData, child: Text("Get AI Recommendation")),
            SizedBox(height: 20),
            Text(recommendation, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
