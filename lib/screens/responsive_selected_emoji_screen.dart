import 'package:flutter/material.dart';
import 'screens.dart';

class ResponsiveSelectedEmojiScreen extends StatelessWidget {
  const ResponsiveSelectedEmojiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    final shortest = MediaQuery.of(context).size.shortestSide;
    print('Shortest: $shortest');

    if (shortest >= 1200) { //1200
      // PC/Desktop
      return const DesktopSelectedEmojiScreen();
    } else if (shortest > 400) { //else if (width >= 800 && width < 1200) { //900
      // Tablet
      return const FirstTabletScreen();// return const TabletSelectedEmojiScreen();
    } else {
      // Móvil
      return const FirstMobileScreen();
    }
  }
}
