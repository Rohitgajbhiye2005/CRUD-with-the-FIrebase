import 'package:firebase/UI/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  bool loading=false;
  final addpostcontroller = TextEditingController();
  final firebaseref=FirebaseDatabase.instance.ref("Rohit");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: addpostcontroller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What is in your mind ? ",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20,),
            RoundButton(title: 'Add', loading: loading,onpress: (){
              setState(() {
                loading=true;
              });
              String id=DateTime.now().millisecondsSinceEpoch.toString();
              firebaseref.child(id).set({
                'id':id,
                'title':addpostcontroller.text.toString()
              }).then((value){
                
                Utils().toastMessage('post added');
                setState(() {
                  loading=false;
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  loading=false;
                });
              },);
            })
          ],
        ),
      ),
    );
  }
}