import 'package:currency_app/repository/currency_repository.dart';
import 'package:currency_app/services/currency_service.dart';
import 'package:currency_app/widgets/text_field_generic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  final repository = CurrencyRepository();

  String fromCurrency = "BRL";
  String toCurrency = "USD";
  String result;
  var offlineDates;

  final service = CurrencyService();

  @override
  void initState() {
    super.initState();
    service.loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: service.currencies == null
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
                      Text(result != null ? result : "Informe um valor", style: TextStyle(fontSize: 28.0, color: Colors.amber)),
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
                  GestureDetector(
                    onTap: () async {
                      result = await service.doConversion(text: fromTextController.text, from: fromCurrency, to: toCurrency);
                      repository.insert(text: fromTextController.text, from: fromCurrency, to: toCurrency);
                      offlineDates = await repository.query();
                      setState(() {});
                    },
                    child: SizedBox(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.amber,
                        elevation: 5.0,
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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  if (result != null)
                    Text("Conversão Atualizada com Sucesso".toUpperCase(),
                        style: TextStyle(fontSize: 12.0, color: Colors.amber, fontWeight: FontWeight.bold)),
                  if (offlineDates != null)
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            'Segue abaixo os Dados do banco de dados local, para uso Offline:',
                            style: TextStyle(fontSize: 12.0, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: offlineDates.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Expanded(child: Text("Nº: " + offlineDates[index]['_id'].toString())),
                                    Expanded(child: Text("De: " + offlineDates[index]['from_currency'].toString())),
                                    Expanded(child: Text("Para: " + offlineDates[index]['to_currency'].toString())),
                                    Expanded(child: Text("Valor: " + offlineDates[index]['value'].toString())),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(),
                ],
              ),
            ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      underline: Container(),
      icon: Icon(Icons.arrow_downward),
      iconEnabledColor: Colors.white,
      items: service.currencies
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
