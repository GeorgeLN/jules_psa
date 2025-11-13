
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';

class EmailVerificationTabletScreen extends StatefulWidget {

  const EmailVerificationTabletScreen({super.key});

  @override
  State<EmailVerificationTabletScreen> createState() => _EmailVerificationTabletScreenState();
}

class _EmailVerificationTabletScreenState extends State<EmailVerificationTabletScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer =Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo de verificación enviado. Revisa tu bandeja de entrada.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return isEmailVerified
      ? const OptionsTabletScreen()
      : Scaffold(
        backgroundColor: Color.fromARGB(255, 6, 98, 196),

        appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 98, 196),
        title: Text(
          'Verificación de Correo',
          style: GoogleFonts.poppins(
            fontSize: width * 0.035,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

        body: PopScope(
          canPop: false,

          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Se ha enviado un correo de verificación a tu dirección de correo electrónico. Por favor, verifica tu correo para continuar.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.035,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: width * 0.85,

                    child: ElevatedButton(
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(39, 54, 114, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Icon(
                            Icons.email,
                            size: width * 0.04,
                            color: Colors.white,
                          ),
                          Text(
                            'Reenviar correo de verificación',
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.03,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const LoginTabletScreen(),
                      ));
                    },
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.03,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
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
