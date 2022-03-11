import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController updateEmail =
      TextEditingController(text: auth.currentUser!.email);
  TextEditingController updateName =
      TextEditingController(text: auth.currentUser!.displayName);
  TextEditingController adl1 = TextEditingController();
  TextEditingController adl2 = TextEditingController();
  TextEditingController dist = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController phoneNum = TextEditingController();
  final formValidator = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var profilePhoto;
  String fileName = '';
  double totalPrice = 0.0;
  String? photoPath;
  String uploadTitle = 'Do you want to upload this image';
  // this below alert dialog show picked image and conform for upload
  showConfirmAlert() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(uploadTitle),
            content: Center(
              // Load image from image or byte. on web platform file picker picked file byte that will be loading through Image.memory(byte). on other platform is will picked file path so this is load image from Image.file(file)
              child: kIsWeb
                  ? Image.memory(profilePhoto)
                  : Image.file(File(photoPath.toString())),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    profilePhoto = null;
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      Navigator.pop(context);
                      showSnackBar(context, 'Uploading please wait');
                      // Upload image for firebase storage
                      await FirebaseStorage.instance
                          .ref('/${auth.currentUser!.uid}/$fileName')
                          .putData(profilePhoto)
                          .then((p0) => showSnackBar(context, 'Photo Uploaded'))
                          .catchError((error) =>
                              showSnackBar(context, error.toString()));
                      //Get the uploded image download url
                      String downloadURL = await FirebaseStorage.instance
                          .ref('/${auth.currentUser!.uid}/$fileName')
                          .getDownloadURL();
                      await auth.currentUser!
                          .updatePhotoURL(downloadURL)
                          .then((value) =>
                              showSnackBar(context, 'Saved as Profile picture'))
                          .catchError((error) =>
                              showSnackBar(context, error.toString()));
                      setState(() {});
                    } else {
                      if (photoPath != null) {
                        Navigator.pop(context);
                        showSnackBar(context, 'Uploading please wait...');
                        // Upload image to firebase storage
                        await FirebaseStorage.instance
                            .ref('${auth.currentUser!.uid}/$fileName')
                            .putFile(File(photoPath!))
                            .then(
                                (p0) => showSnackBar(context, 'Photo Uploaded'))
                            .catchError((error) =>
                                showSnackBar(context, error.toString()));
                        // Get the uploaded image download url
                        String updatedPhotoURL = await FirebaseStorage.instance
                            .ref('${auth.currentUser!.uid}/$fileName')
                            .getDownloadURL();
                        //update profile picture
                       await auth.currentUser!.updatePhotoURL(updatedPhotoURL)
													 .then((value) => showSnackBar(context, 'Updated Profile picture'))
													 .catchError((error) => showSnackBar(context, error.toString()));
                      }
                    }
                  },
                  child: const Text('Upload'))
            ],
          );
        });
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
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.orange[500]!.withOpacity(0.5),
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(
                      auth.currentUser!.photoURL.toString()),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: IconButton(
                          onPressed: () async {
                            // Open File picker
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            PlatformFile file = result!.files.first;
                            profilePhoto = file.bytes;
                            photoPath = file.path;
                            fileName = file.name;
                            // ignore: unnecessary_null_comparison
                            if (result.files != null) {
                              showConfirmAlert();
                            } else {
                              showSnackBar(context, 'Please pick a file');
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                              child: Form(
                                key: formValidator,
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
                                            color:
                                                Color.fromRGBO(225, 95, 27, .3),
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
                                                      color:
                                                          Colors.grey[200]!))),
                                          child: TextFormField(
                                            controller: updateName,
                                            decoration: InputDecoration(
                                                suffix: TextButton(
                                                  onPressed: () {
                                                    if (formValidator
                                                        .currentState!
                                                        .validate()) {
                                                      auth.currentUser
                                                          ?.updateDisplayName(
                                                              updateName.text)
                                                          .then((value) =>
                                                              showSnackBar(
                                                                  context,
                                                                  'Name Updated'))
                                                          .catchError((error) =>
                                                              showSnackBar(
                                                                  context,
                                                                  error
                                                                      .toString()));
                                                    }
                                                  },
                                                  child: const Text('Update'),
                                                ),
                                                hintText: "Full Name",
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                            color:
                                                Color.fromRGBO(225, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10))
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: updateEmail,
                                        decoration: InputDecoration(
                                            suffix: TextButton(
                                                onPressed: () {
                                                  if (formValidator
                                                      .currentState!
                                                      .validate()) {
                                                    auth.currentUser
                                                        ?.updateEmail(
                                                            updateEmail.text)
                                                        .then((value) =>
                                                            showSnackBar(
                                                                context,
                                                                'Email Updated'))
                                                        .catchError((e) =>
                                                            showSnackBar(
                                                                context,
                                                                e.toString()));
                                                  }
                                                },
                                                child: const Text('Update')),
                                            hintText: 'Email',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
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
                                    height: 30,
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Address',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: adl1,
                                            decoration: const InputDecoration(
                                                hintText: 'Address Line 1',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter correct address';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: adl2,
                                            decoration: const InputDecoration(
                                                hintText: 'Address Line 2',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: dist,
                                            decoration: const InputDecoration(
                                                hintText: 'District',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'District is required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: state,
                                            decoration: const InputDecoration(
                                                hintText: 'State',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'State is required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: country,
                                            decoration: const InputDecoration(
                                                hintText: 'Country',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Country is required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: pin,
                                            decoration: const InputDecoration(
                                                hintText: 'PIN no',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'PIN is required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: phoneNum,
                                            decoration: const InputDecoration(
                                                hintText: 'Phone Number',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Phone number must be 10 digit';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                formValidator.currentState!
                                                    .validate();
                                                if (formValidator.currentState!
                                                    .validate()) {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(
                                                          auth.currentUser!.uid)
                                                      .collection('address')
                                                      .doc(pin.text)
                                                      .set({
                                                        'ADL1': adl1.text,
                                                        'ADL2': adl2.text,
                                                        'Dist': dist.text,
                                                        'State': state.text,
                                                        'Country': country.text,
                                                        'PIN': pin.text,
                                                        'Phone': int.parse(
                                                            phoneNum.text)
                                                      })
                                                      .then((value) =>
                                                          showSnackBar(context,
                                                              'Address added'))
                                                      .catchError((error) =>
                                                          showSnackBar(
                                                              context,
                                                              error
                                                                  .toString()));
                                                }
                                              },
                                              child: const Text('Add Address')))
                                    ],
                                  ),
                                ]),
                              )))))
            ])));
  }
}
