import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/screens/gift_card.dart';
import 'package:yummy/screens/orders.dart';
import 'package:yummy/widgets/alert_dialog.dart';

import '../screens/cart.dart';

class MyDrawer extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final pushToLogin;
  const MyDrawer({Key? key, this.pushToLogin}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final ShowAlert _alert = ShowAlert();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              onDetailsPressed: () {
                Navigator.pop(context);
                widget.pushToLogin(2);
              },
              accountName: auth.currentUser == null
                  ? const Text('Sign In')
                  : Text(auth.currentUser!.displayName.toString()),
              accountEmail: auth.currentUser == null
                  ? const Text('Sign In')
                  : Text(auth.currentUser!.email.toString()),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: auth.currentUser != null
                      ? CachedNetworkImageProvider(
                          auth.currentUser!.photoURL.toString())
                      : const CachedNetworkImageProvider('')),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('My Cart'),
              onTap: () {
                Navigator.pop(context);
                if (auth.currentUser == null) {
                  _alert
                      .showSignInDialog(context)
                      .then((value) => widget.pushToLogin(2));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const Cart();
                  })));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood),
              title: const Text('My Orders'),
              onTap: () {
                if (auth.currentUser == null) {
                  _alert
                      .showSignInDialog(context)
                      .then((value) => widget.pushToLogin(2));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const Orders();
                  })));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('My Gift Card'),
              onTap: () {
                if (auth.currentUser == null) {
                  _alert
                      .showSignInDialog(context)
                      .then((value) => widget.pushToLogin(2));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const GiftCard();
                  })));
								}
							}
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About us'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                    context: context,
                    applicationName: 'Yummy',
                    applicationVersion: '1.0',
                    applicationIcon: const Icon(Icons.food_bank),
                    applicationLegalese: 'Yummy food ordring app');
              },
            ),
            ListTile(
              leading: auth.currentUser == null
                  ? const Icon(Icons.login)
                  : const Icon(Icons.logout),
              title: auth.currentUser == null
                  ? const Text('Sign In')
                  : const Text('Log out'),
              onTap: () async {
                Navigator.pop(context);
                auth.currentUser == null
                    ? widget.pushToLogin(2)
                    : await signOutGoogle(context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
						const ListTile(
								leading: Icon(Icons.favorite, color: Colors.red,),
								title: Text('Made by Adalat Kumar ❤️'),
						)
          ],
        ),
      ),
    );
  }
}
