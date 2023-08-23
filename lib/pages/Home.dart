import 'dart:developer';
import 'dart:io';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hive/hive.dart';

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

  final List<Widget> bottomBarPages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
    const Page5(),
  ];
  bool _isloading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(Data);
    return Scaffold(
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
                      var box1 = await Hive.openBox('Data');
                      await box1
                          .deleteAll(['data', 'UB', 'uid']).then((value) async {
                        await _auth.signOut().then((value) {
                          box1.close();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
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
      body: _isloading
          ? EasyLoader(image: AssetImage('assets/logo.png'))
          : PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                  bottomBarPages.length, (index) => bottomBarPages[index]),
            ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.star,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.star,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Image.asset(
                    'assets/started2.png',
                    color: Colors.blueGrey,
                  ),
                  activeItem: Image.asset(
                    'assets/started1.png',
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 3',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Page 4',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Page 5',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome Back !",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kDarkBlueColor),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Please Enter ",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: height * 0.55,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.blueGrey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: Offset(-3, -3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: Offset(3, 3),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Product',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintText: 'Product',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity in KGS...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintText: 'Quantity in KGS...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Date of Dispatch',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintText: 'Date of Dispatch',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Pin Code',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintText: 'Pin Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Region,City',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintText: 'Region,City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: kDarkBlueColor,
                    textColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    onPressed: () {},
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  int? _editingRow;

  File? _selectedFile;
  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "Upcoming Records",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: [
              DataColumn(
                label: Text('Serial.No'),
              ),
              DataColumn(
                label: Text('Date of Request'),
              ),
              DataColumn(
                label: Text('Product'),
              ),
              DataColumn(
                label: Text('Quantity (KG)'),
              ),
              DataColumn(
                label: Text('Date of Dispatch'),
              ),
              DataColumn(
                label: Text('Doc1'),
              ),
              DataColumn(
                label: Text('Doc2'),
              ),
              DataColumn(
                label: Text('Action'),
              ),
            ], rows: [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Arshik')),
                DataCell(Text('5644645')),
                DataCell(Text('3')),
                DataCell(Text('265\$')),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.upload_file),
                        onPressed: _pickFile,
                      ),
                      SizedBox(height: 20),
                      Text(_selectedFile?.path ?? 'No file selected'),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.upload_file),
                        onPressed: _pickFile,
                      ),
                      SizedBox(height: 20),
                      Text(_selectedFile?.path ?? 'No file selected'),
                    ],
                  ),
                ),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _editingRow =
                              0; // Assuming this is the first row, use appropriate index for others
                        });
                      },
                    ),
                    Icon(
                      Icons.delete,
                      size: 15,
                    )
                  ],
                )),
              ])
            ]),
          ),
        ],
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  File? _selectedFile;
  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      } else {}
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "Delivery Records",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: [
              DataColumn(
                label: Text('Serial.No'),
              ),
              DataColumn(
                label: Text('Date of Request'),
              ),
              DataColumn(
                label: Text('Product'),
              ),
              DataColumn(
                label: Text('Quantity (KG)'),
              ),
              DataColumn(
                label: Text('Date of Dispatch'),
              ),
              DataColumn(
                label: Text('Pincode,City'),
              ),
              DataColumn(
                label: Text('Track'),
              ),
            ], rows: [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Arshik')),
                DataCell(Text('5644645')),
                DataCell(Text('3')),
                DataCell(Text('265\$')),
                DataCell(Text("adsad")),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.track_changes),
                    onPressed: () {},
                  ),
                ),
              ])
            ]),
          ),
        ],
      ),
    );
  }
}

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "Completed Records",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: [
              DataColumn(
                label: Text('Serial.No'),
              ),
              DataColumn(
                label: Text('Date of Request'),
              ),
              DataColumn(
                label: Text('Product'),
              ),
              DataColumn(
                label: Text('Quantity (KG)'),
              ),
              DataColumn(
                label: Text('Date of Dispatch'),
              ),
              DataColumn(
                label: Text('Pincode,City'),
              ),
            ], rows: [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Arshik')),
                DataCell(Text('5644645')),
                DataCell(Text('3')),
                DataCell(Text('265\$')),
                DataCell(Text("adsad")),
              ])
            ]),
          ),
        ],
      ),
    );
    ;
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: const Center(child: Text('Account Settings')));
  }
}
