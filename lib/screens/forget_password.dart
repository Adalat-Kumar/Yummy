// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';

class Forget_Password extends StatefulWidget {
  const Forget_Password({Key? key}) : super(key: key);

  @override
  _Forget_PasswordState createState() => _Forget_PasswordState();
}

class _Forget_PasswordState extends State<Forget_Password> {
  TextEditingController email = TextEditingController();
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
                      'Oops!',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Forget Password?',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                )),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Please Enter Your Email that will send your reset Password Link',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 40,
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
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]!))),
                                child: TextFormField(
                                  controller: email,
                                  decoration: const InputDecoration(
                                      hintText: "Email or Phone number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: ElevatedButton(
                              onPressed: () {
                                auth
                                    .sendPasswordResetEmail(email: email.text)
                                    .then((value) => showSnackBar(context,
                                        'Reset password link sended to ${email.text}'));
                              },
                              child: const Text('Send Link')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
