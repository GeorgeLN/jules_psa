import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class TabletDataScreen extends StatelessWidget {
  const TabletDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final patientPainScaleImage =
        Provider.of<UserProvider>(context).getPatientPainScaleImage;
    final userName =
        Provider.of<UserProvider>(context).getUser ?? 'Usuario no definido';
    final numberPain = Provider.of<UserProvider>(context).getNumberPain ?? '';
    final firstName = userName.split(' ').first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Resultados',
          style: GoogleFonts.poppins(
            fontSize: width < 800 ? width * 0.04 : width * 0.04,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 7, 84, 169).withValues(alpha: 0.8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: width < 800 ? width * 0.05 : width * 0.04),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
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
            Column(
              children: [
                Center(
                  child: patientPainScaleImage != null
                      ? Container(
                          width: width * 0.8,
                          height: height * 0.55,
                          margin: const EdgeInsets.all(20),
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
                          child: Image.memory(patientPainScaleImage))
                      : const Text('No image selected'),
                ),
                patientPainScaleImage != null
                    ? Container(
                        margin: EdgeInsets.all(width * 0.008),
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
                    child: Text(
                      '$firstName, su dolor seleccionado en la escala de dolor es de: [$numberPain]',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                        color: Colors.black
                      ),
                    ),
                  )
                  : Text(
                    'No se ha seleccionado un paciente',
                    style: GoogleFonts.poppins(fontSize: width * 0.05, color: Colors.black),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
