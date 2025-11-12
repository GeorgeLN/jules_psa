import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/data/core/widgets/back_button.dart';
import 'package:pain_scale_app/presentation/screens/mobile/options_mobile_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class MobileDataScreen extends StatelessWidget {
  const MobileDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final patientPainScaleImage = Provider.of<UserProvider>(context).getPatientPainScaleImage;
    final userName = Provider.of<UserProvider>(context).getPatientModel?.nombre ?? 'Usuario no definido';
    final numberPain = Provider.of<UserProvider>(context).getNumberPain ?? '';
    final firstName = userName.split(' ').first;


    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 98, 196),
      body: PopScope(
        canPop: false,

        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.03),
                
                child: Text(
                  'Resultados',
                  style: GoogleFonts.poppins(
                    fontSize: width < 800 ? width * 0.05 : width * 0.0325,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Center(
                child: patientPainScaleImage != null
                ? Container(
                  width: width * 0.8,
                  height: height * 0.65,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 30,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Image.memory(patientPainScaleImage),
                )
                : const Text('No image selected'),
              ),
              patientPainScaleImage != null
              ? Container(
                margin: EdgeInsets.all(width * 0.03),
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 30,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '$firstName, su dolor seleccionado en la escala de dolor es de: [$numberPain]',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                        color: Colors.black
                      ),
                    ),
          
                    SizedBox(height: height * 0.02),
          
                    Container(
                      width: width * 0.5,
          
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const OptionsMobileScreen()),
                            (Route<dynamic> route) => false,
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
                          'Salir',
                          style: GoogleFonts.poppins(
                            fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              )
              : Text(
                'No se ha seleccionado un paciente',
                style: GoogleFonts.poppins(fontSize: width * 0.05, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
