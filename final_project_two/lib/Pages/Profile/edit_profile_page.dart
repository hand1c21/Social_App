import 'package:final_project_two/Components/my_buttom.dart';
import 'package:final_project_two/Models/my_user.dart';
import 'package:provider/provider.dart';
import '../../Components/my_app_bar.dart';
import '../../Components/my_text_field‏.dart';
import '../../Services/user_service.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final MyUser user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _phoneNumberController;

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _cityController = TextEditingController(text: widget.user.city);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNum);
  }

  void _saveDetails() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final updatedUser = MyUser(
      id: widget.user.id,
      password: widget.user.password,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      city: _cityController.text,
      phoneNum: _phoneNumberController.text,
    );

    await userService.updateUser(updatedUser);
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'עדכון פרופיל',
        actions: [],
      ),
      body: Container(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MyTextField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                labelText: 'שם פרטי',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                labelText: 'שם משפחה',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                labelText: 'דואר אלקטרוני',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _cityController,
                focusNode: _cityFocusNode,
                labelText: 'עיר',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _phoneNumberController,
                focusNode: _phoneFocusNode,
                labelText: 'מספר טלפון',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 32),
              MyButtom(
                onTap: _saveDetails,
                text: 'שמור',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
