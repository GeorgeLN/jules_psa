import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/presentation/screens/tablet/first_tablet_screen.dart';

class TermsConditionsTabletScreen extends StatefulWidget {

  const TermsConditionsTabletScreen({super.key});

  @override
  State<TermsConditionsTabletScreen> createState() => _TermsConditionsTabletScreenState();
}

class _TermsConditionsTabletScreenState extends State<TermsConditionsTabletScreen> {
  bool isCheckboxCheckedT = false;

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

            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),

            child: Column(
              children: [
                SizedBox(height: height * 0.025),

                Text(
                  'Estimado usuario.\nTenga en cuenta las sigientes recomendaciones para tener una mejor experiencia.\n\n'
                  'Los indicadores de dolor son subjetivos y pueden variar entre diferentes personas. Los números asignados a cada nivel de dolor son aproximados y pueden no reflejar con precisión la experiencia individual de cada paciente siendo 1 el menos doloroso y 10 el mas doloroso.\n\n'
                  'Los emojis son representaciones visuales que pueden ayudar a expresar el sentimiento de dolor en el paciente de manera rápida y sencilla. Siendo 😐 la representación más baja de dolor y 🥵 la representación más alta de dolor.\n',

                  textAlign: TextAlign.justify,

                  style: GoogleFonts.poppins(
                    fontSize: width * 0.03,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Row(
                  children: [
                    Checkbox(
                      value: isCheckboxCheckedT,
                      onChanged: (value) {
                        setState(() {
                          isCheckboxCheckedT = value ?? false;
                        });
                      },
                      checkColor: Color.fromRGBO(0, 80, 166, 1),
                      activeColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),

                    Text(
                      'He leído y acepto las\nrecomendaciones.',
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.03,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.03),

                ContinueButtonT(width: width, isCheckboxChecked: isCheckboxCheckedT),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class ContinueButtonT extends StatelessWidget {
  const ContinueButtonT({
    super.key,
    required this.width,
    required this.isCheckboxChecked,
  });

  final double width;
  final bool isCheckboxChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.9,
      child: ElevatedButton(
        onPressed: isCheckboxChecked
        ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FirstTabletScreen(),
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
            fontSize: width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
