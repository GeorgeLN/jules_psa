import 'package:flutter/material.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      
      child: Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: width < 800 ? width * 0.075 : width * 0.05,
      ),
    );
  }
}