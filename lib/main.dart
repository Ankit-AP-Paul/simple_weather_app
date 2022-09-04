import 'package:flutter/material.dart';
import 'package:simple_weather_app/data_service.dart';
import 'package:simple_weather_app/drawerMenu.dart';
import 'package:simple_weather_app/models.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
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

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: () async {
            final difference = DateTime.now().difference(timeBackPressed);
            final isExitWarning = difference >= Duration(seconds: 2);
            timeBackPressed = DateTime.now();
            if (isExitWarning) {
              final msgg = 'Press Back Again to exit';
              Fluttertoast.showToast(msg: msgg, fontSize: 18);
              return false;
            } else {
              Fluttertoast.cancel();
              return true;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 20, 79, 241),
              title: Center(child: Text('Simple Weather App')),
            ),
            drawer: DrawerMenu(),
            backgroundColor: Colors.lightBlueAccent,
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
                              controller: _cityTextController,
                              decoration: InputDecoration(labelText: 'City'),
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
                            color: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(_response.iconUrl),
                                Text(
                                  '${_response.weatherInfo.description} \n in ${_response.cityName}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
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
