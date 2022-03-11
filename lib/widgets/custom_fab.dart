import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFAB extends StatefulWidget {
  VoidCallback onPressed;
  Widget child;
  CustomFAB({Key? key, required this.child, required this.onPressed})
      : super(key: key);

  @override
  _CustomFABState createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  bool isProgess = false;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: (() {
        isProgess = true;
        setState(() {});
        widget.onPressed;
        isProgess = false;
        setState(() {});
      }),
      label: isProgess
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : widget.child,
    );
  }
}
