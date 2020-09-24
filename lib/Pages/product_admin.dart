
import 'package:final_app/Pages/product_create_edit_page.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:final_app/widgets/UIelement/logoutListTile.dart';
import 'package:flutter/material.dart';
import './product_create_edit_page.dart';
import './product_list_page.dart';
class ProductAdmin extends StatelessWidget {
  final MainModel model;
  ProductAdmin(this.model);
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child:
    Scaffold(
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/homepage');
            },
          )
          ,Divider(),
          LogoutListTile(),
        ],
      )),
      appBar: AppBar(
        title: Text('Manage Products'),
        bottom: TabBar(tabs: <Widget>[
           Tab(text: 'Create Product',
            icon: Icon(Icons.create),
           ),
           Tab(text:'My Product',
           icon: Icon(Icons.list),
           
           )

        ],),
      ),
      body: TabBarView(children: <Widget>[
           ProductCreateEdit(),
           ProductList(model),
        
      ],),
    ),);
  }
}
