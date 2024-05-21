import 'package:flutter/material.dart';
import 'package:flutter_weather_app/view/home_screen.dart';
import 'package:flutter_weather_app/view/setting_screen.dart';
import 'package:flutter_weather_app/view_models/home_view_model.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Forecast App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: '/',
      defaultTransition:
          Transition.fade, // Y// ou can use other transitions as well
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => WeatherController());
      }),
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/settings', page: () => SettingsScreen()),
      ],
    );
  }
}
