import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monthly/screens/home_screen.dart';
import 'package:monthly/screens/login_screen.dart';
//
// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//           if(snapshot.hasData){
//             return HomeScreen();
//           }else{
//             return LoginScreen();
//           }
//         },
//       ),
//     );
//   }
// }


// FirebaseAuth.instance
//     .authStateChanges()
//     .listen((User? user) {
// if (user == null) {
// print('User is currently signed out!');
// } else {
// print('User is signed in!');
// }
// });