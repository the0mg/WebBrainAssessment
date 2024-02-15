
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webbrainassesment/const/color_const.dart';
import 'package:webbrainassesment/const/txt_field.dart';
import 'package:webbrainassesment/helper/database_helper.dart';
import 'package:webbrainassesment/screen/reg_page.dart';
import 'package:webbrainassesment/screen/welcome_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController nameCtr = TextEditingController();
  TextEditingController mailCtr = TextEditingController();
  TextEditingController pwdCtr = TextEditingController();
  DateTime? currentBackPressTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //calling this method for task 1
    task1();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mailCtr.dispose();
    pwdCtr.dispose();
    nameCtr.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      var snackBar = const SnackBar(content: Text('Press back again to exit!!...'));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.headerColor,
          elevation: 0,
          leading: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        backgroundColor: ColorConst.headerColor,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15, ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: ColorConst.headerColor,
                            child: Image.asset(
                              'assets/login_icon.png'
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Text(
                              'Log In',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(height: 25,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TxtField(
                                ctr: nameCtr,
                                hintTxt: 'Enter name',
                                txtInputType: TextInputType.text,
                              ),
                              const SizedBox(height: 18,),
                              const Text(
                                'Email',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TxtField(
                                ctr: mailCtr,
                                hintTxt: 'Enter mail',
                                txtInputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 18,),
                              const Text(
                                'Password',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TxtField(
                                ctr: pwdCtr,
                                icon: Icons.lock,
                                txtInputType: TextInputType.visiblePassword,
                                hintTxt: 'Enter password',
                              ),

                            ],
                          ),
                          const SizedBox(height: 30,),
                          InkWell(
                            onTap: () async {
                              //check if it's null or not
                              if(isValid()){
                                String userMail = mailCtr.text;
                                String password = pwdCtr.text;
                                Map<String, dynamic>? existingUser = await DatabaseHelper().getUser(userMail);

                                if (existingUser != null) {
                                  // User already exists
                                  print('User already exists');
                                  if (existingUser != null && existingUser['password'] == password) {
                                    // Login successful
                                    Get.to(()=>const WelcomePage());
                                    print('Login successful');
                                  } else {
                                    // Login failed
                                    var snackBar = const SnackBar(content: Text('Invalid password.'));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    print('Login failed');
                                  }

                                } else {
                                  var snackBar = const SnackBar(content: Text('User is not registered yet.'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                            },
                            child: Container(
                              width: size.width/1.1,
                              padding: const EdgeInsets.symmetric(vertical: 15, ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorConst.btnColor
                              ),
                              child: const Text(
                                'Log In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                InkWell(
                  onTap: () async {
                    //check if it's null or not
                    if(isValid()){
                      //going to sign up page
                      Get.to(()=>const RegPage());
                    }

                  },
                  child: SizedBox(
                    width: size.width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Do not have account?',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String mail) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(mail);
  }

  bool isValid(){
    if(nameCtr.text.trim()==''){
      var snackBar = const SnackBar(content: Text('Please enter name'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }else if(mailCtr.text.trim()==''){
      var snackBar = const SnackBar(content: Text('Please enter email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }else if(isValidEmail(mailCtr.text.trim())==false){
      var snackBar = const SnackBar(content: Text('Please enter valid email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }else if(pwdCtr.text.trim()==''){
      var snackBar = const SnackBar(content: Text('Please enter password'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
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
}
