import 'package:final_project_two/Components/my_buttom.dart';
import 'package:final_project_two/Models/post.dart';
import 'package:final_project_two/Services/image_service.dart';
import 'package:final_project_two/Services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Components/my_app_bar.dart';
import '../../Components/my_text_field‏.dart';

class EditPostsPage extends StatefulWidget {
  final Post post;
  EditPostsPage({required this.post});

  @override
  _EditPostsPageState createState() => _EditPostsPageState();
}

class _EditPostsPageState extends State<EditPostsPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _cityController;
  late bool _isAvailable;
  late String? imagePath;
  final ImageService _imageService = ImageService();


  FocusNode _cityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.post.description);
    _cityController = TextEditingController(text: widget.post.city);
    _isAvailable = widget.post.isAvailable;
    imagePath = widget.post.imagePath;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cityController.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _imageService.pickImage(ImageSource.gallery);
                  if (_imageService.imageUrl.isNotEmpty) {
                    setState(() {
                      imagePath = _imageService.imageUrl;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _imageService.pickImage(ImageSource.camera);
                  if (_imageService.imageUrl.isNotEmpty) {
                    setState(() {
                      imagePath = _imageService.imageUrl;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateAvailability(bool value) async {
    print("Updating availability to: $value");
    final postService = Provider.of<PostService>(context, listen: false);
    final updatedPost = Post(
      id: widget.post.id,
      userId: widget.post.userId,
      categoryId: widget.post.categoryId,
      title: widget.post.title,
      description: _descriptionController.text,
      city: _cityController.text,
      time: DateTime.now(),
      imagePath: widget.post.imagePath,
      isAvailable: value,
    );

    try {
      await postService.updatePost(updatedPost);
      print("Post updated successfully");
    } catch (e) {
      print("Error updating post: $e");
    }
  }

  void _saveDetails() async {
    final postService = Provider.of<PostService>(context, listen: false);
    final updatedPost = Post(
      id: widget.post.id,
      userId: widget.post.userId,
      categoryId: widget.post.categoryId,
      title: widget.post.title,
      description: _descriptionController.text,
      city: _cityController.text,
      time: DateTime.now(),
      imagePath: imagePath,
      isAvailable: _isAvailable,
    );

    await postService.updatePost(updatedPost);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'עדכון פוסט', actions: []),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              MyTextField(
                controller: _descriptionController,
                focusNode: FocusNode(),
                labelText: 'תיאור',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _cityController,
                focusNode: _cityFocusNode,
                labelText: 'עיר',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 20,
              ),
              imagePath != null
                  ?Image.network(
                      imagePath!, width: 100, height: 100,)
                  : Container(),
              SizedBox(height: 20),
              Text('עדכן תמונה'),
              SizedBox(height: 5,),
              ElevatedButton(
                onPressed: _showImageSourceDialog,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  fixedSize: Size(60, 60),
                ),
                child: Tooltip(
                  message: 'הוספת תמונה',
                  preferBelow:
                      false, 
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('סטטוס', style: TextStyle(fontSize: 16)),
                  CupertinoSwitch(
                    value: widget.post.isAvailable,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        widget.post.isAvailable = value;
                        _isAvailable = value;
                      });
                      _updateAvailability(value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              MyButtom(
                onTap: _saveDetails,
                text: 'עדכן',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
