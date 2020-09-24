
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:final_app/widgets/UIelement/logoutListTile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:final_app/widgets/Products/products.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  final MainModel model;
  HomePage(this.model);
  @override
  State<StatefulWidget> createState() {
    
    return Homepagestate();
  }
}
class Homepagestate extends State<HomePage>{
  @override
  void initState() {
    
    widget.model.fetchProducts();
    super.initState();
  }

Widget _buildProduct()
{

return ScopedModelDescendant<MainModel>(builder:(BuildContext context,Widget child,MainModel model){
  Widget content =Center(child:Text('No product Found'));
 if (model.displayedProducts.length>0&&!model.isLoading)
 {
   content =Products();
 }
 else if(model.isLoading)
 {
      content=Center(child:CircularProgressIndicator());

 }
return RefreshIndicator(child: content, onRefresh:model.fetchProducts) ;

});
 
 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            )
            ,Divider(),
            LogoutListTile(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/shop.png',height: 30,),
            SizedBox(width:10),
            Text('দোকান',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          ],
        ),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(builder:(BuildContext context,Widget child,MainModel model)
          {
            return IconButton(icon: Icon(model.displayFavoritesOnly? Icons.favorite:Icons.favorite_border), 
            
            onPressed: () {

            model.toggleDisplayMode();
          });
          }
           )
          
        ],
      ),
      body: _buildProduct(),
      );
    
  }
}
