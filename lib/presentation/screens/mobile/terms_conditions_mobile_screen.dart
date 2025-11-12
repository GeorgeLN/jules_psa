import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/data/core/widgets/back_button.dart';

import '../screens.dart';

class TermsConditionsMobileScreen extends StatefulWidget {
   
  const TermsConditionsMobileScreen({super.key});

  @override
  State<TermsConditionsMobileScreen> createState() => _TermsConditionsMobileScreenState();
}

//GLOBAL VALUES
bool isCheckboxCheckedM = false;
bool isbuttonEnabledM = false;

class _TermsConditionsMobileScreenState extends State<TermsConditionsMobileScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 98, 196),
      body: PopScope(
        canPop: false,
        
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
                  
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
                  
            child: Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.only(right: width * 0.8, top: height * 0.02),
                  
                //   child: ButtonBack(
                //     width: width,
                //     height: height,
                //   ),
                // ),
          
                SizedBox(height: height * 0.025),
                  
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
                  
                ContinueButtonM(width: width),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class ContinueButtonM extends StatefulWidget {
  const ContinueButtonM({
    super.key,
    required this.width,
  });

  final double width;

  @override
  State<ContinueButtonM> createState() => _ContinueButtonMState();
}

class _ContinueButtonMState extends State<ContinueButtonM> {

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);

    // void submit() async {
      
    //     CollectionReference users = FirebaseFirestore.instance.collection('usuarios');
    //     DocumentReference patientRef = await users.doc(FirebaseAuth.instance.currentUser!.uid).collection('patients').add({
    //       'name': widget.nameController.text,
    //       'age': widget.ageController.text,
    //     });

    //     userProvider.setUser(widget.nameController.text);
    //     userProvider.setAgeUser(widget.ageController.text);

    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const SelectedEmojiScreen(),
    //       ),
    //     );
    // }

    return Container(
      width: widget.width * 0.9,
      child: ElevatedButton(
        // onPressed: widget.nameController.text.isNotEmpty && widget.ageController.text.isNotEmpty && isCheckboxCheckedM ? () {
          //Se agrega al gestor de estado el nombre del usuario.
        onPressed: isCheckboxCheckedM 
        ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OptionsMobileScreen(),
            ),
          );
        }
        : null,

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
