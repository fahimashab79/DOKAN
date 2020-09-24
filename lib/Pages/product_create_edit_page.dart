import 'package:final_app/Models/product_class.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:final_app/widgets/UIelement/image.dart';
//import 'package:final_app/widgets/FormInput/location.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:map_view/location.dart';

import 'package:scoped_model/scoped_model.dart';

class ProductCreateEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductCreateEditState();
  }
}

class ProductCreateEditState extends State<ProductCreateEdit> {
  final Map<String, dynamic> _formdata = {
    'title': null,
    'description': null,
    'price': null,
     'address':null,
     'phoneno':null,
    'image': 'assets/food.jpg'

  };

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void _setImage(File image)
  {

       _formdata['image']=image;

  }

  Widget _buildTitleFomField(Product product) {
    //print(products);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: product == null ? '' : product.title,
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
      },
      onSaved: (String value) {
        _formdata['title'] = value;
      },
    );
  }
   Widget _buildAddressFomField(Product product) {
    //print(products);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Location of the product'),
      initialValue: product == null ? '' : product.address,
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty ) {
          return 'address is required.';
        }
      },
      onSaved: (String value) {
        _formdata['address'] = value;
      },
    );
  }
  Widget _buildPhnnoFomField(Product product) {
    //print(products);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Contact No.'),
      initialValue: product == null ? '' : product.phnno,
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty ) {
          return 'Phoneno is required.';
        }
      },
      onSaved: (String value) {
        _formdata['phoneno'] = value;
      },
    );
  }

  Widget _buildDescriptionFomField(Product products) {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Product Description'),
      initialValue: products == null ? '' : products.description,
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long.';
        }
      },
      onSaved: (String value) {
        _formdata['description'] = value;
      },
    );
  }

  Widget _buildpriceFomField(Product products) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Product Price'),
      initialValue: products == null ? '' : products.price.toString(),
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number.';
        }
      },
      onSaved: (String value) {
        _formdata['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(Function additem, Function updateitem,
      Function setSelectedProduct, int selectedProductIndex) {
    if (!_formkey.currentState.validate()||(_formdata['image']==null && selectedProductIndex==-1)) {
      return;
    }

    _formkey.currentState.save();
    if (selectedProductIndex == -1) {
      additem(_formdata['title'], _formdata['description'], _formdata['price'],
              _formdata['image'],_formdata['address'],_formdata['phoneno'])
          .then((bool success) {

         if(success){   
        Navigator.pushReplacementNamed(context, '/homepage').then((_) {
          setSelectedProduct(null);
        });}
        else{
        showDialog(context:context,builder:(BuildContext context)
        {

          return AlertDialog(

            title: Text('Something Went Wrong'),
            content: Text('Please Try Again'),
            actions: <Widget>[
              FlatButton(onPressed: (){

                Navigator.of(context).pop();
              }, child: Text('Okay'))
            ],
          );
        }
        );


        }
      });
    } else {
      updateitem(_formdata['title'], _formdata['description'],
              _formdata['price'], _formdata['image'],_formdata['address'],_formdata['phoneno'])
          .then((_) => Navigator.pushReplacementNamed(context, '/homepage')
              .then((_) => setSelectedProduct(null)));
      ;
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                _submitForm(model.addProduct, model.updateProduct,
                    model.selectProduct, model.selectedProductIndex);
              },
              child: Text('Save'),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              _buildTitleFomField(product),
              _buildDescriptionFomField(product),
              _buildpriceFomField(product),
              _buildAddressFomField(product),
              _buildPhnnoFomField(product),
              SizedBox(
                height: 10.0,
             ),
            ImageInput(_setImage,product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        //print('baire');
        //print(model.selectedProductIndex);
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);

        //print('vitore');
        //print(model.selectedProductIndex);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
