import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  Future<Map<String, dynamic>> fetchPostDetail() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Detail')),
      body: FutureBuilder(
        future: fetchPostDetail(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final postDetail = snapshot.data as Map<String, dynamic>;
          return Padding(
            padding: EdgeInsets.all(20),
            child: Text(postDetail['body']),
          );
        },
      ),
    );
  }
}
