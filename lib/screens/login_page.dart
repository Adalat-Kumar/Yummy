// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/screens/forget_password.dart';
import 'package:yummy/screens/sign_up.dart';
import 'package:yummy/widgets/alert_dialog.dart';

class loginPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final gotoProfile;
  const loginPage({Key? key, this.gotoProfile}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  bool _showpassword = false;

  @override
  void initState() {
    updateScreen();
    super.initState();
  }

  updateScreen() {
    auth.currentUser != null ? widget.gotoProfile(2) : Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Colors.orange[900]!,
            Colors.orange[800]!,
            Colors.orange[400]!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: email,
                                decoration: const InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: password,
                                obscureText: !_showpassword,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showpassword = !_showpassword;
                                          });
                                        },
                                        icon: _showpassword == true
                                            ? const Icon(Icons.visibility)
                                            : const Icon(
                                                Icons.visibility_off))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Forget_Password()));
                              },
                              child: const Text('Forget Password?')),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text('Sign Up'))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: 300,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              await signInWithEmailPassword(
                                      context, email.text, password.text)
                                  .then((value) => widget.gotoProfile(2));
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                                child: Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            )),
                            Text(
                              "Continue with Social Media",
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            )),
                          ]),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SignInButton(Buttons.Google, onPressed: () async {
                            if (kIsWeb) {
                              ShowAlert alert = ShowAlert();
                              alert.loadingDialog(context, 'Signning in');
                              await signInWithGoogle()
                                  .then((value) => Navigator.pop(context))
                                  .then((value) => widget.gotoProfile(2))
                                  .catchError((error) =>
                                      showSnackBar(context, error.toString()));
                            } else {
                              if (Platform.isMacOS) {
                                showSnackBar(context,
                                    "Google sign in is not supported on MacOS");
                              } else {
                                ShowAlert alert = ShowAlert();
                                alert.loadingDialog(context, 'Signning in');
                                await signInWithGoogle()
                                    .then((value) => Navigator.pop(context))
                                    .then((value) => widget.gotoProfile(2))
                                    .catchError((error) => showSnackBar(
                                        context, error.toString()));
                              }
                            }
                          }),
                          SignInButton(Buttons.FacebookNew, onPressed: () {
                            showSnackBar(context, 'Comming Soon');
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
