import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coin_data.dart';

const apiKey = 'FD3A891E-D9FC-447B-B8E1-EE0CC5DE5ADB';

class GetAPIData {

  String currencyInput;
  String crypto;

  GetAPIData({@required this.currencyInput});

  Future<Map> getRate() async {
    Map <String,String> coinValues={};

    for (int k=0;k<3;k++) {
      crypto=cryptoList[k];
      print(crypto);
      http.Response response = await http.get(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$currencyInput?apikey=$apiKey');
      if (response.statusCode == 200) {
        String codedData = response.body;
        print(codedData);
        var decodedData = jsonDecode(codedData);
        var amount = decodedData['rate'].floor();
        coinValues[crypto]=amount.toString();
        print(coinValues[crypto]);
      }
      else {
        print(response.statusCode);
        print("Error from networking!");
      }
    }
    return coinValues;
  }
}
