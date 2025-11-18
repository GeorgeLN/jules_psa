// ignore_for_file: sized_box_for_whitespace

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../screens.dart';

class FirstTabletScreen extends StatefulWidget {
   
  const FirstTabletScreen({super.key});

  @override
  State<FirstTabletScreen> createState() => _FirstTabletScreenState();
}

class _FirstTabletScreenState extends State<FirstTabletScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final List<Widget> customOptions = [
      buildColumn(
        width,
        height,
        'Su Dolor',
        'Registre el nivel de dolor de\nsu paciente de forma clara y rápida.',
      ),

      buildColumn(
        width,
        height,
        'Su Voz',
        'Evalúe la intensidad del dolor en segundos para un diagnóstico más efectivo y oportuno.',
      ),

      buildColumnWithButton(
        width,
        height,
        'Su Alivio',
        'Facilite el seguimiento del dolor de sus pacientes con esta herramienta intuitiva y confiable.',
        context,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: width,
                height: height * 0.55,
                child: Image.asset(
                  'assets/images/doctor.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: width,
                  height: height * 0.55, // Ajusta la altura del degradado según lo que necesites
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                      ],
                      stops: [0.55, 0.95],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Column(
            children: [
              Container(
                width: width * 0.9,
                color: Colors.white,
          
                child: CarouselSlider(
                  items: customOptions,
                  options: CarouselOptions(
                    height: height * 0.3,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: height * 0.015),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: customOptions.asMap().entries.map((entry) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == entry.key
                          ? Color.fromRGBO(39, 54, 114, 1)
                          : Colors.grey[400],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildColumn(double width, double height, String text, String description) {
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: width < 800 ? width * 0.045 : width * 0.0325,
            fontWeight: FontWeight.bold,
          ),
        ),

        Container(
          width: width * 0.3,
          height: height * 0.005,

          decoration: BoxDecoration(
            color: Color.fromRGBO(39, 54, 114, 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        SizedBox(height: height * 0.02),

        Text(
          description,
          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.grey,
            fontSize: width < 800 ? width * 0.03 : width * 0.0325,
            fontWeight: FontWeight.w400,
          ),
        ),
        // SizedBox(height: height * 0.02),
      ],
    );
  }

  Column buildColumnWithButton(double width, double height, String text, String description, BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: width < 800 ? width * 0.045 : width * 0.0325,
            fontWeight: FontWeight.bold,
          ),
        ),

        Container(
          width: width * 0.3,
          height: height * 0.005,

          decoration: BoxDecoration(
            color: Color.fromRGBO(39, 54, 114, 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        SizedBox(height: height * 0.02),

        Text(
          description,
          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.grey,
            fontSize: width < 800 ? width * 0.03 : width * 0.0325,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: height * 0.025),

        Container(
          width: width * 0.9,

          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OptionsTabletScreen(),
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
              'Empecemos',
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),

          ),
        ),
      ],
    );
  }
}