import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webbrainassesment/const/color_const.dart';
import 'package:webbrainassesment/ctr/getCtr.dart';
import 'package:webbrainassesment/helper/helper.dart';
import 'package:webbrainassesment/model/login_user_model.dart';
import 'package:webbrainassesment/screen/login_screen.dart';
import 'package:webbrainassesment/screen/splash_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  final GetController getCtr = Get.find();
  LoginUserModel? loginUserModel;
  DateTime? currentBackPressTime;
  // bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUserModel = getCtr.loginUserModel;
    print(loginUserModel!.name);
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
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.headerColor,
          elevation: 0,
          actions: [
            InkWell(
              onTap: () async {
                await btnLogOut();
              },
              child: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
            ).marginSymmetric(horizontal: 15),
          ],
          title: const Text('Welcome Page', style: TextStyle(color: Colors.black),),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                loginUserModel!.name != null ? 'Hello ${loginUserModel!.name}!' :'Welcome',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 35
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  btnLogOut() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text("Are you sure?\nYou want to LOGOUT!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Yes'),
                onPressed: () async {
                  // print('object');
                  await Helper().setIsUserLogin(false);
                  await Helper().logOut();
                  Get.offAll(() => const SplashScreen());
                },
              ),
              CupertinoDialogAction(
                  child: const Text('No', style: TextStyle(color: Colors.black),),
                  onPressed: () async {
                    Get.back();
                  })
            ],
          );
        });
  }

}
