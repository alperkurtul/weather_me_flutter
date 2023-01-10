import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final Uri url;

  NetworkHelper(this.url);

  Future<dynamic> getData() async {
    //print(url);
    http.Response response = await http.get(url);

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
