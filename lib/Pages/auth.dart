import 'package:final_app/Models/authenticate.dart';
import 'package:final_app/Scooped_model/scooped_main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formdata = {
    'email': null,
    'password': null,
    'acceptterm': false,
  };
  AuthMode _authMode = AuthMode.Login;
  TextEditingController _passwordcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Widget _buildEmailTextform() {
    return TextFormField(
        //keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'Email', filled: true, fillColor: Colors.white),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return ('valid email required');
          }
        },
        onSaved: (String value) {
          _formdata['email'] = value;
        });
  }

  Widget _buildPasswordTextform() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordcontroller,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return ('Password must be 6 character long');
        }
      },
      onSaved: (String value) {
        _formdata['password'] = value;
      },
    );
    //keyboardType: TextInputType.emailAddress,
  }
void _submitForm(Function authenticate)async
{

Map<String,dynamic>report;
_formkey.currentState.save();
            if (!_formkey.currentState.validate() || !_formdata['acceptterm']) {
              return;
            }
            
               report=await authenticate(_formdata['email'], _formdata['password'],_authMode);
            
                 
               
               
                if (report['success']) {
                  Navigator.pushReplacementNamed(context, '/homepage');
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Something went wrong'),
                          content: Text(report['message']),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('okay'))
                          ],
                        );
                      });
                }
              ;
            

}
  Widget _buildSubmitButton()  {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
           
      return RaisedButton(
          color: Colors.lightGreen,
          child: Text('${_authMode == AuthMode.Signup ? 'SignUp' : 'LogIn'}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          textColor: Colors.black,
          onPressed: () {
            _submitForm(model.authenticate);

            //Navigator.pushReplacementNamed(context, '/homepage');
          });
    });
  }

  Widget _buildConfirmPasswordTextform() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordcontroller.text != value) {
          return ('Password donot match');
        }
      },
    );
    //keyboardType: TextInputType.emailAddress,
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(child:Row(
         mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/shop.png',height: 30,),
            SizedBox(width:10),
            Text("দোকান", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ],
        )),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.7), BlendMode.dstATop),
            fit: BoxFit.cover,
            image: AssetImage('assets/back.jpg'),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
            child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                  CircleAvatar(
                    maxRadius: 80,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  SizedBox(height: 20),
                _buildEmailTextform(),
                SizedBox(height: 10),
                _buildPasswordTextform(),
                SizedBox(height: 10),
                _authMode == AuthMode.Signup
                    ? _buildConfirmPasswordTextform()
                    : Container(),
                SizedBox(height: 10),

                Container(
                   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: (BorderRadius.circular(4.0)),
            ),
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _authMode == AuthMode.Login
                              ? _authMode = AuthMode.Signup
                              : _authMode = AuthMode.Login;
                        });
                      },
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'SignUp' : 'LogIn'}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)),
                ),
                SwitchListTile(
                  
                    activeColor: Colors.black,
                    value: _formdata['acceptterm'],
                    onChanged: (bool value) {
                      setState(() {
                        _formdata['acceptterm'] = value;
                      });
                    },
                    title: Container(
                      margin: EdgeInsets.only(left: 80),
                       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: (BorderRadius.circular(4.0)),
            ),
                      child: Center(child:Text('Accept Terms',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)))),
                SizedBox(
                  height: 10.0,
                ),
                _buildSubmitButton(),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
