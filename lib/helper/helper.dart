import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webbrainassesment/model/login_user_model.dart';

class Helper {

  var isLoginKey = 'isLogin';
  var loginUserData = 'loginUserData';
  var password = 'PASSWORD';


  static showMsg(String msg, BuildContext context){
    var snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isValidEmail(String mail) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(mail);
  }


  Future<bool> isUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoginKey) ?? false;
  }

  setIsUserLogin(bool val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoginKey, val);
  }

  Future<bool> setUserLoginDate(LoginUserModel loginUserModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        loginUserData, json.encode(loginUserModel.toJson()));
  }

  Future<LoginUserModel?> getLoginUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(loginUserData);
    if (data != null) {
      return LoginUserModel.fromJson(json.decode(data));
    } else {
      return null;
    }
  }

  setPassword(String pwd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(password, pwd);
  }

  Future<String> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(password)??'';
  }

  logOut()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoginKey);
    await prefs.remove(loginUserData);
  }

}