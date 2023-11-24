import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monthly/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // final _auth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser;
    final auth = FirebaseAuth.instance;


    return Drawer(
      backgroundColor: Color(0xE228282A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text('hello',style: TextStyle(
                color: Colors.black
              ),),
              accountEmail: Text(user!.email! + '',style: TextStyle(
                color: Colors.black,
              ),),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('images/logo.png',width: 90,height: 90,fit: BoxFit.cover,),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                image: AssetImage('images/back.jpg'),
                opacity: 0.6,
                fit: BoxFit.cover,
              ),

            ),

          ),
          ListTile(
            leading: Icon(Icons.archive, color: Colors.white,),
            title: Text('Download List' ,style: TextStyle(
              color: Colors.white,
            ),),
            onTap: (){

              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/download');
              // Navigator.popAndPushNamed(context, '/download');
            Navigator.pushReplacementNamed(context, '/download');
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind_outlined, color: Colors.white,),
            title: Text('Sign out' ,style: TextStyle(
              color: Colors.white,
            ),),
            onTap: () async {
              try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);

                await FirebaseAuth.instance.signOut(); // Sign out user

                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => const LoginScreen(),),
                // );
                Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
                  '/login', // Route name for the login screen
                      (route) => false, // Pop all routes in the stack
                );
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   '/login', // Route name for the login screen
                //       (Route<dynamic> route) => false, // Pop all routes in the stack
                // );
              } catch (e) {
                print("Error signing out: $e");
              }
              // Navigator.pop(context); // Close the drawer
            },
          ),

        ],
      ),
    );
  }
}
