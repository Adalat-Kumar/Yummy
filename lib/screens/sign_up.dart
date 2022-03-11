import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/widgets/alert_dialog.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

// ignore: prefer_typing_uninitialized_variables
var encodeImage;
String downloadURL = '';
String fileName = '';

class _SignUpState extends State<SignUp> {
  late bool _password;
  // ignore: non_constant_identifier_names
  late bool _conform_password;
  final validateKey = GlobalKey<FormState>();
  TextEditingController signUpemail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();
  TextEditingController signUpName = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  // ignore: prefer_typing_uninitialized_variables
  var imageUint;
  @override
  void initState() {
    _conform_password = false;
    _password = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.orange[900]!,
                Colors.orange[600]!,
                Colors.orange[400]!
              ],
            )),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Create an account. Its Free',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  child: Form(
                      key: validateKey,
                      child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Colors.white),
                          child: SingleChildScrollView(
                              child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(children: [
                              const SizedBox(
                                height: 10,
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
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextFormField(
                                        onTap: () async {},
                                        controller: signUpName,
                                        decoration: const InputDecoration(
                                            hintText: "Full Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                    controller: signUpemail,
                                    decoration: const InputDecoration(
                                        hintText: 'Email',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                    controller: signUpPassword,
                                    obscureText: !_password,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _password = !_password;
                                              });
                                            },
                                            icon: Icon(_password
                                                ? Icons.visibility
                                                : Icons.visibility_off)),
                                        hintText: 'Password',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                    controller: confPassword,
                                    obscureText: !_conform_password,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _conform_password
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _conform_password =
                                                  !_conform_password;
                                            });
                                          },
                                        ),
                                        hintText: 'Conform Password',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    validator: (text) {
                                      if (text != signUpPassword.text) {
                                        return 'Password does not matched';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      validateKey.currentState!.validate();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: 300,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (validateKey.currentState!.validate()) {
                                      await createUser(
                                          signUpemail.text,
                                          signUpName.text,
                                          confPassword.text,
                                          context);
                                      await auth.signOut();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(children: const [
                                Expanded(
                                    child: Divider(
                                  thickness: 0.5,
                                  color: Colors.black,
                                )),
                                Text("OR"),
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
                                children: [
                                  SignInButton(Buttons.Google,
                                      onPressed: () async {
                                    if (kIsWeb) {
                                      ShowAlert alert = ShowAlert();
                                      alert.loadingDialog(
                                          context, 'Signning in');
                                      await signInWithGoogle()
                                          .then((value) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Home())))
                                          .catchError((error) => showSnackBar(
                                              context, error.toString()));
                                    } else {
                                      if (Platform.isMacOS) {
                                        showSnackBar(context,
                                            'Google Sign in is not supported on MacOS');
                                      } else {
                                        await signInWithGoogle()
                                            .then((value) =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Home())))
                                            .catchError((error) => showSnackBar(
                                                context, error.toString()));
                                      }
                                    }
                                  }),
                                  SignInButton(Buttons.FacebookNew,
                                      onPressed: () {
                                    showSnackBar(context, 'Comming Soon');
                                  })
                                ],
                              )
                            ]),
                          )))))
            ])));
  }
}
