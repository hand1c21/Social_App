import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget{
  final String text;
  final void Function()? onTap;

  const ConfirmationButton({
    required this.text,
    required this.onTap
  });

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.teal[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}