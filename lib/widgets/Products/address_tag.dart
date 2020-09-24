import 'package:flutter/material.dart';

class AdressTag extends StatelessWidget{
  final String address;
  AdressTag(this.address);
  @override
  Widget build(BuildContext context) {
    
    return  Container(
              
              
            margin: EdgeInsets.symmetric(horizontal: 60),
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: (BorderRadius.circular(4.0)),
            ),
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                Image.asset('assets/location.png',height: 30,),
                SizedBox(width: 10,)
                ,Text(address,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            ),
          );
  }
}