import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webbrainassesment/const/color_const.dart';
import 'package:webbrainassesment/const/txt_field.dart';
import 'package:webbrainassesment/ctr/getCtr.dart';
import 'package:webbrainassesment/helper/database_helper.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:webbrainassesment/helper/helper.dart';
import 'package:webbrainassesment/model/login_user_model.dart';
import 'package:webbrainassesment/screen/welcome_page.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {

  TextEditingController nameCtr = TextEditingController();
  TextEditingController mailCtr = TextEditingController();
  TextEditingController pwdCtr = TextEditingController();

  final key = "This 32 char key have 256 bits..";
  final GetController getCtr = Get.find();

  @override
  void dispose() {
    // TODO: implement dispose
    mailCtr.dispose();
    pwdCtr.dispose();
    nameCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.headerColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: Text('Registration', style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
                        'Registration',
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
                            String userName = nameCtr.text.trim();
                            String userMail = mailCtr.text.trim();
                            String password = pwdCtr.text.trim();
                            enc.Encrypted encrypted = encryptWithAES(key, password);
                            password = encrypted.base64;
                            Map<String, dynamic>? existingUser = await DatabaseHelper().getUser(userMail);
                            if (existingUser == null) {
                              Map<String, dynamic> newUser = {
                                'username': userName,
                                'usermail': userMail,
                                'password': password,
                              };
                              await DatabaseHelper().saveUser(newUser);
                              await Helper().setUserLoginDate(LoginUserModel(
                                password: password,
                                mail: userMail,
                                name: userName,
                              ));
                              await Helper().setIsUserLogin(true);
                              Helper().getLoginUserData().then((value) {
                                getCtr.setUserDetailModel(value!);
                              });
                              showToastMsg('User registered successfully.');
                              Get.offAll(() => const WelcomePage());
                            }else{
                              showToastMsg('User already exists.');
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
          ],
        ),
      ),
    );
  }

  showToastMsg(String msg){
    Helper.showMsg(msg, context);
  }


  bool isValid(){
    if(nameCtr.text.trim()==''){
      showToastMsg('Please enter name');
      return false;
    }else if(mailCtr.text.trim()==''){
      showToastMsg('Please enter email');
      return false;
    }else if(Helper.isValidEmail(mailCtr.text.trim())==false){
      showToastMsg('Please enter valid email');
      return false;
    }else if(pwdCtr.text.trim()==''){
      showToastMsg('Please enter password');
      return false;
    }
    return true;
  }

  enc.Encrypted encryptWithAES(String key, String plainText) {
    final cipherKey = enc.Key.fromUtf8(key);
    final encryptService =
    enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.cbc));
    final initVector = enc.IV.fromUtf8(key.substring(0,
        16));

    enc.Encrypted encryptedData =
    encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

}
