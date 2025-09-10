import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MorePage()));

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final List<String> _moreItems = ["Explore Features"];

  void _addMoreCard() {
    setState(() {
      _moreItems.add("More Option ${_moreItems.length + 1}");
    });
  }

  Widget buildMoreCard(String title) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.more_horiz, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("Tap to explore more options"),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tapped on '$title'")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Page")),
      body: ListView(
        children: _moreItems.map((item) => buildMoreCard(item)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMoreCard,
        child: Icon(Icons.add),
      ),
    );
  }
}