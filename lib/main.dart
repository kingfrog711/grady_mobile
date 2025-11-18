import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:grady/screens/login.dart';
import 'package:grady/screens/register.dart';
import 'package:grady/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Grady',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            backgroundColor: const Color(0xFFF8F5EF), // soft beige background
          ).copyWith(
            primary: const Color(0xFF3C5B41), // deep forest green
            secondary: const Color(0xFF7A8E67), // muted olive accent
            surface: const Color(0xFFF8F5EF), // light cream surface
            onPrimary: Colors.white, // for text/icons on green
            onSecondary: Colors.white,
            onSurface: const Color(0xFF1F2D20), // dark greenish text
          ),
        ),
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => MyHomePage(),
        },
      ),
    );
  }
}
