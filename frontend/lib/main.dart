import 'package:flutter/material.dart';
import 'questions_list_screen.dart';
import 'new_question_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neoja Q&A Forum',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF073B4C),
          secondary: Color(0xFFFF7F11),
          background: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF333333),
          onSurface: Color(0xFF333333),
        ),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        fontFamily: 'OpenSans',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF555555)),
          titleLarge: TextStyle(
            color: Color(0xFF073B4C),
            fontWeight: FontWeight.bold,
          ),
        ),

        // Update AppBarTheme
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF073B4C),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),

        // Update ElevatedButtonTheme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF7F11),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Update FloatingActionButtonTheme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF7F11),
          foregroundColor: Colors.white,
        ),

        // You can define other themes if necessary
      ),
      home: QuestionsListScreen(),
      routes: {'/new_question': (context) => NewQuestionScreen()},
    );
  }
}
