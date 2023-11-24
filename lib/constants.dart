import 'package:flutter/material.dart';

BoxDecoration kInputBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 4,
      offset: Offset(2, 2), // changes the position of the shadow
    ),
  ],
  color: Colors.white, // Set the background color here
);

InputDecoration kInputTextDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  ),
  hintText: 'Enter password', // Add your desired hint text
  hintStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  filled: true,
  fillColor: Colors.white, // Should match the container color
);
