import 'package:flutter/material.dart';
import 'package:simple_weather_app/data_service.dart';
import 'package:simple_weather_app/drawerMenu.dart';
import 'package:simple_weather_app/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

final Uri _url = Uri.parse('https://weather-radar-otms.vercel.app/');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();

  WeatherResponse _response;
  // ignore: prefer_final_fields
  String _bgImage = 'images/app_background.jpg';
  Color _cardBgColor = const Color.fromRGBO(68, 128, 255, 0.6);
  // ignore: prefer_final_fields
  Color _iconColor = const Color.fromARGB(255, 20, 79, 241);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(_bgImage),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Center(child: Text('WeatherRadar')),
            ),
            drawer: const DrawerMenu(),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            controller: _cityTextController,
                            decoration: const InputDecoration(hintText: 'City'),
                            textAlign: TextAlign.center,
                            onSubmitted: ((value) => _search()),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        onPressed: _search,
                        child: const Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  if (_response != null)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          color: _cardBgColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(_response.iconUrl),
                              Text(
                                '${_response.weatherInfo.description} \n in ${_response.cityName}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(109, 244, 237, 237),
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.thermostat,
                              color: _iconColor,
                              size: 50,
                            ),
                            title: Text(
                              'Temperature = ${_response.tempInfo.temperature}°C \n Feels Like = ${_response.tempInfo.feelsTemp}°C',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(109, 244, 237, 237),
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.water_drop,
                              color: _iconColor,
                              size: 50,
                            ),
                            title: Text(
                              'Humidity = ${_response.tempInfo.humid}%',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(109, 244, 237, 237),
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.air_outlined,
                              color: _iconColor,
                              size: 50,
                            ),
                            title: Text(
                              'Wind Speed = ${(_response.windInfo.wspeed * 3.6).toStringAsFixed(2)} km/h',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 30,
                        //   child: TextButton(
                        //     onPressed: _launchUrl,
                        //     child: Text(
                        //       'For more weatherinfo Click here',
                        //       style: TextStyle(
                        //         fontSize: 15,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: _launchUrl,
                          child: Text(
                            'For more weatherinfo Click here',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  _search() async {
    final response = await _dataService
        .getWeather(_cityTextController.text.toString().trim());
    setState(() {
      _response = response;
      if (_response.weatherInfo.main == 'Mist' ||
          _response.weatherInfo.main == 'Smoke' ||
          _response.weatherInfo.main == 'Haze' ||
          _response.weatherInfo.main == 'Fog' ||
          _response.weatherInfo.main == 'Dust' ||
          _response.weatherInfo.main == 'Ash') {
        _bgImage = 'images/mist.jpg';
        _cardBgColor = const Color.fromARGB(159, 110, 110, 125);
        _iconColor = const Color.fromARGB(255, 0, 0, 0);
      } else if (_response.weatherInfo.main == 'Clear') {
        _bgImage = 'images/app_background.jpg';
        _cardBgColor = const Color.fromRGBO(68, 128, 255, 0.6);
        _iconColor = const Color.fromARGB(255, 241, 134, 20);
      } else if (_response.weatherInfo.main == 'Snow') {
        _bgImage = 'images/snowy.jpg';
        _cardBgColor = const Color.fromARGB(255, 188, 193, 194);
        _iconColor = const Color.fromARGB(255, 255, 255, 255);
      } else if (_response.weatherInfo.main == 'Thunderstorm') {
        _bgImage = 'images/thunder.png';
        _cardBgColor = const Color.fromARGB(255, 238, 193, 86);
        _iconColor = const Color.fromARGB(255, 255, 171, 2);
      } else if (_response.weatherInfo.main == 'Tornado') {
        _bgImage = 'images/tornado.jpg';
        _cardBgColor = const Color.fromARGB(153, 221, 225, 233);
        _iconColor = const Color.fromARGB(255, 1, 1, 1);
      } else if (_response.weatherInfo.main == 'Sand') {
        _bgImage = 'images/sand.jpg';
        _cardBgColor = const Color.fromARGB(255, 255, 179, 0);
        _iconColor = const Color.fromARGB(255, 255, 140, 0);
      } else if (_response.weatherInfo.main == 'Clouds') {
        _bgImage = 'images/cloud.jpg';
        _cardBgColor = const Color.fromARGB(153, 221, 225, 233);
        _iconColor = const Color.fromARGB(255, 255, 255, 255);
      } else if (_response.weatherInfo.main == 'Rain' ||
          _response.weatherInfo.main == 'Drizzle') {
        _bgImage = 'images/rainy.jpg';
        _cardBgColor = const Color.fromARGB(125, 141, 244, 255);
        _iconColor = const Color.fromARGB(255, 79, 71, 235);
      } else {
        _bgImage = 'images/app_background.jpg';
        _cardBgColor = const Color.fromRGBO(68, 128, 255, 0.6);
        _iconColor = const Color.fromARGB(255, 20, 79, 241);
      }
      // print(response.weatherInfo.main);
    });
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
