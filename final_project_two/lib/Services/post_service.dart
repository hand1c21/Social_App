import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/post.dart';

class PostService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Post> _posts = [];

  List<Post> get posts => _posts;
  
  List<Post> _mapDocsToPosts(List<QueryDocumentSnapshot> docs) {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Post(
        id: doc.id,
        categoryId: data['categoryId'],
        description: data['description'],
        city: data['city'],
        title: data['title'],
        userId: data['userId'],
        imagePath: data['imagePath'],
        time: (data['time'] as Timestamp).toDate(),
        isAvailable: data['isAvailable'],
      );
    }).toList();
  }

  Future<void> fetchUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Posts')
          .where('userId', isEqualTo: userId)
          .where('isAvailable', isEqualTo: true)
          .orderBy('time', descending: true)
          .get();
      _posts = _mapDocsToPosts(snapshot.docs);
      notifyListeners();
    } catch (e) {
      print('Error fetching user posts: $e');
    }
  }

   Future<void> fetchAllUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Posts')
          .where('userId', isEqualTo: userId)
          .orderBy('time', descending: true)
          .get();
      _posts = _mapDocsToPosts(snapshot.docs);
      notifyListeners();
    } catch (e) {
      print('Error fetching user posts: $e');
    }
  }

  Future<void> fetchAllOpenPostsSortedByTime() async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Posts')
          .where('isAvailable', isEqualTo: true)
          .orderBy('time', descending: true)
          .get();
      _posts = _mapDocsToPosts(snapshot.docs);
      notifyListeners();
    } catch (e) {
      print('Error fetching all posts: $e');
    }
  }

  Future<void> fetchPostsByCity(String city) async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Posts')
          .where('city', isEqualTo: city.toLowerCase())
          .where('isAvailable', isEqualTo: true)
          .orderBy('time', descending: true)
          .get();
      _posts = _mapDocsToPosts(snapshot.docs);
      notifyListeners();
    } catch (e) {
      print('Error fetching posts by city: $e');
    }
  }

  Future<void> fetchAllPostsSortedByTime() async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Posts')
          .where('isAvailable', isEqualTo: true)
          .orderBy('time', descending: true)
          .get();
      _posts = _mapDocsToPosts(snapshot.docs);
      notifyListeners();
    } catch (e) {
      print('Error fetching all posts: $e');
    }
  }

  Future<void> addPost(Post post) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('Posts').add({
      'categoryId': post.categoryId,
      'description': post.description,
      'city': post.city,
      'title': post.title,
      'userId': post.userId,
      'imagePath': post.imagePath,
      'isAvailable': post.isAvailable,
      'time': post.time
    });
    post.id = docRef.id;
    _posts.add(post);
    notifyListeners();
  }

  Future<void> updatePost(Post post) async {
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(post.id)
        .update(post.toMap());
    print('post.id ${post.id}');
    int indexToUpdate = _posts.indexWhere((p) => p.id == post.id);
    if (indexToUpdate != -1) {
      _posts[indexToUpdate] = post;
    }
    notifyListeners();
  }

  Future<void> deletePost(Post post) async {
    await FirebaseFirestore.instance.collection('Posts').doc(post.id).delete();
    _posts.remove(post);
    notifyListeners();
  }
  
}
