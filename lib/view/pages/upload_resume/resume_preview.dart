import 'package:flutter/material.dart';

class ResumePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Widget selectedTemplate; // Antha specific template widget inge varum

  ResumePreviewScreen({required this.userData, required this.selectedTemplate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101820),
      appBar: AppBar(
        title: Text("Final Preview", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.cyanAccent),
            onPressed: () {
              // Logic to share resume
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Resume Page Preview
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black54, blurRadius: 15, offset: Offset(0, 5))
                ],
              ),
              child: SingleChildScrollView(
                child: selectedTemplate, // Select panna template inge display aagum
              ),
            ),
          ),

          // Download Action Bar
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1E2732),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Text(
                  "Your resume is ready to download!",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          // PDF Download Logic
                          _showSuccessDialog(context);
                        },
                        icon: Icon(Icons.picture_as_pdf, color: Colors.black),
                        label: Text("Save as PDF",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E2732),
        title: Text("Success", style: TextStyle(color: Colors.cyanAccent)),
        content: Text("Resume saved successfully to your gallery.",
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}