import 'package:get/get.dart';

import '../model/login_user_model.dart';

class GetController extends GetxController {

  LoginUserModel? loginUserModel = LoginUserModel();

  // void setUserDetail(XmlElement xmlElement){
  //   userDetail = xmlElement;
  // }

  void setUserDetailModel(LoginUserModel loginModel){
    loginUserModel = loginModel;
  }
}
