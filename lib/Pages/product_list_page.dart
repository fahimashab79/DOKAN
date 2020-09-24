
import 'package:final_app/Pages/product_create_edit_page.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductList extends StatefulWidget {
  final MainModel model;
  ProductList(this.model);
@override
  State<StatefulWidget> createState() {
    
    return ProductListState();
  }
}
class ProductListState extends State<ProductList>{

  @override
  void initState() {
    widget.model.fetchProducts(onlyForUser:true);
    //widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
        
      return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allProducts[index].title),
              background: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 30),
                    ),
                  )),
              onDismissed: (DismissDirection direction) {
                model.selectProduct(model.allProducts[index].id);
                if (direction == DismissDirection.endToStart) {
                  model.deleteProduct();
                  
                }
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(model.allProducts[index].image),
                      ),
                      title: Text(model.allProducts[index].title),
                      subtitle: Text('\$${model.allProducts[index].price}'),
                      trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              model.selectProduct(model.allProducts[index].id);
                              
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ProductCreateEdit();
                              }));
                            }),
                     
                      ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        ),
      );
    });
  }
}
