// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/data/core/widgets/back_button.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../viewmodels/patient_view_model.dart';
import '../screens.dart';

class MobileDataUserScreen extends StatefulWidget {
  const MobileDataUserScreen({super.key, this.patient, required this.isEditing});

  final PatientModel? patient;
  final bool isEditing;

  @override
  State<MobileDataUserScreen> createState() => _MobileDataUserScreenState();
}

class _MobileDataUserScreenState extends State<MobileDataUserScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController textNameController = TextEditingController();
  final TextEditingController textAgeController = TextEditingController();
  Uint8List? _imageFile;

  bool get isEditing {
    return widget.patient != null;
  }

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      textNameController.text = widget.patient!.nombre;
      textAgeController.text = widget.patient!.edad;
    }
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

  Future<void> _savePatientData() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final patientViewModel = PatientViewModel();

      final userDocumentId = userProvider.getUid;
      final patientName = textNameController.text;
      final patientAge = textAgeController.text;

      if (userDocumentId != null) {
        if (isEditing) {
          final success = await patientViewModel.updatePatient(
            userDocumentId: userDocumentId,
            patientId: widget.patient!.uid,
            newName: patientName,
            newAge: patientAge,
            newImage: _imageFile,
          );

          Navigator.of(context).pop();

          if (success) {
            final userModel = await UserRepository().getUser(userProvider.getUid!);
            if (userModel != null) {
              userProvider.setUserModel(userModel);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectedEmojiScreen(isEditing: true, patient: widget.patient,),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error al actualizar los datos del paciente')),
            );
          }
        } else {
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
                builder: (context) => SelectedEmojiScreen(isEditing: false, patientId: patientId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error al guardar los datos del paciente')),
            );
          }
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se ha encontrado el usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 80, 166, 1),
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
                    color: Color.fromARGB(255, 6, 98, 196).withValues(alpha: 0.7),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Container(
                    margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                    child: Column(
                      children: [
                
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.8, top: height * 0.02),
                
                          child: ButtonBack(
                            width: width,
                            height: height,
                          ),
                        ),
                
                        SizedBox(height: height * 0.02),
                  
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.05,
                              right: width * 0.05,
                              bottom: height * 0.03),
                          child: Text(
                            isEditing
                                ? 'Modificar datos del paciente'
                                : 'Ingrese los datos del paciente',
                            style: GoogleFonts.poppins(
                              fontSize:
                                  width < 800 ? width * 0.05 : width * 0.0325,
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
                              FocusScope.of(context).unfocus();
                              _savePatientData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(39, 54, 114, 1),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              isEditing
                                  ? 'Guardar y continuar'
                                  : 'Guardar y continuar',
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