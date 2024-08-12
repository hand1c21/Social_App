import 'package:final_project_two/Components/my_app_bar.dart';
import 'package:final_project_two/Services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Models/category.dart';
import '../../../../Services/category_service.dart';
import '../../Components/my_buttom.dart';

class CategoryManager extends StatefulWidget {
  @override
  _CategoryManagerState createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  final _nameController = TextEditingController();
  final _imagePathController = TextEditingController();

  void _addCategory() {
    final name = _nameController.text.trim();
    final imagePath = _imagePathController.text.trim();

    if (name.isNotEmpty && imagePath.isNotEmpty) {
      final category = Category(
        name: name,
        imagePath: imagePath,
      );
      Provider.of<CategoryService>(context, listen: false)
          .addCategory(category);
      _nameController.clear();
      _imagePathController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid category details'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _deleteCategory(Category category) {
    if (Provider.of<PostService>(context, listen: false)
        .posts
        .any((p) => p.categoryId == category.id)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' יש פוסטים שמשתמשים בקטגוריה זו לא ניתן למחוק'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Provider.of<CategoryService>(context, listen: false)
          .deleteCategory(category);
    }
  }

  void _showUpdateCategoryDialog(BuildContext context, Category category) {
    final _nameController =
        TextEditingController(text: category.name.toString());
    final _imagePathController =
        TextEditingController(text: category.imagePath.toString());
    String? categoryId = category.id;

    void _updateCategory() {
      Map<String, dynamic> updatedData = {
        'name': _nameController.text.trim(),
        'imagePath': _imagePathController.text.trim(),
      };
      Provider.of<CategoryService>(context, listen: false)
          .updateCategory(categoryId!, updatedData)
          .then((_) {
        Navigator.of(context).pop();
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('עדכון קטגוריה'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'שם קטגוריה',
                ),
              ),
              TextField(
                controller: _imagePathController,
                decoration: InputDecoration(labelText: 'Image Path'),
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
                'ביטול',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _updateCategory,
              child: Text(
                'עדכון',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: [],
        title: 'ניהול קטגוריות',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'שם קטגוריה',
                contentPadding: EdgeInsets.only(right: 12.0),
              ),
              textAlign: TextAlign.right,
            ),
            TextField(
              controller: _imagePathController,
              decoration: InputDecoration(
                labelText: 'תמונה',
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 20),
            MyButtom(text: 'הוספת קטגוריה', onTap: _addCategory),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<CategoryService>(
                builder: (context, categoryService, child) {
                  return ListView.builder(
                    itemCount: categoryService.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryService.categories[index];
                      return ListTile(
                        title: Text(category.name),
                        leading: Image.asset(category.imagePath, height: 50),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCategory(category),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showUpdateCategoryDialog(context, category),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
