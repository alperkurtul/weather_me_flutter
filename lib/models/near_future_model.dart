class NearFutureModel {
  String id;
  String temp;
  String dtTxt;

  NearFutureModel({
    this.id,
    this.temp,
    this.dtTxt,
  });

  dynamic toMap() {
    return {
      'id': id,
      'temp': temp,
      'dtTxt': dtTxt,
    };
  }
}
