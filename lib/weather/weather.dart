import 'package:agro_hatch/weather/weather_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GetLocation extends StatefulWidget {
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final Location location = Location();
  LocationData _locationData;
  getLocation() async {
    _locationData = await location.getLocation();
    print(_locationData);
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => WeatherPage(lat: _locationData.latitude, lon: _locationData.longitude,),),);
  }
  Future<void> getLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _status;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _status = await location.hasPermission();
    if (_status == PermissionStatus.denied) {
      _status = await location.requestPermission();
      if (_status == PermissionStatus.granted) {
        return;
      }
    }
  }
  @override
  void initState() {
    getLocationPermission();
    getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitDoubleBounce(
                size: 50.0,
                color: Colors.green,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text('Getting Your Location...'),
            ],
          ),
        ),
      ),
    );
  }
}
