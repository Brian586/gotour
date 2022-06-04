// ignore_for_file: file_names

import 'package:geocoding/geocoding.dart';
import 'package:gotour/Config/config.dart';
import 'package:weather/weather.dart';

class WeatherAssistant {
  WeatherFactory weatherFactory = WeatherFactory(GoTour.weatherApiKey);

  Future<Weather> getCurrentWeatherInfo(String city, String country) async {
    List<Location> locations = await getLocation(city, country);

    Weather weather = await weatherFactory.currentWeatherByLocation(
        locations[0].latitude, locations[0].longitude);

    return weather;
  }

  Future<List<Weather>> getWeatherForecastInfo(
      String city, String country) async {
    List<Location> locations = await getLocation(city, country);

    List<Weather> forecast = await weatherFactory.fiveDayForecastByLocation(
        locations[0].latitude, locations[0].longitude);

    return forecast;
  }

  Future<List<Location>> getLocation(String city, String country) async {
    List<Location> locations = await locationFromAddress("$city, $country");

    return locations;
  }
}
