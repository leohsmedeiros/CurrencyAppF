import 'package:currency_app/db/database_helper.dart';
import 'package:flutter/material.dart';

class CurrencyRepository {
  final dbHelper = DatabaseHelper.instance;

  void insert({@required String text, @required String from, @required String to}) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnFrom: from,
      DatabaseHelper.columnTo: to,
      DatabaseHelper.columnValue: text,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<List<Map<String, dynamic>>> query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) {
      print(row);
      print(row['_id']);
    });

    return allRows;
  }
}
