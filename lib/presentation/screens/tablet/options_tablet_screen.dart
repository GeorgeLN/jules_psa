
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/screens/tablet/login_tablet_screen.dart';
import 'package:pain_scale_app/presentation/screens/tablet/patients_tablet_screen.dart';
import 'package:pain_scale_app/presentation/screens/tablet/tablet_data_user_screen.dart';
import 'package:provider/provider.dart';


class OptionsTabletScreen extends StatelessWidget {

  const OptionsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PopScope(
        canPop: false,

        child: SafeArea(
          child: Container(
            width: width ,
            height: height,
            color: Color.fromRGBO(0, 80, 166, 1),

            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),

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
                Column(
                  children: [
                    SizedBox(height: height * 0.075),
                
                    Container(
                      width: width,
                
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              //Logout action
                              FirebaseAuth.instance.signOut();
                              Provider.of<UserProvider>(context, listen: false).clearUser();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: ( _ ) => LoginTabletScreen(),
                                ),
                                (route) => false
                              );
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: width * 0.05,
                            ),
                          )
                        ],
                      ),
                    ),
                
                    SizedBox(height: height * 0.175),
                
                    Text(
                      'Seleccione una de las\nsiguientes opciones',
                      textAlign: TextAlign.center,
                
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                
                    SizedBox(height: height * 0.01),
                
                    OptionButtonT(
                      width: width,
                      height: height,
                      text: 'Agregar nuevo paciente',
                
                      widg: TabletDataUserScreen(isEditing: false),
                    ),
                
                    OptionButtonT(
                      width: width,
                      height: height,
                      text: 'Ver listado de pacientes',
                
                      widg: PatientsTabletScreen(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: height * 0.015,

                  child: Container(
                    width: width * 0.55,
                    height: height * 0.1,
                    margin: EdgeInsets.only(left: width * 0.17),
                  
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logotipo.png'),
                        fit: BoxFit.contain,
                      ),
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

class OptionButtonT extends StatelessWidget {
  const OptionButtonT({
    super.key,
    required this.width,
    required this.height,
    required this.widg,
    required this.text,
  });

  final double width;
  final double height;
  final Widget widg;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.75,
      margin: EdgeInsets.only(
        top: height * 0.025,
      ),

      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ( _ ) => widg,
            ),
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
            fontSize: width < 800 ? width * 0.04 : width * 0.0325,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
