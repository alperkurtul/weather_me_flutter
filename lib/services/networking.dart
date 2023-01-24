import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_me_flutter/states/locations.dart';

class NetworkHelper {
  Uri url;
  BuildContext context;

  NetworkHelper({this.context, this.url});

  Future<dynamic> getData() async {
    http.Response response;

    int triedCount = 0;
    int maxTryCount = 5;
    if (url.toString().contains('/2.5/find?')) {
      maxTryCount = 1;
    }
    //print('maxTryCount : ' + maxTryCount.toString());
    while (response == null && triedCount < maxTryCount) {
      triedCount++;
      //print('triedCount : ' + triedCount.toString());
      try {
        //print('http.get TRY : ' + url.toString());
        response =
            await http.get(url).timeout(Duration(seconds: 1 + triedCount));
        //print('http.get SUCCESS : ' + url.toString());
      } on TimeoutException catch (e) {
        print(
            'http.get ERROR TimeoutException : ${e.message} : ${url.toString()}');
      } catch (e) {
        print(
            'http.get ERROR TimeoutException : ${e.message} : ${url.toString()}');
      }
    }

    if (response == null) {
      if (context.read<Locations>().isInternetConnectionOK) {
        context.read<Locations>().setInternetConnectionStatus(false);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred while fetching weather data. Please check your Internet connection!',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return 'NOK';
    } else {
      if (!context.read<Locations>().isInternetConnectionOK) {
        context.read<Locations>().setInternetConnectionStatus(true);
      }
    }

    if (response.statusCode == 200) {
      //print('HTTP request DONE with SUCCESS!');
      //String data = response.body;

      //return jsonDecode(data);
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      print(
          'HTTP request DONE with ERROR! : ' + response.statusCode.toString());
      return response.statusCode;
    }
  }
}
