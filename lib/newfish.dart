import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lab_2/mainscreen.dart';
import 'package:lab_2/user.dart';
import 'custom_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:place_picker/place_picker.dart';

File _image;
String pathAsset = 'assets/logo/upload.png';
String urlUpload = "http://myondb.com/myNelayanWJ/php/upload_job.php";
String urlgetuser = "http://myondb.com/myNelayanWJ/php/get_user.php";

TextEditingController _titlecontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
final TextEditingController _pricecontroller = TextEditingController();
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress = "Searching your current location...";

class NewFish extends StatefulWidget {
  final User user;

  const NewFish({Key key, this.user}) : super(key: key);

  @override
  _NewFishState createState() => _NewFishState();
}

class _NewFishState extends State<NewFish> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Upload Seafood'),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/logo/seafood.jpg",
                ),
              )),
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: CreateNewSeafood(widget.user),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class CreateNewSeafood extends StatefulWidget {
  final User user;
  CreateNewSeafood(this.user);

  @override
  _CreateNewSeafoodState createState() => _CreateNewSeafoodState();
}

class _CreateNewSeafoodState extends State<CreateNewSeafood> {
  String defaultValue = 'Pickup';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image:
                    _image == null ? AssetImage(pathAsset) : FileImage(_image),
                fit: BoxFit.fill,
              )),
            )),
        Text('Click on image above to take seafood picture'),
        SizedBox(height: 15,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.fish),
                  onPressed: _changefish),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.caviar),
                  onPressed: _changecaviar),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.lobster),
                  onPressed: _changelobster),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.seaurchin),
                  onPressed: _changeseaurchin),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.shellfish),
                  onPressed: _changeshellfish),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.shrimp),
                  onPressed: _changeshrimp),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Custom.squid),
                  onPressed: _changesquid),
            ],
          ),
        ),
        TextField(
          controller: _titlecontroller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.deepPurpleAccent),
            filled: true,
            fillColor: Colors.white10,
            enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.deepPurpleAccent),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.purpleAccent)),
            labelText: 'Seafood Title',
            icon: Icon(
              Icons.title,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        TextField(
          controller: _pricecontroller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.deepPurpleAccent),
            filled: true,
            fillColor: Colors.white10,
            enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.deepPurpleAccent),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.purpleAccent)),
            labelText: 'Seafood Price',
            icon: Icon(
              Icons.attach_money,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        TextField(
          controller: _desccontroller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.previous,
          maxLines: 3,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.deepPurpleAccent),
            filled: true,
            fillColor: Colors.white10,
            enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.deepPurpleAccent),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.purpleAccent)),
            labelText: 'Seafood Description',
            icon: Icon(
              Icons.info,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
            onTap: _loadmap,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text("Seafood Origin",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.location_searching),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(_currentAddress),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 40,
          child: Text('Upload Seafood'),
          color: Colors.deepPurpleAccent,
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onAddSeafood,
        ),
      ],
    );
  }

  void _choose() async {
    _image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 400);
    setState(() {});
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onAddSeafood() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_titlecontroller.text.isEmpty) {
      Toast.show("Please enter seafood title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_pricecontroller.text.isEmpty) {
      Toast.show("Please enter seafood price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Requesting...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(_currentPosition.latitude.toString() +
        "/" +
        _currentPosition.longitude.toString());

    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
      "fishtitle": _titlecontroller.text,
      "fishdesc": _desccontroller.text,
      "fishprice": _pricecontroller.text,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "credit": widget.user.credit,
      "rating": widget.user.rating
    }).then((res) {
      print(urlUpload);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _titlecontroller.text = "";
        _pricecontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.user.email);
        _onLogin(widget.user.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // print(_getCurrentLocation);
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _onLogin(String email, BuildContext ctx) {
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
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
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadmap() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyAvIHhXiQ7TxWE2L7WY_qP2WpBDrR7TWHk")));

    // Handle the result in your way
    print("MAP SHOW:");
    print(result);
  }

  void _changefish() {
    _titlecontroller.text = "Fish";
  }

  void _changecaviar() {
    _titlecontroller.text = "Caviar";
  }

  void _changelobster() {
    _titlecontroller.text = "Lobster";
  }

  void _changeseaurchin() {
    _titlecontroller.text = "Seaurchin";
  }

  void _changeshellfish() {
    _titlecontroller.text = "Shellfish";
  }

  void _changeshrimp() {
    _titlecontroller.text = "Shrimp";
  }

  void _changesquid() {
    _titlecontroller.text = "Squid";
  }
}
