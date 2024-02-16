import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webbrainassesment/ctr/getCtr.dart';
import 'package:webbrainassesment/helper/helper.dart';
import 'package:webbrainassesment/screen/login_screen.dart';
import 'package:webbrainassesment/screen/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GetController getCtr = Get.put(GetController());
  RxBool isLogin = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //calling this method for task 1
    task1().then((value) {
      getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
            'assets/login_icon.png'
        ),
      ),
    );
  }

  Future<void> task1() async{
    const jsonData = '''
  {
    "animals": [
      {"animal": "dog,cat,dog,cow"},
      {"animal": "cow,cat,cat"},
      {"animal": null},
      {"animal": ""}
    ]
  }
  ''';

    final parsedData = jsonDecode(jsonData);
    final List<dynamic> animalsData = parsedData['animals'];

    for (final animalData in animalsData) {
      final animalString = animalData['animal'] ?? '';
      final animals = animalString.split(',').toList();

      final Map<String, int> animalCount = {};

      for (final animal in animals) {
        if (animal.isNotEmpty) {
          animalCount[animal] = (animalCount[animal] ?? 0) + 1;
        }
      }

      final groupedAnimals = animalCount.entries.map((entry) {
        if (entry.value > 1) {
          return '${entry.key}(${entry.value})';
        } else {
          return entry.key;
        }
      }).join(',');

      print(groupedAnimals);
    }
  }

  Future<void> getUser() async{
    bool checkLogin = await Helper().isUserLogin();
    // print('checkLogin: $checkLogin');
    setState(() {
      isLogin = checkLogin.obs;
    });
  }

  Future<void> getUserData() async {
    if(await Helper().isUserLogin()){
      Helper().getLoginUserData().then((value) {
        getCtr.setUserDetailModel(value!);
      });
      Get.offAll(() => const WelcomePage());
    }else{
      Get.offAll(() => const LoginScreen());
    }
  }

}
