import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: PostPage()));

class Post {
  final String imageUrl;
  final String caption;

  Post({required this.imageUrl, required this.caption});
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Post> _posts = [];

  void _addPost(String imageUrl, String caption) {
    setState(() {
      _posts.insert(0, Post(imageUrl: imageUrl, caption: caption));
    });
  }

  void _showAddPostDialog() {
    String imageUrl = '';
    String caption = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Image URL"),
              onChanged: (value) => imageUrl = value,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Caption"),
              onChanged: (value) => caption = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (imageUrl.isNotEmpty && caption.isNotEmpty) {
                _addPost(imageUrl, caption);
              }
              Navigator.pop(context);
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Page")),
      body: _posts.isEmpty
          ? Center(child: Text("No posts yet. Tap + to add one!"))
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(post.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 200, color: Colors.grey[300], child: Center(child: Text("Invalid Image URL"))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post.caption, style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: Icon(Icons.add),
      ),
    );
  }

