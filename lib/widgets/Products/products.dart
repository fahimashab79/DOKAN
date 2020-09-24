import 'package:final_app/Models/product_class.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Products/product_card.dart';
import 'package:flutter/material.dart';

//import './pages/product_pages.dart';

class Products extends StatelessWidget {


  Widget _buildProductList(List<Product>products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    //print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(builder:(BuildContext context,Widget child,MainModel model){

      return _buildProductList(model.displayedProducts);
    },);
  }
}
