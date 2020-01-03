import 'package:flutter/material.dart';
import 'package:lab_2/loginpage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(Fpasspage());

class Fpasspage extends StatefulWidget {
  @override
  _FpasspageState createState() => _FpasspageState();
}

class _FpasspageState extends State<Fpasspage> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  String urlpass = "http://myondb.com/myNelayanWJ/php/forgetpass.php";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo/sunset.gif'),
                      fit: BoxFit.cover)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: Image.asset(
                    'assets/logo/icon1.png',
                    width: 250,
                    height: 250,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(28, 10, 0, 0),
                  child: Text(
                    'Enter your e-mail address and we will send \n you a link to reset your password ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(33, 50, 0, 0),
                    child: Container(
                      width: 350,
                      height: 55,
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
                                  borderSide:
                                      BorderSide(color: Colors.white)))),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                  child: Container(
                    width: 260,
                    height: 40,
                    child: MaterialButton(
                      onPressed: _resetpassword,
                      color: Colors.purpleAccent,
                      child: Text('Reset Password'),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                  child: GestureDetector(
                    onTap: _returnpage,
                    child: Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetpassword() {
    _email = _emcontroller.text;
    if (_isEmailValid(_email)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Sending Email");
      pr.show();
      http.post(urlpass, body: {
        "email": _email,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        _emcontroller.text = '';

        pr.dismiss();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }).catchError((err) {
        print(err);
      });
    }
  }

  void _returnpage() {
    print('return');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  bool _isEmailValid(email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
} 
