import 'package:flutter/material.dart';
import '../Components/background_full.dart';
import '../Components/confirmation_button.dart';
import '../Components/user_detail_text_field.dart';
import '../Models/my_user.dart';
import '../Services/user_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _phone = TextEditingController();

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  final authService = UserService();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _city.dispose();
    _phone.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _cityFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void register() async {
    if (_formKey.currentState?.validate() ?? false) {
      MyUser user = MyUser(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
        city: _city.text.trim(),
        phoneNum: _phone.text.trim(),
      );

      try {
        await authService.signUpWithEmailPassword(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text("לא ניתן להירשם.."),
            content: Text("אנא נסה שוב מאוחר יותר."),
          ),
        );
      }
    }
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(gradient: backgroundFullGradiant),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "היי, ברוכים הבאים",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "הכניסו פרטים כדי להרשם",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      UserDetailTextField(
                        controller: _firstName,
                        hintText: "שם פרטי",
                        obscureText: false,
                        focusNode: _firstNameFocusNode,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'הכנס שם פרטי'
                            : null,
                      ),
                      SizedBox(height: 24),
                      UserDetailTextField(
                        controller: _lastName,
                        hintText: "שם משפחה",
                        obscureText: false,
                        focusNode: _lastNameFocusNode,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'הכנס שם משפחה'
                            : null,
                      ),
                      SizedBox(height: 24),
                      UserDetailTextField(
                        controller: _email,
                        hintText: 'דוא"ל',
                        obscureText: false,
                        focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'הכנס דוא"ל';
                          }
                          final emailRegExp =
                              RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'דוא"ל לא תקין';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      UserDetailTextField(
                        controller: _password,
                        hintText: "סיסמה",
                        obscureText: true,
                        focusNode: _passwordFocusNode,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.end,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'הכנס סיסמה';
                          }
                          if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$')
                              .hasMatch(value)) {
                            return 'Password must be at least 6 characters long, include an uppercase letter, a lowercase letter, and a number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      UserDetailTextField(
                        controller: _city,
                        hintText: "עיר",
                        obscureText: false,
                        focusNode: _cityFocusNode,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'הכנס עיר מגורים'
                            : null,
                      ),
                      SizedBox(height: 24),
                      UserDetailTextField(
                        controller: _phone,
                        hintText: "טלפון",
                        obscureText: false,
                        focusNode: _phoneFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'הכנס מספר טלפון';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'מספר הטלפון חייב להכיל רק ספרות.';
                          }
                          if (value.length < 10) {
                            return 'מספר הטלפון חייב להיות באורך של לפחות 10 ספרות.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 48),
                      ConfirmationButton(text: "הרשם", onTap: register),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: navigateToLogin,
                  child: Text(
                    "יש לך חשבון? אנא התחבר.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
