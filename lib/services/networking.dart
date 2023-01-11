import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final Uri url;

  NetworkHelper(this.url);

  Future<dynamic> getData() async {
    Map retMap = Map();

    http.Response response;
    try {
      print('http.get TRY : ' + url.toString());
      response = await http.get(url);
      print('http.get SUCCESS : ' + url.toString());
    } catch (e) {
      print('http.get ERROR : ' + url.toString());
      print('http.get ERROR : ' + e.message);
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
