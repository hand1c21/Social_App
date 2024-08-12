import 'package:final_project_two/Components/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../Models/post.dart';
import '../Services/category_service.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  final void Function(Post)? delete;
  final void Function(BuildContext, Post)? update;

  PostList({required this.posts, this.update, this.delete});

  String _timeAgo(DateTime postDate) {
    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inDays > 0) {
      return 'הועלה לפני ${difference.inDays} ימים';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} שעות';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} דקות';
    } else {
      return 'לפני פחות מדקה';
    }
  }

  void showPostDetails(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 40),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: MyAppBar(
                    title: '',
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          Share.share(
                              'כותרת: ${post.title}\nתיאור: ${post.description}\n');
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: kToolbarHeight + 8,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: Text(
                      'פרטי בקשה',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'סטטוס: ${post.isAvailable ? 'פתוח' : 'סגור'}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(
                        'מועד הפרסום: ${_timeAgo(post.time)}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                if (post.imagePath != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(
                      post.imagePath!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                if (Provider.of<CategoryService>(context, listen: false)
                    .categories
                    .where((cat) => cat.id == post.categoryId)
                    .isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Image.asset(
                      Provider.of<CategoryService>(context, listen: false)
                          .categories
                          .where((cat) => cat.id == post.categoryId)
                          .first
                          .imagePath,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                Text(
                  post.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 8.0),
                Text(post.description),
                SizedBox(height: 16.0),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return GestureDetector(
            onTap: () => showPostDetails(context, post),
            child: Card(
              margin: EdgeInsets.all(8.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(8.0)),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                post.categoryId != ""
                                    ? Image.asset(
                                        Provider.of<CategoryService>(context,
                                                listen: false)
                                            .categories
                                            .where((cat) =>
                                                cat.id == post.categoryId)
                                            .first
                                            .imagePath,
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      )
                                    : Text("אין קטגוריה"),
                                Text(
                                  post.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 35),
                              child: Text(
                                post.description,
                                textAlign: TextAlign.right,
                                maxLines: null,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      post.city,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(width: 16),
                                    Icon(Icons.access_time,
                                        color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      _timeAgo(post.time),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (update != null)
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => update!(context, post),
                        ),
                      if (delete != null)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => delete!(post),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
