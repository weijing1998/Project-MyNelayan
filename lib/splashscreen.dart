import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab_2/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

String _email, _password;
String urlLogin = "http://myondb.com/myNelayanWJ/php/login.php";

void main() => runApp(Splashscreen());

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

//create logo and progress indegator
class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo/seafood.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: SizedBox(
                    width: 500,
                    height: 400,
                    child: Image.asset(
                      'assets/logo/icon3.png',fit:BoxFit.fill,
                    ),
                  )),
              new ProgressIndegator(),
            ],
          ),
        ),
      ),
    );
  }
}

//funtion of progress indecator
class ProgressIndegator extends StatefulWidget {
  ProgressIndegator({Key key}) : super(key: key);

  @override
  _ProgressIndegatorState createState() => _ProgressIndegatorState();
}

class _ProgressIndegatorState extends State<ProgressIndegator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override

  //
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loadpref(this.context);
      });
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SpinKitWave(
        color: Colors.purpleAccent,
        size: 30,
      ),
    ));
  }

  void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email') ?? '');
    _password = (prefs.getString('pass') ?? '');
    print("Splash:Preference");
    print(_email);
    print(_password);
    if (_isEmailValid(_email ?? "no_email")) {
      //try to login if got email;
      _onLogin(_email, _password, context);
      print("gtemail");
    } else {
      //login as unregistered user
      User user = new User(
          name: "not register user",
          email: "user@noregister",
          phone: "not register",
          radius: "15",
          credit: "0",
          rating: "0");
      print(user.toString() + "spalshscreen");
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => MainScreen(user: user)));
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _onLogin(String email, String pass, BuildContext ctx) {
    http.post(urlLogin, body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print("SPLASH:loading");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      } else {
        //allow login as unregistered user
        User userempty = new User(
            name: "not register user",
            email: "user@noregister",
            phone: "not register",
            radius: "15",
            credit: "0",
            rating: "0");

        print(userempty.toString());
        Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (context) => MainScreen(user: userempty)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
