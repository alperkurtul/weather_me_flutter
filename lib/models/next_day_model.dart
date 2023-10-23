class NextDayModel {
  String? id;
  String? main;
  String? description;
  String? icon;
  String? temp;
  String? tempMin;
  String? tempMax;
  String? dtTxt;

  NextDayModel({
    this.id,
    this.main,
    this.description,
    this.icon,
    this.temp,
    this.tempMin,
    this.tempMax,
    this.dtTxt,
  });

  dynamic toMap() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
      'temp': temp,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'dtTxt': dtTxt,
    };
  }
}
