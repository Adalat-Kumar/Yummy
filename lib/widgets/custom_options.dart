import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOptions extends StatelessWidget {
  String title;
  IconData icon;
  GestureTapCallback onTap;
  CustomOptions(
      {Key? key, required this.icon, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )),
      ),
      onTap: onTap,
    );
  }
}
