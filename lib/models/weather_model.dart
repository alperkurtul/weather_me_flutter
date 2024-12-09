import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/near_future_model.dart';
import 'package:weather_me_flutter/models/next_day_model.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';
import 'package:intl/intl.dart';
import 'package:weather_me_flutter/utilities/misc_constants.dart';
import 'package:weather_me_flutter/utilities/util_date_utils.dart';

class WeatherModel {
  bool dataLoaded;
  String id;
  String main;
  String description;
  String icon;
  String realTemperature;
  String feelsTemperature;
  String minTemperature;
  String maxTemperature;
  String pressure;
  String humidity;
  String countryCode;
  String sunRise;
  String sunSet;
  String timeZone;
  String locationId;
  String locationName;
  String visibility;
  String windSpeed;
  String windDirectionDegree;
  String weatherDataTime;
  String currentDateDisplay;
  String dataLoadedAtUtcTime = '';
  List<NearFutureTimesModel>? nearFutureTimes;
  List<NextDayModel>? nextDays;

  WeatherModel({
    this.dataLoaded = false,
    this.id = kWeatherDataDefaultValue,
    this.main = '',
    this.description = '',
    this.icon = '',
    this.realTemperature = kWeatherDataDefaultValue,
    this.feelsTemperature = '',
    this.minTemperature = '',
    this.maxTemperature = '',
    this.pressure = kWeatherDataDefaultValue,
    this.humidity = kWeatherDataDefaultValue,
    this.countryCode = kWeatherDataDefaultValue,
    this.sunRise = kWeatherDataDefaultValue,
    this.sunSet = kWeatherDataDefaultValue,
    this.timeZone = '',
    this.locationId = '',
    this.locationName = kWeatherDataDefaultValue,
    this.visibility = kWeatherDataDefaultValue,
    this.windSpeed = kWeatherDataDefaultValue,
    this.windDirectionDegree = kWeatherDataDefaultValue,
    this.weatherDataTime = kWeatherDataDefaultValue,
    this.currentDateDisplay = '',
    this.nearFutureTimes,
    this.nextDays,
  }) {
    if (nearFutureTimes == null) {
      nearFutureTimes = [];
      for (int i = 0; i < 9; i++) {
        nearFutureTimes?.add(NearFutureTimesModel(
            id: kWeatherDataDefaultValue,
            temp: kWeatherDataDefaultValue,
            dtTxt: kWeatherDataDefaultValue));
      }
    }

    if (nextDays == null) {
      nextDays = [];
      for (int i = 0; i < 5; i++) {
        nextDays?.add(NextDayModel(
            id: kWeatherDataDefaultValue,
            temp: kWeatherDataDefaultValue,
            dtTxt: kWeatherDataDefaultValue));
      }
    }
    dataLoadedAtUtcTime = '0';
  }

  dynamic toMap() {
    List nearFutureList = [];
    for (NearFutureTimesModel nf in nearFutureTimes!) {
      dynamic map = nf.toMap();
      nearFutureList.add(map);
    }

    List nextDayList = [];
    for (NextDayModel nd in nextDays!) {
      dynamic map = nd.toMap();
      nextDayList.add(map);
    }

    return {
      'dataLoaded': dataLoaded,
      'id': id,
      'main': main,
      'description': description,
      'icon': '',
      'realTemperature': realTemperature,
      'feelsTemperature': feelsTemperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'pressure': pressure,
      'humidity': humidity,
      'countryCode': countryCode,
      'sunRise': sunRise,
      'sunSet': sunSet,
      'timeZone': timeZone,
      'locationId': locationId,
      'locationName': locationName,
      'visibility': visibility,
      'windSpeed': windSpeed,
      'windDirectionDegree': windDirectionDegree,
      'weatherDataTime': weatherDataTime,
      'currentDateDisplay': currentDateDisplay,
      'dataLoadedAtUtcTime': dataLoadedAtUtcTime,
      'nearFutures': nearFutureList,
      'nextDays': nextDayList,
    };
  }

