import 'package:Hopnmove/pages/Login.dart';
import 'package:Hopnmove/pages/Newuser.dart';
import 'package:Hopnmove/pages/getstarted.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('Data');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  late final Box box;

  @override
  void initState() {
    initializeBox();
    super.initState();
  }

  Future<void> initializeBox() async {
    box = await Hive.openBox('Data');
  }

  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;
    return MaterialApp(
        title: 'Hop and Move',
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
            var Aubool = box.get('AU') ?? false;

            if (userSnapshot.hasData) {
              return Newuser(UID: userSnapshot.data!.uid);
            } else if (userSnapshot.hasError) {
              return EasyLoader(image: AssetImage('assets/logo.png'));
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
              nextScreen: Aubool ? Login() : Getstarted(),
              splashTransition: SplashTransition.scaleTransition,
              pageTransitionType: PageTransitionType.fade,
            );
          },
        ));
  }
}
