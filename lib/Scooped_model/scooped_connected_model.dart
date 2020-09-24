import 'package:final_app/Models/authenticate.dart';
import 'package:final_app/Models/product_class.dart';
import 'package:final_app/Models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ConnectedModel extends Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
}

class ProductModel extends ConnectedModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<String> uploadImage(File image,
      ) async {
    // final mimeTypeData = lookupMimeType(image.path).split('/');
    // final imageUploadRequest = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         'https://us-central1-productapp-e9cbb.cloudfunctions.net/storeImage'));
    // final file = await http.MultipartFile.fromPath(
    //   'image',
    //   image.path,
    //   contentType: MediaType(
    //     mimeTypeData[0],
    //     mimeTypeData[1],
    //   ),
    // );
    // print(imageUploadRequest);
    // imageUploadRequest.files.add(file);
    // if (imagePath != null) {
    //   imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    // }
    // imageUploadRequest.headers['Authorization'] = 'Bearer ${_authenticatedUser.token}';

    // try {
    //   final streamedResponse = await imageUploadRequest.send();
    //   final response = await http.Response.fromStream(streamedResponse);
    //   print(response.body);
    //   if (response.statusCode != 200 && response.statusCode != 201) {
    //     print('Something went wrong');
    //    // print(json.decode(response.body));
    //     return null;
    //   }
    //   final responseData = json.decode(response.body);
    //   print(responseData);
    //   return responseData;
    // } catch (error) {
    //   print(error);
    //   return null;
    // }

   final FirebaseAuth _auth=FirebaseAuth.instance;
   AuthResult result=await _auth.signInAnonymously();
   FirebaseUser user=result.user;
   var now = new DateTime.now();
   http.post('https://firebasestorage.googleapis.com/v0/b/productapp-e9cbb.appspot.com/o');
    print(user);
    final StorageReference ref = FirebaseStorage.instance.ref().child('${_authenticatedUser.email}/'+'${now.toString()}'+'.jpg');
    final StorageUploadTask uploadTask = await ref.putFile(image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<bool> addProduct(String title, String description,
      double price, File image,String address,String phoneno) async {
    _isLoading = true;
    notifyListeners();
    final String uploadData = await uploadImage(image);
    print(uploadData);

    if (uploadData == null) {
      print('Upload failed!');
      return false;
    }

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':uploadData,
      'price': price,
      'address':address,
      'phoneno':phoneno,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      
    };
    try {
      final http.Response response = await http.post(
          'https://productapp-e9cbb.firebaseio.com/Product.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: uploadData,
          price: price,
          address: address,
          phnno: phoneno,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }
  Future<bool> updateProduct(
      String title, String description, double price, File image,String address,String phoneno) async{
    _isLoading = true;
    notifyListeners();
     final String uploadData = await uploadImage(image);
    print(uploadData);

    if (uploadData == null) {
      print('Upload failed!');
      return false;
    }
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':uploadData,
      'price': price,
      'address':address,
      'phoneno':phoneno,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://productapp-e9cbb.firebaseio.com/Product/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response reponse) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: uploadData,
          price: price,
          address: address,
          phnno: phoneno,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://productapp-e9cbb.firebaseio.com/Product/${deletedProductId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://productapp-e9cbb.firebaseio.com/Product.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          address: productData['address'],
          phnno: productData['phoneno'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
          isFavorite: productData['wishlistUsers'] == null
              ? false
              : (productData['wishlistUsers'] as Map<String, dynamic>)
                  .containsKey(_authenticatedUser.id),
        );

        fetchedProductList.add(product);
      });
      _products = onlyForUser
          ? fetchedProductList.where((Product product) {
              return product.userId == _authenticatedUser.id;
            }).toList()
          : fetchedProductList;
      ;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        address: selectedProduct.address,
        phnno: selectedProduct.phnno,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://productapp-e9cbb.firebaseio.com/Product/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://productapp-e9cbb.firebaseio.com/Product/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          address: selectedProduct.address,
          phnno: selectedProduct.phnno,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedModel {
  get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode]) async {
    _isLoading = true;
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAO_uCAgMCGCMcBxXe5kEkwua-SnM3ID5c',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAO_uCAgMCGCMcBxXe5kEkwua-SnM3ID5c',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email doesnot exists.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password does not match.';
    }

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    // print('fahim/n');
    //print(token);
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      notifyListeners();
    }
  }

  void logOut() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }
}

class UtilityElement extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
