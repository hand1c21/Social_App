import 'package:final_project_two/Components/my_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MyAppBar(
        title: "הגדרות",
        actions: [],
      ),
      body: Center(
        child: Container(
          width: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "שינוי מצב",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CupertinoSwitch(
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
