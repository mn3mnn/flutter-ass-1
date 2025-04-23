import 'package:ass1/pages/favorite_stores.dart';
import 'package:ass1/pages/stores_list.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart'; // Import the SignUpPage class
import 'pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'providers/store_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StoreProvider())],
      child: const MyApp(),
    ),
  );
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/profile': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return ProfilePage(userData: args);
        },
        '/store-list': (context) => const StoreListPage(),
        '/favorite-stores': (context) => const FavoriteStoresPage(),
      },
    );
  }
}
