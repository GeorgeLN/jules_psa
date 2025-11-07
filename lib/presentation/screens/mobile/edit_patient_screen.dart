import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'package:provider/provider.dart';

class EditPatientScreen extends StatefulWidget {
  final PatientModel patient;

  const EditPatientScreen({super.key, required this.patient});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  Uint8List? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.nombre);
    _ageController = TextEditingController(text: widget.patient.edad);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  _imageFile = userProvider.getPatientPainScaleImage;
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? MemoryImage(_imageFile!)
                        : NetworkImage(widget.patient.imagen) as ImageProvider,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectedEmojiScreen(
                        isChanging: true,
                      ),
                    ),
                  );
                },
                child: const Text('Cambiar imagen'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una edad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final patientViewModel = PatientViewModel();
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);

                    final success = await patientViewModel.updatePatient(
                      userDocumentId: userProvider.getUserDocumentId!,
                      patientId: widget.patient.uid,
                      newName: _nameController.text,
                      newAge: _ageController.text,
                      newImage: _imageFile,
                    );

                    if (success) {
                      final userRepository = UserRepository();
                      final userModel = await userRepository
                          .getUser(userProvider.getUserDocumentId!);
                      if (userModel != null) {
                        userProvider.setUserModel(userModel);
                      }
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al actualizar el paciente'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
