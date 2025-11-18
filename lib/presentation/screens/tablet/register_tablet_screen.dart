import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pain_scale_app/data/repositories/auth_repository.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';

class RegisterTabletScreen extends StatefulWidget {
  const RegisterTabletScreen({super.key});

  @override
  State<RegisterTabletScreen> createState() => _RegisterTabletScreenState();
}

class _RegisterTabletScreenState extends State<RegisterTabletScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authRepository = Provider.of<AuthRepository>(context, listen: false);
      try {
        final user = await authRepository.registrarUsuario(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );

        if (user != null) {
          Provider.of<UserProvider>(context, listen: false).setIsRegisted(true);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerificationTabletScreen(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 98, 196),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 98, 196),
        title: Text(
          'Registrarse',
          style: GoogleFonts.poppins(
            fontSize: width * 0.03,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(
                  'assets/animations/pain.json',
                  width: width * 0.5,
                  animate: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.white,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.02,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: width * 0.02,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.02,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: width * 0.02,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su correo electrónico';
                            }
                            if (!value.contains('@')) {
                              return 'Ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.white,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.02,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: width * 0.02,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: width * 0.6,

                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(39, 54, 114, 1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Registrarme',
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.025,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes una cuenta?',
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.02,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginTabletScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Inicia sesión',
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.02,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
