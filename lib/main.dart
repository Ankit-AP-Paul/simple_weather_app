import 'package:flutter/material.dart';
import 'package:simple_weather_app/data_service.dart';
import 'package:simple_weather_app/drawerMenu.dart';
import 'package:simple_weather_app/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

final Uri _url = Uri.parse('https://weather-radar400.herokuapp.com/');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();

  WeatherResponse _response;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/app_background.jpg'),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 20, 79, 241),
              title: Center(child: Text('WeatherRader')),
            ),
            drawer: DrawerMenu(),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: SizedBox(
                            width: 150,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _cityTextController,
                              decoration: InputDecoration(hintText: 'City'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        RaisedButton(
                          color: Color.fromARGB(255, 20, 79, 241),
                          onPressed: _search,
                          child: Text(
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
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: Color.fromRGBO(68, 128, 255, 0.6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(_response.iconUrl),
                                Text(
                                  '${_response.weatherInfo.description} \n in ${_response.cityName}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.blue.shade200,
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListTile(
                              leading: Icon(
                                Icons.thermostat,
                                color: Color.fromARGB(255, 20, 79, 241),
                                size: 50,
                              ),
                              title: Text(
                                'Temperature = ${_response.tempInfo.temperature}°C \n Feels Like = ${_response.tempInfo.feelsTemp}°C',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.blue.shade200,
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListTile(
                              leading: Icon(
                                Icons.water_drop,
                                color: Color.fromARGB(255, 20, 79, 241),
                                size: 50,
                              ),
                              title: Text(
                                'Humidity = ${_response.tempInfo.humid}%',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.blue.shade200,
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListTile(
                              leading: Icon(
                                Icons.air_outlined,
                                color: Color.fromARGB(255, 20, 79, 241),
                                size: 50,
                              ),
                              title: Text(
                                'Wind Speed = ${(_response.windInfo.wspeed * 3.6).toStringAsFixed(2)} km/h',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: FlatButton(
                              onPressed: _launchUrl,
                              child: Text(
                                'For more weatherinfo Click here',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ]),
            ),
          ),
        ));
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
