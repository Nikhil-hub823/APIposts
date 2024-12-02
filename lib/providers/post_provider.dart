import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<int, int> _timers = {}; // Tracks remaining time for each post
  Map<int, bool> _readStatus = {};
  Map<int, bool> _timerActive = {}; // Tracks whether a timer is active

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      _posts = (json.decode(response.body) as List)
          .map((post) => Post.fromJson(post))
          .toList();
      for (var post in _posts) {
        // Shuffle the list and pick the first element
        var options = [10, 20, 25]..shuffle();
        _timers[post.id!] = options.first;
      }
      notifyListeners();
    }
  }

  void markAsRead(int postId) {
    _readStatus[postId] = true;
    notifyListeners();
  }

  bool isRead(int postId) {
    return _readStatus[postId] ?? false;
  }

  int getTimer(int postId) {
    return _timers[postId] ?? 0;
  }

  void startTimer(int postId) {
    _timerActive[postId] = true;
    _runTimer(postId);
  }

  void stopTimer(int postId) {
    _timerActive[postId] = false;
  }

  void _runTimer(int postId) async {
    while (_timerActive[postId] == true && _timers[postId]! > 0) {
      await Future.delayed(Duration(seconds: 1));
      if (_timerActive[postId] == true) {
        _timers[postId] =
            (_timers[postId]! - 1).clamp(0, double.infinity).toInt();
        notifyListeners();
      }
    }
  }
}
