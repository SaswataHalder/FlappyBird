import  'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;
  const MyBarrier({ Key? key, this.size }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height:size,
      decoration: BoxDecoration(
        color: Colors.green[800],
        border: Border.all(width: 10,color: Colors.brown),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}