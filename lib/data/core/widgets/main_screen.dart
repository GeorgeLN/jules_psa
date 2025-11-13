
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder <User?>(
        stream: _authStateChanges,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            final userProvider = Provider.of<UserProvider>(context, listen: false);

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final userRepository = UserRepository();
              final userModel = await userRepository.getUser(user.uid);
              if (userModel != null) {
                userProvider.setUid(user.uid);
                userProvider.setUserDocumentId(user.uid);
                userProvider.setUserModel(userModel);
              }
            });

            return const ResponsiveSelectedEmojiScreen();
          } else {
            return const RegisterScreen();
          }
        },
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;

    if (shortest > 400) {
      return const RegisterTabletScreen();
    } else {
      return const RegisterMobileScreen();
    }
  }
}