import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:lab_2/TabScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab_2/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

String pathAsset = 'assets/logo/camera.png';
String urlUpload = "http://myondb.com/myNelayanWJ/php/register.php";
File _image;
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
String _name, _email, _password, _phone;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterPage({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        bottomSheet: _registerbutton(),
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('MyNelayan Sign Up'),
          backgroundColor: Colors.purple[300],
        ),
        body: Stack(children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/logo/sunset.gif')))),
          SingleChildScrollView(
            child: Container(
              child: RegisterWidget(),
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Splashscreen(),
        ));
    return Future.value(false);
  }

  _registerbutton() {}
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(150, 35, 0, 20),
          child: GestureDetector(
              onTap: _choose,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(10.0),
                    border: Border.all(width: 1),
                    image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.fill,
                    )),
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
          child: Container(
            height: 50,
            width: 350,
            child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _emcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white10,
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)))),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Container(
            height: 50,
            width: 350,
            child: TextField(
                controller: _namecontroller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)))),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Container(
            height: 50,
            width: 350,
            child: TextField(
              controller: _passcontroller,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
                enabledBorder: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              obscureText: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Container(
            height: 50,
            width: 350,
            child: TextField(
                controller: _phcontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white10,
                  enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Phone',
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(80, 50, 0, 0),
          child: GestureDetector(
              onTap: _onBackPress,
              child: Text('Already Have an Account?  LogIn.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline))),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
              width: 1000,
              height: 60,
              child: FlatButton(
                child: Text('Register'),
                color: Colors.purple[300],
                textColor: Colors.white,
                onPressed: _onRegister,
              ),
            ))
      ],
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => TabScreen()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Splashscreen()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}
