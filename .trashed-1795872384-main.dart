import 'package:flutter/material.dart';
import 'screens/thread_home_screen.dart';

void main() {
  runApp(const ThreadFlowApp());
}

class ThreadFlowApp extends StatelessWidget {
  const ThreadFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thread Flow App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFF6366F1),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF161F30),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ThreadHomeScreen(),
    );
  }
}
