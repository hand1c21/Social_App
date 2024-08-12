import 'package:final_project_two/Components/my_app_bar.dart';
import 'package:final_project_two/Components/post_list.dart';
import 'package:final_project_two/Models/post.dart';
import 'package:final_project_two/Pages/new_request_page.dart';
import 'package:final_project_two/Services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Services/post_service.dart';
import '../Components/my_drawer.dart';
import '../Services/category_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  String city = '';
  String uid = '';
  List<Post> _posts = [];
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocationAndFetchPosts();
  }

  Future<void> _fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _postService.fetchUserPosts(user.uid);
      setState(() {
        _posts = _postService.posts;
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  Future<void> _fetchAllPostsSortedByTime() async {
    await _postService.fetchAllPostsSortedByTime();
    setState(() {
      _posts = _postService.posts;
      _isLoading = false;
    });
  }

  Future<void> getLocationAndFetchPosts() async {
    String city = '';
    String uid;
    String? cityFromLocation = null;

    if (cityFromLocation != null) {
      setState(() {
        city = cityFromLocation;
      });
    } else {
      uid = await _userService.getCurrentUser()!.uid;
      city = await _userService.fetchDefaultCityFromFirestore(uid);
    }

    fetchPostsByCity(city);
  }

  Future<void> fetchPostsByCity(String city) async {
    await _postService.fetchPostsByCity(city);
    setState(() {
      _posts = _postService.posts;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isLoading = true;
    });

    if (_selectedIndex == 0) {
      _fetchUserPosts();
    } else if (_selectedIndex == 2) {
      _fetchAllPostsSortedByTime();
    } else if (_selectedIndex == 1) {
      getLocationAndFetchPosts();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLoading = ValueNotifier(
        Provider.of<CategoryService>(context, listen: false)
            .categories
            .isNotEmpty);
    return Scaffold(
      appBar: MyAppBar(
        title: "עמוד הבית",
        actions: [],
      ),
      drawer: MyDrawer(),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return Column(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _onItemTapped(0),
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
                        onTap: () => _onItemTapped(1),
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
                              'בסביבה ',
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
                    Expanded(
                      child: InkWell(
                        onTap: () => _onItemTapped(2),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _selectedIndex == 2
                                    ? Colors.blueAccent
                                    : Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'אחרונים ',
                              style: TextStyle(
                                color: _selectedIndex == 2
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
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _posts.isEmpty
                        ? Center(child: Text('אין פוסטים להציג'))
                        : PostList(
                            posts: _posts,
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewRequest(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}
