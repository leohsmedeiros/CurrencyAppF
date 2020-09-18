import 'package:flutter/material.dart';

class TextFieldGeneric extends StatelessWidget {
  final String prefix;
  final String label;
  final TextEditingController fieldController;
  final Function callbackFunction;

  const TextFieldGeneric({
    Key key,
    @required this.fieldController,
    this.label,
    this.prefix,
    this.callbackFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width /1.5,
      child: TextField(
        controller: fieldController,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.amber),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.amberAccent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.amberAccent)),
            prefixText: prefix),
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        onChanged: callbackFunction,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
