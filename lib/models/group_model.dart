import 'package:flutter/material.dart';

enum ImageSourceType { network, file, none }

class Group {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final Color color;
  final List<String> members;
  final String admin;
  final ImageSourceType imageSourceType;
  final int unreadCount;
  final String? lastMessageTime;

  // NEW: Added messages list for chat functionality
  final List<Map<String, dynamic>> messages;

  Group({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.color = Colors.deepPurple,
    required this.members,
    required this.admin,
    this.imageSourceType = ImageSourceType.none,
    this.unreadCount = 0,
    this.lastMessageTime,
    this.messages = const [], // Initialized as an empty list
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  // NEW: copyWith factory method to allow non-mutable objects to be updated
  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    Color? color,
    List<String>? members,
    String? admin,
    ImageSourceType? imageSourceType,
    int? unreadCount,
    String? lastMessageTime,
    List<Map<String, dynamic>>? messages, // Include messages in copyWith
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      members: members ?? this.members,
      admin: admin ?? this.admin,
      imageSourceType: imageSourceType ?? this.imageSourceType,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      messages: messages ?? this.messages,
    );
  }
}