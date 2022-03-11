import 'package:flutter/material.dart';
import 'package:yummy/utils/utils.dart';

import '../API/firebase_api.dart';

// ignore: must_be_immutable
class SelectableCard extends StatefulWidget {
  Map<String, dynamic> data;
  VoidCallback opTap;
  SelectableCard({Key? key, required this.opTap, required this.data})
      : super(key: key);

  @override
  _SelectableCardState createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  final cardSeletor = const OutlineInputBorder(
      borderSide: BorderSide(
    color: Colors.orange,
    width: 2,
  ));
  String error = '';
  bool isSelected = false;
  final Utils _utils = Utils();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> address = widget.data;
    return GestureDetector(
      child: Card(
        shape: isSelected ? cardSeletor : null,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Address Line 1: ${address['ADL1'] ?? ""}'),
                    Text('Address Line 2: ${address['ADL2'] ?? ""}'),
                    Text('District: ${address['Dist'] ?? ""}'),
                    Text('State: ${address['State'] ?? ""}'),
                    Text('Country: ${address['Country'] ?? ""}'),
                    Text('PIN no: ${address['PIN'] ?? ""}'),
                    Text('Phone No: ${address['Phone'] ?? ""}')
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                      onPressed: (() {
                        _utils
                            .userAddressData()
                            .doc(address["PIN"].toString())
                            .delete()
                            .then(
                          (value) {
                            showSnackBar(context, 'Addess Deleted');
                          },
                        ).catchError((error) =>
                                showSnackBar(context, error.toString()));
                      }),
                      icon: const Icon(Icons.delete)),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        isSelected == true ? isSelected = false : isSelected = true;
        setState(() {});
        widget.opTap();
     },
    );
  }
}
