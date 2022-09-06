import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://www.linkedin.com/in/ankit-paul-914936234/');
final Uri _url2 = Uri.parse('https://www.linkedin.com/in/arpan-de-001ab31b9/');
final Uri _url3 =
    Uri.parse('https://github.com/Ankit-AP-Paul/simple_weather_app');
final Uri _url4 =
    Uri.parse('https://www.linkedin.com/in/hindol-banerjee-93701124b/');

class AppInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Color.fromARGB(255, 20, 79, 241),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
          ),
          Image.asset('images/app_icon.png', height: 150),
          Text(
            'WeatherRader',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 20, 79, 241)),
          ),
          Text('Made using OpenWeather API'),
          Text(
            'v1.0.0',
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 20, 79, 241)),
          ),
          Container(
            height: 40,
          ),
          Text(
            'This is an open source project and can be found on',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          FlatButton(
            onPressed: _launchUrl3,
            child: Text(
              'GitHub',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Text(
            'If you liked our work',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            'show some ❤ and ⭐ the repository',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Container(
            height: 40,
          ),
          Text(
            'Made with ❤ by',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 20, 79, 241),
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 25,
            child: FlatButton(
              onPressed: _launchUrl,
              child: Text(
                'Ankit Paul',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
            child: FlatButton(
              onPressed: _launchUrl2,
              child: Text(
                'Arpan De',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
            child: FlatButton(
              onPressed: _launchUrl4,
              child: Text(
                'Hindol Banerjee',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

Future<void> _launchUrl2() async {
  if (!await launchUrl(_url2)) {
    throw 'Could not launch $_url2';
  }
}

Future<void> _launchUrl3() async {
  if (!await launchUrl(_url3)) {
    throw 'Could not launch $_url3';
  }
}

Future<void> _launchUrl4() async {
  if (!await launchUrl(_url4)) {
    throw 'Could not launch $_url4';
  }
}
