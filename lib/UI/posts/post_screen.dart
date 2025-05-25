import 'package:firebase/UI/Auth/login_screen.dart';
import 'package:firebase/UI/posts/add_post.dart';

import 'package:firebase/UI/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const   PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ref=FirebaseDatabase.instance.ref('Rohit');

  final searchController=TextEditingController();
  final updatecontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen'),centerTitle: true,backgroundColor: Colors.green,automaticallyImplyLeading: false,
      
      actions: [
        IconButton(onPressed: (){
          auth.signOut().then((value) {
           // ignore: use_build_context_synchronously
           Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen())); 
          }).onError((error, stackTrace) {
            Utils().toastMessage(error.toString());
          },);
        }, icon:Icon(Icons.logout)),
        SizedBox(width: 10,)
      ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder()
              ),
              onChanged: (String value){
               setState(() {
                
              });              
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(query: ref, itemBuilder: (context,snapshot,animation,index){
              final title=snapshot.child('title').value.toString();
              if(searchController.text.isEmpty){
                return ListTile(
                
                title: Text(snapshot.child('title').value.toString()),
                
                subtitle: Text(snapshot.child('id').value.toString()),

                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context)=>[
                  PopupMenuItem(
                    value: 1,
                    child:ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        showdialogbox(title.toString(),snapshot.key!);
                      },
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                    ) 
                  ),
                  PopupMenuItem(
                    value: 2,
                    child:ListTile(
                       onTap: (){
                        Navigator.pop(context);
                        ref.child(snapshot.key!).remove();

                       },
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                    ) 
                    )


                ]),
                
              );
              }else if(title.toString().toLowerCase().contains(searchController.text.toLowerCase().toString())){
                return ListTile(
                
                title: Text(snapshot.child('title').value.toString()),
                
                subtitle: Text(snapshot.child('id').value.toString()),
                
              );
              }else{
                return Container();
              }
              
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
      },
      child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showdialogbox(String title,String id)async{
    updatecontroller.text=title;
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        
        title: Text('Update'),
        content: 
          
          TextField(
            controller: updatecontroller,
            decoration: InputDecoration(
              hintText: 'Edit'
            ),
          ),
        
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          TextButton(onPressed: (){
             Navigator.pop(context);
            ref.child(id).update({
              'title':updatecontroller.text.toLowerCase()
            }).then((value){
              Utils().toastMessage('Post Updated');
             
            }
            ).onError((error,stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, child: Text('Update'))
        ],
      );
    });
  }
}