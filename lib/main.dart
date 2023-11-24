import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monthly/screens/download_screen.dart';
import 'package:monthly/screens/home_screen.dart';
import 'package:monthly/screens/login_screen.dart';
import 'package:monthly/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Monthly());
}

class Monthly extends StatefulWidget {



  const Monthly({super.key});

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {

  late String StartRoute;
  bool isStatusChecked = false;
  // @override
  // void didChangeDependencies(){
  //   super.didChangeDependencies();
  //     checkUserLoginStatus();
  //   // isAuthorized();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLoginStatus();
  }

  Future<void> checkUserLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    print(isLoggedIn);
    setState(() {
      StartRoute = isLoggedIn ? '/home' : '/login';
      isStatusChecked = true;
    });
  }

  // void isAuthorized(){
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       StartRoute = '/login';
  //     } else {
  //       StartRoute = '/home';
  //     }
  //   });
  // }



  @override
  Widget build(BuildContext context) {

    if (!isStatusChecked) {
      return const CircularProgressIndicator(); // Show loading indicator until status is checked
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: StartRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/download': (context) => const DownloadScreen(),
      },
    );
    // return MaterialApp(
    //   navigatorKey: navigatorKey,
    //   initialRoute: StartRoute,
    //   routes: {
    //     '/login': (context)=> const LoginScreen(),
    //     '/register': (context)=> const RegisterScreen(),
    //     '/home':(context)=> const HomeScreen(),
    //     '/download':(context)=> const DownloadScreen(),
    //   },
    // );
  }
}
