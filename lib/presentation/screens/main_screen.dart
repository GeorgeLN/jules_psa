
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';

class MainScreen extends StatelessWidget {
   
  const MainScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder <User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const ResponsiveSelectedEmojiScreen();
          } else {
            return const EmailVerificationMobileScreen();
          }
        },
      ),
    );
  }
}