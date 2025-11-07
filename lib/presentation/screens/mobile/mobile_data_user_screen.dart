// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/widgets/back_button.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../viewmodels/patient_view_model.dart';
import '../../viewmodels/storage_view_model.dart';
import '../screens.dart';

class MobileDataUserScreen extends StatefulWidget {
  const MobileDataUserScreen({super.key});

  @override
  State<MobileDataUserScreen> createState() => _MobileDataUserScreenState();
}

class _MobileDataUserScreenState extends State<MobileDataUserScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController textNameController = TextEditingController();
  final TextEditingController textAgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textNameController.addListener(_validateForm);
    textAgeController.addListener(_validateForm);
  }

  @override
  void dispose() {
    textNameController.dispose();
    textAgeController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // isbuttonEnabledM = textNameController.text.isNotEmpty && textAgeController.text.isNotEmpty;
    });
  }

  Future<void> _saveUserData() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final patientViewModel = PatientViewModel();

      final userDocumentId = userProvider.getUid;
      final patientName = textNameController.text;
      final patientAge = textAgeController.text;

      if (userDocumentId != null) {
        final patientId = await patientViewModel.addPatient(
          userDocumentId: userDocumentId,
          patientName: patientName,
          patientAge: patientAge,
        );

        Navigator.of(context).pop();

        if (patientId != null) {
          userProvider.setPatientId(patientId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectedEmojiScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar los datos del paciente')),
          );
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No se ha encontrado el usuario')),
        );
      }
    }
  }

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
            height: height + height * 0.1,
          
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

                Form(
                  key: formKey,
                  child: Container(
                    margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                    child: Column(
                      children: [
                        ButtonBack(
                          width: width,
                          height: height,
                        ),
                  
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: height * 0.03),
                  
                          child: Text(
                            'Ingrese los datos del paciente',
                            style: GoogleFonts.poppins(
                              fontSize: width < 800 ? width * 0.05 : width * 0.0325,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                            
                        TextFormField(
                          controller: textNameController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                                  
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.04,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                                  
                          decoration: InputDecoration(
                            labelText: 'Nombre del Paciente',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Ingrese el nombre del paciente',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                                        
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el nombre del paciente';
                            }
                            return null;
                          },
                        ),
                  
                        SizedBox(height: height * 0.02),
                            
                        TextFormField(
                          controller: textAgeController,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.white,
                            
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.04,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                            
                          decoration: InputDecoration(
                            labelText: 'Edad del Paciente',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Ingrese la edad del paciente',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                  
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la edad del paciente';
                            }
                            return null;
                          },
                        ),
                            
                        SizedBox(height: height * 0.03), 
                            
                        Container(
                          width: width * 0.9,
                  
                          child: ElevatedButton(
                            onPressed: () {
                              _saveUserData();
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
                              'Guardar y Continuar',
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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