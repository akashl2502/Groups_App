import 'package:app/pages/Home.dart';
import 'package:app/pages/Newuser.dart';
import 'package:app/pages/getstarted.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            )),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return Newuser();
            } else if (userSnapshot.hasError) {
              return CircularProgressIndicator();
            }
            return AnimatedSplashScreen(
              duration: 3000,
              splash: Container(
                width: Width * 0.9,
                height: Height * 0.9,
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
              nextScreen: Getstarted(),
              splashTransition: SplashTransition.scaleTransition,
              pageTransitionType: PageTransitionType.fade,
            );
          },
        ));
  }
}
