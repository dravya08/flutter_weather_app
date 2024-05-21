import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/api_constant.dart';
import '../helper/database_helper.dart';

class WeatherController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    WeatherDatabase().database;
    await fetchWeatherData();
  }

  RxBool isLoading = false.obs;
  RxInt temperature = 0.obs;
  RxInt minTemperature = 0.obs;
  RxInt maxTemperature = 0.obs;

  RxString weatherCondition = "".obs;

  RxInt humidity = 0.obs;
  RxDouble windSpeed = 0.0.obs;

  var temperatureUnit = TemperatureUnit.celsius.obs;

  RxString cityName = "".obs;

  RxString exception = "".obs;

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  /// Method to update weather data
  updateWeather(
      int temp, int min, int max, int condition, double wind, int cloudPer) {
    temperature.value = temp;
    minTemperature.value = min;
    maxTemperature.value = max;

    humidity.value = condition;
    windSpeed.value = wind;

    weatherCondition.value =
        determineWeatherCondition(cloudPer, temp, condition);
  }

  String determineWeatherCondition(int cloudPct, int temp, int humidity) {
    if (cloudPct > 75) {
      return 'cloudy';
    } else if (temp > 30 && humidity < 50) {
      return 'clear';
    } else if (humidity > 70) {
      return 'rain';
    } else {
      return 'clear';
    }
  }

  Set<String> uniqueDates = <String>{};
  List<DateTime> uniqueDatetimes = [];

  /// Method to fetch weather data
  Future<void> fetchWeatherData() async {
    isLoading(true);

    try {
      Position currentPosition = await getCurrentPosition();

      final address = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      cityName(address[0].locality);

      final forecastResponse = await http.get(
          Uri.https('api.api-ninjas.com', '/v1/weather', {
            'lat': "${currentPosition.latitude}",
            "lon": "${currentPosition.longitude}",
          }),
          headers: {'X-Api-Key': ApiConstant.apiKey});

      log("forecastResponse ${forecastResponse.request}");
      log("forecastResponse ${forecastResponse.body}");

      if (forecastResponse.statusCode == 200) {
        final Map<String, dynamic> forecastData =
            json.decode(forecastResponse.body);

        log("for ${forecastData["temp"]}");

        await updateWeather(
          forecastData["temp"],
          forecastData["min_temp"],
          forecastData["max_temp"],
          forecastData["humidity"],
          forecastData["wind_speed"],
          forecastData["cloud_pct"],
        );

        WeatherDatabase().insertWeather(
            cityName.value,
            forecastData["temp"],
            forecastData["min_temp"],
            forecastData["min_temp"],
            forecastData["humidity"],
            forecastData["wind_speed"],
            weatherCondition.value);
        exception('');
        isLoading(false);
      } else {
        isLoading(false);

        exception('Failed to load weather data');
        throw Exception('Failed to load weather data');
      }
    } on Exception catch (_) {
      isLoading(false);

      exception('Failed to load weather data ');
      throw Exception('Failed to load weather data');
    }
  }

  DateTime initialDate = DateTime.now();
  DateTime? currentDate; // To keep track of the current date

  /// Method to fetch weather by location data
  Future<void> fetchWeatherByLocation(String location) async {
    try {
      isLoading(true);

      final response = await http.get(
          Uri.https('api.api-ninjas.com', '/v1/weather', {
            'city': location,
          }),
          headers: {'X-Api-Key': ApiConstant.apiKey});

      if (response.statusCode == 200) {
        final Map<String, dynamic> forecastData = json.decode(response.body);

        updateWeather(
          forecastData["temp"],
          forecastData["min_temp"],
          forecastData["min_temp"],
          forecastData["humidity"],
          forecastData["wind_speed"],
          forecastData["cloud_pct"],
        );

        cityName(location.capitalizeFirst);

        WeatherDatabase().insertWeather(
            cityName.value,
            forecastData["temp"],
            forecastData["min_temp"],
            forecastData["min_temp"],
            forecastData["humidity"],
            forecastData["wind_speed"],
            weatherCondition.value);
        exception('');

        isLoading(false);
      } else {
        isLoading(false);

        exception('Failed to load weather data');
        throw Exception('Failed to load weather data');
      }
    } on Exception catch (_) {
      isLoading(false);

      exception('Failed to load weather data');
      throw Exception('Failed to load weather data');
    }
  }

  ///convert unit

  void setTemperatureUnit(TemperatureUnit unit) {
    temperatureUnit.value = unit;
    Get.back();
  }

  String getTemperatureUnitLabel() {
    return temperatureUnit.value == TemperatureUnit.celsius ? 'C' : 'F';
  }

  int convertTemperature(int temp) {
    if (temperatureUnit.value == TemperatureUnit.fahrenheit) {
      return ((temp * 9 / 5) + 32).toInt();
    } else {
      return temp;
    }
  }

  ///Theme

  var isDarkTheme = false.obs;

  void toggleTheme() {
    Get.changeTheme(
      Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
    );

    Get.back();
  }
}
