import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webbrainassesment/const/color_const.dart';
import 'package:webbrainassesment/screen/login_screen.dart';
import 'package:webbrainassesment/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: const TextTheme(),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: ColorConst.primaryColor,
              secondary: ColorConst.secondaryColor,
              brightness: Brightness.light)
      ),
      home: const SplashScreen(),
    );
  }
}
