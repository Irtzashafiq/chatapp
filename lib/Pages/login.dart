// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/Components/Button.dart';
import 'package:chatapp/Components/Textfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  final Function()? ontap;
  const Loginpage({super.key, this.ontap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  //Text Editing Controller
  final emailTextcontroller = TextEditingController();
  final passwordeditingcontroller = TextEditingController();
  //sign In User
  void signIn() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //try signIn
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextcontroller.text,
          password: passwordeditingcontroller.text);

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      //display error message
      displayMessage(e.code);
    }
  }

  // Display an error message

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Logo
              const SafeArea(
                  child: Icon(
                Icons.lock,
                size: 100,
              )),
              const SizedBox(
                height: 50,
              ),
              //Welcome Back
              Text('Welcome Back. We really missed you!',
                  style: TextStyle(color: Colors.grey[700])),
              const SizedBox(
                height: 20,
              ),
              //Email text field

              MyTextField(
                  controller: emailTextcontroller,
                  hintText: 'Email',
                  obscureText: false),

              const SizedBox(height: 10),
              // Password Text field

              MyTextField(
                  controller: passwordeditingcontroller,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 30),

              //signIn Button

              MyButton(
                text: 'Sign In',
                ontap: signIn,
              ),
              const SizedBox(height: 8),

              // go to register page

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?',
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.ontap,
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
