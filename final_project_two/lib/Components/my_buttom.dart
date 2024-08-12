import 'package:flutter/material.dart';

class MyButtom extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButtom({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
         constraints: BoxConstraints(
          maxWidth: 200.0, 
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondary, 
            ),
          ),
        ),
      ),
    );
  }
}
