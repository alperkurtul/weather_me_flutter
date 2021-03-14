import 'package:weather_me_flutter/models/application_api_mode.dart';
import 'package:weather_me_flutter/models/near_future_model.dart';
import 'package:weather_me_flutter/models/next_day_model.dart';
import 'package:weather_me_flutter/services/weather_service.dart';
import 'package:weather_me_flutter/utilities/app_configuration.dart';
import 'package:intl/intl.dart';
import 'package:weather_me_flutter/utilities/util_date_utils.dart';

class WeatherModel {
  bool dataLoaded = false;
  String id = '';
  String main = '';
  String description = '';
  String icon = '';
  String realTemperature = '';
  String feelsTemperature = '';
  String minTemperature = '';
  String maxTemperature = '';
  String pressure = '';
  String humidity = '';
  String countryCode = '';
  String sunRise = '';
  String sunSet = '';
  String timeZone = '';
  String locationId = '';
  String locationName = '';
  String visibility = '';
  String windSpeed = '';
  String windDirectionDegree = '';
  String weatherDataTime = '';
  String currentDateDisplay = '';
  String dataLoadedUtcTime = '';
  List<NearFutureModel> nearFutures = [];
  List<NextDayModel> nextDays = [];

  WeatherModel({
    this.dataLoaded = false,
    this.id = '',
    this.main = '',
    this.description = '',
    this.icon = '',
    this.realTemperature = '',
    this.feelsTemperature = '',
    this.minTemperature = '',
    this.maxTemperature = '',
    this.pressure = '',
    this.humidity = '',
    this.countryCode = '',
    this.sunRise = '',
    this.sunSet = '',
    this.timeZone = '',
    this.locationId = '',
    this.locationName = '',
    this.visibility = '',
    this.windSpeed = '',
    this.windDirectionDegree = '',
    this.weatherDataTime = '',
    this.currentDateDisplay = '',
    this.nearFutures,
    this.nextDays,
  }) {
    if (this.nearFutures == null) {
      nearFutures = [];
    }
    if (this.nextDays == null) {
      nextDays = [];
    }
    this.dataLoadedUtcTime = '0';
  }

  dynamic toMap() {
    List nearFutureList = [];
    for (NearFutureModel nf in nearFutures) {
      dynamic map = nf.toMap();
      nearFutureList.add(map);
    }

    List nextDayList = [];
    for (NextDayModel nd in nextDays) {
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
      'dataLoadedUtcTime': dataLoadedUtcTime,
      'nearFutures': nearFutureList,
      'nextDays': nextDayList,
    };
  }

  void setWeatherInfo(WeatherService weatherService) {
    if (AppConfiguration.apiMode == ApplicationApiMode.WeatherMeApi) {
      _weatherDataFromWeatherMe(weatherService);
      dataLoaded = true;
    } else if (AppConfiguration.apiMode == ApplicationApiMode.OpenWeatherApi) {
      _weatherDataFromOpenWeather(weatherService);
      dataLoaded = true;
    }
  }

