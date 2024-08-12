import 'package:final_project_two/Components/my_buttom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Models/my_user.dart';
import '../../../Services/user_service.dart';
import '../../../Components/my_app_bar.dart';  

class UsersManager extends StatefulWidget {
  @override
  _UsersManagerState createState() => _UsersManagerState();
}

class _UsersManagerState extends State<UsersManager> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneNumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserService>(context, listen: false).fetchUsers();
  }

  void _addUser() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final city = _cityController.text.trim();
    final phoneNum = _phoneNumController.text.trim();

    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && password.isNotEmpty && city.isNotEmpty) {
      final myUser = MyUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        city: city,
        phoneNum: phoneNum
      );
      Provider.of<UserService>(context, listen: false).addUser(myUser);
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _cityController.clear();
      _phoneNumController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('אנא הכנס ערכים תקינים'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _deleteUser(MyUser user) {
    Provider.of<UserService>(context, listen: false).deleteUser(user);
  }

  void _isAdminAllow(MyUser user) {
    Provider.of<UserService>(context, listen: false).isAdminAllow(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'ניהול משתמשים',
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'שם פרטי'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'שם משפחה'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'אימייל'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'סיסמא'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'עיר'),
            ),
            TextField(
              controller: _phoneNumController,
              decoration: InputDecoration(labelText: 'מספר פלאפון'),
            ),
            SizedBox(height: 20),
            MyButtom(
              onTap: _addUser,
              text: 'הוסף משתמש',
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<UserService>(
                builder: (context, userService, child) {
                  return ListView.builder(
                    itemCount: userService.users.length,
                    itemBuilder: (context, index) {
                      final user = userService.users[index];
                      return ListTile(
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
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

