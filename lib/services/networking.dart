import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_me_flutter/states/locations.dart';

class NetworkHelper {
  static Future<dynamic> getData(BuildContext context, Uri uri) async {
    http.Response? response;

    int triedCount = 0;
    int maxTryCount = 1;
    if (uri.toString().contains('/2.5/find?')) {
      //maxTryCount = 1;
      maxTryCount = 1;
    }
    //print('maxTryCount : ' + maxTryCount.toString());
    while (response == null && triedCount < maxTryCount) {
      triedCount++;
      //print('triedCount : ' + triedCount.toString());
      try {
        //print('http.get TRY : ' + uri.toString());
        response = await http.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 1 + triedCount));
        //print('http.get SUCCESS : ' + uri.toString());
      } on TimeoutException catch (err) {
        print(
            'http.get ERROR TimeoutException : ${err.message} : ${uri.toString()}');
      } catch (err) {
        print('http.get ERROR : $err : ${uri.toString()}');
        /*print(
            'http.get ERROR : ${e.message} : ${uri.toString()}');*/
        /*if (e.osError != null && e.osError.message != null) {
          print(
              'http.get ERROR : ${e.osError.message} : ${uri.toString()}');
        }*/
      }
    }

    if (response == null) {
      if (context.mounted) {
        if (Provider.of<Locations>(context, listen: false)
            .isInternetConnectionOK) {
          Provider.of<Locations>(context, listen: false)
              .setInternetConnectionStatus(false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred while fetching weather data. Please check your Internet connection!',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
      return 'NOK';
    } else {
      if (context.mounted) {
        if (!Provider.of<Locations>(context, listen: false)
            .isInternetConnectionOK) {
          Provider.of<Locations>(context, listen: false)
              .setInternetConnectionStatus(true);
        }
      }
    }

    if (response.statusCode == 200) {
      //print('HTTP request DONE with SUCCESS!');
      //String data = response.body;

      //return jsonDecode(data);
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      print(
          'HTTP request DONE with ERROR! : ${response.statusCode.toString()}');
      return response.statusCode;
    }
  }
}
