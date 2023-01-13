import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final Uri url;

  NetworkHelper(this.url);

  Future<dynamic> getData() async {
    Map retMap = Map();

    http.Response response;

    int triedCount = 0;
    int maxTryCount = 5;
    if (url.toString().contains('/2.5/find?')) {
      maxTryCount = 1;
    }
    print('maxTryCount : ' + maxTryCount.toString());
    while (response == null && triedCount < maxTryCount) {
      triedCount++;
      print('triedCount : ' + triedCount.toString());
      try {
        print('http.get TRY : ' + url.toString());
        response = await http.get(url).timeout(Duration(seconds: 1+triedCount));
        print('http.get SUCCESS : ' + url.toString());
      } on TimeoutException catch(e) {
        print('http.get ERROR TimeoutException : ' + url.toString());
        print('http.get ERROR TimeoutException : ' + e.message);
        //return retMap;
      } catch (e) {
        print('http.get ERROR : ' + url.toString());
        print('http.get ERROR : ' + e.message);
        //return retMap;
      }
    }

    if (response == null) {
      return retMap;
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
