// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final String sectionName;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              //edit button
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey[400],
                  ))
            ],
          ),
          Text(text, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
