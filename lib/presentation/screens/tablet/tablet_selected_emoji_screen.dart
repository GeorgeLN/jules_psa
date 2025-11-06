// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, sized_box_for_whitespace, unused_field

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:pain_scale_app/data/services/storage_service.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../../widgets/wave_tap_screen_tablet.dart';
import '../screens.dart';

class TabletSelectedEmojiScreen extends StatefulWidget {
  const TabletSelectedEmojiScreen({super.key});

  @override
  _TabletSelectedEmojiScreenState createState() => _TabletSelectedEmojiScreenState();
}

class _TabletSelectedEmojiScreenState extends State<TabletSelectedEmojiScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey _screenshotKey = GlobalKey();

  // Posiciones relativas de las ondas (ajustadas para tablet)
  final List<Map<String, double>> _fixedWavePositions = [
    {"left": 0.53, "top": 0.07},   // cabeza
    //{"left": 0.53, "top": 0.16},  // cuello
    {"left": 0.41, "top": 0.23},  // hombro izquierdo
    {"left": 0.65, "top": 0.23},  // hombro derecho
    {"left": 0.30, "top": 0.35},  // brazo izquierdo
    {"left": 0.75, "top": 0.35},  // brazo derecho
    {"left": 0.30, "top": 0.50},  // antebrazo izquierdo
    {"left": 0.76, "top": 0.50},  // antebrazo derecho
    {"left": 0.28, "top": 0.63},  // mano izquierda
    {"left": 0.78, "top": 0.63},  // mano derecha
    {"left": 0.53, "top": 0.30},  // pecho
    {"left": 0.53, "top": 0.45},  // abdomen
    {"left": 0.43, "top": 0.57},  // cadera izq
    {"left": 0.62, "top": 0.57},  // cadera der
    {"left": 0.43, "top": 0.70},  // pierna izq
    {"left": 0.63, "top": 0.70},  // pierna der
    {"left": 0.41, "top": 0.82},  // rodilla izq
    {"left": 0.64, "top": 0.82},  // rodilla der
    {"left": 0.40, "top": 0.95},   // antepierna izq
    {"left": 0.65, "top": 0.95},   // antepierna der
    {"left": 0.43, "top": 1.11},   // pie izq
    {"left": 0.63, "top": 1.11},    // pie der
  ];

  late List<bool> _waveVisible;

  @override
  void initState() {
    super.initState();
    _waveVisible = List<bool>.filled(_fixedWavePositions.length, false);
  }
  

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print("Width: $width, Height: $height");

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            // Overlay azul translúcido
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 6, 98, 196).withOpacity(0.6),
              ),
            ),
            // Contenido principal
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Escala de dolor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      SizedBox(
                        width: width * 0.26,
                        child: Image.asset(
                          'assets/images/logo_flocas.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    'Hola, ¿cómo está tu dolor hoy?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: height * 0.1,
                          child: Container(
                            width: width * 0.625,
                            child: Image.asset(
                              'assets/images/circulo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: emojis.length,
                          padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.1),
                          itemBuilder: (context, index) {
                            final isSelected = selectedEmojiIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedEmojiIndex = index;
                                });
                                if (index != 0) {
                                  _playClickSound(index - 1);
                                }
                              },
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
                                    width: isSelected ? width * 0.14 : width * 0.09,
                                    height: isSelected ? width * 0.14 : width * 0.09,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.yellow.withOpacity(0.8),
                                              blurRadius: 18,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      emojis[index],
                                      style: TextStyle(
                                        fontSize: isSelected ? width * 0.065 : width * 0.05,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        Container(
                          margin: EdgeInsets.only(left: width * 0.05),
                          width: width * 0.6,
                          child: WaveTapScreenTablet(),
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
                          textAlign: TextAlign.center,
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
                                  .collection('users')
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
