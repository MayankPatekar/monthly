import 'package:flutter/material.dart';
import 'package:monthly/crudmethods/fetch_data.dart';
import 'package:monthly/screens/nav_bar.dart';
import 'package:multiselect/multiselect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../constants.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late DateTime _dateTime = DateTime.now();
  late DateTime _startDateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }
  void handleAllSelection(bool value) {
    setState(() {
      selectAll = value;
      if (selectAll) {
        selectedItem = List<String>.from(items);
      } else {
        // selectedItem = [];
        selectedItem.clear(); // Clear all selected items
      }
    });
  }

  void handleTypeAllSelection(bool value){
    setState(() {
      selectTypesAll = value;
      if (selectTypesAll) {
        selectedType = List<String>.from(types);
      } else {
        // selectedItem = [];
        selectedType.clear(); // Clear all selected items
      }
    });
  }

  void _showStartDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _startDateTime = value!;
      });
    });
  }

  List<String> items = [
    'Grocery',
    'Electronics',
    'Electric',
    'Stationary',
    'Education',
    'EMI',
    'Fun & Celebration',
    'Loan',
    'Salary'
  ];
  bool selectAll = false;
  List<String> selectedItem = [];
  List<String> types = ['Debited', 'Credited'];
  bool selectTypesAll = false;
  List<String> selectedType = [];
  Future<void> _handlePermissionsAndGenerateCSV(BuildContext context) async {
    // Request the required permission to write to external storage
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      await exportToExcel(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission denied for writing to external storage.'),
        ),
      );
    }
  }

  Future<void> exportToExcel(BuildContext context) async {
    try {
      List<List<dynamic>> data = await fetchData(
          _startDateTime, _dateTime, selectedItem, selectedType);
      print(data);
      List<List<dynamic>> csvData = [
        // Add headers for the Excel sheet
        [
          'Description',
          'Type',
          'Category',
          'Amount', /* Add more header fields */
        ],
        ...data,
      ];
      print(csvData);
      String csv = const ListToCsvConverter().convert(csvData);
      print(csv);
      Directory? directory = await getExternalStorageDirectory();
      print(directory?.path);
      File file = File('${directory?.path}/myData.csv');
      // File file = File('/data/user/0/com.example.monthly/myData.csv');
      // String newFilePath = '${directory.path}/../Download/example.csv';
      // await file.rename(newFilePath);
      try {
        await file.writeAsString(csv);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CSV file exported successfully.'),
          ),
        );
      } catch (e) {
        print('error while saving file => $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting CSV file: $e'),
          ),
        );
      }
      print(file);
      // Open the file for sharing or other operations if needed
      // You can use packages like 'open_file' to open the file.
      try {
        await OpenFile.open(file.path);
      } catch (e) {
        print('Error opening file: $e');
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    selectedItem = List<String>.from(items);
    selectedType = List<String>.from(types);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,

          // automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Text('Monthly'),
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0, right: 40.0, left: 40.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                        child: Text(
                          'From',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                          // textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 60,
                        decoration: kInputBoxDecoration,
                        alignment: Alignment.center,
                        child: MaterialButton(
                          onPressed: () {
                            _showStartDatePicker();
                          },
                          child: Text(
                            _startDateTime.day.toString() +
                                '/' +
                                _startDateTime.month.toString() +
                                '/' +
                                _startDateTime.year.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                        child: Text(
                          'To',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 60,
                        decoration: kInputBoxDecoration,
                        alignment: Alignment.center,
                        child: MaterialButton(
                          onPressed: () {
                            _showDatePicker();
                          },
                          child: Text(
                            _dateTime.day.toString() +
                                '/' +
                                _dateTime.month.toString() +
                                '/' +
                                _dateTime.year.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: kInputBoxDecoration,
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: Column(
                children: [
                  // "All" checkbox
                  CheckboxListTile(
                    title: Text('All'),
                    value: selectAll,
                    onChanged: (value)=>handleAllSelection(value ?? false),
                  ),
                  DropDownMultiSelect(
                    options: items,
                    selectedValues: selectedItem,
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                        selectAll = selectedItem.length == items.length;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    whenEmpty: 'Select category',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: kInputBoxDecoration,
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text('All'),
                    value: selectTypesAll,
                    onChanged: (value)=>handleTypeAllSelection(value ?? false),
                  ),
                  DropDownMultiSelect(
                    options: types,
                    selectedValues: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                        selectTypesAll = selectedType.length == types.length;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    whenEmpty: 'Select types',
                  ),
                ],
              ),
            ),
            // const Divider(
            //   height: 30,
            //   thickness: 2,
            //   indent: 0,
            //   endIndent: 0,
            //   color: Colors.black,
            // ),
            SizedBox(
              height: 20.0,
            ),

            GestureDetector(
              onTap: () {
                _handlePermissionsAndGenerateCSV(context);
              },
              child: Container(
                width: double.infinity,
                height: 45.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Download excel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
