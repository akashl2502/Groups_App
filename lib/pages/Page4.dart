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
