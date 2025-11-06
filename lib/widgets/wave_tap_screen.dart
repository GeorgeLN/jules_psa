// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pain_scale_app/presentation/providers/wave_provider.dart';
import 'package:provider/provider.dart';
import 'wave_pulse.dart';
import 'dart:ui' as ui;

class WaveTapScreen extends StatefulWidget {
  const WaveTapScreen({Key? key}) : super(key: key);

  @override
  State<WaveTapScreen> createState() => _WaveTapScreenState();
}

class _WaveTapScreenState extends State<WaveTapScreen> {
  final List<Offset> _tapPositions = [];
  late ui.Image _image;
  final GlobalKey _imageKey = GlobalKey(); // Llave para obtener referencia a la imagen

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/images/silueta_humana.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      _image = frame.image;
    });
  }

  void _onTapDown(TapDownDetails details, BuildContext context, GlobalKey key) async {
    // Obtiene la posición del tap relativa al widget de la imagen
    final renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    if (_image != null) {
       // Tamaño del widget mostrado
      final widgetSize = renderBox.size;

      // Tamaño original de la imagen
      final imageWidth = _image.width.toDouble();
      final imageHeight = _image.height.toDouble();

      // Calcula el factor de escalado manteniendo la proporción
      final scale = (widgetSize.width / imageWidth).clamp(0.0, widgetSize.height / imageHeight);

      // Calcula el tamaño visible real de la imagen dentro del widget
      final displayWidth = imageWidth * scale;
      final displayHeight = imageHeight * scale;

      // Calcula los márgenes sobrantes si la imagen está centrada
      final offsetX = (widgetSize.width - displayWidth) / 2;
      final offsetY = (widgetSize.height - displayHeight) / 2;

      // Coordenadas del toque ajustadas al área visible real de la imagen
      final dx = ((localPosition.dx - offsetX) * (imageWidth / displayWidth)).toInt();
      final dy = ((localPosition.dy - offsetY) * (imageHeight / displayHeight)).toInt();

      // Lee los datos de los píxeles de la imagen
      final byteData = await _image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final byteOffset = ((dy * _image.width) + dx) * 4;

      // Extrae el valor alfa (transparencia) del píxel tocado
      final alpha = byteData!.getUint8(byteOffset + 3);

      // Si el píxel es opaco (alfa > 10), se considera parte de la silueta
      if (alpha > 10) {
        setState(() {
          _tapPositions.add(localPosition);
        });
      }
    }
  }

  void _removeAllWaves() {
    setState(() {
      _tapPositions.clear();
    });
  }

  void _removeLastWave() {
    if (_tapPositions.isNotEmpty) {
      setState(() {
        _tapPositions.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final waveProvider = Provider.of<WaveProvider>(context);

    return Stack(
      children: [
        RepaintBoundary(
          key: super.widget.key,
          child: GestureDetector(
            onTapDown: (details) {
              _onTapDown(details, context, _imageKey);
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/silueta_humana.png',
                    key: _imageKey,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(child: Container(color: Colors.transparent)),
                ..._tapPositions.map(
                  (position) => Positioned(
                    left: position.dx - 50,
                    top: position.dy - 50,
                    child: WavePulse(
                      color: waveProvider.isActive ? Colors.blue : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: height * 0.025,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _removeAllWaves,
                    icon: Icon(Icons.delete, color: Colors.white, size: width * 0.05),
                  ),
                  IconButton(
                    onPressed: _removeLastWave,
                    icon: Icon(Icons.restart_alt_outlined, color: Colors.white, size: width * 0.05),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: waveProvider.isActive,
                    onChanged: (value) => waveProvider.setActive(value!),
                    fillColor: WidgetStateProperty.all(Colors.white),
                    checkColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Text(
                    'Espalda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
