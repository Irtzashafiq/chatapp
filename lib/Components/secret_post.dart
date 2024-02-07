// ignore_for_file: camel_case_types, unused_local_variable, unnecessary_cast, use_build_context_synchronously, avoid_print
import 'package:chatapp/Components/CommentButton.dart';
import 'package:chatapp/Components/delete_button.dart';
import 'package:chatapp/Components/like_button.dart';
import 'package:chatapp/helper/helper_mathod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Components/comment.dart';

class Secret_Room extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;

  const Secret_Room({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  }) : super(key: key);

  @override
  State<Secret_Room> createState() => _Secret_RoomState();
}

class _Secret_RoomState extends State<Secret_Room> {
//comment text controller
  final _commentTextcontroller = TextEditingController();
  //user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  void deletePost() {
    //confirmation before delete the post
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post"),
              content: const Text('Are you sure you want to delete this post'),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'cancel',
                      style: TextStyle(color: Colors.white60),
                    )),
                //delete Button
                TextButton(
                    onPressed: () async {
                      //delete the comment from firebase
                      //if delete the post the comment will still be in the firebase
                      final commentDocs = await FirebaseFirestore.instance
                          .collection('user post')
                          .doc(widget.postId)
                          .collection('comments')
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection('user post')
                            .doc(widget.postId)
                            .collection('comments')
                            .doc(doc.id)
                            .delete();
                      }
                      //then delete the post
                      FirebaseFirestore.instance
                          .collection('user post')
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print("Post Deleted"))
                          .catchError(
                              (error) => print("Failed to delete the post"));

                      //dismis the dialog pox
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'delete',
                      style: TextStyle(color: Colors.white60),
                    )),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser?.email);
  }

  //toggle like button
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the documents from Firebase

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('user post').doc(widget.postId);
    if (isLiked) {
      //If the post is liked, add the user's email to the 'Likes' field
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser?.email])
      });
    } else {
      //If the post is now unliked remove the user's email from the 'Likes' field
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser?.email])
      });
    }
  }

  //add a comment
  void addComment(String commentText) {
    //write the comment in the firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection('user post')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser!.email,
      'CommentTime': Timestamp.now(),
    });
  }
  //show a dialog box for add  comment

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comments"),
        content: TextField(
          controller: _commentTextcontroller,
          decoration: const InputDecoration(hintText: "write a comment.."),
        ),
        actions: [
          //cancel button
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commentTextcontroller.clear();
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white60))),
          //Post button
          TextButton(
              onPressed: () {
                //add the comment
                addComment(_commentTextcontroller.text);
                Navigator.pop(context);
                //clear the controller
                _commentTextcontroller.clear();
              },
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white60),
              )),
        ],
      ),
    );
  }

  //delete a post

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Secret post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //group of texts(messages + user email)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //message
                      Text(
                        widget.message,
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //user
                      Row(
                        children: [
                          Text(
                            widget.user,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          Text(" . ",
                              style: TextStyle(color: Colors.grey[400])),
                          Text(widget.time,
                              style: TextStyle(color: Colors.grey[400])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //Delete Button
              if (widget.user == currentUser?.email)
                DeleteButton(
                  onTap: deletePost,
                )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //button

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Like
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  //like count
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              //comment
              //Like
              Column(
                children: [
                  //Comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  //Comment count
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //Comments under the posts
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user post')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show circular indicator if no data
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true, //for nested list
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comments from firebase
                  final commentData = doc.data() as Map<String, dynamic>;
                  //return the comments
                  return Comment(
                      text: commentData['CommentText'],
                      user: commentData['CommentedBy'],
                      time: formatDate(commentData['CommentTime']));
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
