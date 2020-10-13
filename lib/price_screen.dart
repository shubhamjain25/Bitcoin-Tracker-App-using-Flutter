import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'networking.dart';
import 'bitcoin_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isWaiting = true;
  String selectedCurrency = 'USD';
  int c = 0;
  String currencyToAPI;
  String bitcoinToAPI;
  var convertedAmount = ['?', '?', '?'];
  String fAmount;

  CupertinoPicker getIOSDropdown() {
    List<Text> listItemsCupertino = [];

    for (int i = 0; i < currenciesList.length; i++) {
      listItemsCupertino.add(Text(currenciesList[i]));
    }

    return CupertinoPicker(
      backgroundColor: Colors.blueAccent,
      itemExtent: 32.0,
      onSelectedItemChanged: (value) {
        print(value);
      },
      children: listItemsCupertino,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getIOSDropdown();
    } else {
      return getAndroidDropdown();
    }
  }

  DropdownButton<String> getAndroidDropdown() {
    List<DropdownMenuItem<String>> listItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      listItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: listItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          insertAmount(value);
        });
      },
    );
  }

  Map<String, String> coinPrice = {};

  Future<void> insertAmount(String currencyToAPI) async {
    isWaiting = true;

    try {
      GetAPIData getAPIData = GetAPIData(currencyInput: currencyToAPI);
      var price = await getAPIData.getRate();
      isWaiting=false;
      setState(() {
        coinPrice = price;
      });
    }
    catch(e) {
      print(e);
    }
  }

  @override
  void initState(){
    super.initState();
    insertAmount(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: GetBitcoinCard(
                  bitcoinName: 'BTC',
                  bitcoinValue: isWaiting ? '?' : coinPrice['BTC'],
                  selectedCurrency: selectedCurrency,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: GetBitcoinCard(
                  bitcoinName: 'ETH',
                  bitcoinValue: isWaiting ? '?' : coinPrice['ETH'],
                  selectedCurrency: selectedCurrency,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: GetBitcoinCard(
                  bitcoinName: 'LTC',
                  bitcoinValue: isWaiting ? '?' : coinPrice['LTC'],
                  selectedCurrency: selectedCurrency,
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class GetBitcoinCard extends StatelessWidget {
  GetBitcoinCard({this.bitcoinName, this.bitcoinValue, this.selectedCurrency});

  final String bitcoinName;
  final String bitcoinValue;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $bitcoinName = $bitcoinValue $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
