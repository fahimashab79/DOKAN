import 'package:final_app/Models/product_class.dart';


import 'package:final_app/widgets/Products/address_tag.dart';
import 'package:final_app/widgets/Products/contactno.dart';
import 'package:final_app/widgets/Products/description_tag.dart';
import 'package:final_app/widgets/Products/price_tag.dart';
import 'package:final_app/widgets/UIelement/title_default.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  ProductDetailsPage(this.product);
  void _buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            content: Text('This Can not be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: Text('Continue')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child:  Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10,),
                Image.network(product.image,height: 300,width: 400,),
                TitleDefault(product.title),
                PriceTag(product.price.toString()),
                SizedBox(
                  height: 10,
                ),
                AdressTag(product.address),
                SizedBox(
                  height: 10,
                ),
                ContactNo(product.phnno),
                 SizedBox(
                  height: 10,
                ),
               DescriptionTag(product.description),
              
              ])),
    );

    // Center(child: Text('This is the product page'),));
  }
}
