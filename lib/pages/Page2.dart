import 'dart:developer';
import 'dart:io';
import 'package:app/Utils.dart';
import 'package:app/main.dart';
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

