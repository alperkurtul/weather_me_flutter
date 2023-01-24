import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_flutter/states/locations.dart';
import 'package:weather_me_flutter/screens/location_weather_info/location_weather_info.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  // disable Landscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Locations()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    //print('_isInForeground : $_isInForeground');
    if (_isInForeground) {
      context.read<Locations>().changeSelectedLocation(
          context.read<Locations>().selectedLocationIndex,
          locateLocationList: false,
          locateWeatherList: false,
          notify: false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather ME',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Roboto',
            ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0.8),
        ),
      ),
      /*onGenerateRoute: (settings) {
        if (settings.name == CurrentWeather.routeName) {
          final CurrentWeatherArguments args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return CurrentWeather(
                lon: args.lon,
                lat: args.lat,
              );
            },
          );
        }
        assert(false, 'Implementation ${settings.name}');
        return null;
      },*/
      /*initialRoute: LocationWeatherInfo.routeName,
      routes: {
        LocationWeatherInfo.routeName: (context) => LocationWeatherInfo(),
        CurrentWeather.routeName: (context) => CurrentWeather(),
      },*/
      home: LocationWeatherInfo(),
    );
  }
}
