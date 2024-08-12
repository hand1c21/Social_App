import 'package:final_project_two/Components/my_app_bar.dart';
import 'package:final_project_two/Components/my_buttom.dart';
import 'package:final_project_two/Pages/new_request_page.dart';
import 'package:final_project_two/Services/category_service.dart';
import 'package:final_project_two/Services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/post_list.dart';
import '../../Models/post.dart';

class PostManager extends StatefulWidget {
  _PostManagerState createState() => _PostManagerState();
}

class _PostManagerState extends State<PostManager> {
  List<Post> _posts = [];
  final PostService _postService = PostService();
  CategoryService categoryService = CategoryService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void _deletePost(Post post) {
    Provider.of<PostService>(context, listen: false).deletePost(post);
    setState(() {
      _posts.remove(post);
    });
  }

  void _showUpdatePostDialog(BuildContext context, Post post) {
    final categoryController = TextEditingController(
        text: Provider.of<CategoryService>(context, listen: false)
            .categories
            .firstWhere((c) => c.id == post.categoryId)
            .name
            .toString());
    final descriptionController =
        TextEditingController(text: post.description.toString());
    final cityController = TextEditingController(text: post.city.toString());
    final imagePathController =
        TextEditingController(text: post.imagePath.toString());

    void _updatePost() {
      Post updatedData = Post(
        id: post.id,
        categoryId: Provider.of<CategoryService>(context, listen: false)
            .categories
            .firstWhere((c) => c.name == categoryController.text.trim())
            .id
            .toString(),
        time: DateTime.now(),
        description: descriptionController.text.trim(),
        city: cityController.text.trim(),
        title: post.title,
        userId: post.userId,
        imagePath: imagePathController.text.trim(),
        isAvailable: post.isAvailable,
      );

      Provider.of<PostService>(context, listen: false).updatePost(updatedData);
      setState(() {
        int indexToUpdate = _posts.indexWhere((p) => p.id == post.id);
        if (indexToUpdate != -1) {
          _posts[indexToUpdate] = updatedData;
        }
      });
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: imagePathController,
                decoration: InputDecoration(labelText: 'Image Path'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => post.isAvailable = false,
                child: Text(
                  'not avilable',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            MyButtom(
              onTap: _updatePost,
              text: 'Update',
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchPosts() async {
    await _postService.fetchAllOpenPostsSortedByTime();
    setState(() {
      _posts = _postService.posts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLoading = ValueNotifier(
        Provider.of<CategoryService>(context, listen: false).categories != []);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: MyAppBar(
            actions: [],
            title: 'ניהול פוסטים',
          ),
          body: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, value, child) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      MyButtom(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewRequest(),
                              ),
                            );
                          },
                          text: 'הוספת פוסט'),
                      SizedBox(height: 20),
                      Expanded(
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _posts.isEmpty
                                ? Center(child: Text('אין פוסטים להציג'))
                                : PostList(
                                    posts: _posts,
                                    update: (context, post) => {
                                      _showUpdatePostDialog(context, post),
                                      setState(() {})
                                    },
                                    delete: (post) => _deletePost(post),
                                  ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
