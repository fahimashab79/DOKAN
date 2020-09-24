import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LogoutListTile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
  
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context ,Widget child,MainModel model){

     return ListTile(leading: Icon(Icons.exit_to_app),title: Text('LogOut'),onTap: (){

      model.logOut();
      Navigator.pushReplacementNamed(context, '/');

     },);

    });
  }

}