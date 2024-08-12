import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_two/Models/category.dart';
import 'package:flutter/material.dart';

class CategoryService extends ChangeNotifier {
  List<Category> _categories = [];
  
  CategoryService() {
    _fetchCategories();
  }

  List<Category> get categories => _categories;

  Future<void> _fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Category').get();
    _categories = snapshot.docs.map((doc) {
      return Category(
        id: doc.id,
        name: doc['name'],
        imagePath: doc['imagePath'],
      );
    }).toList();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('Category').add({
      'name': category.name,
      'imagePath': category.imagePath,
    });
    category.id = docRef.id;
    _categories.add(category);
    notifyListeners();
  }

  Future<void> updateCategory(String categoryId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection('Category').doc(categoryId).update(updatedData);

    int indexToUpdate = _categories.indexWhere((category) => category.id == categoryId);
    if (indexToUpdate != -1) {
      _categories[indexToUpdate] = Category(
        id: categoryId,
        name: updatedData['name'],
        imagePath: updatedData['imagePath'],
      );
    }
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await FirebaseFirestore.instance.collection('Category').doc(category.id).delete();
    _categories.remove(category);
    notifyListeners();
  }
}