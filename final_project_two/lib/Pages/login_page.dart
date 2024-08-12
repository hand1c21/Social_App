import 'package:flutter/material.dart';
import 'package:final_project_two/Components/confirmation_button.dart';
import 'package:final_project_two/Components/user_detail_text_field.dart';
import 'package:final_project_two/Services/user_service.dart';
import '../Components/background_full.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  final authService = UserService();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await authService.signInWithEmailPassword(
          _email.text.trim(),
          _password.text.trim(),
        );
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
            title: Text("לא ניתן להתחבר"),
            content: Text("אנא בדוק את פרטי ההתחברות שלך ונסה שוב"),
          ),
        );
      }
    }
  }

  void navigateToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
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
                  "כיף לראות אותך שוב :)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'הכנס סיסמה ודוא"ל כדי להיכנס',
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
                        controller: _email,
                        hintText: 'דוא"ל',
                        obscureText: false,
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
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.end,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'הכנס סיסמה';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 48),
                      ConfirmationButton(text: "התחבר", onTap: login),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: navigateToRegister,
                  child: Text(
                    "אין לך חשבון? הרשם כאן",
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
