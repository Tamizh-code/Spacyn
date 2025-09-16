import 'package:flutter/material.dart';

class Group {
  String id;
  String name;
  String description;
  Color color;
  List<String> members;
  String admin;
  String? imageUrl;
  List<Map<String, dynamic>> messages;

  Group({
    required this.id,
    required this.name,
    this.description = '',
    Color? color,
    List<String>? members,
    required this.admin,
    this.imageUrl,
    List<Map<String, dynamic>>? messages,
  })  : color = color ?? Colors.deepPurple,
        members = members ?? [],
        messages = messages ?? [];
}
