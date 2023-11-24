import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _auth = FirebaseAuth.instance;
  final nameTextController = TextEditingController();
  final amountTextController = TextEditingController();
  late DateTime _dateTime = DateTime.now();
  // var formatedDate = "${_dateTime.day}-${_dateTime.month}-${_dateTime.year}";
  late int amount;
  late String givenName;
  late String category;
  late String type;


  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        _dateTime = value!;
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
  List<String> types = ['Debited','Credited'];
  String? selectedItem = 'Grocery';
  String? selectedType = 'Debited';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.0,
      padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
      child: Column(
        children: <Widget>[
          //Give name input box
          Container(
            width: double.infinity,
            height: 60,
            decoration: kInputBoxDecoration,
            child: TextField(
              controller: nameTextController,
              onChanged: (value) {
                givenName = value;
              },
              autofocus: true,
              decoration: kInputTextDecoration.copyWith(
                  hintText: 'Give meaningful name'),
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 60,
            decoration: kInputBoxDecoration,
            padding: EdgeInsets.only(top: 5.0, left: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: DropdownButton(
                // alignment: Alignment.center,
                hint: Text(
                  selectedItem!,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                // value: selectedItem,
                underline: Container(),
                items: items
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        )))
                    .toList(),
                onChanged: (item) => setState(() {selectedItem = item;category=selectedItem!;}),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 60,
            decoration: kInputBoxDecoration,
            padding: EdgeInsets.only(top: 5.0, left: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: DropdownButton(
                // alignment: Alignment.center,
                hint: Text(
                  selectedType!,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                // value: selectedItem,
                underline: Container(),
                items: types
                    .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    )))
                    .toList(),
                onChanged: (item) => setState(() {selectedType = item;type=selectedType!;}),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 60,
            decoration: kInputBoxDecoration,
            alignment: Alignment.centerLeft,
            child: MaterialButton(
              onPressed: () {
                _showDatePicker();
              },
              child: Text(
                'Select Date :- ' +
                    _dateTime.day.toString() +
                    '/' +
                    _dateTime.month.toString() +
                    '/' +
                    _dateTime.year.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          // Enter Amount input box
          Container(
            width: double.infinity,
            height: 60,
            decoration: kInputBoxDecoration,
            child: TextField(
              controller: amountTextController,
              onChanged: (value) {
                amount = int.parse(value);
              },
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration:
                  kInputTextDecoration.copyWith(hintText: 'Enter amount'),
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xffdc432f), Color(0x84dc2f39)],
                )),
            child: GestureDetector(
              onTap: () {
                try{
                  _firestore.collection('store').add({
                    'Name' : givenName,
                    'amount':amount,
                    'category':category,
                    'date': _dateTime,
                    'createdAt': FieldValue.serverTimestamp(),
                    'type':type,
                    'userName': _auth.currentUser?.email
                  }).then((DocumentReference doc) =>
                      print('DocumentSnapshot added with ID: ${doc.id}'));
                  nameTextController.clear();
                  amountTextController.clear();
                  _dateTime = DateTime.now();
                  Navigator.pop(context);
                }catch(e){
                  print(e);
                }

              },
              child: Text('Add',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
