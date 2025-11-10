// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../viewmodels/storage_view_model.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';

import '../screens.dart';

class TabletDataUserScreen extends StatefulWidget {
  final PatientModel? patient;
  const TabletDataUserScreen({super.key, this.patient});

  @override
  State<TabletDataUserScreen> createState() => _TabletDataUserScreenState();
}

//IS GLOBAL
bool isCheckboxChecked = false;
bool isbuttonEnabled = false;

class _TabletDataUserScreenState extends State<TabletDataUserScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController textNameController = TextEditingController();
  final TextEditingController textAgeController = TextEditingController();
  Uint8List? _imageFile;

  bool get isEditing => widget.patient != null;

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
      isbuttonEnabled = textNameController.text.isNotEmpty && textAgeController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 55, 55, 215).withValues(alpha: 0.5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height < 800 ? height + height * 0.35 : height + height * 0.25,
          
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
                    margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.025),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: Text(
                            isEditing
                                ? 'Modificar datos del paciente'
                                : 'Ingrese los siguientes datos y acepte las recomendaciones para continuar.',
                            style: GoogleFonts.poppins(
                              fontSize:
                                  width < 800 ? width * 0.04 : width * 0.0325,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (isEditing) ...[
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              _imageFile = userProvider.getPatientPainScaleImage;
                              return CircleAvatar(
                                radius: 50,
                                backgroundImage: _imageFile != null
                                    ? MemoryImage(_imageFile!)
                                    : NetworkImage(widget.patient!.imagen)
                                        as ImageProvider,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SelectedEmojiScreen(isEditing: true),
                                ),
                              );
                            },
                            child: const Text('Cambiar imagen'),
                          ),
                          const SizedBox(height: 20),
                        ],
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
                              fontSize: width < 800 ? width * 0.03 : width * 0.0325,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Ingrese el nombre del paciente',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: width < 800 ? width * 0.03 : width * 0.0325,
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

                        Consumer<StorageViewModel>(
                          builder: (context, storageViewModel, child) {
                            return Column(
                              children: [
                                if (storageViewModel.selectedImage != null)
                                  Image.file(
                                    storageViewModel.selectedImage!,
                                    height: height * 0.2,
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    storageViewModel.pickImage(ImageSource.gallery);
                                  },
                                  child: const Text('Seleccionar Imagen'),
                                ),
                              ],
                            );
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
                              fontSize: width < 800 ? width * 0.03 : width * 0.0325,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Ingrese la edad del paciente',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: width * 0.035,
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
                            
                        SizedBox(height: height * 0.015),
                            
                        Divider(color: Colors.white70, thickness: 2),
                            
                        SizedBox(height: height * 0.01),
                            
                        Text(
                          'Estimado usuario.\nTenga en cuenta las sigientes recomendaciones para tener una mejor experiencia.\n\n'
                          'Los indicadores de dolor son subjetivos y pueden variar entre diferentes personas. Los números asignados a cada nivel de dolor son aproximados y pueden no reflejar con precisión la experiencia individual de cada paciente siendo 1 el menos doloroso y 10 el mas doloroso.\n\n'
                          'Los emojis son representaciones visuales que pueden ayudar a expresar el sentimiento de dolor en el paciente de manera rápida y sencilla. Siendo 😐 la representación más baja de dolor y 🥵 la representación más alta de dolor.\n',
                          
                          textAlign: TextAlign.justify,
                            
                          style: GoogleFonts.poppins(
                            fontSize: width < 800 ? width * 0.03 : width * 0.0325,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  
                        Row(
                          children: [
                            Checkbox(
                              value: isCheckboxChecked,
                              onChanged: (value) {
                                setState(() {
                                  isCheckboxChecked = value ?? false;
                                });
                              },
                              checkColor: Color.fromARGB(255, 6, 98, 196),
                              activeColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                  
                            Text(
                              'He leído y acepto las\nrecomendaciones.',
                              style: GoogleFonts.poppins(
                                fontSize: width < 800 ? width * 0.03 : width * 0.0325,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                            
                        SizedBox(height: height * 0.03),
                        ContinueButton(
                          width: width,
                          nameController: textNameController,
                          ageController: textAgeController,
                          patient: widget.patient,
                          isEditing: isEditing,
                          imageFile: _imageFile,
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

class ContinueButton extends StatefulWidget {
  ContinueButton(
      {super.key,
      required this.width,
      required this.nameController,
      required this.ageController,
      this.patient,
      required this.isEditing,
      this.imageFile});

  final double width;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final PatientModel? patient;
  final bool isEditing;
  final Uint8List? imageFile;

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final storageViewModel =
        Provider.of<StorageViewModel>(context, listen: false);

    void submit(UserProvider userProvider) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final patientViewModel = PatientViewModel();
      final userDocumentId = userProvider.getUserDocumentId;
      final patientName = widget.nameController.text;
      final patientAge = widget.ageController.text;

      if (userDocumentId != null) {
        if (widget.isEditing) {
          final success = await patientViewModel.updatePatient(
            userDocumentId: userDocumentId,
            patientId: widget.patient!.uid,
            newName: patientName,
            newAge: patientAge,
            newImage: widget.imageFile,
          );

          Navigator.of(context).pop();

          if (success) {
            final userModel =
                await UserRepository().getUser(userProvider.getUserDocumentId!);
            if (userModel != null) {
              userProvider.setUserModel(userModel);
            }
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error al actualizar los datos del paciente')),
            );
          }
        } else {
          if (storageViewModel.selectedImage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Por favor, seleccione una imagen.')),
            );
            return;
          }

          await storageViewModel.uploadImage(userDocumentId);
          final imageUrl = storageViewModel.imageUrl;

          if (imageUrl != null) {
            final patientId = await patientViewModel.addPatient(
              userDocumentId: userDocumentId,
              patientName: patientName,
              patientAge: patientAge,
            );

            if (patientId != null) {
              await patientViewModel.updatePatientImage(
                userDocumentId: userDocumentId,
                patientId: patientId,
                imageUrl: imageUrl,
              );

              userProvider.setPatientId(patientId);
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TabletSelectedEmojiScreen(),
                ),
              );
            } else {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Error al guardar los datos del paciente')),
              );
            }
          } else {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al subir la imagen')),
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

    return Container(
      width: widget.width * 0.9,
      child: ElevatedButton(
        // onPressed: widget.nameController.text.isNotEmpty && widget.ageController.text.isNotEmpty && isCheckboxChecked ? () {
        //Se agrega al gestor de estado el nombre del usuario.
        onPressed: isbuttonEnabled && isCheckboxChecked
            ? () => submit(userProvider)
            : null,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(39, 54, 114, 1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          widget.isEditing ? 'Guardar Cambios' : 'Continuar',
          style: TextStyle(
            fontSize: widget.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
