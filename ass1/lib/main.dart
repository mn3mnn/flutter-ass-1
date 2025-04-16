import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lib/pages/login_page.dart';
import 'lib/pages/signup_page.dart';
import 'lib/pages/profile_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCAI App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(), 
        '/profile': (context) => ProfilePage(userData: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
      },
    );
  }
}
