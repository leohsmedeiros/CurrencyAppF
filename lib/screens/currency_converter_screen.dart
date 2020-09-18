import 'dart:async';
import 'dart:convert';
import 'package:currency_app/widgets/text_field_generic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  String fromCurrency = "BRL";
  String toCurrency = "USD";
  String result;
  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    _loadCurrencies();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Text("O valor de: ", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      Expanded(child: Container()),
                      Text("Na moeda: ", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      TextFieldGeneric(
                        fieldController: fromTextController,
                      ),
                      SizedBox(
                        width: 22.0,
                      ),
                      _buildDropDownButton(fromCurrency),
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Atualmente custa: ", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      Text("Na moeda: ", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(result != null ? result : "Informe um Valor", style: TextStyle(fontSize: 28.0, color: Colors.amber)),
                      Expanded(child: Container()),
                      _buildDropDownButton(toCurrency),
                      SizedBox(
                        width: 22.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FlatButton(
                    height: 40.0,
                    color: Colors.amberAccent.withOpacity(0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Realizar Conversão',
                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Icon(
                          FontAwesomeIcons.bitcoin,
                          size: 22.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onPressed: _doConversion,
                  ),
                ],
              ),
            ),
    );
  }

  Future<String> _loadCurrencies() async {
    String uri = "https://api.exchangeratesapi.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri = "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) * (responseBody["rates"][toCurrency])).toString();
    });
    print(result);
    return "Success";
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      underline: Container(),
      icon: Icon(Icons.arrow_downward),
      iconEnabledColor: Colors.white,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }
}
