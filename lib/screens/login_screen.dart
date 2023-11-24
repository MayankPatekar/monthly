import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0, right: 40.0, left: 40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Monthly',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: kInputBoxDecoration,
                  child: TextField(
                    onChanged: (value){
                      email = value;
                    },
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter email', // Add your desired hint text
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor:
                          Colors.white, // Should match the container color
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: kInputBoxDecoration,
                  child: TextField(
                    onChanged: (value){
                      password = value;
                    },
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
                      fillColor:
                          Colors.white, // Should match the container color
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () async{
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        saveUserLoginStatus(true);
                        Navigator.pushReplacementNamed(context,'/home');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffff0000),
                          Color(0xd1d51515)
                        ], // Your gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Text(
                      'Sign in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        }, child: Text('Register now !'))),
                SizedBox(
                  height: 40.0,
                ),
                Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.black,
                          height: 50,
                        )),
                  ),
                  Text("Or continue with"),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 50,
                        )),
                  ),
                ]),
                SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () async{
                    try{
                      final user = await AuthService().signInWithGoogle();
                      if(user!=null){
                        saveUserLoginStatus(true);
                        Navigator.pushReplacementNamed(context, '/home');
                      }else{
                        print('something wrong');
                      }
                    }catch(e){
                      print(e);
                    }

                  },
                  child: Container(
                    width: double.infinity,
                    height: 59,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white10),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(
                              0, 2), // changes the position of the shadow
                        ),
                      ],

                      color: Colors.white, // Set the background color here
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: FractionalOffset.centerRight,
                        colors: [
                          Colors.white,
                          Color(0x009e9e9e),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/google_logo.png'),
                        Text(
                          'Sign in with google',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
void saveUserLoginStatus(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', isLoggedIn); // Save login status to local storage
}
