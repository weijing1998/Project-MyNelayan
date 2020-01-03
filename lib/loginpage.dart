import 'package:flutter/material.dart';
import 'package:lab_2/fpasspage.dart';
import 'package:lab_2/registerpage.dart';
import 'package:lab_2/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lab_2/mainscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _passcontroller = TextEditingController();
  String _password = "";
  bool _checkboxvalue = false;
  String urlLogin = "http://myondb.com/myNelayanWJ/php/login.php";

  @override
  void initState() {
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNelayan',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/logo/sunset.gif'),
                  fit: BoxFit.cover)),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                  child: Image.asset(
                    'assets/logo/icon1.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Welcome Back,',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Text(
                    'Sign in to continue',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _emcontroller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white24,
                          hintText: 'Email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purpleAccent, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent, width: 1)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 0, 7),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _passcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purpleAccent, width: 1),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Checkbox(
                        onChanged: (bool value) {
                          _checkboxfunction(value);
                        },
                        value: _checkboxvalue,
                        activeColor: Colors.purple,
                      ),
                    ),
                    Text(
                      'Remember Me',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(125, 20, 0, 0),
                    child: SizedBox(
                      width: 170,
                      height: 40,
                      child: MaterialButton(
                        onPressed: _onpress,
                        color: Colors.purpleAccent,
                        child: Text('Login'),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(130, 20, 0, 0),
                      child: Text(
                        'New user ?',
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5, 20, 0, 0),
                        child: GestureDetector(
                          onTap: _onregister,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ))
                  ],
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(150, 15, 0, 0),
                    child: GestureDetector(
                      onTap: _toFpassPage,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkboxfunction(bool value) {
    setState(() {
      _checkboxvalue = value;
      savepref(value);
    });
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_isEmailValid(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _checkboxvalue = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _passcontroller.text = '';
        _checkboxvalue = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _onpress() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    if (_isEmailValid(_email) && (_password.length > 4)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List fish = string.split(",");
        print(fish);
        Toast.show(fish[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (fish[0] == "success") {
          pr.dismiss();
          print("Radius:");
          print(fish);
         User user = new User(name:fish[1],email: fish[2],phone:fish[3],radius: fish[4],credit: fish[5],rating: fish[6]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(user: user)));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {
      Toast.show('Please check your email and password', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email != null) {
      _emcontroller.text = _email;
      _passcontroller.text = _password;
      setState(() {
        _checkboxvalue = true;
      });
    } else {
      print('No pref');
      setState(() {
        _checkboxvalue = false;
      });
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _onregister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void _toFpassPage() {
     print('fpass');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Fpasspage()));
  }
}
