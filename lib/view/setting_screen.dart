import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/api_constant.dart';
import '../view_models/home_view_model.dart';

class SettingsScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find<WeatherController>();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(() =>
                Text('Temperature Unit: ${weatherController.temperatureUnit}')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    weatherController
                        .setTemperatureUnit(TemperatureUnit.celsius);
                  },
                  child: const Text('Celsius'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    weatherController
                        .setTemperatureUnit(TemperatureUnit.fahrenheit);
                  },
                  child: const Text('Fahrenheit'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                weatherController.toggleTheme();
              },
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
