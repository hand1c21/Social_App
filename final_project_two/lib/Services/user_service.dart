import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/my_user.dart';
import '../Pages/login_page.dart';

class UserService extends ChangeNotifier {
  List<MyUser> _users = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  List<MyUser> get users => _users; 

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    if (email == null || password == null) {
      throw ArgumentError('Email and password must not be null');
    }
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } 
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(MyUser user) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      await _firebaseFirestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'first name': user.firstName,
          'last name': user.lastName,
          'email': user.email,
          'city': user.city,
          'phone number': user.phoneNum
        },
      );

      await fetchUsers();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<MyUser> getUser(String? uid) async {
    DocumentSnapshot doc = await _firebaseFirestore.collection('Users').doc(uid).get();
    return MyUser.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUser(MyUser user) async {
    try {
      await _firebaseFirestore
          .collection('Users')
          .doc(user.id)
          .update(user.toMap());
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
      throw Exception('Failed to update user');
    }
  }

  Future<void> addUser(MyUser user) async {
    DocumentReference docRef = await _firebaseFirestore.collection('Users').add({
      'uid': user.id,
      'first name': user.firstName,
      'last name': user.lastName,
      'email': user.email,
      'city': user.city,
      'phone number': user.phoneNum
    });
    user.id = docRef.id;
    _users.add(user);
    notifyListeners();
    await fetchUsers();
  }

  Future<void> deleteUser(MyUser user) async {
    await _firebaseFirestore.collection('Users').doc(user.id).delete();
    _users.remove(user);
    notifyListeners();
  }

  Future<void> isAdminAllow(MyUser user) async {
    user.isAdminAllowed = true;
    await FirebaseFirestore.instance.collection('Posts').doc(user.id).update(user.toMap());
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    try {
      final querySnapshot = await _firebaseFirestore.collection('Users').get();
      _users = querySnapshot.docs.map((doc) => MyUser.fromMap(doc.data() as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<String> fetchDefaultCityFromFirestore(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      return userDoc['city'] as String;
    } catch (e) {
      print('Error fetching default city: $e');
      return 'DefaultCity';
    }
  }
  void logout(BuildContext context) {
    final authService = UserService();
    authService.signOut().then(
      (_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      },
    );
  }
}
