import 'dart:developer';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:weather_icons/weather_icons.dart';

import '../view_models/home_view_model.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find<WeatherController>();

  HomeScreen({super.key});

  TextEditingController textController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isDarkMode = Get.isDarkMode;

    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: weatherController.isLoading.value,
        isDarkMode: isDarkMode,
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  weatherController.exception.value != ""
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimSearchBar(
                                closeSearchOnSuffixTap: true,
                                rtl: true,
                                width: 400,
                                color: const Color(0xffffb56b),
                                textController: textController,
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 26,
                                ),
                                onSuffixTap: () async {
                                  textController.text == ""
                                      ? log("No city entered")
                                      : weatherController
                                          .fetchWeatherByLocation(
                                              textController.text);

                                  FocusScope.of(context).unfocus();
                                  textController.clear();
                                },
                                style: GoogleFonts.questrial(
                                  backgroundColor: Get.isDarkMode
                                      ? Colors.black26
                                      : Colors.white,
                                  color:
                                      isDarkMode ? Colors.black : Colors.black,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSubmitted: (String ans) {
                                  log("ans $ans");
                                },
                              ),
                            ),
                            Text("${weatherController.exception}"),
                          ],
                        )
                      : weatherController.isLoading.value
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02,
                                    horizontal: size.width * 0.05,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.toNamed("/settings")!
                                              .then((value) => Get.isDarkMode);
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.bars,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Align(
                                        child: Text(
                                          'Weather App', //TODO: change app name
                                          style: GoogleFonts.questrial(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff1D1617),
                                            fontSize: size.height * 0.02,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          weatherController.onInit();
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.arrowsRotate,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: AnimSearchBar(
                                    rtl: true,
                                    width: 400,
                                    color: const Color(0xffffb56b),
                                    textController: textController,
                                    suffixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                    onSuffixTap: () async {
                                      textController.text == ""
                                          ? log("No city entered")
                                          : weatherController
                                              .fetchWeatherByLocation(
                                                  textController.text);

                                      FocusScope.of(context).unfocus();
                                      textController.clear();
                                    },
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onSubmitted: (String ans) {
                                      log("ans $ans");
                                    },
                                  ),
                                ),
                                Align(
                                  child: Text(
                                    "${weatherController.cityName}",
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: size.height * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.005,
                                  ),
                                  child: Align(
                                    child: Text(
                                      'Today', //day
                                      style: GoogleFonts.questrial(
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: size.height * 0.035,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.03,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getWeatherIcon(weatherController
                                            .weatherCondition.value),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        '${weatherController.convertTemperature(weatherController.temperature.value)} ${weatherController.getTemperatureUnitLabel()}', //curent temperature
                                        style: GoogleFonts.questrial(
                                          color: weatherController
                                                      .temperature.value <=
                                                  0
                                              ? Colors.blue
                                              : weatherController.temperature
                                                              .value >
                                                          0 &&
                                                      weatherController
                                                              .temperature
                                                              .value <=
                                                          15
                                                  ? Colors.indigo
                                                  : weatherController
                                                                  .temperature
                                                                  .value >
                                                              15 &&
                                                          weatherController
                                                                  .temperature
                                                                  .value <
                                                              30
                                                      ? Colors.deepPurple
                                                      : Colors.pink,
                                          fontSize: size.height * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.25),
                                  child: Divider(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.005,
                                      ),
                                      child: Align(
                                        child: Text(
                                          'Min ${weatherController.minTemperature.value} ${weatherController.getTemperatureUnitLabel()}', // weather
                                          style: GoogleFonts.questrial(
                                            color: isDarkMode
                                                ? Colors.white54
                                                : Colors.black54,
                                            fontSize: size.height * 0.02,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.005,
                                      ),
                                      child: Align(
                                        child: Text(
                                          'Max ${weatherController.maxTemperature.value} ${weatherController.getTemperatureUnitLabel()}', // weather
                                          style: GoogleFonts.questrial(
                                            color: isDarkMode
                                                ? Colors.white54
                                                : Colors.black54,
                                            fontSize: size.height * 0.02,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.005,
                                  ),
                                  child: Align(
                                    child: Text(
                                      'Humidity ${weatherController.humidity.value}', // weather
                                      style: GoogleFonts.questrial(
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.03,
                                    bottom: size.height * 0.01,
                                  ),
                                  child: Align(
                                    child: Text(
                                      '${(weatherController.windSpeed * 3.6).toStringAsFixed(2)} KMPH', // weather
                                      style: GoogleFonts.questrial(
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return WeatherIcons.day_sunny;
      case 'cloudy':
        return WeatherIcons.cloud;
      case 'rain':
        return WeatherIcons.rain;
      default:
        return WeatherIcons.na;
    }
  }
}
