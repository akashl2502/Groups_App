import 'package:Hopnmove/Utils.dart';
import 'package:Hopnmove/main.dart';
import 'package:Hopnmove/pages/Page1.dart';
import 'package:Hopnmove/pages/Page2.dart';
import 'package:Hopnmove/pages/Page4.dart';
import 'package:Hopnmove/pages/page3.dart';
import 'package:easy_loader/easy_loader.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.UID});
  final String UID;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = PageController(initialPage: 0);
  final Color kDarkBlueColor = const Color(0xFF053149);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Map<String, dynamic> Data;
  bool _isloading = false;
  int maxCount = 5;
  @override
  void initState() {
    _boxFuture = openHiveBox();
    super.initState();
  }

  Future<Box> openHiveBox() async {
    final box = await Hive.openBox('Data');
    Data = await box.get('data');

    return box;
  }

  late Future<Box> _boxFuture;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final _advancedDrawerController = AdvancedDrawerController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
        future: _boxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return EasyLoader(
              image: AssetImage('assets/logo.png'),
            );
          } else if (snapshot.hasError) {
            return Text('An error occurred while initializing the box.');
          } else if (!snapshot.hasData) {
            return Text('No data available.');
          }

          final box = snapshot.data!;
          return AdvancedDrawer(
            backdrop: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
                ),
              ),
            ),
            controller: _advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            animateChildDecoration: true,
            rtlOpening: false,
            // openScale: 1.0,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              // NOTICE: Uncomment if you want to add shadow behind the page.
              // Keep in mind that it may cause animation jerks.
              // boxShadow: <BoxShadow>[
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 0.0,
              //   ),
              // ],
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            drawer: SafeArea(
              child: Container(
                child: ListTileTheme(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 128.0,
                        height: 128.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 64.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                        ),
                      ),
                      Data['type'] == 'seller'
                          ? ListTile(
                              onTap: () {},
                              leading: Icon(Icons.home),
                              title: Text('Home'),
                            )
                          : Container(),
                      Data['type'] == 'seller'
                          ? ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Page2(
                                              uid: box.get('uid'),
                                            )));
                              },
                              leading: Icon(Icons.account_circle_rounded),
                              title: Text('Upcoming '),
                            )
                          : Container(),
                      ListTile(
                        onTap: () {
                          Data['type'] == 'seller'
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Page3(
                                            uid: box.get('uid'),
                                            buyer: Data['type'] == 'buyer',
                                          )))
                              : null;
                        },
                        leading: Icon(Icons.favorite),
                        title: Text('Inprogress '),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Page4(
                                        uid: box.get('uid'),
                                        buyer: Data['type'] == 'buyer',
                                      )));
                        },
                        leading: Icon(Icons.settings),
                        title: Text('Completed '),
                      ),
                      Spacer(),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: Text('Terms of Service | Privacy Policy'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: ModalProgressHUD(
              inAsyncCall: _isloading,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: _handleMenuButtonPressed,
                      icon: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _advancedDrawerController,
                        builder: (_, value, __) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: Icon(
                              value.visible ? Icons.clear : Icons.menu,
                              key: ValueKey<bool>(value.visible),
                            ),
                          );
                        },
                      ),
                    ),
                    elevation: 5.0,
                    actions: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // CircleAvatar(
                              //     backgroundColor: kDarkBlueColor,
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 3),
                              //       child: Image.asset(
                              //         'assets/logo.png',
                              //         fit: BoxFit.contain,
                              //       ),
                              //     )),
                              IconButton(
                                icon: Icon(Icons.logout_rounded),
                                color: kDarkBlueColor,
                                onPressed: () async {
                                  await box.deleteAll(['data', 'UB', 'uid']);
                                  await _auth.signOut().then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp()));
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
                  body: Data['type'] == 'buyer'
                      ? Page3(
                          uid: box.get('uid'),
                          buyer: Data['type'] == 'buyer',
                        )
                      : Page1(uid: box.get('uid'))),
            ),
          );
        });
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
