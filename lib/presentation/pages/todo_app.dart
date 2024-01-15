import 'package:flutter/material.dart';
import 'package:todo_list/presentation/pages/main_page.dart';
import 'package:todo_list/theme/app_theme.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Remove red debug banner
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme().themeData,
      home: const MainPage(),
    );
  }
}
