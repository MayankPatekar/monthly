import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/main.dart';
import 'package:monthly/screens/add_screen.dart';
import 'package:monthly/screens/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
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
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //
          //       _auth.signOut();
          //       Navigator.pop(context);
          //     },
          //     child: Icon(
          //       Icons.close,
          //       size: 32.0,
          //       color: Colors.black,
          //     ),
          //   ),
          //   SizedBox(
          //     width: 10.0,
          //   ),
          //   // Padding(
          //   //   padding: EdgeInsets.only(right: 40.0),
          //   //   child: Icon(
          //   //     Icons.menu,
          //   //     size: 32.0,
          //   //     color: Colors.black,
          //   //   ),
          //   // ),
          // ],
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        padding:
            EdgeInsets.only(right: 35.0, left: 35.0, top: 20, bottom: 20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 296,
                height: 172,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xd1d51515), Color(0x8c000000)],
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/Ellipse1.png",
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '140000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 42.0,
                    ),
                    Text(
                      '24 \nAugust \n2023',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                  ],
                )),
            Container(
              padding:
                  EdgeInsets.only(right: 35.0, left: 35.0, top: 35, bottom: 0),
              width: double.infinity,
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RecentBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddScreen(),
              ),
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
      ),
    );
  }
}

// Container(
// padding: EdgeInsets.only(top: 60),
// child: Column(
// children: <Widget>[
// Center(
// child: Text('Home'),
// ),
// Text( user!.email! + '' ),
// GestureDetector(onTap:(){
// _auth.signOut();
// Navigator.pop(context);
// },child: Icon(Icons.close)),
// ],
// ),
// ),

class RecentBuilder extends StatelessWidget {
  const RecentBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('store').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final expenses = snapshot.data?.docs;
          List<Widget> expenseBoxes = [];
          for (var expense in expenses!) {
            if (expense['userName'] == user?.email) {
              final name = expense['Name'];
              final Timestamp date = expense['date'];
              //
              // final int seconds = date.seconds;
              // final int nanoseconds = date.nanoseconds;

              print(date);
              final DateTime d = date.toDate();
              // final DateTime d = DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanoseconds ~/ 1000000);
              print(d);
              final amount = expense['amount'];
              final type = expense['type'];

              final expensebox = Container(
                padding: EdgeInsets.only(
                    right: 35.0, left: 35.0, top: 20, bottom: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          amount.toString()+' Rs./-',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(d.hour.toString() + d.minute.toString(),style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),),
                        getType(type),
                        // Text(type,),
                      ],
                    ),
                  ],
                ),
                decoration: kInputBoxDecoration,
              );

              expenseBoxes.add(expensebox);
              expenseBoxes.add(
                SizedBox(
                  height: 10,
                ),
              );
              if (expenseBoxes.length == 4) {
                break;
              }
            }
          }

          return Expanded(
            child: ListView(
              children: expenseBoxes,
            ),
          );
        });
  }

  getType(type) {
    if(type == 'Debited'){
      return Text(type,style: TextStyle(
        color: Colors.red,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),);
    }else{
      return Text(type,style: TextStyle(
        color: Colors.green,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),);
    }
  }
}
