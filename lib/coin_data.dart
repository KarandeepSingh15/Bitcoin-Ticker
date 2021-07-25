import 'package:http/http.dart' as http;
import 'apikey.dart';
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'DOGE',
];

class CoinData {
  Future<double> getCoinData(String currency, String crypto) async {
    http.Response response = await http.get(
      Uri.https('rest.coinapi.io', '/v1/exchangerate/$crypto/$currency',
          {'apikey': apikey}),
    );
    if (response.statusCode == 200) {
      var cryptoPrice = jsonDecode(response.body);
      return cryptoPrice['rate'];
    } else {
      print(response.statusCode);
      throw 'problem with get request';
    }
  }
}
