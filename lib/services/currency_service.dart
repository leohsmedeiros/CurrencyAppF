import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  List<String> currencies = [];

  Future<List<String>> loadCurrencies() async {
    String uri = "https://api.exchangeratesapi.io/latest";
    var response = await http.get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    print(currencies);
    return currencies;
  }

  Future<String> doConversion({@required String text, @required String from, @required String to}) async {
    String uri = "https://api.exchangeratesapi.io/latest?base=$from&symbols=$to";
    var response = await http.get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    var result;
      if (text != "")  result = (double.parse(text) * (responseBody["rates"][to])).toStringAsFixed(8);
      if (text == "") text = 0.toString();
    print(result);
    return result;
  }


}