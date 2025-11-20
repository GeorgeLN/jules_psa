import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/screens/mobile/mobile_data_screen.dart';
import 'package:pain_scale_app/presentation/screens/mobile/mobile_data_user_screen.dart';
import 'package:pain_scale_app/presentation/screens/mobile/options_mobile_screen.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'package:provider/provider.dart';

class PatientsMobileScreen extends StatefulWidget {
  const PatientsMobileScreen({super.key});

  @override
  State<PatientsMobileScreen> createState() => _PatientsMobileScreenState();
}

class _PatientsMobileScreenState extends State<PatientsMobileScreen> {
  Map<String, bool> _expandedStates = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Future<void> _refreshPatients() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userRepository = UserRepository();
    final userModel = await userRepository.getUser(userProvider.getUid!);
    if (userModel != null) {
      userProvider.setUserModel(userModel);
      if (mounted) {
        setState(() {
          _expandedStates = {
            for (var patient in userModel.pacientes) patient.uid: false
          };
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final patients = userProvider.getUserModel?.pacientes ?? [];
    _expandedStates = {for (var patient in patients) patient.uid: false};
    _refreshPatients();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUserModel;
    final patients = user?.pacientes.reversed.toList() ?? [];
    final filteredPatients = patients.where((patient) {
      return patient.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 80, 166, 1),

      body: PopScope(
        canPop: false,

        child: SafeArea(
          child: patients.isEmpty
          ? Stack(
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
              Center(
                child: Text(
                  'No hay pacientes',
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )
                ),
              ),
            ],
          )
          : Stack(
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
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
              
                child: Padding(
                  padding: EdgeInsets.only(top: width * 0.05, left: width * 0.05, right: width * 0.05),
                
                  child: RefreshIndicator(
                    onRefresh: _refreshPatients,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.8, top: height * 0.02),
                          // child: ButtonBack(
                          //   width: width,
                          //   height: height,
                          // ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OptionsMobileScreen()));
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: width * 0.08
                            )
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Buscar paciente',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width * 0.025),
                              ),
                              prefixIcon: const Icon(Icons.search, color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          height: height * 0.7,
              
                          child: ListView.builder(
                            itemCount: filteredPatients.length,
                            itemBuilder: (context, index) {
                              final patient = filteredPatients[index];
                              return Card(
                                color: const Color.fromRGBO(39, 54, 114, 1),
                                margin: EdgeInsets.symmetric(vertical: width * 0.015),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(width * 0.025),
                                ),
              
                                child: ExpansionTile(
                                  backgroundColor: Color.fromRGBO(39, 54, 114, 1),
                                  initiallyExpanded: _expandedStates[patient.uid] ?? false,
                                  onExpansionChanged: (bool expanded) {
                                    setState(() {
                                      _expandedStates[patient.uid] = expanded;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(width * 0.025),
                                  ),
                                  trailing: Icon(
                                    _expandedStates[patient.uid] ?? false ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: width * 0.08,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: width * 0.08,
                                    ),
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
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit, color: Colors.white),
                                      title: const Text('Editar', style: TextStyle(color: Colors.white)),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MobileDataUserScreen(patient: patient, isEditing: true),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete, color: Colors.white),
                                      title: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                                      onTap: () {
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
                                                        const SnackBar(content: Text('Error al eliminar el paciente')),
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
                                    ListTile(
                                      leading: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white
                                      ),
                                      title: const Text('Ver detalles', style: TextStyle(color: Colors.white)),
                                      onTap: () {
                                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                                        userProvider.setPatientModel(patient);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const MobileDataScreen(),
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
              // Positioned(
              //   bottom: height * 0.01,

              //   child: Container(
              //     width: width * 0.6,
              //     height: height * 0.2,
              //     margin: EdgeInsets.only(left: width * 0.2),
                
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage('assets/images/logo_flocas.png'),
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
