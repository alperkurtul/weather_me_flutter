class NearFutureModel {
  String id;
  String temp;
  String dtTxt;

  NearFutureModel({
    required this.id,
    required this.temp,
    required this.dtTxt,
  });

  dynamic toMap() {
    return {
      'id': id,
      'temp': temp,
      'dtTxt': dtTxt,
    };
  }
}
