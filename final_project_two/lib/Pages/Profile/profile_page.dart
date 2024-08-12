import 'package:final_project_two/Components/post_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project_two/Models/my_user.dart';
import 'package:final_project_two/Models/post.dart';
import 'package:final_project_two/Services/post_service.dart';
import 'package:final_project_two/Services/user_service.dart';
import 'edit_posts_page.dart';
import 'edit_profile_page.dart';
import 'package:final_project_two/Components/my_app_bar.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _selectedIndex = 1;
  MyUser? _user;
  List<Post> _posts = [];
  final PostService _postService = PostService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserPosts();
    _fetchUser();
  }

  Future<void> _fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _postService.fetchAllUserPosts(user.uid);
      setState(() {
        _posts = _postService.posts;
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  Future<void> _fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserService userService = UserService();
      MyUser fetchedUser = await userService.getUser(user.uid);
      setState(() {
        _user = fetchedUser;
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  void _editUserDetails() {
    if (_user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePage(user: _user!),
        ),
      ).then((updatedUser) {
        if (updatedUser != null) {
          setState(() {
            _user = updatedUser;
          });
        }
      });
    }
  }

  void _editPost(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostsPage(post: post),
      ),
    ).then((_) {
      _fetchUserPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(
          title: "פרופיל משתמש",
          actions: [],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedIndex == 0
                                  ? Colors.blueAccent
                                  : Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'הפוסטים שלי',
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? Colors.blueAccent
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedIndex == 1
                                  ? Colors.blueAccent
                                  : Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'פרטי משתמש',
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.blueAccent
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _selectedIndex == 0
                      ? _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : _posts.isEmpty
                              ? Center(child: Text('עדיין לא הוספת פוסטים'))
                              : PostList(
                                  posts: _posts,
                                  update: (context, post) =>
                                      _editPost(context, post),
                                )
                      : SizedBox.shrink(),
                  _selectedIndex == 1
                      ? _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Consumer<UserService>(
                              builder: (context, userService, child) {
                                return FutureBuilder<MyUser>(
                                  future: userService.getUser(_user!.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData) {
                                      return Center(
                                          child: Text('No data available'));
                                    } else {
                                      final user = snapshot.data!;
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(25),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 200.0,
                                                    maxHeight: 200.0,
                                                  ),
                                                  child: Image.asset('lib/Images/drawer.png'),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'שם: ',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                            '${user.firstName} ${user.lastName}'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'דואר אלקטרוני: ',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Text('${user.email}'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'עיר: ',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Text('${user.city}'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'מספר טלפון: ',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Text('${user.phoneNum}'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.edit, color: Colors.blue),
                                                  onPressed: _editUserDetails,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}