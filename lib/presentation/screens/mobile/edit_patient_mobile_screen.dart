// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:pain_scale_app/data/models/patient_model.dart';
import 'package:pain_scale_app/presentation/providers/providers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';

class EditPatientMobileScreen extends StatefulWidget {
  final PatientModel patient;

  const EditPatientMobileScreen({super.key, required this.patient});

  @override
  _EditPatientMobileScreenState createState() =>
      _EditPatientMobileScreenState();
}

class _EditPatientMobileScreenState extends State<EditPatientMobileScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey _screenshotKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final List<String> emojiSounds = [
    "sounds/sound3.mp3",
    "sounds/sound10.mp3",
    "sounds/sound1.mp3",
    "sounds/sound8.mp3",
    "sounds/sound5.mp3",
    "sounds/sound4.mp3",
    "sounds/sound7.mp3",
    "sounds/sound9.mp3",
    "sounds/sound6.mp3",
    "sounds/sound2.mp3",
  ];

  Future<void> _playClickSound(int index) async {
    if (index >= 0 && index < emojiSounds.length) {
      await _audioPlayer.play(AssetSource(emojiSounds[index]));
    }
  }

  Future<Uint8List?> _captureImage() async {
    try {
      RenderRepaintBoundary boundary =
          _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }

  final List<String> emojis = [
    "😐", "😕", "😞", "😓", "😢", "😨", "😪", "😵", "🤢", "😰", "🥵"
  ];

  int? selectedEmojiIndex;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.patient.nombre;
    _ageController.text = widget.patient.edad;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PopScope(
        canPop: true,
        child: SafeArea(
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
                  color: const Color.fromARGB(255, 6, 98, 196).withOpacity(0.6),
                ),
              ),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Editar Paciente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: width * 0.04),
                        SizedBox(
                          width: width * 0.35,
                          child: Image.asset(
                            'assets/images/logo_flocas.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: height * 0.02),
                          TextField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Edad',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            top: height * 0.1,
                            child: Image.asset(
                              'assets/images/circulo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          ListView.builder(
                            itemCount: emojis.length,
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                                horizontal: width * 0.05),
                            itemBuilder: (context, index) {
                              final isSelected = selectedEmojiIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedEmojiIndex = index;
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .setNumberPain(index.toString());
                                  });
                                  if (index != 0) {
                                    _playClickSound(index - 1);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        index.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.055,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                        width: isSelected
                                            ? width * 0.225
                                            : width * 0.125,
                                        height: isSelected
                                            ? width * 0.225
                                            : width * 0.125,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.yellowAccent
                                                        .withOpacity(0.8),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                  )
                                                ]
                                              : [],
                                        ),
                                        child: Center(
                                          child: Text(
                                            emojis[index],
                                            style: TextStyle(
                                              fontSize: isSelected
                                                  ? width * 0.145
                                                  : width * 0.08,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(width * 0.05),
                            margin: EdgeInsets.only(right: width * 0.2),
                            child: RepaintBoundary(
                              key: _screenshotKey,
                              child: WaveTapScreen(captureKey: _screenshotKey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          final patientViewModel = Provider.of<PatientViewModel>(
                              context,
                              listen: false);

                          final userId = userProvider.getUserDocumentId;

                          if (userId != null) {
                            final imageBytes = await _captureImage();

                            await patientViewModel.updatePatient(
                              userDocumentId: userId,
                              patientId: widget.patient.uid,
                              newName: _nameController.text,
                              newAge: _ageController.text,
                              newImage: imageBytes,
                            );

                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print("Error updating patient: $e");
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
