// ignore_for_file: file_names, use_build_context_synchronously

import 'package:chatapp/Components/Button.dart';
import 'package:chatapp/Components/Textfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? ontap;
  const RegisterPage({super.key, this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextcontroller = TextEditingController();
  final passwordtexteditingcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  //Sign Up User

  Future<void> signup() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //make sure password matches
    if (passwordtexteditingcontroller.text !=
        passwordtexteditingcontroller.text) {
      //pop loading circle
      Navigator.pop(context);
      displayMessage("Password Don't Match!");
      return;
    }

    try {
      //create the user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextcontroller.text,
              password: passwordtexteditingcontroller.text);
      //after creating the user, create a new document in cloud firestore called users
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': emailTextcontroller.text.split('@')[0], // intial username
        'bio': 'Emptybio..' //initialy empty bio
        //add any additional fields as needed
      });

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //show error
      displayMessage(e.code);
    }
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
              Text("Let's create an account for you!",
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
                  controller: passwordtexteditingcontroller,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 10),

              //Confirm Password Text field

              MyTextField(
                  controller: confirmpasswordcontroller,
                  hintText: 'Confirm Password',
                  obscureText: true),
              const SizedBox(height: 30),
              //signIn Button

              MyButton(
                text: 'Sign Up',
                ontap: signup,
              ),
              const SizedBox(height: 8),

              // go to register page

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.ontap,
                    child: const Text(
                      'Login Here',
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
