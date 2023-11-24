import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;


Future<List<List<dynamic>>> fetchData(DateTime startDateTime,DateTime dateTime, List<String> selectedItem, List<String> selectedType,) async {
  // DateTime startDate = DateTime(2023, 9, 10);
  // DateTime endDate = DateTime(2023, 9, 15);
  // QuerySnapshot querySnapshot = await firestore
  //     .collection('store')
  //     .where('userName',isEqualTo: user?.email)
  //     .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
  //     .where('date',isLessThanOrEqualTo: Timestamp.fromDate(endDate))
  // .where('category',whereIn: selectedItem)
  // .orderBy('date')
  //     .get();
  // print(selectedType);

  Query query = firestore
      .collection('store')
      .where('userName',isEqualTo: user?.email);
  // .where('category', whereIn: selectedItem)
  //     .where('type', whereIn: selectedType);
  // if(startDateTime !=null && dateTime !=null){
  //   query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDateTime))
  //       .where('date', isLessThanOrEqualTo: Timestamp.fromDate(dateTime));
  //   print(query.toString());
    // query = query.where('type', whereIn: selectedType);
  // }
  //
  // if (selectedItem.isNotEmpty) {
  //     query = query.where('category', whereIn: selectedItem);
  // }
  // if (selectedType.isNotEmpty) {
  //   query = query.where('type', whereIn: selectedType);
  // }

  QuerySnapshot querySnapshot = await query.orderBy('date').get();

  List<List<dynamic>> data = [];
print(querySnapshot.docs);
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    DateTime docDate = docData['date'].toDate(); // Assuming the date field is stored as a Timestamp

    // Add only the fields you want to include in the Excel sheet
    List<dynamic> row = [
      // docData['date'],
      docData['Name'],
      docData['type'],
      docData['category'],
      docData['amount']
      // Add more fields as needed
    ];
    if(docDate.isAfter(startDateTime) &&
        docDate.isBefore(dateTime) && selectedItem.contains(docData['category']) && selectedType.contains(docData['type'])){
      data.add(row);
    }
  }
// print(data);
  return data;
}
