// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../viewmodels/storage_viewmodel.dart';
import '../screens.dart';

class MobileDataUserScreen extends StatefulWidget {
  const MobileDataUserScreen({super.key});

  @override
  State<MobileDataUserScreen> createState() => _MobileDataUserScreenState();
}

//IS GLOBAL
bool isCheckboxCheckedM = false;
bool isbuttonEnabledM = false;

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
      isbuttonEnabledM = textNameController.text.isNotEmpty && textAgeController.text.isNotEmpty;
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
                    margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.025),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: Text(
                            'Ingrese los siguientes datos y acepte las recomendaciones para continuar.',
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
                            
                        SizedBox(height: height * 0.015),
                            
                        Divider(color: Colors.white70, thickness: 2),
                            
                        SizedBox(height: height * 0.01),
                            
                        Text(
                          'Estimado usuario.\nTenga en cuenta las sigientes recomendaciones para tener una mejor experiencia.\n\n'
                          'Los indicadores de dolor son subjetivos y pueden variar entre diferentes personas. Los números asignados a cada nivel de dolor son aproximados y pueden no reflejar con precisión la experiencia individual de cada paciente siendo 1 el menos doloroso y 10 el mas doloroso.\n\n'
                          'Los emojis son representaciones visuales que pueden ayudar a expresar el sentimiento de dolor en el paciente de manera rápida y sencilla. Siendo 😐 la representación más baja de dolor y 🥵 la representación más alta de dolor.\n',
                          
                          textAlign: TextAlign.justify,
                            
                          style: GoogleFonts.poppins(
                            fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  
                        Row(
                          children: [
                            Checkbox(
                              value: isCheckboxCheckedM,
                              onChanged: (value) {
                                setState(() {
                                  isCheckboxCheckedM = value ?? false;
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
                                fontSize: width < 800 ? width * 0.04 : width * 0.0325,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                            
                        SizedBox(height: height * 0.03), 
                            
                        ContinueButtonM(width: width, nameController: textNameController, ageController: textAgeController),
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

class ContinueButtonM extends StatefulWidget {
  ContinueButtonM({
    super.key,
    required this.width,
    required this.nameController,
    required this.ageController,
  });

  final double width;
  final TextEditingController nameController;
  final TextEditingController ageController;

  @override
  State<ContinueButtonM> createState() => _ContinueButtonMState();
}

class _ContinueButtonMState extends State<ContinueButtonM> {

  @override
  Widget build(BuildContext context) {
    final storageViewModel = Provider.of<StorageViewModel>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    void submit() async {
      if (storageViewModel.selectedImage == null) {
        // Mostrar un mensaje de error si no se ha seleccionado ninguna imagen.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione una imagen.')),
        );
        return;
      }

      await storageViewModel.uploadImage(userProvider.getAgeUser.toString());

      if (storageViewModel.imageUrl != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        users.doc(userProvider.getUser).collection('patients').add({
          'name': widget.nameController.text,
          'age': widget.ageController.text,
          'image': storageViewModel.imageUrl,
        });

        Provider.of<UserProvider>(context, listen: false).setUser(widget.nameController.text);
        Provider.of<UserProvider>(context, listen: false).setAgeUser(widget.ageController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectedEmojiScreen(),
          ),
        );
      }
    }

    return Container(
      width: widget.width * 0.9,
      child: ElevatedButton(
        // onPressed: widget.nameController.text.isNotEmpty && widget.ageController.text.isNotEmpty && isCheckboxCheckedM ? () {
          //Se agrega al gestor de estado el nombre del usuario.
        onPressed: isbuttonEnabledM && isCheckboxCheckedM ? submit : null,

        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(39, 54, 114, 1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Continuar',
          style: TextStyle(
            fontSize: widget.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
