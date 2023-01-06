import 'package:flutter/material.dart';
import 'package:simple_weather_app/data_service.dart';
import 'package:simple_weather_app/drawerMenu.dart';
import 'package:simple_weather_app/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

final Uri _url = Uri.parse('https://www.accuweather.com/');

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
              backgroundColor: const Color.fromARGB(255, 20, 79, 241),
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
                              decoration:
                                  const InputDecoration(hintText: 'City'),
                              textAlign: TextAlign.center,
                              onSubmitted: ((value) => _search()),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 20, 79, 241),
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
                            color: const Color.fromRGBO(68, 128, 255, 0.6),
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
                            color: Colors.blue.shade200,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListTile(
                              leading: const Icon(
                                Icons.thermostat,
                                color: Color.fromARGB(255, 20, 79, 241),
                                size: 50,
                              ),
                              title: Text(
                                'Temperature = ${_response.tempInfo.temperature}°C \n Feels Like = ${_response.tempInfo.feelsTemp}°C',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.blue.shade200,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListTile(
                              leading: const Icon(
                                Icons.water_drop,
                                color: Color.fromARGB(255, 20, 79, 241),
                                size: 50,
                              ),
                              title: Text(
                                'Humidity = ${_response.tempInfo.humid}%',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.blue.shade200,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: ListTile(
                              leading: const Icon(
                                Icons.air_outlined,
                                color: Color.fromARGB(255, 20, 79, 241),
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
                  ]),
            ),
          ),
        ));
  }

  _search() async {
    final response =
        await _dataService.getWeather(_cityTextController.text.toString());
    setState(() => _response = response);
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
