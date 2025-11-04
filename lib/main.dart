import 'package:flutter/material.dart';
import 'package:grady/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
      home: MyHomePage(),
    );
  }
}
