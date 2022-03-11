import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/screens/profile.dart';
import 'package:yummy/widgets/drawer.dart';

import 'cart.dart';
import 'food_item.dart';
import 'login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yummy',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
	
  @override
  _HomeState createState() => _HomeState();
}

int currentIndex = 0;
int drawerIndex = 0;
String email = '';
String name = '';

class _HomeState extends State<Home> {
  updateScreen(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // This two addVisitors and visitors are used for how many user visit you app or website

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(pushToLogin: updateScreen),
      body: [
        const FoodItem(),
        Cart(
          goTologin: updateScreen,
          showSignInButton: true,
        ),
        auth.currentUser != null
            ? Profile(
                goTologin: updateScreen,
              )
            : loginPage(
                gotoProfile: updateScreen,
              )
      ].elementAt(currentIndex),
      bottomNavigationBar: CustomNavigationBar(
        iconSize: 25,
        selectedColor: Colors.orange[700]!,
        strokeColor: Colors.orange,
        unSelectedColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(icon: const Icon(Icons.home)),
          CustomNavigationBarItem(icon: const Icon(Icons.shopping_cart)),
          CustomNavigationBarItem(icon: const Icon(Icons.person))
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
