// ignore_for_file: file_names

import 'package:chatapp/Components/Drawer.dart';
import 'package:chatapp/Components/Textfields.dart';
import 'package:chatapp/Components/secret_post.dart';
import 'package:chatapp/helper/helper_mathod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //
  final textcontroller = TextEditingController();
  //SignOut Function
  void signout() {
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postmessage() {
    //only post if there is something in the text box
    if (textcontroller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('user post').add({
        'userEmail': currentUser.email,
        'message': textcontroller.text,
        'Timestamp': Timestamp.now(),
        'likes': [],
      });
    }
//clear the textfield
    setState(() {
      textcontroller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Secret Room',
          style: TextStyle(color: Colors.white),
        )),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          children: [
            //secret room
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user post')
                    .orderBy("Timestamp", descending: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        //get the message
                        final post = snapshot.data!.docs[index];
                        return Secret_Room(
                          message: post['message'],
                          user: post['userEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['likes'] ?? []),
                          time: formatDate(post['Timestamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            //post message
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                      child: MyTextField(
                          controller: textcontroller,
                          hintText: 'Go Ahead,Typeee...',
                          obscureText: false)),
                  IconButton(
                      onPressed: postmessage,
                      icon: const Icon(Icons.keyboard_double_arrow_right))
                ],
              ),
            ),
            //logged in
            Text("Logged In as:${currentUser.email!}"),
          ],
        ),
      ),
    );
  }
}
