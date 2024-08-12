import 'package:final_project_two/Components/my_text_field%E2%80%8F.dart';
import 'package:final_project_two/Models/category.dart';
import 'package:final_project_two/Models/post.dart';
import 'package:final_project_two/Pages/category_item.dart';
import 'package:final_project_two/Pages/home_page.dart';
import 'package:final_project_two/Services/category_service.dart';
import 'package:final_project_two/Services/post_service.dart';
import 'package:final_project_two/Services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Services/image_service.dart';

class NewRequest extends StatefulWidget {
  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  TextEditingController _categoryId = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _city = TextEditingController();

  FocusNode _cityFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();

  late Post newPost;
  int _currentStep = 0;

  final UserService _userService = UserService();
  final ImageService _imageService = ImageService();

  late String userId;
  late String categoryId;
  late String title;
  late String description;
  late String city;
  late DateTime time;
  String? imagePath;
  late bool isAvailable;
  late Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    final currentUser = _userService.getCurrentUser();
    if (currentUser != null) {
      userId = currentUser.uid;
    } else {
      print('User is not logged in');
    }
    selectedCategory = null;
  }

  void _onCategorySelected(Category category) {
    setState(() {
      selectedCategory = category;
      if (category.id != null) {
        _categoryId.text = category.id!;
        _currentStep = 1;
      } else {
        print('Category id is null');
      }
    });
  }

  void _continue() {
    setState(() {
      if (_city.text.isNotEmpty && _description.text.isNotEmpty) {
        _currentStep = 2;
      }
    });
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

  void createPost() {
    categoryId = selectedCategory?.id ?? '';
    title = selectedCategory!.name;
    description = _description.text;
    city = _city.text;
    time = DateTime.now();
    imagePath = imagePath;
    isAvailable = true;

    newPost = Post(
      userId: userId,
      categoryId: categoryId,
      title: title,
      description: description,
      city: city,
      time: time,
      imagePath: imagePath,
      isAvailable: isAvailable,
    );
    Provider.of<PostService>(context, listen: false).addPost(newPost).then((_) {
      showSuccessDialog(context);
    });
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text('הפוסט הועלה בהצלחה!'), actions: [
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
        ]);
      },
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryService(),
      child: Consumer<CategoryService>(
        builder: (context, categoryService, child) {
          List<Category> categories = categoryService.categories;
          List<Step> _stepperSteps = [
            Step(
              title: Text(''),
              content: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'נתחיל בבחירת הקטגוריה המתאימה ביותר לתיאור הבקשה שלך. הדבר יעזור לאחרים לראות את הבקשה שלך במהירות.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 50),
                  categories.isEmpty
                      ? CircularProgressIndicator()
                      : GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                          children: categories.map((category) {
                            return CategoryItem(
                              category: category,
                              onCategoryTap: _onCategorySelected,
                            );
                          }).toList(),
                        ),
                ],
              ),
              isActive: _currentStep == 0,
            ),
            Step(
              title: Text(''),
              content: Column(
                children: [
                  if (selectedCategory != null) ...[
                    selectedCategory!.imagePath != null
                        ? Image.asset(selectedCategory!.imagePath,
                            width: 100, height: 100)
                        : Container(),
                    SizedBox(height: 20),
                    Text(selectedCategory!.name, textAlign: TextAlign.center),
                    SizedBox(height: 30),
                  ],
                  SizedBox(height: 20),
                  MyTextField(
                    controller: _city,
                    labelText: 'עיר',
                    focusNode: _cityFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: _description,
                    labelText: 'תיאור',
                    focusNode: _descriptionFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLength: TextField(
                      maxLength: 300,
                    ),
                    maxLines: TextField(
                      maxLength: 5,
                    ),
                  ),
                  SizedBox(height: 20),
                  _imageService.imageFile != null
                      ? Image.file(_imageService.imageFile!,
                          width: 100, height: 100)
                      : Container(),
                  SizedBox(height: 20),
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
                      preferBelow: false,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      minimumSize: Size(200, 50),
                    ),
                    onPressed: _continue,
                    child: Text(
                      'המשך',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep == 1,
            ),
            Step(
              title: Text(''),
              content: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      minimumSize: Size(200, 50),
                    ),
                    onPressed: createPost,
                    child: Text(
                      'פרסם',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep == 2,
            ),
          ];

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  title: Text(
                    'בקשה חדשה',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  centerTitle: true,
                ),
                body: SafeArea(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Theme(
                      data: ThemeData(
                        canvasColor: Theme.of(context).colorScheme.background,
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: Theme.of(context).colorScheme.tertiary,
                              background: Colors.black,
                              secondary: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                      child: Stepper(
                        type: StepperType.horizontal,
                        currentStep: _currentStep,
                        onStepContinue: () {
                          if (_currentStep < _stepperSteps.length - 1) {
                            setState(() {
                              _currentStep++;
                            });
                          }
                        },
                        onStepCancel: () {
                          if (_currentStep > 0) {
                            setState(() {
                              _currentStep--;
                            });
                          }
                        },
                        controlsBuilder: (BuildContext context,
                            ControlsDetails controlsDetails) {
                          return Container();
                        },
                        steps: _stepperSteps,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
