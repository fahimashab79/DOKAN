import 'package:final_app/Models/product_class.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:final_app/widgets/Products/address_tag.dart';
import 'package:final_app/widgets/UIelement/title_default.dart';
import 'package:flutter/material.dart';
import '../Products/price_tag.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product products;
  final int index;
  ProductCard(this.products, this.index);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Card(
        child: Column(
          children: <Widget>[
            FadeInImage(
              placeholder: AssetImage('assets/food.jpg'),
              image: NetworkImage(products.image),
              height: 300.0,
              width: 400,
              fit: BoxFit.cover,
            ),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TitleDefault(products.title),
                    SizedBox(width: 10.0),
                    PriceTag(products.price.toString()),
                  ],
                )),
            //Text(products.userEmail),
            AdressTag(products.address),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    //child: Text('Details'),

                    icon: Icon(Icons.info),
                    onPressed: () => Navigator.pushNamed<bool>(
                        context, '/product/' + model.allProducts[index].id),),
                IconButton(
                    icon: Icon(model.allProducts[index].isFavorite == false
                        ? Icons.favorite_border
                        : Icons.favorite),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      model.selectProduct(model.allProducts[index].id);
                      model.toggleProductFavoriteStatus();
                    }),
              ],
            )
          ],
        ),
      );
    });
  }
}
