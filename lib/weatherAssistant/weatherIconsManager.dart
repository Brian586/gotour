
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';

class WeatherIconsManager {

  Widget manageIcon(Weather weather, double size) {
    if(weather.weatherIcon == "04d") {
      return BoxedIcon(WeatherIcons.cloudy, size: size,);
    }
    else if(weather.weatherIcon == "04n") {
      return BoxedIcon(WeatherIcons.cloudy, size: size,);
    }
    else if(weather.weatherIcon == "02d") {
      return BoxedIcon(WeatherIcons.day_cloudy, size: size,);
    }
    else if(weather.weatherIcon == "03d") {
      return BoxedIcon(WeatherIcons.cloud, size: size,);
    }
    else if(weather.weatherIcon == "03n") {
      return BoxedIcon(WeatherIcons.cloud, size: size,);
    }
    else if(weather.weatherIcon == "01d") {
      return BoxedIcon(WeatherIcons.day_sunny, size: size, color: Colors.yellowAccent,);
    }
    else if(weather.weatherIcon == "10d") {
      return BoxedIcon(WeatherIcons.day_showers, size: size);
    }
    else if(weather.weatherIcon == "10n") {
      return BoxedIcon(WeatherIcons.night_showers, size: size);
    }
    else
      {
        return Image.network("http://openweathermap.org/img/w/${weather.weatherIcon}.png", height: 50.0, width: 50.0,);
      }
  }
}