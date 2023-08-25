import 'dart:developer';
import 'dart:io';
import 'package:app/Utils.dart';
import 'package:app/main.dart';
import 'package:app/pages/Page1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key, required this.UID});
  final String UID;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = PageController(initialPage: 0);
  final Color kDarkBlueColor = const Color(0xFF053149);
  final _controller = NotchBottomBarController(index: 0);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Map<String, dynamic> Data;
  bool _isimageloading = false;
  bool _isstateloading = false;
  int maxCount = 5;
  @override
  void initState() {
    box = Hive.box('Data');
    Data = box.get('data');
    super.initState();
  }

  late final Box box;
  @override
  void dispose() {
    Hive.close();

    _pageController.dispose();
    super.dispose();
  }

  bool _isloading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);

    print(Data);
    return ModalProgressHUD(
      inAsyncCall: loadingProvider.isLoading,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 5.0,
            actions: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          backgroundColor: kDarkBlueColor,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                          )),
                      IconButton(
                        icon: Icon(Icons.logout_rounded),
                        color: kDarkBlueColor,
                        onPressed: () async {
                          var box1 = Hive.box('Data');
                          await box1.deleteAll(['data', 'UB', 'uid']).then(
                              (value) async {
                            await _auth.signOut().then((value) {
                              box1.close();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                            });
                          });
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
            automaticallyImplyLeading: false,
          ),
          body: Page1()),
    );
  }
}
