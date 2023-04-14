import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/ui/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: DepInit(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.teal),
      home: const Home(),
    );
  }
}
