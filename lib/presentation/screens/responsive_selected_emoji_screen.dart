import 'package:flutter/material.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class ResponsiveSelectedEmojiScreen extends StatelessWidget {
  const ResponsiveSelectedEmojiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    final isRegisted = Provider.of<UserProvider>(context).getIsRegisted;
    print('Shortest: $shortest');

    if (shortest >= 1200) { //1200
      // PC/Desktop
      return const DesktopSelectedEmojiScreen();
    } else if (shortest > 400) { //else if (width >= 800 && width < 1200) { //900
      // Tablet
      if (isRegisted == true) {
        return const TermsConditionsTabletScreen();
      }
      else {
        return const FirstTabletScreen();// return const TabletSelectedEmojiScreen();
      }
    } else {
      // Móvil
      if (isRegisted == true) {
        return const TermsConditionsMobileScreen();
      }
      else {
        return const FirstMobileScreen(); // return const TabletSelectedEmojiScreen();
      }
    }
  }
}
