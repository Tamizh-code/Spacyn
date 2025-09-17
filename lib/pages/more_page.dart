import 'package:flutter/material.dart';
import 'election_page.dart'; // now exists ✅

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ElectionPage()),
            );
          },
          child: Text("Open Election Portal"),
        ),
      ),
    );
  }
}
