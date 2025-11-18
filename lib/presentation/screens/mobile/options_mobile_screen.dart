
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../screens.dart';

class OptionsMobileScreen extends StatelessWidget {
   
  const OptionsMobileScreen({super.key});
  
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
            color: Color.fromARGB(255, 6, 98, 196),
                  
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.9,
                    
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
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
                                  builder: ( _ ) => LoginMobileScreen(),
                                ),
                                (route) => false
                              );
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: width * 0.07,
                            ),
                          ),
                        ],
                      ),
                    ),
                          
                    SizedBox(height: height * 0.175),
                          
                    Text(
                      'Seleccione una de las\nsiguientes opciones',
                      textAlign: TextAlign.center,
                      
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: width * 0.0475,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                          
                    SizedBox(height: height * 0.01),
                      
                    OptionButton(
                      width: width,
                      height: height,
                      text: 'Agregar nuevo paciente',
                          
                      widg: MobileDataUserScreen(isEditing: false),
                    ),
                          
                    OptionButton(
                      width: width,
                      height: height,
                      text: 'Ver listado de pacientes',
                          
                      widg: PatientsMobileScreen(),
                    ),
                          
                    // Text(
                    //   'uid: ${Provider.of<UserProvider>(context).getUid}',
                    // ),
                  ],
                ),
                Positioned(
                  bottom: height * 0.01,

                  child: Container(
                    width: width * 0.6,
                    height: height * 0.2,
                    margin: EdgeInsets.only(left: width * 0.175),
                  
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo_flocas.png'),
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

class OptionButton extends StatelessWidget {
  const OptionButton({
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
            fontSize: width * 0.0475,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}