import 'package:final_app/Models/product_class.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  
   Function setImage;
   Product product;
   ImageInput(this.setImage,this.product);
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
 File _imageFile;

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text(
                  'Choose Option',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height:5),
                FlatButton(
                  
                    onPressed: () {

                      _getImage(context, ImageSource.camera);
                    },
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        Text('Use Camera'),
                      ],
                    )),
                 FlatButton(
                    
                    onPressed: () {

                      _getImage(context, ImageSource.gallery);
                    },
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.image),
                        Text('Use Gallary'),
                      ],
                    )),
              ],
            ),
          );
        });
  }
  void _getImage(BuildContext context,ImageSource source)
  {

 ImagePicker.pickImage(source: source,maxWidth: 600).then((File image)
 {
  
  setState(() {
    _imageFile=image;
  });
  widget.setImage(image);
  Navigator.pop(context);
 });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
            onPressed: () {
              _openImagePicker(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.camera_alt),
                SizedBox(
                  width: 5.0,
                ),
                Text('Add Image'),
              ],
            )),
            SizedBox(height:5),
            _imageFile==null?Text('Please Choose an image'):Image.file(_imageFile,
            fit: BoxFit.cover,
            height: 300,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,

            )
      ],
    );
  }
}
