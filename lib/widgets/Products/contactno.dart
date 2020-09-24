import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class ContactNo extends StatelessWidget{
  final String phnno;
  ContactNo(this.phnno);
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
            
            child:RaisedButton(
                onPressed: () {
  launch(('tel://${phnno}'));
},

                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: <Widget>[
                  Image.asset('assets/call.png',height: 40,),
                  SizedBox(width: 10,)
                  ,Text(phnno,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          );
  }
}