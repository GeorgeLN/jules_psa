import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'screens.dart';

class NewPatientDataScreen extends StatelessWidget {
  final Widget returnScreen;

  const NewPatientDataScreen({super.key, required this.returnScreen});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final patient = Provider.of<UserProvider>(context).getPatientModel;

    // Responsive font size logic
    final double titleFontSize = width < 800 ? width * 0.05 : width * 0.0325;
    final double bodyFontSize = width < 800 ? width * 0.04 : width * 0.0325;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 80, 166, 1),
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: patient == null
              ? Center(
                  child: Text(
                    'No se ha seleccionado un paciente',
                    style: GoogleFonts.poppins(fontSize: titleFontSize, color: Colors.white),
                  ),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: const Color.fromARGB(255, 6, 98, 196).withAlpha(178), // approx 0.7 opacity
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: Text(
                              'Detalles del Paciente',
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  patient.imagen,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(width * 0.03),
                            padding: EdgeInsets.all(width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
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
                                  '${patient.nombre}, ${patient.edad} años.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: bodyFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Su dolor general es de ${patient.dolorGeneral!}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: bodyFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                SizedBox(
                                  width: width * 0.5,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => returnScreen),
                                        (route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(39, 54, 114, 1),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      'Volver',
                                      style: GoogleFonts.poppins(
                                        fontSize: bodyFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
