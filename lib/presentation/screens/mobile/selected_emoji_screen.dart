// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, unused_field

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:pain_scale_app/presentation/providers/providers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import '../../../data/services/storage_service.dart';
import '../screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedEmojiScreen extends StatefulWidget {
  const SelectedEmojiScreen({super.key});

  @override
  _SelectedEmojiScreenState createState() => _SelectedEmojiScreenState();
}

class _SelectedEmojiScreenState extends State<SelectedEmojiScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey _screenshotKey = GlobalKey();

  final List<String> emojiSounds = [
    // Aquí van los sonidos, uno por cada emoji
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

  Future<Uint8List?> _capturarImagen() async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturando imagen: $e");
      return null;
    }
  }

  final List<String> emojis = [
    "😐", "😕", "😞", "😓", "😢", "😨", "😪", "😵", "🤢", "😰", "🥵"
  ];

  int? selectedEmojiIndex;
  // final List<Offset> _wavePositions = [];
  // Posiciones fijas para las ondas (ajusta según tus necesidades)
  // Usar proporciones para posiciones (relativas al área de la imagen)
  final List<Map<String, double>> _fixedWavePositions = [
    {"left": 0.56, "top": 0.06},
    {"left": 0.45, "top": 0.13},
    {"left": 0.65, "top": 0.13},
    {"left": 0.56, "top": 0.18}, 

    {"left": 0.55, "top": 0.32}, //Pecho 1
    {"left": 0.39, "top": 0.32}, //clavicula IZQ
    {"left": 0.71, "top": 0.32}, //clavicula DER
    
    {"left": 0.30, "top": 0.38}, //brazo IZQ 1
    {"left": 0.28, "top": 0.48}, //brazo IZQ 2
    {"left": 0.27, "top": 0.60}, //brazo IZQ 3
    {"left": 0.26, "top": 0.70}, //brazo IZQ 4
    {"left": 0.24, "top": 0.80}, //mano IZQ
    {"left": 0.86, "top": 0.48},
    {"left": 0.88, "top": 0.68}, 
    {"left": 0.90, "top": 0.85}, 
    {"left": 0.55, "top": 0.40}, 
    {"left": 0.55, "top": 0.60}, 
    {"left": 0.43, "top": 0.77}, 
    {"left": 0.69, "top": 0.77}, 
    {"left": 0.40, "top": 0.95}, 
    {"left": 0.72, "top": 0.95}, 
    {"left": 0.40, "top": 1.13}, 
    {"left": 0.72, "top": 1.13}, 
    {"left": 0.40, "top": 1.3}, 
    {"left": 0.73, "top": 1.3}, 
    {"left": 0.41, "top": 1.5},
    {"left": 0.7, "top": 1.5}, 
  ];
  // Visibilidad de cada onda
  late List<bool> _waveVisible;

  @override
  void initState() {
    super.initState();
    // Inicialmente todas las ondas están ocultas
    _waveVisible = List<bool>.filled(_fixedWavePositions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PopScope(
        canPop: false,

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
                  color: Color.fromARGB(255, 6, 98, 196).withOpacity(0.6),
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
                          'Escala de dolor',
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
                    Text(
                      '¿Cómo está tu dolor hoy?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //const SizedBox(height: 20),
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
        
                        // ListView y otros widgets primero
                        ListView.builder(
                          itemCount: emojis.length,
                          padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.05),
                          itemBuilder: (context, index) {
                            final isSelected = selectedEmojiIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedEmojiIndex = index;
                                  Provider.of<UserProvider>(context, listen: false).setNumberPain(index.toString());
                                });
                                if (index != 0) {
                                  _playClickSound(index - 1);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
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
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                        width: isSelected ? width * 0.225 : width * 0.125,
                                        height: isSelected ? width * 0.225 : width * 0.125,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.yellowAccent.withOpacity(0.8),
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
                                              fontSize: isSelected ? width * 0.145 : width * 0.08,
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
                          child: WaveTapScreen(key: _screenshotKey),
                        ),
                      ],
                    ),
                  ),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: height * 0.01, left: width * 0.05),
        
                        child: Text(
                          'Diclofenaco sódico + Betametasona\n+ Hidroxocobalamina',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
        
                      Container(
                        width: width * 0.1,
                        height: width * 0.1,
                        margin: EdgeInsets.only(bottom: height * 0.01, right: width * 0.05),
        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            final userDocumentId = userProvider.getUserDocumentId;
                            final patientId = userProvider.getPatientId;
        
                            if (userDocumentId == null || patientId == null) {
                              print("Error: userDocumentId o patientId es nulo.");
                              // Opcional: Mostrar un mensaje al usuario.
                              return;
                            }
        
                            final imageData = await _capturarImagen();
                            if (imageData != null) {
                              final storageService = StorageService();
                              final imageUrl = await storageService.uploadImage(
                                  imageData, userDocumentId, patientId);
        
                              if (imageUrl != null) {
                                // Guardar la URL en Firestore
                                await FirebaseFirestore.instance
                                    .collection('usuarios')
                                    .doc(userDocumentId)
                                    .collection('patients')
                                    .doc(patientId)
                                    .update({'painScaleImage': imageUrl});
                                print("Imagen subida y URL guardada con éxito.");
                              } else {
                                print("Error al subir la imagen.");
                              }
                            } else {
                              print("Error al capturar la imagen.");
                            }
        
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MobileDataScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_sharp, color: Colors.black, size: width * 0.06),
                        ),
                      ),
                    ],
                  ),
                ]
              )
            )],
            )),
      ));
  }
}