  void _weatherDataFromWeatherMe(WeatherService weatherService) {
    var weatherData = weatherService.weatherData;

    this.id = weatherData['id'];
    this.main = weatherData['main'];
    this.description = weatherData['description'];
    this.icon = weatherData['icon'];
    this.realTemperature =
        double.parse(weatherData['realTemperature'].toString())
            .toStringAsFixed(0);
    this.feelsTemperature =
        double.parse(weatherData['feelsTemperature'].toString())
            .toStringAsFixed(0);
    this.minTemperature = double.parse(weatherData['minTemperature'].toString())
        .toStringAsFixed(0);
    this.maxTemperature = double.parse(weatherData['maxTemperature'].toString())
        .toStringAsFixed(0);
    if (this.realTemperature == '-0') this.realTemperature = '0';
    if (this.feelsTemperature == '-0') this.feelsTemperature = '0';
    if (this.minTemperature == '-0') this.minTemperature = '0';
    if (this.maxTemperature == '-0') this.maxTemperature = '0';
    this.pressure = weatherData['pressure'];
    this.humidity = weatherData['humidity'];
    this.countryCode = weatherData['countryCode'];
    this.sunRise = weatherData['sunRise'].toString().substring(11, 16);
    this.sunSet = weatherData['sunSet'].toString().substring(11, 16);
    this.timeZone = weatherData['timeZone'];
    this.locationId = weatherData['locationId'];
    this.locationName = weatherData['locationName'];
    this.visibility =
        (double.parse(weatherData['visibility'].toString()) / 1000)
            .toStringAsFixed(1);
    this.windSpeed =
        (double.parse(weatherData['windSpeed'].toString()) * 3600 / 1000)
            .toStringAsFixed(2);
    this.windDirectionDegree = weatherData['windDirectionDegree'];
    this.weatherDataTime = weatherData['weatherDataTime'];

    this.currentDateDisplay = this.weatherDataTime.substring(0, 2);
    this.dataLoadedUtcTime = (UTILDateUtils.utcTimeInMilliseconds).toString();
    print('$locationName last saved at $dataLoadedUtcTime');

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
    this.currentDateDisplay = this.currentDateDisplay +
        ' ' +
        months[int.parse(this.weatherDataTime.substring(3, 5)) - 1];

    DateTime date = DateTime.utc(
        int.parse(this.weatherDataTime.substring(6, 10)),
        int.parse(this.weatherDataTime.substring(3, 5)),
        int.parse(this.weatherDataTime.substring(0, 2)));
    this.currentDateDisplay =
        DateFormat('EE').format(date) + ', ' + this.currentDateDisplay;

    List<NearFutureModel> nfs = [];
    nfs.add(NearFutureModel(
      id: this.id.toString(),
      temp: this.realTemperature,
      dtTxt: 'Now',
    ));
    for (var item in weatherData['nearFuture']) {
      String tmp = double.parse(item['temp'].toString()).toStringAsFixed(0);
      if (tmp == '-0') tmp = '0';
      nfs.add(
        NearFutureModel(
          id: item['id'],
          temp: tmp,
          dtTxt: item['dtTxt'].toString().substring(11, 16),
        ),
      );
    }
    this.nearFutures = nfs;

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedCurrentDate = formatter.format(DateTime.now());
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
      DateTime date = DateTime.parse(item['dtTxt']);
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
    this.nextDays = nds;
  }

