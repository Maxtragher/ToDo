import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_list/pages/todo_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize sharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(ToDoApp(prefs: prefs));

  // Make statusBar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}
