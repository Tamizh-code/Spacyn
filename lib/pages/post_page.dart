import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // for Web images
import 'package:share_plus/share_plus.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () => _openCreatePost(),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    Widget? imageWidget;
    if (post["imageBytes"] != null) {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.memory(
          post["imageBytes"],
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageWidget != null) imageWidget,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post["title"] ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(post["description"] ?? "", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(post["isLiked"] ? Icons.favorite : Icons.favorite_border, color: Colors.deepPurple),
                          onPressed: () {
                            setState(() {
                              post["isLiked"] = !post["isLiked"];
                              post["likes"] += post["isLiked"] ? 1 : -1;
                            });
                          },
                        ),
                        Text("${post["likes"]}"),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined, color: Colors.deepPurple),
                      onPressed: () => _openComments(post),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.deepPurple),
                      onPressed: () => Share.share("${post["title"]} - ${post["description"]}"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openComments(Map<String, dynamic> post) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: post["comments"].length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepPurple),
                  title: Text(post["comments"][index]),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(hintText: "Write a comment...", border: OutlineInputBorder()),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: () {
                      setState(() {
                        post["comments"].add(commentController.text);
                      });
                      Navigator.pop(context);
                      _openComments(post);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _openCreatePost() async {
    Uint8List? imageBytes;
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Create Post", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Title", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: "Description", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white),
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                    if (result != null && result.files.isNotEmpty) {
                      imageBytes = result.files.first.bytes;
                      setState(() {}); // refresh UI
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white),
                  child: const Text("Post"),
                  onPressed: () {
                    setState(() {
                      posts.insert(0, {
                        "title": titleController.text,
                        "description": descController.text,
                        "imageBytes": imageBytes,
                        "likes": 0,
                        "isLiked": false,
                        "comments": <String>[],
                      });
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
