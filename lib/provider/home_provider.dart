import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum PermissionEnum { idle, loading, done }

class HomeProvider extends ChangeNotifier{

  PermissionEnum permissionEnum = PermissionEnum.idle;

  bool isPermission = false;

  void setEnablePermission(bool permission) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    isPermission =permission;

   await prefs.setBool("isPermission", isPermission);
    notifyListeners();
  }

  void  setpermissionEnum(PermissionEnum perm) {
    permissionEnum = perm;
    notifyListeners();
  }
}