  void setWeatherInfo(dynamic weatherData, dynamic forecastData) {
    if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
      _weatherDataFromWeatherMe(weatherData);
      dataLoaded = true;
    } else if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
      _weatherDataFromOpenWeather(weatherData, forecastData);
      dataLoaded = true;
    }
  }

  void _weatherDataFromWeatherMe(dynamic weatherData) {
    id = weatherData['id'];
    main = weatherData['main'];
    description = weatherData['description'];
    icon = weatherData['icon'];
    realTemperature = double.parse(weatherData['realTemperature'].toString())
        .toStringAsFixed(0);
    feelsTemperature = double.parse(weatherData['feelsTemperature'].toString())
        .toStringAsFixed(0);
    minTemperature = double.parse(weatherData['minTemperature'].toString())
        .toStringAsFixed(0);
    maxTemperature = double.parse(weatherData['maxTemperature'].toString())
        .toStringAsFixed(0);
    if (realTemperature == '-0') realTemperature = '0';
    if (feelsTemperature == '-0') feelsTemperature = '0';
    if (minTemperature == '-0') minTemperature = '0';
    if (maxTemperature == '-0') maxTemperature = '0';
    pressure = weatherData['pressure'];
    humidity = weatherData['humidity'];
    countryCode = weatherData['countryCode'];
    sunRise = weatherData['sunRise'].toString().substring(11, 16);
    sunSet = weatherData['sunSet'].toString().substring(11, 16);
    timeZone = weatherData['timeZone'];
    locationId = weatherData['locationId'];
    locationName = weatherData['locationName'];
    visibility = (double.parse(weatherData['visibility'].toString()) / 1000)
        .toStringAsFixed(1);
    windSpeed =
        (double.parse(weatherData['windSpeed'].toString()) * 3600 / 1000)
            .toStringAsFixed(2);
    windDirectionDegree = weatherData['windDirectionDegree'];
    weatherDataTime = weatherData['weatherDataTime'];

    currentDateDisplay = weatherDataTime.substring(0, 2);
    dataLoadedAtUtcTime = (UTILDateUtils.utcTimeInMilliseconds).toString();
    /*print('$locationName last saved at dataLoadedAtUtcTime');*/

    var months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    currentDateDisplay =
        'currentDateDisplay ${months[int.parse(weatherDataTime.substring(3, 5)) - 1]}';

    DateTime date = DateTime.utc(
        int.parse(weatherDataTime.substring(6, 10)),
        int.parse(weatherDataTime.substring(3, 5)),
        int.parse(weatherDataTime.substring(0, 2)));
    currentDateDisplay =
        '${DateFormat("EE").format(date)}, $currentDateDisplay';

    List<NearFutureTimesModel> nfs = [];
    nfs.add(NearFutureTimesModel(
      id: id.toString(),
      temp: realTemperature,
      dtTxt: 'Now',
    ));
    for (var item in weatherData['nearFuture']) {
      String tmp = double.parse(item['temp'].toString()).toStringAsFixed(0);
      if (tmp == '-0') tmp = '0';
      nfs.add(
        NearFutureTimesModel(
          id: item['id'],
          temp: tmp,
          dtTxt: item['dtTxt'].toString().substring(11, 16),
        ),
      );
    }
    nearFutureTimes = nfs;

    int timezone = int.parse(weatherData['timeZone'].toString());
    final String formattedCurrentDate =
        UTILDateUtils.utcTimeInMillisecondsAsFormattedString(
            'dd-MM-yyyy', timezone * 1000);
    int startIndex = 0;
    if (weatherData['nextDays'][0]['dtTxt'].toString().substring(0, 10) ==
        formattedCurrentDate) {
      if (weatherData['nextDays'].length > 5) {
        startIndex = 1;
      }
    }

    List<NextDayModel> nds = [];
    for (int index = startIndex;
        index < weatherData['nextDays'].length;
        index++) {
      var item = weatherData['nextDays'][index];
      String strDate = item['dtTxt'].toString();
      strDate =
          '${strDate.substring(6, 10)}-${strDate.substring(3, 5)}-${strDate.substring(0, 2)} ${strDate.substring(11)}';
      DateTime date = DateTime.parse(strDate);
      String dayOfWeek = DateFormat('EEEE').format(date);

      String tmp = double.parse(item['temp'].toString()).toStringAsFixed(0);
      if (tmp == '-0') tmp = '0';
      String tmpMin =
          double.parse(item['tempMin'].toString()).toStringAsFixed(0);
      if (tmpMin == '-0') tmpMin = '0';
      String tmpMax =
          double.parse(item['tempMax'].toString()).toStringAsFixed(0);
      if (tmpMax == '-0') tmpMax = '0';

      nds.add(
        NextDayModel(
          id: item['id'],
          main: item['main'],
          description: item['description'],
          icon: item['icon'],
          temp: tmp,
          tempMin: tmpMin,
          tempMax: tmpMax,
          dtTxt: dayOfWeek,
        ),
      );
    }
    nextDays = nds;
  }

  void _weatherDataFromOpenWeather(dynamic weatherData, dynamic forecastData) {
    DateTime date;
    final dateFormat =
        DateFormat("dd-MM-yyyy HH:mm:ss"); //("dd-MM-yyyy HH:mm a");
    dynamic timeInSeconds;

    id = weatherData['weather'][0]['id'].toString();
    main = weatherData['weather'][0]['main'];
    description = weatherData['weather'][0]['description'];
    icon = ''; //weatherData['icon'];
    realTemperature =
        double.parse(weatherData['main']['temp'].toString()).toStringAsFixed(0);
    feelsTemperature =
        double.parse(weatherData['main']['feels_like'].toString())
            .toStringAsFixed(0);
    minTemperature = double.parse(weatherData['main']['temp_min'].toString())
        .toStringAsFixed(0);
    maxTemperature = double.parse(weatherData['main']['temp_max'].toString())
        .toStringAsFixed(0);
    if (realTemperature == '-0') realTemperature = '0';
    if (feelsTemperature == '-0') feelsTemperature = '0';
    if (minTemperature == '-0') minTemperature = '0';
    if (maxTemperature == '-0') maxTemperature = '0';
    pressure = weatherData['main']['pressure'].toString();
    humidity = weatherData['main']['humidity'].toString();
    countryCode = weatherData['sys']['country'];

    timeInSeconds = weatherData['sys']['sunrise'] + weatherData['timezone'];
    sunRise = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInSeconds * 1000, isUtc: true));
    sunRise = sunRise.substring(11, 16);

    timeInSeconds = weatherData['sys']['sunset'] + weatherData['timezone'];
    sunSet = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInSeconds * 1000, isUtc: true));
    sunSet = sunSet.substring(11, 16);

    timeZone = weatherData['timezone'].toString();
    locationId = weatherData['id'].toString();
    locationName = weatherData['name'];
    visibility = (double.parse(weatherData['visibility'].toString()) / 1000)
        .toStringAsFixed(1);
    windSpeed =
        (double.parse(weatherData['wind']['speed'].toString()) * 3600 / 1000)
            .toStringAsFixed(2);
    windDirectionDegree = weatherData['wind']['deg'].toString();

    timeInSeconds = weatherData['dt'] + weatherData['timezone'];
    weatherDataTime = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInSeconds * 1000, isUtc: true));

    currentDateDisplay = weatherDataTime.substring(0, 2);
    dataLoadedAtUtcTime = (UTILDateUtils.utcTimeInMilliseconds).toString();
    /*print('$locationName last saved at dataLoadedAtUtcTime');*/

    var months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    currentDateDisplay =
        '$currentDateDisplay ${months[int.parse(weatherDataTime.substring(3, 5)) - 1]}';

    date = DateTime.utc(
        int.parse(weatherDataTime.substring(6, 10)),
        int.parse(weatherDataTime.substring(3, 5)),
        int.parse(weatherDataTime.substring(0, 2)));
    currentDateDisplay =
        '${DateFormat('EE').format(date)}, $currentDateDisplay';

    List<NearFutureTimesModel> nfs = [];
    nfs.add(NearFutureTimesModel(
      id: id.toString(),
      temp: realTemperature,
      dtTxt: 'Now',
    ));
    for (int index = 0; index <= 7; index++) {
      var item = forecastData['list'][index];

      timeInSeconds = item['dt'] + weatherData['timezone'];
      String dt = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(
          timeInSeconds * 1000,
          isUtc: true));
      dt = dt.substring(11, 16);

      String tmp =
          double.parse(item['main']['temp'].toString()).toStringAsFixed(0);
      if (tmp == '-0') tmp = '0';

      nfs.add(
        NearFutureTimesModel(
            id: (item['weather'][0]['id']).toString(), temp: tmp, dtTxt: dt),
      );
    }
    nearFutureTimes = nfs;

    _forecastDataConsolidation(forecastData);
  }

  void _forecastDataConsolidation(dynamic forecastData) {
    //print(forecastData);
    var forecastDataList = forecastData['list'];

    final dateFormat01 = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedCurrentDate;
    dynamic timeInSeconds;
    int timezone;

    timezone = int.parse(forecastData['city']['timezone'].toString());

    formattedCurrentDate = UTILDateUtils.utcTimeInMillisecondsAsFormattedString(
        'yyyy-MM-dd', timezone * 1000);

    for (var item in forecastDataList) {
      timeInSeconds = int.parse(item['dt'].toString()) + timezone;
      String dt = dateFormat01.format(DateTime.fromMillisecondsSinceEpoch(
          timeInSeconds * 1000,
          isUtc: true));
      item['dt_txt'] = dt;
    }

    List<NextDayModel> nds = [];

    List<Map<String, dynamic>> idArray = [];
    double temperatureMin = 1000;
    double temperatureMax = -1000;
    double temperatureTotal = 0;
    int temperatureCount = 0;

    int len = forecastDataList.length;

    for (int i = 0; i < len; i++) {
      if (double.parse(forecastDataList[i]['main']['temp_min'].toString()) <
          temperatureMin) {
        temperatureMin =
            double.parse(forecastDataList[i]['main']['temp_min'].toString());
      }

      if (double.parse(forecastDataList[i]['main']['temp_max'].toString()) >
          temperatureMax) {
        temperatureMax =
            double.parse(forecastDataList[i]['main']['temp_max'].toString());
      }

      temperatureTotal = temperatureTotal +
          double.parse(forecastDataList[i]['main']['temp'].toString());

      _idProcess('PROCESS_ADD',
          forecastDataList[i]['weather'][0]['id'].toString(), idArray);

      temperatureCount++;

      if ((i == len - 1) ||
          (forecastDataList[i]['dt_txt'].toString().substring(0, 10) !=
              forecastDataList[i + 1]['dt_txt'].toString().substring(0, 10))) {
        NextDayModel nd = NextDayModel();
        nd.id = _idProcess('PROCESS_DECIDE', '', idArray);
        nd.temp = (temperatureTotal / temperatureCount).toStringAsFixed(0);
        if (nd.temp == '-0') nd.temp = '0';
        nd.tempMin = temperatureMin.toStringAsFixed(0);
        if (nd.tempMin == '-0') nd.tempMin = '0';
        nd.tempMax = temperatureMax.toStringAsFixed(0);
        if (nd.tempMax == '-0') nd.tempMax = '0';

        DateTime date =
            DateTime.parse(forecastDataList[i]['dt_txt'].toString());
        nd.dtTxt = DateFormat('EEEE').format(date);

        if (forecastDataList[i]['dt_txt'].toString().substring(0, 10) !=
            formattedCurrentDate) {
          nds.add(nd);
        }

        idArray = [];
        temperatureMin = 1000;
        temperatureMax = -1000;
        temperatureTotal = 0;
        temperatureCount = 0;
      }
    }
    nextDays = nds;
  }

  String? _idProcess(String processType, String id, List idArray) {
    Map? outMap;

    if (processType == 'PROCESS_ADD') {
      outMap = WeatherService.getWeatherConditionIcon(int.parse(id));
      String outId = outMap['outCondition'].toString();
      String outIcon = outMap['icon'];

      int itemLocation = -1;
      for (int index = 0; index < idArray.length; index++) {
        if (idArray[index]['outCondition'] == outId) {
          itemLocation = index;
        }
      }

      if (itemLocation == -1) {
        Map<String, dynamic> m = {
          'id': outId,
          'icon': outIcon,
          'iconcount': 1,
        };
        idArray.add(m);
      } else {
        Map<String, dynamic> m = {
          'id': outId,
          'icon': outIcon,
          'iconcount':
              int.parse(idArray[itemLocation]['iconcount'].toString()) + 1,
        };
        idArray.add(m);
        idArray.removeAt(itemLocation);
      }

      return '';
    }

    if (processType == 'PROCESS_DECIDE') {
      for (Map item in idArray) {
        if (outMap == null) {
          outMap = item;
        } else {
          if (item['iconcount'] == outMap['iconcount']) {
            if (int.parse(item['id']) < int.parse(outMap['id'])) {
              outMap = item;
            }
          } else if (item['iconcount'] > outMap['iconcount']) {
            outMap = item;
          }
        }
      }

      if (outMap == null) {
        return '';
      } else {
        return outMap['id'];
      }
    }

    return '';
  }
}
