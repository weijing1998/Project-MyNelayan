import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_2/TabScreen.dart';
import 'package:lab_2/TabScreen2.dart';
import 'package:lab_2/TabScreen3.dart';
import 'package:lab_2/TabScreen4.dart';
import 'package:lab_2/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key key, this.user, User users}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen4(user: widget.user)
    ];
    print(widget.user.toString() + "MainScreen");
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepPurpleAccent));

    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.fish),
            title: Text("Market"),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.upload, ),
            title: Text("Posted Seafood"),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.shopping, ),
            title: Text("MyCart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
