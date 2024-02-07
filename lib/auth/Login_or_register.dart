// ignore_for_file: non_constant_identifier_names, file_names

import 'package:chatapp/Pages/RegisterPage.dart';
import 'package:chatapp/Pages/login.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //intially show the login page
  bool showloginPage = true;

  //toggle between pages

  void TogglePages() {
    setState(() {
      showloginPage = !showloginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginPage) {
      return Loginpage(
        ontap: TogglePages,
      );
    } else {
      return RegisterPage(
        ontap: TogglePages,
      );
    }
  }
}
