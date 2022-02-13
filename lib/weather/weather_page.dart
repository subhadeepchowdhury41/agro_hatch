import 'package:agro_hatch/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  WeatherPage({this.lat, this.lon});
  final double lat;
  final double lon;
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/onecall?lat=${widget.lat}&lon=${widget.lon}&exclude=hourly,daily&appid=$kApikey'));
      if (response.statusCode == 200) {
        String data = response.body;
        print(data);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
  void onTap(value) {
    setState(() {
      _index = value;
    });
    _pageController.jumpToPage(_index);
  }

  int _index = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Now'),
          BottomNavigationBarItem(
              icon: Icon(Icons.skip_next), label: 'Tomorrow'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'This Week'),
        ],
        onTap: onTap,
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (value) {
            setState(() {
              _index = value;
            });
          },
          controller: _pageController,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Text('Page1'),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('Page2'),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('Page3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
