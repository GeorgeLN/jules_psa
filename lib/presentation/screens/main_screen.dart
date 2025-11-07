
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
   
  const MainScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder <User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            Provider.of<UserProvider>(context, listen: false).setUid(user.uid);
            return const ResponsiveSelectedEmojiScreen();
          } else {
            return const EmailVerificationMobileScreen();
          }
        },
      ),
    );
  }
}