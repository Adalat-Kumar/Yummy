import 'package:flutter/material.dart';
import 'package:yummy/screens/item_list.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

TextEditingController textController = TextEditingController();

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(225, 95, 27, .3),
                blurRadius: 50,
                offset: Offset(0, 10))
          ]),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu)),
          ),
          Expanded(
              child: TextFormField(
            controller: textController,
            cursorColor: Colors.black,
            onFieldSubmitted: (text) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemList(
                            itemQuery: textController.text.toString(),
                            catogaryKeyword: null,
                          )));
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Search....'),
          )),
        ],
      ),
    );
  }
}
