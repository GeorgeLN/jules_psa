import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'package:provider/provider.dart';

import 'edit_patient_screen.dart';

class PatientsMobileScreen extends StatelessWidget {
  const PatientsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUserModel;
    final patients = user?.pacientes ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),
      body: patients.isEmpty
          ? const Center(
              child: Text('No hay pacientes'),
            )
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(patient.imagen),
                  ),
                  title: Text(patient.nombre),
                  subtitle: Text('${patient.edad} años'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPatientScreen(patient: patient),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar paciente'),
                              content: const Text(
                                  '¿Estás seguro de que quieres eliminar este paciente?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final patientViewModel =
                                        PatientViewModel();
                                    final userProvider =
                                        Provider.of<UserProvider>(context,
                                            listen: false);
                                    final success =
                                        await patientViewModel.deletePatient(
                                      userDocumentId:
                                          userProvider.getUserDocumentId!,
                                      patientId: patient.uid,
                                    );
                                    if (success) {
                                      final userRepository =
                                          UserRepository();
                                      final userModel =
                                          await userRepository.getUser(
                                              userProvider.getUserDocumentId!);
                                      if (userModel != null) {
                                        userProvider
                                            .setUserModel(userModel);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Error al eliminar el paciente'),
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
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
    );
  }
}
