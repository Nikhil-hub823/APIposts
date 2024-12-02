import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: FutureBuilder(
        future: postProvider.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: postProvider.posts.length,
            itemBuilder: (context, index) {
              final post = postProvider.posts[index];
              final isRead = postProvider.isRead(post.id!);
              return GestureDetector(
                onTap: () {
                  postProvider.markAsRead(post.id!);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetailScreen(postId: post.id!),
                  ));
                },
                child: Container(
                  color: isRead ? Colors.white : Colors.yellow[200],
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(post.title!)),
                      Text('${postProvider.getTimer(post.id!)}s'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
