import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onpress;
   final bool loading;
  const RoundButton({super.key,required this.title,required this.onpress,this.loading=false});

  @override
  Widget build(BuildContext context) {
  
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child:loading?CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):
           Text(title,style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}