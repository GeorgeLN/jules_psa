
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pain_scale_app/presentation/viewmodels/patient_view_model.dart';
import 'firebase_options.dart';
import 'presentation/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:pain_scale_app/data/repositories/auth_repository.dart';
import 'package:pain_scale_app/presentation/providers/providers.dart';
import 'package:pain_scale_app/presentation/viewmodels/storage_view_model.dart';

void main() async {
  //Configuración inicial de Firebase para que no de errores.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Definir una orientación fija al momento que arranca la aplicación.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(

    //El DevicePreview sólo se habilita para modo de pruebas.
    /*DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ( _ ) => WaveProvider()),
        ],
        child: const MyApp(),
      ),
    ),*/

    MultiProvider(
        providers: [
          Provider(create: (_) => AuthRepository()),
          ChangeNotifierProvider(create: ( _ ) => WaveProvider()),
          // ChangeNotifierProvider(create: ( _ ) => ImagenProvider()),
          ChangeNotifierProvider(create: ( _ ) => UserProvider()),
          ChangeNotifierProvider(create: ( _ ) => StorageViewModel()),
          ChangeNotifierProvider(create: ( _ ) => PatientViewModel()),
        ],
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Escala de Dolor - App',
        home: MainScreen(),
      ),
    );
  }
}