// ignore_for_file: non_constant_identifier_names, file_names

import 'package:chatapp/Components/TextBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  //edit field
  Future<void> editfield(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Enter New $field",
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (Value) {
            newValue = Value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
          //save button
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(newValue);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
    //update the values in the firestore

    if (newValue.trim().isNotEmpty) {
      //If the text field is not empty
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Profile Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    //Profile Pic
                    const Icon(
                      Icons.person,
                      size: 72,
                    ),
                    //user email
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      currentUser.email.toString(),
                      style: TextStyle(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //user details
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'My Details',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //username

                    MyTextBox(
                      text: userData['username'],
                      sectionName: 'username',
                      onPressed: () {
                        editfield('username');
                      },
                    ),
                    //bio
                    MyTextBox(
                      text: userData["bio"],
                      sectionName: 'bio',
                      onPressed: () {
                        editfield('bio');
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //user posts
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'My Posts',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