  void _weatherDataFromOpenWeather(WeatherService weatherService) {
    var weatherData = weatherService.weatherData;

    DateTime date;
    final dateFormat =
        DateFormat("dd-MM-yyyy HH:mm:ss"); //("dd-MM-yyyy HH:mm a");
    dynamic timeInSeconds;

    this.id = weatherData['weather'][0]['id'].toString();
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
    if (feelsTemperature == '-0') this.feelsTemperature = '0';
    if (this.minTemperature == '-0') this.minTemperature = '0';
    if (this.maxTemperature == '-0') this.maxTemperature = '0';
    this.pressure = weatherData['main']['pressure'].toString();
    this.humidity = weatherData['main']['humidity'].toString();
    this.countryCode = weatherData['sys']['country'];

    timeInSeconds = weatherData['sys']['sunrise'] + weatherData['timezone'];
    this.sunRise = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInSeconds * 1000, isUtc: true));
    this.sunRise = this.sunRise.substring(11, 16);

    timeInSeconds = weatherData['sys']['sunset'] + weatherData['timezone'];
    this.sunSet = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInSeconds * 1000, isUtc: true));
    this.sunSet = this.sunSet.substring(11, 16);

    this.timeZone = weatherData['timezone'].toString();
    this.locationId = weatherData['id'].toString();
    this.locationName = weatherData['name'];
    this.visibility =
        (double.parse(weatherData['visibility'].toString()) / 1000)
            .toStringAsFixed(1);
    this.windSpeed =
        (double.parse(weatherData['wind']['speed'].toString()) * 3600 / 1000)
            .toStringAsFixed(2);
    this.windDirectionDegree = weatherData['wind']['deg'].toString();

    timeInSeconds = weatherData['dt'] + weatherData['timezone'];
    this.weatherDataTime = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInSeconds * 1000, isUtc: true));

    this.currentDateDisplay = this.weatherDataTime.substring(0, 2);
    this.dataLoadedUtcTime = (UTILDateUtils.utcTimeInMilliseconds).toString();
    print('$locationName last saved at $dataLoadedUtcTime');

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
    this.currentDateDisplay = this.currentDateDisplay +
        ' ' +
        months[int.parse(this.weatherDataTime.substring(3, 5)) - 1];

    date = DateTime.utc(
        int.parse(this.weatherDataTime.substring(6, 10)),
        int.parse(this.weatherDataTime.substring(3, 5)),
        int.parse(this.weatherDataTime.substring(0, 2)));
    this.currentDateDisplay =
        DateFormat('EE').format(date) + ', ' + this.currentDateDisplay;

    var forecastData = weatherService.forecastData;
    List<NearFutureModel> nfs = [];
    nfs.add(NearFutureModel(
      id: this.id.toString(),
      temp: this.realTemperature,
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
        NearFutureModel(
            id: (item['weather'][0]['id']).toString(), temp: tmp, dtTxt: dt),
      );
    }
    this.nearFutures = nfs;

    _forecastDataConsolidation(weatherService);
  }

  void _forecastDataConsolidation(WeatherService weatherService) {
    //print(weatherService.forecastData);
    var forecastData = weatherService.forecastData['list'];

    final dateFormat01 = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedCurrentDate;
    dynamic timeInSeconds;
    int timezone;

    timezone =
        int.parse(weatherService.forecastData['city']['timezone'].toString());

    formattedCurrentDate = UTILDateUtils.utcTimeInMillisecondsAsFormattedString(
        'yyyy-MM-dd', timezone * 1000);

    for (var item in forecastData) {
      timeInSeconds = int.parse(item['dt'].toString()) + timezone;
      String dt = dateFormat01.format(DateTime.fromMillisecondsSinceEpoch(
          timeInSeconds * 1000,
          isUtc: true));
      item['dt_txt'] = dt;
    }

    List<NextDayModel> nds = [];

    List<Map<String, dynamic>> _idArray = [];
    double _temperatureMin = 1000;
    double _temperatureMax = -1000;
    double _temperatureTotal = 0;
    int _temperatureCount = 0;

    int _len = forecastData.length;

    for (int i = 0; i < _len; i++) {
      if (double.parse(forecastData[i]['main']['temp_min'].toString()) <
          _temperatureMin) {
        _temperatureMin =
            double.parse(forecastData[i]['main']['temp_min'].toString());
      }

      if (double.parse(forecastData[i]['main']['temp_max'].toString()) >
          _temperatureMax) {
        _temperatureMax =
            double.parse(forecastData[i]['main']['temp_max'].toString());
      }

      _temperatureTotal = _temperatureTotal +
          double.parse(forecastData[i]['main']['temp'].toString());

      _idProcess(weatherService, 'PROCESS_ADD',
          forecastData[i]['weather'][0]['id'].toString(), _idArray);

      _temperatureCount++;

      if ((i == _len - 1) ||
          (forecastData[i]['dt_txt'].toString().substring(0, 10) !=
              forecastData[i + 1]['dt_txt'].toString().substring(0, 10))) {

        NextDayModel nd = NextDayModel();
        nd.id = _idProcess(null, 'PROCESS_DECIDE', '', _idArray);
        nd.temp = (_temperatureTotal / _temperatureCount).toStringAsFixed(0);
        if (nd.temp == '-0') nd.temp = '0';
        nd.tempMin = _temperatureMin.toStringAsFixed(0);
        if (nd.tempMin == '-0') nd.tempMin = '0';
        nd.tempMax = _temperatureMax.toStringAsFixed(0);
        if (nd.tempMax == '-0') nd.tempMax = '0';

        DateTime date = DateTime.parse(forecastData[i]['dt_txt'].toString());
        nd.dtTxt = DateFormat('EEEE').format(date);

        if (forecastData[i]['dt_txt'].toString().substring(0, 10) !=
            formattedCurrentDate) {
          nds.add(nd);
        }

        _idArray = [];
        _temperatureMin = 1000;
        _temperatureMax = -1000;
        _temperatureTotal = 0;
        _temperatureCount = 0;
      }
    }
    this.nextDays = nds;
  }

  String _idProcess(WeatherService weatherService, String processType,
      String id, List idArray) {
    Map outMap;
    String icon;

    if (processType == 'PROCESS_ADD') {
      outMap = weatherService.getWeatherConditionIcon(int.parse(id));
      String outId = outMap['outCondition'].toString();
      String outIcon = outMap['icon'];

      int itemLocation = -1;
      for (int index = 0; index < idArray.length; index++) {
        if (idArray[index]['icon'] == outIcon) {
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
          'iconcount': int.parse(idArray[itemLocation]['iconcount'].toString()) + 1,
        };
        idArray.add(m);
        idArray.removeAt(itemLocation);
      }

      return '';
    }
    if (processType == 'PROCESS_DECIDE') {

      for(Map item in idArray) {
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
  }
}
