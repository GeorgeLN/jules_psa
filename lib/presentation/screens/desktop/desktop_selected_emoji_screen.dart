// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, unused_field, library_private_types_in_public_api

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../data/core/widgets/wave_tap_screen_desktop.dart';

class DesktopSelectedEmojiScreen extends StatefulWidget {
  const DesktopSelectedEmojiScreen({super.key});

  @override
  _DesktopSelectedEmojiScreenState createState() => _DesktopSelectedEmojiScreenState();
}

class _DesktopSelectedEmojiScreenState extends State<DesktopSelectedEmojiScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  final List<String> emojis = [
    "😐", "😕", "😞", "😓", "😢", "😨", "😪", "😵", "🤢", "😰", "🥵"
  ];

  int? selectedEmojiIndex;

    final List<Map<String, double>> _fixedWavePositions = [
    {"left": 0.2, "top": 0.06},   // cabeza
    //{"left": 0.16, "top": 0.23},  // cuello
    {"left": 0.15, "top": 0.20},  // hombro izquierdo
    {"left": 0.25, "top": 0.20},  // hombro derecho
    {"left": 0.08, "top": 0.27},  // brazo izquierdo
    {"left": 0.31, "top": 0.27},  // brazo derecho
    {"left": 0.07, "top": 0.40},  // antebrazo izquierdo
    {"left": 0.32, "top": 0.40},  // antebrazo derecho
    {"left": 0.07, "top": 0.52},  // mano izquierda
    {"left": 0.33, "top": 0.52},  // mano derecha
    {"left": 0.20, "top": 0.25},  // pecho
    {"left": 0.20, "top": 0.38},  // abdomen
    {"left": 0.14, "top": 0.48},  // cadera izq
    {"left": 0.255, "top": 0.48},  // cadera der
    {"left": 0.14, "top": 0.60},  // pierna izq
    {"left": 0.255, "top": 0.60},  // pierna der
    {"left": 0.13, "top": 0.72},  // rodilla izq
    {"left": 0.265, "top": 0.72},  // rodilla der
    {"left": 0.135, "top": 0.83},   // antepierna izq
    {"left": 0.26, "top": 0.83},   // antepierna der
    {"left": 0.14, "top": 0.94},   // pie izq
    {"left": 0.255, "top": 0.94},   // pie der
  ];

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
    print("Width: $width, Height: $height");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 98, 196).withOpacity(0.6),
      body: Row(
        children: [
          // Panel lateral informativo
          Container(
            width: width * 0.3,
            color: Colors.blueGrey.shade50,
            child: Stack(
              children: [
                Positioned(
                  top: height * 0.1,
                  child: Image.asset(
                    'assets/images/circulo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                WaveTapScreenDesktop(),
              ],
            ),
          ),
          // Pantalla principal
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Escala de dolor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    SizedBox(
                      width: width * 0.18,
                      child: Image.asset(
                        'assets/images/logotipo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Hola, ¿cómo está tu dolor hoy?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.025),
                Wrap(
                  spacing: width * 0.01,
                  runSpacing: width * 0.02,
                  alignment: WrapAlignment.center,
                  children: List.generate(emojis.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedEmojiIndex = index;
                        });
                        if (index != 0) {
                          _playClickSound(index - 1);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        width: selectedEmojiIndex == index ? width * 0.09 : width * 0.07,
                        height: selectedEmojiIndex == index ? width * 0.09 : width * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: selectedEmojiIndex == index
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
                            fontSize: selectedEmojiIndex == index ? width * 0.06 : width * 0.04,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.1),
            
                  child: Text(
                    'Diclofenaco sódico + Betametasona + Hidroxocobalamina',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
