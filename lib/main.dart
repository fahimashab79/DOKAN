

import 'package:final_app/Models/product_class.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:final_app/Pages/auth.dart';
import 'package:final_app/Pages/homepage.dart';
import 'package:flutter/material.dart';

import './Pages/product_admin.dart';
import './Pages/product_details_page.dart';

void main() {
//debugPaintSizeEnabled=true;
//SharedPreferences.setMockInitialValues({});
//MapView.setApiKey('AIzaSyAO_uCAgMCGCMcBxXe5kEkwua-SnM3ID5c');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
final MainModel _model=MainModel();
@override
  void initState() {
   _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            accentColor: Colors.greenAccent,
            brightness: Brightness.light),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>  _model.user==null? AuthPage():HomePage(_model),
          
          '/homepage': (BuildContext context) => HomePage(_model),
          '/admin': (BuildContext context) => ProductAdmin(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') {
            return null;
          } else if (pathElements[1] == 'product') {
            final String  productId = (pathElements[2]);
            final Product product=_model.allProducts.firstWhere((Product product)
            {
                return product.id==productId;

            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext contex) => ProductDetailsPage(product),
            );
          }

          return null;
        },
        onUnknownRoute: (RouteSettings setting) {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(_model),
          );
        },
      ),
    );
  }
}
