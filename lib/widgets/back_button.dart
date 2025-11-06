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
      
      child: Container(
        width: width * 0.3,
        height: height * 0.1,
        
        margin: EdgeInsets.only(
          right: width * 0.9,
        ),
      
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: width * 0.08,
        ),
      ),
    );
  }
}