import 'package:flutter/material.dart';

class ButtonTranspert extends StatelessWidget {
    final String text;
  final void Function()? onTap;

  const ButtonTranspert({
    required this.text,
    required this.onTap
  });
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Theme.of(context).colorScheme.background),
        ),
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
