// ignore_for_file: file_names

import 'package:chatapp/Components/ListTile.dart';
import 'package:chatapp/Pages/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfile;
  final void Function()? onLogout;
  const MyDrawer({super.key, this.onProfile, this.onLogout});

  @override
  Widget build(BuildContext context) {
    void signout() {
      FirebaseAuth.instance.signOut();
    }

    //onProfile tap mathod
    void onProfile() {
      Navigator.pop(context);
      //Go to Profile Page
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }

    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //Header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              //List Tile
              MylistTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              //Profile List Tile
              MylistTile(
                icon: Icons.person_2_outlined,
                text: "P R O F I L E",
                onTap: onProfile,
              ),
            ],
          ),

          //Logout List Tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MylistTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: signout,
            ),
          )
        ],
      ),
    );
  }
}
