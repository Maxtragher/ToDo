import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/pages/main_page.dart';
import 'package:todo_list/theme/app_theme.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({
    required this.prefs,
    super.key,
  });
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme(),
      home: MainPage(prefs: prefs),
    );
  }
}
