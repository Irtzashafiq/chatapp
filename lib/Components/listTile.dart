// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class MylistTile extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final String text;
 const MylistTile({super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
