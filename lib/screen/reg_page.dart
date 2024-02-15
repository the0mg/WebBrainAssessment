import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webbrainassesment/const/color_const.dart';
import 'package:webbrainassesment/const/txt_field.dart';
import 'package:webbrainassesment/helper/database_helper.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {

  TextEditingController nameCtr = TextEditingController();
  TextEditingController mailCtr = TextEditingController();
  TextEditingController pwdCtr = TextEditingController();

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
      body: Column(
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
                          String username = nameCtr.text;
                          String userMail = mailCtr.text;
                          String password = pwdCtr.text;
                          Map<String, dynamic>? existingUser = await DatabaseHelper().getUser(userMail);
                          if (existingUser == null) {
                            Map<String, dynamic> newUser = {
                              'username': username,
                              'usermail': userMail,
                              'password': password,
                            };
                            await DatabaseHelper().saveUser(newUser);
                            var snackBar = const SnackBar(content: Text('User registered successfully.'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }else{
                            var snackBar = const SnackBar(content: Text('User already exists.'));
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
        ],
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

}
