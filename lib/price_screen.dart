import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String bitcoin = '1 BTC = ? USD';
  String etherium = '1 ETH = ? USD';
  String litecoin = '1 LTC = ? USD';
  String dogecoin = '1 DOGE = ? USD';
  CoinData coindata = CoinData();
  DropdownButton androidDropDown() {
    List<DropdownMenuItem<String>> currencyList = [];
    for (String currency in currenciesList) {
      currencyList.add(
        DropdownMenuItem<String>(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyList,
      onChanged: (value) {
        updateUI(value);
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> currencyList = [];
    for (String currency in currenciesList) currencyList.add(Text(currency));
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedindex) {
        updateUI(currenciesList[selectedindex]);
      },
      children: currencyList,
    );
  }

  String selectedCurrency = 'USD';

  void updateUI(String currency) async {
    try {
      double bitcoinprice = await coindata.getCoinData(currency, cryptoList[0]);
      double etheriumprice =
          await coindata.getCoinData(currency, cryptoList[1]);
      double litecoinprice =
          await coindata.getCoinData(currency, cryptoList[2]);
      double dogecoinprice =
          await coindata.getCoinData(currency, cryptoList[3]);

      setState(() {
        bitcoin =
            '1 ${cryptoList[0]} = ${bitcoinprice.toStringAsFixed(4)} $currency';
        etherium =
            '1 ${cryptoList[1]} = ${etheriumprice.toStringAsFixed(4)} $currency';
        litecoin =
            '1 ${cryptoList[2]} = ${litecoinprice.toStringAsFixed(4)} $currency';
        dogecoin =
            '1 ${cryptoList[3]} = ${dogecoinprice.toStringAsFixed(4)} $currency';
      });
    } catch (e) {
      print(e);
      setState(() {
        bitcoin =
            etherium = litecoin = dogecoin = 'Error! Unable to fetch data';
      });
    }
  }

  @override
  initState() {
    super.initState();
    updateUI('USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DisplayCard(
            textToDisplay: bitcoin,
          ),
          DisplayCard(
            textToDisplay: etherium,
          ),
          DisplayCard(
            textToDisplay: litecoin,
          ),
          DisplayCard(
            textToDisplay: dogecoin,
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropDown(),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayCard extends StatelessWidget {
  final String textToDisplay;
  DisplayCard({@required this.textToDisplay});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              textToDisplay,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
