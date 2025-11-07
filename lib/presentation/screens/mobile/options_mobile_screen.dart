
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/widgets/back_button.dart';

import '../screens.dart';

class OptionsMobileScreen extends StatelessWidget {
   
  const OptionsMobileScreen({super.key});
  
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
        
                Container(
                  width: width,
                  height: height,
        
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                  ),
                  
                  child: Column(
                    children: [
                      ButtonBack(
                        width: width,
                        height: height,
                      ),

                      SizedBox(height: height * 0.175),

                      Text(
                        'Seleccione una de las siguientes opciones',
                        textAlign: TextAlign.center,
                        
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: width * 0.046,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.01),
        
                      OptionButton(
                        width: width,
                        height: height,
                        text: 'Agregar nuevo paciente',

                        route: MaterialPageRoute(
                          builder: (context) => const MobileDataUserScreen(),
                        ),
                      ),

                      OptionButton(
                        width: width,
                        height: height,
                        text: 'Ver listado de pacientes',

                        route: MaterialPageRoute(
                          builder: (context) => const PatientsMobileScreen(),
                        ),
                      ),
                    ],
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

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.width,
    required this.height,
    required this.route,
    required this.text,
  });

  final double width;
  final double height;
  final Route route;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.9,
      margin: EdgeInsets.only(
        top: height * 0.025,
      ),
      
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            route,
          );
        },
      
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(39, 54, 114, 1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      
        child: Text(
          text,
          style: TextStyle(
            fontSize: width * 0.046,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}