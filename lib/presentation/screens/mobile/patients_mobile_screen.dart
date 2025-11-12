import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/screens/mobile/mobile_data_user_screen.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'package:pain_scale_app/data/core/widgets/back_button.dart';
import 'package:provider/provider.dart';

class PatientsMobileScreen extends StatefulWidget {
  const PatientsMobileScreen({super.key});

  @override
  State<PatientsMobileScreen> createState() => _PatientsMobileScreenState();
}

class _PatientsMobileScreenState extends State<PatientsMobileScreen> {
  Future<void> _refreshPatients() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userRepository = UserRepository();
    final userModel = await userRepository.getUser(userProvider.getUid!);
    if (userModel != null) {
      userProvider.setUserModel(userModel);
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshPatients();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUserModel;
    final patients = user?.pacientes ?? [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 98, 196),

      body: PopScope(
        canPop: false,

        child: SafeArea(
          child: patients.isEmpty
          ? Center(
              child: Text(
                'No hay pacientes',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )
              ),
            )
          : SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Padding(
              padding: EdgeInsets.only(top: width * 0.05, left: width * 0.05, right: width * 0.05),
            
              child: RefreshIndicator(
                onRefresh: _refreshPatients,
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
                    Container(
                      height: height * 0.8,

                      child: ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(patient.imagen),
                            ),
                            title: Text(
                              patient.nombre,
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.035,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${patient.edad} años',
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.03,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MobileDataUserScreen(patient: patient, isEditing: true),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Eliminar paciente'),
                                        content: const Text('¿Estás seguro de que quieres eliminar este paciente?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                final patientViewModel = PatientViewModel();
                                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                                final success = await patientViewModel.deletePatient(userDocumentId: userProvider.getUid!, patientId: patient.uid);
                                
                                                if (success) {
                                                  final userRepository = UserRepository();
                                                  final userModel = await userRepository.getUser(userProvider.getUid!);
                                                  if (userModel != null) {
                                                    userProvider.setUserModel(userModel);
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Error al eliminar el paciente'),
                                                    ),
                                                  );
                                                }
                                                Navigator.pop(context);
                                              } catch (e) {
                                                print('Error al eliminar el paciente: $e');
                                              }
                                            },
                                            child: const Text('Eliminar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
