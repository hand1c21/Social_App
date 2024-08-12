import 'dart:core';
import 'package:final_project_two/Pages/Profile/profile_page.dart';
import 'package:final_project_two/Pages/home_page.dart';
import 'package:final_project_two/Pages/login_page.dart';
import 'package:final_project_two/Pages/managment/category_manager.dart';
import 'package:final_project_two/Pages/managment/post_maneger.dart';
import 'package:final_project_two/Pages/managment/users.dart';
import 'package:final_project_two/Pages/new_request_page.dart';
import 'package:final_project_two/Services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Pages/settings_Page.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Image.asset('lib/Images/drawer.png'),
                    ),
                  ),
                ),
                _buildListTile(
                  context,
                  title: 'דף הבית',
                  icon: Icons.home,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  title: 'הגדרות',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  title: 'פרופיל משתמש',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  title: 'פוסט חדש',
                  icon: Icons.add_circle,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewRequest()),
                    );
                  },
                ),
                 if (UserService().getCurrentUser()!.email! == dotenv.env['EMAIL'])
                  Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      leading:Padding(padding: EdgeInsets.only(right: 17),child: Icon(Icons.manage_accounts,
                          color: Theme.of(context).colorScheme.primary),),
                          
                      title: Text(
                        "לניהול האפליקציה",
                        style: TextStyle(color: Colors.black),
                      ),
                      children: <Widget>[
                        _buildListTile(
                          context,
                          title: 'ניהול משתמשים',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UsersManager()),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          title: 'ניהול פוסטים',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PostManager()),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          title: 'ניהול קטגוריות',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CategoryManager()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, bottom: 25),
              child: _buildListTile(
                context,
                title: "יציאה",
                icon: Icons.logout,
                onTap: () => logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(
    BuildContext context, {
    required String title,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: icon != null
          ? Icon(icon, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
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