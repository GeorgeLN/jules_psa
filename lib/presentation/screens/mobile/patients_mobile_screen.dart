
import 'package:flutter/material.dart';

class PatientsMobileScreen extends StatelessWidget {
   
  const PatientsMobileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PopScope(
        canPop: false,

        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Color.fromARGB(255, 6, 98, 196).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}